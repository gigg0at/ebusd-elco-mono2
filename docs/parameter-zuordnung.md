# Parameter-Zuordnung Elco Aerotop Mono.2

Menüpunkte aus der Installationsanleitung *AEROTOP MONO M-RX/M-R, 420011185102, 11-2023 (DE)*, Parameter-Tabelle S. 86–95, zugeordnet zu den Codes auf dem Bus. Werte in Klammern sind die Messwerte der Testanlage.

Legende: ✔ sicher (gegen Bedienteil/Anleitung geprüft) · ~ wahrscheinlich · ? offen

## Wärmepumpe (Adresse 1e, Lesebefehl 2000)

| Menü | Bezeichnung | Code | Typ | ebusd-Name | |
|---|---|---|---|---|---|
| 13.8.0 | Außenluft-Temperatur | 7810 | SIN/10 °C | heatpump_ext_temp | ✔ |
| 13.8.1 | WP Vorlauftemperatur | 7610 | SIN/10 °C | heatpump_LWT_temp | ✔ |
| 13.8.2 | WP Rücklauftemperatur | 7710 | SIN/10 °C | heatpump_EWT_temp | ✔ |
| 13.8.3 | Verdampfungstemperatur | 7910 | SIN/10 °C | heatpump_evaporator_temp | ✔ |
| 13.8.4 | Sauggastemperatur | 7217 | SIN/10 °C | heatpump_suction_temp | ✔ |
| 13.8.5 | Heißgastemperatur | 7317 | SIN/10 °C | heatpump_comp_discharge_temp | ✔ |
| 13.8.6 | Kondensator-Austrittstemperatur | 7117 | SIN/10 °C | heatpump_condenser_outlet_temp | ✔ |
| 13.8.7 | TEO | 7417 | SIN/10 °C | heatpump_teo_temp | ✔ |
| 13.9.0 | WP Betriebsmodus | ca46 | UCH | heatpump_mode | ✔ (3 Heizen, 11 Zeitschutz, 1 Standby) |
| 13.9.3 | Durchflusssensor | 6e13 | UIN/10 l/min | heatpump_flowmeter | ✔ |
| 13.9.4 | Durchflussschalter | 0c45 | | heatpump_flow_switch | ✔ |
| 13.9.6 | Verdampfungsdruck | 6c4f | UIN/10 bar | heatpump_evap_pressure | ✔ |
| 13.9.7 | Kondensationsdruck | 6d4f | UIN/10 bar | heatpump_cond_pressure | ✔ |
| 13.10.0 | Wechselrichterleistung | 6947 | kW | heatpump_inverter_nominal_power | ✔ (8) |
| 13.10.1 | Kompressor aktuelle Drehzahl | cb46 | Hz | heatpump_compr_frequency | ✔ |
| 13.10.2 | Kompressor Soll-Modulation | c446 | % | heatpump_compr_modulation | ~ (zeigt 100) |
| 13.10.5 | Ventilator 1 Drehzahl | 6e4f | rpm | heatpump_fan1_speed | ✔ |
| 13.10.7 | Expansionsventil | 704f | | heatpump_exp_valve | ✔ |
| – | Elektrische Leistungsaufnahme | 6347+7c4f | W | heatpump_power_consumption | ✔ |
| 13.4.4 | dT Pumpe Sollwert | 7b2b | SIN/10 °C | pump_dt_setpoint | ~ (6,0) |
| 13.7.1 | WP Anzahl ON-Zyklen | 40d8 | UIN | heatpump_ingnition_cycles | ? Einheit (Anzeige „n/10“) |
| 13.7.2 | WP Abtauung Stunden | 47d1 | UIN | heatpump_defrost_op_hours | ? Einheit (Anzeige „h/10“) |

Nicht vorhanden an 1e (Antwort `01 00`): d927 (Anticycle Kühlen).

## Energy Manager (Adresse 18)

| Menü | Bezeichnung | Befehl / Code | Typ | ebusd-Name | |
|---|---|---|---|---|---|
| 1.16.0 | Status Energiemanager | 2000 c94b | UCH | hybrid_status | ✔ |
| 1.16.7 | Systemdruck Heizkreis | 2000 7547 | SIN/10 bar | system_pressure | ✔ (2,0) |
| 1.5.2 | AT für Heizkesselabschaltung | 2000 7126 | SIN/10 °C | boiler_disable_ext_temp_threshold | ✔ |
| 1.5.3 | AT für WP-Abschaltung | 2000 7226 | SIN/10 °C | hp_disable_ext_temp_threshold | ✔ |
| 1.7.2 | Korrektur Vorlauftemperatur WP | 2001 7d2b | SIN/10 °C (0–10) | hp_flow_correction | ✔ |
| 1.6.3 | Pumpenbetrieb | 2001 c328 | 0–2 | – | ✔ (2 = modulierend) |
| – | Silent Mode | 2000/2001 0320 | onoff | silent_mode | ✔ |
| 1.14.x | Betriebsstunden | 2000 40d1/55d1/… | UIN h | heatpump_*_op_hours | ✔ |

