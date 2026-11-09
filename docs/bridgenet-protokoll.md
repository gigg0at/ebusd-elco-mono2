# BridgeNet auf dem eBUS – Notizen zur Mono.2

Beobachtungen an einer Elco Aerotop Mono.2 mit Remocon Plus.2 und Remocon NET. Alle Werte Little-Endian; „SIN/10“ = vorzeichenbehaftet, Zehntel.

## Teilnehmer

| Master | Slave | Gerät |
|---|---|---|
| 13 | 18 | Energy Manager (Inneneinheit) |
| – | 1e | Wärmepumpe (Außeneinheit) |
| 70 | 75 | Bedienteil Remocon Plus.2 (fragt u. a. alle 10 s den Anlagendruck ab, sendet Raumtemperatur/-feuchte) |
| 7f | 84 | Gateway Remocon NET (Cloud-Abfragen, Zeitprogramme, Datum/Uhrzeit) |
| 00, 03 | – | weitere Systemteilnehmer (Bus-Scan `203a`, ID `203b`) |
| 31 | 36 | ebusd |

## Befehle (PBSB)

| PBSB | Richtung | Bedeutung |
|---|---|---|
| 2000 | Master → Slave | Status/Messwerte lesen. Anfrage: Liste von 2-Byte-Codes. Antwort: Bitmaske gültiger Codes + Werte. |
| 2001 | Master → 18 | Parameter lesen (nur Energy-Manager-Parameter, Menü 1.x). Antwort: Wert, Min, Max. |
| 2001 | Master → fe | Parameter-Abfrage als Rundruf (Zonenparameter); Energy Manager antwortet mit 200e. |
| 200e | 13 → fe | Antwort auf 2001-Rundruf: Code, Wert, Min, Max |
| 2000 | Master → fe | Status-Abfrage als Rundruf; Antwort 200f |
| 200f | 13/70 → fe | Antwort auf 2000-Rundruf: je Code Wert + Flag |
| 2010 | 13/70/7f → fe | zyklische Messwert-Rundrufe: je Code Wert + Flag |
| 2020 | 13 → fe | zyklischer Rundruf **aller Einstellungen** (3er-Pakete). Von anderen Mastern gesendet = **Schreiben** – von ebusd aus nie verwenden! |
| 2031/2034 | – | Seriennummern / Bus-Reset |
| 203a/203b | – | Bus-Scan / Identifikation |
| 2050–2052, 2071, 2073 | 7f (Gateway) → fe | Zeitprogramme, Übersteuerungen |

## Telegrammformate

### 2000 direkt (Lesen)

```
Anfrage:  QQ ZZ 20 00 NN  C1C1 [C2C2 …]
Antwort:  NN  MM  W1 [W2 …]
```

`MM` = Bitmaske der gültigen Antworten (01 = erster Code gültig, 03 = beide …). Antwort `01 00` = Code an dieser Adresse unbekannt.

Wertlänge je Code: **1 Byte**, wenn das erste Code-Byte < 0x40 oder ≥ 0xC0 ist, sonst **2 Byte**.

Beispiele:
```
31 1e 2000 02 7810   →  03 01 5600         Außentemp. 0x0056 = 8,6 °C
70 18 2000 04 4dfd 7547 → 05 03 0200 1400  4dfd = 2, Anlagendruck 0x14 = 2,0 bar
70 1e 2000 04 d140 ca46 → 03 03 03 03      Konfig.-Zähler 3, Modus 3 (Heizen)
```

### 2001 direkt an 18 (Parameter lesen)

```
Antwort:  NN  Wert  Min  Max     (je 1 oder 2 Byte, kein Statusbyte)
```
```
18 2001 02 7d2b → 06 0000 0000 6400   Korrektur Vorlauf WP = 0,0 (0…10,0)
18 2001 02 c328 → 03 02 01 02         Pumpenbetrieb = 2 (1…2)
18 2001 02 6471 → 00                  Zonenparameter: per direkter Abfrage nicht lesbar
```

### 200e (Antwort auf 2001-Rundruf)

```
13 fe 200e 08 6271 d700 6400 2c01    Z1 T Tag = 21,5 °C (10,0 … 30,0)
13 fe 200e 08 6471 3c00 74ff 8c00    Z1 Parallelverschiebung = 6,0 (−14,0 … 14,0)
```

### 2020-Rundruf des Energy Managers (Einstellungen)

Der Energy Manager schickt alle Einstellungen aller Zonen reihum, ca. alle 35 Minuten. Die Paketgrenzen sind stabil, daher lassen sich ebusd-`b`-Zeilen auf den ersten Code jedes Pakets setzen:

```
13 fe 2020 0c  6071 f401  6171 c800  6471 3c00     Max 50,0 · Min 20,0 · Verschiebung 6,0
13 fe 2020 0c  6971 0000  6a71 3c00  6b71 0000     Heizkurve 0,60
13 fe 2020 0a  6c71 0000  c079 03    c279 01       Regelung 3 · Raumeinfluss 1
13 fe 2020 0b  7971 aa00  7a71 1e00  0782 00       S/W 17,0 °C · 30 min
13 fe 2020 0a  c979 00    0081 01    6072 c201     Temperaturbereich Zone 1 = hoch
```

Zonen-Endungen: 2-Byte-Codes `…71`–`…76`, 1-Byte-Codes `…79`–`…7e` bzw. `…81`–`…86` für Zone 1–6.

### 2010 / 200f (Messwerte)

```
13 fe 2010 05  769e 4701 00         Rücklauf 32,7 °C
70 fe 2010 05  7118 cd00 00         Raumtemperatur 20,5 °C vom Bedienteil (vermutet)
13 fe 200f 0d  0591 0000  0691 0000  6996 d200 00
```

Je Code: Wert (1 oder 2 Byte) + 1 Flag-Byte (bisher immer 00).

## Vorgehen beim Entschlüsseln

1. `ebusctl grab` reicht nicht: `grab` behält pro Telegrammtyp nur das letzte Telegramm, Zonen überschreiben sich gegenseitig.
2. Besser: das Add-on-Protokoll über ≥ 60 min speichern. Unbekannte Telegramme stehen dort als `received unknown BC cmd: …`.
3. Werte über die Zeit gegen bekannte Messwerte legen (z. B. 769e ≡ Rücklauf).
4. Für Parameter: Wert, Min und Max aus 200e bzw. 2001 mit den Bereichen der Parameter-Tabelle der Anleitung abgleichen.
