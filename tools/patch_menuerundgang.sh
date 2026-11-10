#!/bin/sh
# Korrekturen und Ergänzungen aus dem Menü-Rundgang vom 10.11.2026.
# Wird von build_from_upstream.sh aufgerufen, kann aber auch einzeln auf eine
# bestehende Datei angewendet werden:  sh tools/patch_menuerundgang.sh <datei.csv>
# NUR LESEN: es kommen ausschließlich Lese- (2000/2001) und Mithör-Zeilen (b) dazu.
set -e
F="$1"

# 1) Status-Zeilen der WP lasen das Maskenbyte statt des Werts (Verdichter zeigte immer "on")
sed -i -E '/^r1?,heatpump,heatpump_(compr_current|compressor_state|fan1_state|fan2_state|4way_valve_state),/ s/,1e,2000,([0-9a-f]{4}),,s,/,1e,2000,\1,,s,IGN:1,,,,,s,/' "$F"

# 2) Zonen-Rundrufe 2020 nur vom Energy Manager (13) auswerten.
#    Einzelwert-Pakete vom Bedienteil (70) sind Schreibbefehle und erzeugten Parsefehler.
sed -i -E 's/^b,energymgr,(z1_flow_limits|z1_heat_curve|z1_regulation|z1_summer_winter|z1_temp_range_bc),([^,]*),,fe,2020,/b,energymgr,\1,\2,13,fe,2020,/' "$F"

# 3) Falsche bzw. ersetzte Zeilen entfernen
sed -i -E '/^r[0-9]?,heatpump,(heatpump_last_error|heatpump_safety_thermostat|heatpump_electric_heater|pump_dt_setpoint|pump_max_pwm|pump_min_pwm|pump_operation),/d' "$F"
sed -i -E '/^r[0-9]?,energymgr,(hydraulic_scheme|energymgr_hv_inv_3_status),/d' "$F"
sed -i -E '/^b,energymgr,(heat_slope|heat_request|setpoint_temp),/d; /^#b,panel,/d; /^# UNBESTÄTIGT – Rundrufe des Bedienteils/d' "$F"

# 4) WP-Betriebsstunden selten abfragen
sed -i -E 's/^r,(energymgr,heatpump_only_op_hours,)/r9,\1/' "$F"

# 5) Neue Zeilen anhängen
cat >> "$F" <<'ADD'

# ---- Menü-Rundgang 10.11.2026 (zugeordnet über Bedienteil-Screenshots) ----
# Zone 1 – Rundrufe (passiv mithören)
b,zone1,room_temp,Raumtemperatur Bedienteil 4.3.0,70,fe,2010,7118,,m,SIN,10,°C,,,m,IGN:1
b,zone1,room_humidity,Relative Luftfeuchte 4.3.7,13,fe,2010,c9c1,,m,UCH,,%,,,m,IGN:1
b,zone1,heat_request,Waermeanforderung Zone 1 4.3.4,13,fe,2010,0191,,m,UCH,0=off;1=on,,,,m,IGN:1
# Zone 1 – Antworten auf Menü-Abfragen des Bedienteils (nur aktuell, wenn das Menü geöffnet wird)
b,zone1,temp_control_type,Art der Temperaturregelung 4.2.7,13,fe,200e,0881,,m,UCH,0=Klassik;1=Smart,,,,m,IGN:2
b,zone1,quick_setback,Schnellabsenkung 4.2.8,13,fe,200e,db89,,m,UCH,0=off;1=on,,,,m,IGN:2
b,zone1,heat_request_mode,Waermeanforderungsmodus 4.2.9,13,fe,200e,ce79,,m,UCH,0=Standard;1=Zeitprogramm aus;2=Erzwungen,,,,m,IGN:2

