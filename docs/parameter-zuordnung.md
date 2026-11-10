# Parameter-Zuordnung Elco Aerotop Mono.2

Menüpunkte des Bedienteils Remocon Plus.2 bzw. der Installationsanleitung *AEROTOP MONO M-RX/M-R, 420011185102, 11-2023 (DE)*, zugeordnet zu den Codes auf dem Bus. Grundlage ist ein vollständiger Menü-Rundgang am 10.11.2026: jeder Menüpunkt wurde fotografiert und gleichzeitig mitgeschnitten, welche Abfrage das Bedienteil dafür auf den Bus schickt. Werte in Klammern sind die Messwerte der Testanlage.

Legende: ✔ gegen Bedienteil geprüft · ~ wahrscheinlich · ? offen

**Lesebefehle:** `2000` liefert `Maske Wert`, `2001` liefert `Wert Min Max` (beide nur lesend). Ein Code mit erstem Byte < `0x40` oder ≥ `0xC0` hat einen 1-Byte-Wert, sonst 2 Byte (Little Endian).

## Wärmepumpe (Adresse 1e)

| Menü | Bezeichnung | Befehl / Code | Typ | ebusd-Name | |
|---|---|---|---|---|---|
| 13.4.4 | dT Pumpe Sollwert | 2001 7b2b | SIN/10 °C (5–20) | pump_dt_setpoint | ✔ (5,0) |
| 13.4.5 | Max. Pumpe PWM | 2001 d32c | % | pump_max_pwm | ✔ (100) |
| 13.4.6 | Min. Pumpe PWM | 2001 d22c | % | pump_min_pwm | ✔ (40) |
| 13.7.0 | WP-Betriebsstunden | 2000 40d1 | UIN h | heatpump_only_op_hours | ✔ (3578) |
| 13.7.1 | WP Anzahl ON-Zyklen | 2000 40d8 | UIN | heatpump_ingnition_cycles | ✔ (4381) |
| 13.7.2 | WP Abtauung Stunden | 2000 47d1 | UIN h | heatpump_defrost_op_hours | ✔ (50) |
| 13.8.0 | Außenluft-Temperatur | 2000 7810 | SIN/10 °C | heatpump_ext_temp | ✔ |
| 13.8.1 | WP Vorlauftemperatur | 2000 7610 | SIN/10 °C | heatpump_LWT_temp | ✔ |
| 13.8.2 | WP Rücklauftemperatur | 2000 7710 | SIN/10 °C | heatpump_EWT_temp | ✔ |
| 13.8.3 | Verdampfungstemperatur | 2000 7910 | SIN/10 °C | heatpump_evaporator_temp | ✔ |
| 13.8.4 | Sauggastemperatur | 2000 7217 | SIN/10 °C | heatpump_suction_temp | ✔ |
| 13.8.5 | Heißgastemperatur | 2000 7317 | SIN/10 °C | heatpump_comp_discharge_temp | ✔ |
| 13.8.6 | Kondensator-Austrittstemperatur | 2000 7117 | SIN/10 °C | heatpump_condenser_outlet_temp | ✔ |
| 13.8.7 | TEO | 2000 7417 | SIN/10 °C | heatpump_teo_temp | ✔ |
| 13.9.0 | WP Betriebsmodus | 2000 ca46 | UCH | heatpump_mode | ✔ (1 Standby, 3 Heizen, 11 Zeitschutz) |
| 13.9.1 | Letzter Wechselrichterfehler | 2001 c54b | UCH | heatpump_last_error | ✔ (0) |
| 13.9.2 | Sicherheitsthermostat | 2001 0316 | 0/1 | heatpump_safety_thermostat | ✔ (1 = geschlossen) |
| 13.9.3 | Durchfluss | 2000 6e13 | UIN/10 l/min | heatpump_flowmeter | ✔ |
| 13.9.4 | Durchflussschalter | 2000 0c45 | 0/1 | heatpump_flow_switch | ✔ |
| 13.9.5 | Wechselrichter-Abschaltschutz | 2000 1045 | 0/1 | heatpump_shutoff_protection | ✔ |
| 13.9.6 | Verdampfungsdruck | 2000 6c4f | UIN/10 bar | heatpump_evap_pressure | ✔ |
| 13.9.7 | Kondensationsdruck | 2000 6d4f | UIN/10 bar | heatpump_cond_pressure | ✔ |
| 13.10.0 | Wechselrichterleistung | 2000 6947 | kW | heatpump_inverter_nominal_power | ✔ (8) |
| 13.10.1 | Kompressor aktuelle Drehzahl | 2000 cb46 | Hz | heatpump_compr_frequency | ✔ |
| 13.10.2 | Kompressor Soll-Modulation | 2000 c446 | % | heatpump_compr_modulation | ✔ (100) |
| 13.10.3 | Elektroheizeinsatz 1 | 2001 1c45 | 0/1 | heatpump_electric_heater | ✔ |
| 13.10.5 | Ventilator 1 Drehzahl | 2000 6e4f | rpm | heatpump_fan1_speed | ✔ |
| 13.10.6 | Ventilator 2 Drehzahl | 2000 6f4f | rpm | heatpump_fan2_speed | ✔ |
| 13.10.7 | Expansionsventil 1 | 2000 704f | Schritte | heatpump_exp_valve | ✔ (500) |
| 13.11.0 | Kompressor an/aus | 2000 1145 | 0/1 | heatpump_compressor_state | ✔ |
| 13.11.1 | Kompressorvorwärmung | 2000 1245 | 0/1 | heatpump_preheater_state | ✔ |
| 13.11.2 / 3 | Ventilator 1 / 2 | 2000 1445 / 1545 | 0/1 | heatpump_fan1_state / fan2_state | ✔ |
| 13.11.4 | 4-Wege-Ventil | 2000 1345 | 0/1 | heatpump_4way_valve_state | ✔ |
| 13.11.5 | Kondensatwannenheizung | 2000 1645 | 0/1 | heatpump_base_pane_heater_state | ✔ |
| 13.12.0 | SW-Version Hauptplatine | 2002 | HEX | heatpump_sw_version | ✔ (31.33.00 = `1f 21 00`) |
| – | Elektrische Leistungsaufnahme | 2000 6347+7c4f | W | heatpump_power_consumption | ✔ |

