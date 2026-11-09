# ebusd-Konfiguration für Elco Aerotop Mono.2 (BridgeNet)

Liest eine **Elco Aerotop Mono.2** Luft/Wasser-Wärmepumpe (Bedienteil Remocon Plus.2, optional Gateway Remocon NET) über den eBUS aus und stellt die Werte per MQTT in **Home Assistant** bereit.

Elco gehört zur Ariston-Gruppe. Die Geräte sprechen auf dem Bus das herstellerspezifische Protokoll **BridgeNet®**. Die offizielle Konfiguration von ebusd ([john30/ebusd-configuration](https://github.com/john30/ebusd-configuration)) deckt das nicht ab. Diese Konfiguration baut auf der Community-Arbeit von [wrongisthenewright/ebusd-configuration-ariston-bridgenet](https://github.com/wrongisthenewright/ebusd-configuration-ariston-bridgenet) auf und ist an die Mono.2 angepasst.

> **⚠ Nur Lesen.** Diese Konfiguration enthält **keine einzige Schreibzeile**. ebusd fragt nur Werte ab (Befehle `2000`/`2001`) oder hört mit, was Bedienteil, Gateway und Energy Manager ohnehin auf den Bus schicken. Einstellungen werden ausschließlich am Bedienteil oder in der Elco-App geändert.

---

## Inhalt

| Pfad | Inhalt |
|---|---|
| `config/elco-mono2.csv` | Nachrichtendefinitionen für die Mono.2 |
| `config/_templates.csv` | Datentyp-Vorlagen (unverändert aus dem Upstream-Projekt) |
| `docs/parameter-zuordnung.md` | Menüpunkte der Installateur-Anleitung ↔ Bus-Codes |
| `docs/bridgenet-protokoll.md` | Adressen, Befehle und Telegrammformate |
| `tools/build_from_upstream.sh` | erzeugt `elco-mono2.csv` reproduzierbar aus der Upstream-`ariston.csv` |

---

## Was ausgelesen wird

**Wärmepumpe** (Menü 13 der Anleitung): Außentemperatur, Vorlauf, Rücklauf, Verdampfer-, Sauggas-, Heißgas- und Kondensatoraustritt-Temperatur, Verdichterfrequenz, elektrische Leistungsaufnahme, Durchfluss, Verdampfer- und Kondensationsdruck, Expansionsventil, Lüfterdrehzahl, Betriebsmodus (Heizen / Zeitschutz / Standby / Abtauen …), Strömungsschalter, Silent Mode, Betriebsstunden, Abtaustunden, Verdichterstarts, Wechselrichter-Nennleistung, dT-Pumpen-Sollwert.

**Energy Manager** (Menü 1): Anlagenstatus, Vorlauf-Sollwert, Anlagendruck, Systemaußentemperatur, Korrektur Vorlauftemperatur, Abschalt-Außentemperaturen, Betriebsstunden.

**Zone 1** (Menü 4, passiv mitgehört): Heizkurve, Parallelverschiebung, Min-/Max-Vorlauf, Regelungsart, Raumeinfluss, Temperaturbereich, Komfort- und Absenktemperatur, aktueller Raum-Sollwert, Sommer/Winter-Umschaltung.

Die vollständige Liste mit Codes steht in [`docs/parameter-zuordnung.md`](docs/parameter-zuordnung.md).

---

## 1. Benötigte Hardware

| Teil | Hinweis |
|---|---|
| **eBUS-Adapter Shield C6** (ebusd-Adapter v5) – [adapter.ebusd.eu/v5-c6](https://adapter.ebusd.eu/v5-c6/) | Verbindung per WLAN (Standard) oder Ethernet (W5500-Modul). Andere ebusd-taugliche Adapter funktionieren grundsätzlich auch. |
| **USB-C-Netzteil** (mind. 2 W, 5 V / 400 mA) | Der Adapter ist galvanisch getrennt und wird **nicht** über den Bus versorgt. |
| **2-adriges Kabel** zur Inneneinheit | BridgeNet: max. 50 m, mind. 0,5 mm² (laut Elco-Anleitung). |
| **Home Assistant** mit **Mosquitto-Broker** und dem **ebusd-Add-on** | Alternativ ebusd als Docker-Container oder Systemdienst. |

### Anschluss an die Wärmepumpe

1. **Anlage stromlos schalten.** Arbeiten an der Inneneinheit nur durch eine Fachkraft – Netzspannung im Gerät. Eingriffe können die Gewährleistung berühren.
2. Der Adapter wird **parallel** an den Systembus der Inneneinheit angeschlossen: Klemme **„EBUS 2“** („Anschluss BUS für Systemschnittstelle“), an der auch das Bedienteil Remocon Plus.2 hängt.
3. Die **Polung spielt keine Rolle** (laut Adapter-Hersteller).
4. Adapter per USB-C mit Strom versorgen, Anlage wieder einschalten.

> Die Bus-Spannung bei BridgeNet liegt bei 8–24 V. Die Klemmenbezeichnung stammt aus der Installationsanleitung AEROTOP MONO M-RX/M-R (11-2023). Bei anderen Gerätevarianten bitte die eigene Anleitung prüfen.

### Adapter einrichten

1. Adapter mit Strom versorgen. Ein neuer Adapter öffnet den WLAN-Zugangspunkt **„EBUS“** (alternativ WPS).
2. Im Konfigurationsportal des Adapters WLAN-Name und Passwort eintragen, DHCP oder feste IP wählen.
3. IP-Adresse des Adapters notieren (Router-Oberfläche). Eine **feste IP** wird empfohlen.

---

## 2. ebusd-Add-on in Home Assistant einrichten

### Konfigurationsdateien in den Container bringen

Im Terminal des ebusd-Add-ons (bzw. per Samba/File-Editor im Add-on-Konfigurationsordner):

```sh
mkdir -p /config/elco
```

Dann `config/elco-mono2.csv` und `config/_templates.csv` aus diesem Repository nach `/config/elco/` kopieren.

### Startoptionen

Wichtig sind diese Optionen (je nach Add-on-Version als eigene Felder oder unter „zusätzliche Kommandozeilen-Optionen“):

| Option | Wert | Warum |
|---|---|---|
| Device | `ens:<IP-des-Adapters>:9999` | **`ens:` = Enhanced-Protokoll.** Ohne `ens:` übernimmt ebusd die Bus-Arbitrierung über WLAN selbst – das endet in ständigem „arbitration lost“. |
| `--configpath` | `/config/elco` | lädt diese Konfiguration statt der Standard-Konfiguration von ebusd.eu |
| scanconfig | **aus** | BridgeNet-Geräte beantworten die Standard-Identifikation nicht. Mit scanconfig würde nichts geladen. |
| `--mqttint` | `/config/mqtt-hassio.cfg` | Home-Assistant-Discovery |
| `--mqttjson` | – | JSON-Ausgabe für MQTT |
| `--enablehex` | *optional* | nur für eigene Tests mit `ebusctl hex` |

In der `mqtt-hassio.cfg` muss die Zeile so stehen – **ohne `w`**, damit Home Assistant keine Schreib-Entitäten anlegt:

```
filter-direction = r|u
```

Add-on neu starten.

### Prüfen

Im Terminal des Add-ons:

```sh
ebusctl info
```

Erwartet: `device: …, TCP, enhanced`, `messages:` deutlich über 100 und u. a. diese Teilnehmer:

| Adresse | Gerät |
|---|---|
| `1e` | Wärmepumpe (Außeneinheit) |
| `18` | Energy Manager (Inneneinheit, Master `13`) |
| `70` / `75` | Bedienteil Remocon Plus.2 |
| `7f` / `84` | Gateway Remocon NET (falls vorhanden) |
| `31` / `36` | ebusd selbst |

Einzelwerte testen:

```sh
ebusctl read -f -c heatpump heatpump_LWT_temp
ebusctl read -f -c heatpump heatpump_power_consumption
ebusctl read -f -c energymgr hybrid_status
```

Nach 2–3 Minuten erscheinen in Home Assistant unter *Einstellungen → Geräte & Dienste → MQTT* je ein Gerät für die Wärmepumpe (`heatpump`) und den Energy Manager (`energymgr`) mit laufend aktualisierten Werten. Die genauen Gerätenamen hängen von der `mqtt-hassio.cfg` ab.

---

## 3. Gut zu wissen

- **Aktualisierung:** ebusd fragt reihum etwa alle 6 s einen Wert ab. Die wichtigen Wärmepumpen-Werte (`r1`) sind dadurch alle 1,5–2,5 min frisch, Status (`r3`) seltener, Zähler (`r9`) selten.
- **Zonen-Parameter** (Heizkurve usw.) schickt der Energy Manager nur etwa **alle 35 Minuten** von selbst. Nach einem Neustart dauert es entsprechend, bis sie gefüllt sind.
- **„invalid position“ nach einem Neustart:** ebusd liest beim Start einmal alle Definitionen. Einzelne Werte, die eine Anlage nicht hat, erzeugen dabei harmlose Fehler.
- **„arbitration lost“:** gelegentlich normal (mehrere Teilnehmer senden gleichzeitig). Gehäuft → `ens:` im Device fehlt oder WLAN-Empfang des Adapters schlecht.
- **Verdichter-Laufstatus:** `heatpump_compressor_state` zeigt auch bei 0 Hz „on“. Zuverlässiger ist `heatpump_compr_frequency > 0`.
- **Kein Warmwasserspeicher?** Dann liefern Speichertemperaturen 3276,7 (= kein Fühler). Das ist korrekt.
- **Elco-Cloud (Remocon NET):** stört nicht. ebusd hört die Abfragen von Bedienteil und Gateway sogar mit (z. B. Anlagendruck).

---

## 4. Status

Getestet an einer Aerotop Mono.2, 8 kW, Monoblock, nur Heizbetrieb, ohne Warmwasserspeicher, eine Heizzone, mit Remocon NET.

| Bereich | Status |
|---|---|
| Wärmepumpen-Messwerte (1e) | ✔ gegen Bedienteil geprüft |
| Energy-Manager-Status, Anlagendruck | ✔ |
| Zone-1-Parameter (Rundrufe) | ✔ dekodiert, Parallelverschiebung am Gerät bestätigt |
| Raumtemperatur / Luftfeuchte vom Bedienteil | ⏳ in der CSV auskommentiert, noch nicht bestätigt |
| Einheit der Zähler (Menü 13.7: „h/10“, „n/10“) | ⏳ in Prüfung |
| Zeitprogramme (`2050`–`2052`, `2073`) | ✘ nicht dekodiert (in der App sichtbar) |
| Warmwasser, Kühlen, Zonen 2–6, Puffer | ✘ nicht getestet (an der Testanlage nicht vorhanden) |

Rückmeldungen von anderen Anlagenvarianten sind willkommen.

---

## Lizenz und Dank

Die Nachrichtendefinitionen sind abgeleitet aus [wrongisthenewright/ebusd-configuration-ariston-bridgenet](https://github.com/wrongisthenewright/ebusd-configuration-ariston-bridgenet) (Ergebnis der Community auf energeticambiente.it, Beiträge aus [ysard/ebusd_configuration_chaffoteaux_bridgenet](https://github.com/ysard/ebusd_configuration_chaffoteaux_bridgenet) und [komw/ariston-bus-bridgenet-ebusd](https://github.com/komw/ariston-bus-bridgenet-ebusd)) und stehen daher ebenfalls unter der **GPL-3.0** (siehe `LICENSE`).

Kein offizielles Produkt von Elco oder Ariston. Nutzung auf eigene Verantwortung.