# Energy Manager – Einstellungen (Parameter lesen 2001: Wert, Min, Max)
r9,energymgr,ext_heat_logic,Aktivierungslogik ext. Waermeerzeuger 1.3.0,,18,2001,1488,,s,UCH,,,,,s,IGN:2
r9,energymgr,backup_heater_setting,Elektroeinsatz Einstellung 1.3.1,,18,2001,dd28,,s,UCH,,,,,s,IGN:2
r9,energymgr,backup_heater_delay,Elektroeinsatz Verzoegerung 1.3.3,,18,2001,da8d,,s,UCH,,min,,,s,IGN:2
r9,energymgr,backup_release_integral,Freigabeintegralschwelle 1.3.4,,18,2001,6f8c,,s,UIN,,,,,s,IGN:4
r9,energymgr,backup_reset_integral,Integralschwelle zuruecksetzen 1.3.5,,18,2001,708c,,s,UIN,,,,,s,IGN:4
r9,energymgr,pump_prerun,Vorlaufzeit Heizkreispumpe 1.6.0,,18,2001,d527,,s,UCH,,s,,,s,IGN:2
r9,energymgr,new_request_delay,Verzoegerung neue Anforderung 1.6.1,,18,2001,d627,,s,UCH,,s,,,s,IGN:2
r9,energymgr,pump_overrun,Nachzirkulation Heizung 1.6.2,,18,2001,d727,,s,UCH,,min,,,s,IGN:2
r9,heatpump,pump_operation,Pumpenbetrieb 1.6.3,,18,2001,c32a,,s,UCH,0=low_speed;1=high_speed;2=modulating,,,,s,IGN:2
r9,energymgr,antifreeze_circulation,WP Frostschutz Zirkulation 1.6.4,,18,2001,c58f,,s,UCH,,,,,s,IGN:2
r9,heatpump,silent_start,Leiser Betrieb Startzeit 1.12.3,,18,2001,692b,,s,VTM,,,,,s,IGN:4
r9,heatpump,silent_end,Leiser Betrieb Endezeit 1.12.4,,18,2001,6a2b,,s,VTM,,,,,s,IGN:4
r9,energymgr,floor_drying,Estrichtrocknung 1.12.5,,18,2001,de28,,s,UCH,,,,,s,IGN:2
r9,energymgr,hydraulic_scheme,Hydraulikschema 1.16.1,,18,2001,d4f7,,s,UCH,,,,,s,IGN:2
r3,energymgr,room_thermostat_1,Raumthermostat 1 1.17.0,,18,2001,011f,,s,onoff,,,,,s,IGN:2
r9,energymgr,room_thermostat_2,Raumthermostat 2 1.17.1,,18,2001,021f,,s,onoff,,,,,s,IGN:2
r9,energymgr,energymgr_aux2_input,AUX Eingang 2 1.17.3,,18,2001,1f11,,s,onoff,,,,,s,IGN:2
r9,energymgr,backup_heater_hours,Betriebsstunden Elektroeinsatz Stufe 1 1.14.3,,18,2000,51d1,,s,IGN:1,,,,,,UIN,,h

# Wärmepumpe (1e) – Einstellungen und Diagnose (Parameter lesen 2001)
r9,heatpump,pump_dt_setpoint,dT Pumpe Sollwert 13.4.4,,1e,2001,7b2b,,s,SIN,10,°C,,,s,IGN:4
r9,heatpump,pump_max_pwm,Max. Pumpe PWM 13.4.5,,1e,2001,d32c,,s,UCH,,%,,,s,IGN:2
r9,heatpump,pump_min_pwm,Min. Pumpe PWM 13.4.6,,1e,2001,d22c,,s,UCH,,%,,,s,IGN:2
r3,heatpump,heatpump_last_error,Letzter Wechselrichterfehler 13.9.1,,1e,2001,c54b,,s,UCH,,,,,s,IGN:2
r3,heatpump,heatpump_safety_thermostat,Sicherheitsthermostat 13.9.2,,1e,2001,0316,,s,UCH,0=open;1=closed,,,,s,IGN:2
r3,heatpump,heatpump_electric_heater,Elektroheizeinsatz 1 13.10.3,,1e,2001,1c45,,s,onoff,,,,,s,IGN:2
ADD