## Energy Manager (Adresse 18)

| Menü | Bezeichnung | Befehl / Code | Typ | ebusd-Name | |
|---|---|---|---|---|---|
| 1.3.0 | Aktivierungslogik ext. Wärmeerzeuger | 2001 1488 | 0–1 | ext_heat_logic | ✔ (0) |
| 1.3.1 | Elektroeinsatz Einstellung | 2001 dd28 | 0–3 | backup_heater_setting | ✔ (0) |
| 1.3.2 | ECO / KOMFORT | 2000 c728 | 0–5 | heating_mode | ✔ (0) |
| 1.3.3 | Verzögerung Elektroeinsatz | 2001 da8d | min (0–120) | backup_heater_delay | ✔ (30) |
| 1.3.4 | Freigabeintegralschwelle | 2001 6f8c | UIN (0–600) | backup_release_integral | ✔ (100) |
| 1.3.5 | Integralschwelle zurücksetzen | 2001 708c | UIN (0–600) | backup_reset_integral | ✔ (30) |
| 1.5.2 | AT für Heizkesselabschaltung | 2000 7126 | SIN/10 °C | boiler_disable_ext_temp_threshold | ✔ |
| 1.5.3 | AT für WP-Abschaltung | 2000 7226 | SIN/10 °C | hp_disable_ext_temp_threshold | ✔ |
| 1.6.0 | Vorlaufzeit Heizkreispumpe | 2001 d527 | s (30–255) | pump_prerun | ✔ (30) |
| 1.6.1 | Verzögerung neue Anforderung | 2001 d627 | s (0–100) | new_request_delay | ✔ (90) |
| 1.6.2 | Nachzirkulation Heizung | 2001 d727 | min (0–16) | pump_overrun | ✔ (15) |
| 1.6.3 | Pumpenbetrieb | 2001 c32a | 0–2 | pump_operation | ✔ (2 = modulierend) |
| 1.6.4 | WP Frostschutz Zirkulation | 2001 c58f | 0–2 | antifreeze_circulation | ✔ (1) |
| 1.7.2 | Korrektur Vorlauftemperatur WP | 2001 7d2b | SIN/10 °C | hp_flow_correction | ✔ (0,0) |
| 1.12.1 | Antiblock Pumpe | 2000 1823 | 0/1 | pump_antiblock | ✔ |
| 1.12.2 | Leiser Betrieb | 2000 0320 | 0/1 | silent_mode | ✔ (1) |
| 1.12.3 | Leiser Betrieb Startzeit | 2001 692b | VTM (mm hh) | silent_start | ✔ (06:00) |
| 1.12.4 | Leiser Betrieb Endezeit | 2001 6a2b | VTM (mm hh) | silent_end | ✔ (22:00) |
| 1.12.5 | Estrichtrocknung | 2001 de28 | 0–5 | floor_drying | ✔ (0) |
| 1.14.1 | Betriebsstunden Heizen | 2000 55d1 | UIN h | heatpump_heating_op_hours | ✔ (4312) |
| 1.14.2 | Betriebsstunden Warmwasser | 2000 56d1 | UIN h | heatpump_dhw_buffer_op_hours | ✔ (0) |
| 1.14.3 | Elektroeinsatz Stufe 1 | 2000 51d1 | UIN h | backup_heater_hours | ✔ (100) |
| 1.14.4 / 5 | Elektroeinsatz Stufe 2 / 3 | 2000 52d1 / 53d1 | UIN h | – | ✔ (0) |
| 1.14.6 | Betriebsstunden Kühlen | 2000 54d1 | UIN h | heatpump_cooling_op_hours | ✔ (0) |
| 1.16.0 | Status Energiemanager | 2000 c94b | UCH | hybrid_status | ✔ |
| 1.16.1 | Hydraulikschema | 2001 d4f7 | UCH | hydraulic_scheme | ✔ (4) |
| 1.16.2 | Vorlauf-Sollwert | Rundruf 2010 6047 | SIN/10 °C | hybrid_LWT_setpoint | ✔ |
| 1.16.7 | Systemdruck Heizkreis | 2000 7547 | SIN/10 bar | system_pressure | ✔ (1,9–2,0) |
| 1.17.0 / 1 | Raumthermostat 1 / 2 | 2001 011f / 021f | 0/1 | room_thermostat_1 / _2 | ✔ (1 / 0) |
| 1.17.2 / 3 | AUX-Eingang 1 / 2 | 2000 1e11 / 2001 1f11 | 0/1 | energymgr_aux1_input / energymgr_aux2_input | ✔ (0 / 1) |
| 1.17.4 / 5 | HV-Eingang 1 / 2 | 2000 1d11 / 1c11 | 0/1 | energymgr_hv_inv_1_status / _2_status | ✔ |
| 1.18.0 | Hauptumwälzpumpe | 2000 c200 | 0/1 | heatpump_main_pump | ✔ |
| 1.18.2 | Heizkreispumpe 2 | 2000 c700 | 0/1 | heatpump_ext_pump | ✔ |
| 1.18.3 | Umschaltventil Heizen/WW | 2000 0601 | 0/1 | heatpump_3way_valve_dhw_heat | ✔ |
| 1.19.0 | SW-Version Hauptplatine | 2002 | HEX | energymgr_sw_version | ✔ (22.07.14 = `16 07 0e`) |