Nicht per 2001 lesbar (Antwort `00`): Zonenparameter (6471 …) sowie 602b, 7e2b, 672e, 682e, 692e, 6d8f, 6e8f, 7c8e, d02a, d479.

## Zone 1 (passiv aus Rundrufen des Energy Managers)

| Menü | Bezeichnung | Code | Typ | ebusd-Name | |
|---|---|---|---|---|---|
| 4.0.0 | T Tag | 6271 | SIN/10 °C | z1_comfort_temp | ✔ |
| 4.0.1 | T Nacht | 6371 | SIN/10 °C | z1_reduced_temp | ✔ |
| 4.0.2 | T Soll Z1 | 6571 | SIN/10 °C | z1_heat_setpoint_temp_set | ~ |
| 4.1.0 | S/W Funktion | 0781 | 0/1 | – | ✔ |
| 4.1.1 | S/W Temperatur-Grenzwert | 7971 | SIN/10 °C | z1_sw_threshold | ✔ |
| 4.1.2 | S/W Verzögerungszeit | 7a71 | UIN min | z1_sw_delay | ✔ |
| 4.2.0 | Temperaturbereich | 0081 | 0 = niedrig, 1 = hoch | z1_temp_range | ✔ |
| 4.2.1 | Art der Temperaturregelung | c079 | 0–4 | z1_control_type | ✔ |
| 4.2.2 | Heizkurve | 6a71 | UIN/100 | z1_heat_curve | ✔ |
| 4.2.3 | Parallelverschiebung | 6471 | SIN/10 °C | z1_parallel_shift, z1_heat_offset_shift | ✔ (am Gerät bestätigt) |
| 4.2.4 | Raumeinfluss | c279 | UCH | z1_room_influence | ✔ |
| 4.2.5 | Max. Vorlauf | 6071 | SIN/10 °C | z1_max_flow_temp | ✔ |
| 4.2.6 | Min. Vorlauf | 6171 | SIN/10 °C | z1_min_flow_temp | ✔ |
| 4.2.9 | Wärmeanforderungsmodus | ce79 | 0–2 | – | ~ |
| – | aktueller Raum-Sollwert | 6996 / 79c0 | SIN/10 °C | z1_setpoint_temp | ✔ |
| – | Wärmeanforderung | 0191 | 0/1 | heat_request | ✔ |

Zonen 2–6 verwenden dieselben Codes mit Endung 72…76 (bzw. 7a…7e bei 1-Byte-Codes).

## Weitere Rundrufe

| Code | Quelle | Bedeutung | |
|---|---|---|---|
| 6047 | 13 (2010/200f) | Vorlauf-Sollwert | ✔ |
| 6f17 / 7647 | 13 (2010) | Außentemperatur (System) | ✔ |
| 769e | 13 (2010, ~25 s) | Rücklauf | ✔ (identisch mit 7710) |
| 74fd | 18 (vom Gateway gelesen) | Vorlauf | ✔ (identisch mit 7610) |
| 7118 | 70 Bedienteil (2010, ~2 min) | Raumtemperatur Zone 1 | ~ |
| 489d | 70 Bedienteil (2010) | relative Raumfeuchte (/10 %) | ~ |
| 6213 | 18 | ? (≈ 3487, schwankt) | ? |
| 4dfd | 18 | ? (2) | ? |
| c9c1 | 13 | ? (46–48) | ? |
| c0f2 | 18/1e/84 | vermutl. SW-/Protokollversion | ? |
| cff9, d3f9, ddf2, c19a | 7f | Status Gateway | ? |
| 2050–2052, 2071, 2073 | 7f (Gateway) | Zeitprogramme / Übersteuerungen | nicht dekodiert |

## Hinweise aus der Anleitung zum Takten

- Eine Kompressor-Taktsperre ist **nicht** einstellbar („Zeitschutz“ ist fest in der Firmware).
- Eine Hysterese gibt es nur mit Pufferspeicher (20.0.2, 5 °C, 0–20).
- Einflussgrößen: 4.2.2 Heizkurve, 4.2.3 Parallelverschiebung, 4.2.4 Raumeinfluss, 1.7.1 Dauer Temperaturanstieg (16 min, 0–60), 1.6.1 Verzögerung neue Anforderung (90 s, 0–100).
- Mindest-Wassergehalt: 10 l je kW Nennleistung. Mindestdurchfluss Modell 08: 600 l/h.
