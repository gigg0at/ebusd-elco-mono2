#!/bin/sh
# Erzeugt config/elco-mono2.csv aus der Upstream-Datei ariston.csv
# (https://github.com/wrongisthenewright/ebusd-configuration-ariston-bridgenet, GPL-3.0).
# Aufruf: sh tools/build_from_upstream.sh <pfad/zu/upstream/ariston.csv> <ziel.csv>
set -e
SRC="$1"; DST="$2"
cp "$SRC" "$DST"

# 1) Wärmepumpen-Messwerte liegen bei der Mono.2 an Adresse 1e (nicht 18)
sed -i -E '/^r,heatpump,heatpump_(ext|LWT|EWT|evaporator|suction|comp_discharge|condenser_outlet)_temp,/ s/,18,2000,/,1e,2000,/' "$DST"
sed -i -E '/^r,heatpump,heatpump_mode,/ s/,18,2000,/,1e,2000,/' "$DST"
sed -i -E '/^r,energymgr,heatpump_(defrost_op_hours|ingnition_cycles),/ s/,18,2000,/,1e,2000,/' "$DST"

# 2) Nicht vorhandene Geräte/Zonen entfernen (kein Kessel, nur Zone 1)
sed -i -E '/^[rwbg],boiler,/d; /^[rwbg],[a-z]+,z[23]_/d' "$DST"

# 3) NUR LESEN: alle Schreibzeilen entfernen
sed -i -E '/^w,/d' "$DST"

# 4) Parameter, die die Mono.2 so nicht kennt (Antwort "01 00" / kein WW-Speicher)
sed -i -E '/^r[0-9]?,energymgr,(antifreeze_temp|heat_mode|hybrid_LWT_setpoint|z1_[a-z_]+|dhw_[a-z_0-9]+),/d' "$DST"
sed -i -E '/^b,energymgr,(dhw_[a-z_0-9]+|day_temp_settings),/d; /^b,ignored,ign6,/d' "$DST"

# 5) dT Pumpe Sollwert (Menü 13.4.4) liegt an der Wärmepumpe
sed -i -E 's/^r,energymgr,em_delta_t,[^,]*,,18,/r,heatpump,pump_dt_setpoint,dT Pumpe Sollwert,,1e,/' "$DST"

# 6) Polling: r1 = oft, r3 = mittel, r9 = selten
sed -i -E 's/^r,(heatpump,heatpump_(ext_temp|LWT_temp|EWT_temp|evaporator_temp|suction_temp|comp_discharge_temp|condenser_outlet_temp|compr_frequency|power_consumption|flowmeter|evap_pressure|cond_pressure|mode|compressor_state|fan1_speed),)/r1,\1/' "$DST"
sed -i -E 's/^r,(energymgr,(hybrid_status),)/r3,\1/; s/^r,(heatpump,heatpump_(exp_valve|flow_switch),)/r3,\1/' "$DST"
sed -i -E 's/^r,(energymgr,heatpump_(heating_op_hours|defrost_op_hours|ingnition_cycles),)/r9,\1/; s/^r,(heatpump,silent_mode,)/r9,\1/' "$DST"

# 7) Ergänzungen für die Mono.2
cat >> "$DST" <<'ADD'

############################################################################################
####                 ELCO AEROTOP MONO.2 – ERGÄNZUNGEN (nur lesen / mithören)           ####
############################################################################################

# Anlagendruck (Menü 1.16.7) – wird vom Bedienteil alle 10 s abgefragt, ebusd hört mit
r,energymgr,system_pressure,Anlagendruck,,18,2000,7547,,s,IGN:1,,,,,,SIN,10,bar
# Korrektur Vorlauftemperatur WP (Menü 1.7.2), Parameter-Lesebefehl 2001
r9,energymgr,hp_flow_correction,Korrektur Vorlauftemperatur WP,,18,2001,7d2b,,s,SIN,10,°C,,,s,IGN:4

# Zone 1 – Antworten auf Abfragen des Bedienteils (Wert/Min/Max)
b,energymgr,z1_comfort_temp,Z1 Komforttemperatur,,fe,200e,6271,,,SIN,10,°C,,,m,IGN:4
b,energymgr,z1_reduced_temp,Z1 Absenktemperatur,,fe,200e,6371,,,SIN,10,°C,,,m,IGN:4
b,energymgr,z1_heat_offset_shift,Z1 Parallelverschiebung,,fe,200e,6471,,,SIN,10,°C,,,m,IGN:4

# Zone 1 – zyklische Parameter-Rundrufe des Energy Managers (~alle 35 min)
b,energymgr,z1_flow_limits,Z1 Vorlaufgrenzen,,fe,2020,6071,z1_max_flow_temp,m,SIN,10,°C,Max Vorlauf 4.2.5,,m,IGN:2,,,,z1_min_flow_temp,m,SIN,10,°C,Min Vorlauf 4.2.6,,m,IGN:2,,,,z1_parallel_shift,m,SIN,10,°C,Parallelverschiebung 4.2.3
b,energymgr,z1_heat_curve,Z1 Heizkurve 4.2.2,,fe,2020,6971,,m,IGN:4,,,,,m,UIN,100,,,,m,IGN:4
b,energymgr,z1_regulation,Z1 Regelung,,fe,2020,6c71,,m,IGN:4,,,,z1_control_type,m,UCH,0=Feste Vorlauftemperatur;1=EIN/AUS-Thermostat;2=Nur Raumfuehler;3=Nur Aussenfuehler;4=Raum- und Aussenfuehler,,Regelungsart 4.2.1,,m,IGN:2,,,,z1_room_influence,m,UCH,,,Raumeinfluss 4.2.4
b,energymgr,z1_summer_winter,Z1 Sommer Winter,,fe,2020,7971,z1_sw_threshold,m,SIN,10,°C,S/W Grenzwert 4.1.1,,m,IGN:2,,,,z1_sw_delay,m,UIN,,min,S/W Verzoegerung 4.1.2,,m,IGN:3
b,energymgr,z1_temp_range_bc,Z1 Temperaturbereich,,fe,2020,c979,,m,IGN:3,,,,z1_temp_range,m,UCH,0=Niedrige Temperatur;1=Hohe Temperatur,,Temperaturbereich 4.2.0,,m,IGN:4

# UNBESTÄTIGT – Rundrufe des Bedienteils (Remocon Plus.2). Zum Aktivieren das '#' entfernen.
#b,panel,room_temp,Raumtemperatur Zone 1,70,fe,2010,7118,,m,SIN,10,°C,,,m,IGN:1
#b,panel,room_humidity,Raumluftfeuchte,70,fe,2010,489d,,m,UIN,10,%,,,m,IGN:1
ADD