## Zone 1

| Menü | Bezeichnung | Quelle / Code | Typ | ebusd-Name | |
|---|---|---|---|---|---|
| 4.0.0 | T Tag | 13, 200e 6271 | SIN/10 °C | z1_comfort_temp | ✔ |
| 4.0.1 | T Nacht | 13, 200e 6371 | SIN/10 °C | z1_reduced_temp | ✔ |
| 4.1.1 / 4.1.2 | S/W Grenzwert / Verzögerung | 13, 2020 7971 | SIN/10 °C, min | z1_summer_winter | ✔ (17,0 / 30) |
| 4.2.0 | Temperaturbereich | 13, 2020 c979 | 0/1 | z1_temp_range_bc | ✔ |
| 4.2.1 / 4.2.4 | Regelungsart / Raumeinfluss | 13, 2020 6c71 | UCH | z1_regulation | ✔ |
| 4.2.2 | Heizkurve | 13, 2020 6971 | UIN/100 | z1_heat_curve | ✔ (0,90) |
| 4.2.3 | Parallelverschiebung | 13, 200e 6471 | SIN/10 °C | z1_heat_offset_shift | ✔ (+1,0) |
| 4.2.5 / 4.2.6 | Max. / Min. Vorlauf | 13, 2020 6071 | SIN/10 °C | z1_flow_limits | ✔ (52 / 20) |
| 4.2.7 | Art der Temperaturregelung | 13, 200e 0881 | 0 Klassik / 1 Smart | temp_control_type | ✔ (0) |
| 4.2.8 | Schnellabsenkung | 13, 200e db89 | 0/1 | quick_setback | ✔ (0) |
| 4.2.9 | Wärmeanforderungsmodus | 13, 200e ce79 | 0–2 | heat_request_mode | ✔ (0 Standard) |
| 4.3.0 | Raumtemperatur | 70, 2010 7118 | SIN/10 °C | room_temp | ✔ (22,6) |
| 4.3.1 | Sollwert Raumtemperatur | 13, 200f 6996 | SIN/10 °C | z1_setpoint_temp | ✔ (21,5) |
| 4.3.4 | Wärmeanforderung | 13, 2010 0191 | 0/1 | heat_request | ✔ |
| 4.3.7 | Relative Luftfeuchte | 13, 2010 c9c1 | UCH % | room_humidity | ✔ (51) |
| 4.3.8 | Vorlaufsollwert Heizkreis | 13, 200e 6197 | SIN/10 °C | – (= 6047) | ✔ (31,5) |

`200e`-Werte (4.2.7–4.2.9, 6271, 6371, 6471) schickt der Energy Manager nur als Antwort, wenn Bedienteil oder Gateway den Menüpunkt abfragen. `2020`-Rundrufe kommen etwa alle 35 Minuten. Die Zeilen werten nur Pakete vom Energy Manager (`13`) aus; Einzelwert-Pakete vom Bedienteil (`70`) sind Schreibbefehle bei einer Änderung am Gerät.

Zonen 2–6 verwenden dieselben Codes mit Endung 72…76 (bzw. 7a…7e bei 1-Byte-Codes).

## Offen

| Code | Quelle | Beobachtung |
|---|---|---|
| 489d | 70 (2010) | /10 ≈ 29,8–33,0, steigt mit der Raumtemperatur. Keine Luftfeuchte; vermutlich Innentemperatur des Bedienteils |
| 714f | 1e | als Verdichterstrom (/10 A) übernommen, nicht im Menü sichtbar |
| 4bfd, 4cfd, 4dfd | 18 | 10 / 0 / 2 |
| cb9c | 1e | 55 |
| 52d9–57d9 | 18 (vom Gateway gelesen) | 32-Bit-Werte, vermutlich Energiezähler |
| 6213 | 18 | ≈ 3487, schwankt |
| 2050–2052, 2071, 2073 | 7f (Gateway) | Zeitprogramme / Übersteuerungen, nicht dekodiert |

## Hinweise aus der Anleitung zum Takten

- Eine Kompressor-Taktsperre ist **nicht** einstellbar („Zeitschutz“ ist fest in der Firmware).
- Eine Hysterese gibt es nur mit Pufferspeicher (20.0.2, 5 °C, 0–20).
- Einflussgrößen: 4.2.2 Heizkurve, 4.2.3 Parallelverschiebung, 4.2.4 Raumeinfluss, 1.7.1 Dauer Temperaturanstieg (16 min, 0–60), 1.6.1 Verzögerung neue Anforderung (90 s, 0–100).
- Mindest-Wassergehalt: 10 l je kW Nennleistung. Mindestdurchfluss Modell 08: 600 l/h.
