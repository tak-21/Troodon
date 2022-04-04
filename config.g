; config.g
; Troodon v2, RRF v3.40
; 2022-04-02 - TAK
;
;-------------------------
; General preferences
;-------------------------
;
M575 P1 S1 B57600                           ; enable support for PanelDue
G90                                         ; send absolute coordinates...
M83                                         ; ...but relative extruder moves
M550 P"TROODON"                             ; set printer name
M669 K1                                     ; select CoreXY mode
;
;-------------------------
; Network
;-------------------------
;
M552 S1                                     ; enable network
M586 P0 S1                                  ; enable HTTP
M586 P1 S1                                  ; enable FTP
M586 P2 S0                                  ; disable Telnet
;
;-------------------------
; Motor Configuration
;-------------------------
;
M569 P2 R-1                                 ; disable drive 2
M569 P4 R-1                                 ; disable drive 4
M569 P9 R-1                                 ; disable drive 9
;
M569 P0 S1                                  ; physical drive 0 (x) goes forwards
M569 P1 S1                                  ; physical drive 1 (y) goes forwards
M569 P3 S1                                  ; physical drive 3 (y) goes forwards
;                                                                                    +-------+
M569 P5 S1                                  ; physical drive 0 (z5) goes forwards    | 6 | 7 |
M569 P6 S0	                                ; physical drive 0 (z6) goes backwards   | ----- |
M569 P7 S1	                                ; physical drive 0 (z7) goes forwards    | 5 | 8 |
M569 P8 S0	                                ; physical drive 0 (z8) goes backwards   +-------+
;                                                                                      front
M584 X0 Y1 E3 Z6:5:8:7                      ; set drive mapping
M671 X-50:-50:370:370 Y330:-65:-65:330 S20  ; z belts at 4 corners
;
M350 X16 Y16 Z16 E16 I1                     ; configure microstepping with interpolation
M92  X80 Y80 Z400 E688                      ; microsteps steps per mm - with bt
M906 X1200 Y1200 Z1200 E700 I60             ; motor currents (mA) and motor idle factor in percent
M84 S60                                     ; set idle timeout
M913 X100 Y100 Z100 E100                    ; restore motor current percentage to 100%
M203 X15000 Y15000 Z3000 E2000              ; maximum speed (mm/min)
M201 X1500 Y1500 Z300 E2000                 ; maximum acceleration (mm/s²)
M566 X1000 Y1000 Z200 E250                  ; instantaneous speed change / jerk (mm/min) 
M593 F57                                    ; Dynamic Accelaration : filter 57Hz 
M564 H0                                     ; allow unhomed movement
;
;-------------------------
; Axis Limits
;-------------------------
;
M208 X0 Y0 Z-5 S1                           ; set axis minima to end of safe travel.
M208 X310 Y308 Z400 S0                      ; set axis maxima to match endstop location.
;
;-------------------------
; Endstops
;-------------------------
;
M574 X2 S1 P"xstop"                         ; configure switch-type endstop for low end on X via pin xstop
M574 Y2 S1 P"ystop"                         ; configure switch-type endstop for low end on Y via pin ystop
M574 Z0 P"nil"                              ; no Z endstop switch, free up Z endstop input
;
;-------------------------
; Z-Probe
;-------------------------
;
; https://duet3d.dozuki.com/Wiki/Connecting_a_Z_probe#Section_BLTouch
M950 S0 C"duex.pwm5"                        ; create servo pin 0 for BLTouch
M558 P9 C"^zprobe.in" H5 F120 T6000         ; set z probe type
M574 Z1 S0                                  ; set endstops controlled by probe
M557 X10:292 Y21:291 S47:45                 ; define mesh grid
;
;-------------------------
; Heaters
;-------------------------
;
M308 S0 P"bedtemp" Y"thermistor" T100000 B4138 C0 R4700 A"Bed" ; configure sensor 0 as thermistor on pin bedtemp
M950 H0 C"bedheat" Q10 T0                   ; create bed heater output on bedheat and map it to sensor 0
M307 H0 B0 S1.00                            ; disable bang-bang mode for heater and set PWM limit
M140 H0                                     ; map heated bed to heater 0
M143 H0 S120                                ; set temperature limit for heater 0 to 120C
                                            ; PID tuned settings for bed see "config-override.g"
; M308 S1 P"e0temp" Y"thermistor" T100000 B4138 C0 R4700 A"Nozzle" ; value from Vivedino config for org. thermistor
M308 S1 P"e0temp" Y"thermistor" T100000 B4725 C7.060000e-8 A"Nozzle" ; configure E3D thermistor
M950 H1 C"e0heat" T1                        ; create nozzle heater output on e0heat and map it to sensor 1
M307 H1 B0 S1.00                            ; disable bang-bang mode for heater and set PWM limit
M143 H1 S290                                ; set temperature limit for heater 1 to 290C
                                            ; PID tuned settings for nozzle see "config-override.g"
;
;-------------------------
; Filament sensor
;-------------------------
;
M591 D0 P1 C"e0_stop" S1                    ; configures filament sensing: extr. 0, simple sensor, enabled
;
;-------------------------
; Fans
;-------------------------
;
M950 F0 C"fan0" Q500                        ; fan0: print / part cooling
M106 P0 S0 H-1                              ; fan0: thermostatic control is off
M950 F1 C"fan1" Q500                        ; fan1: heat sink cooling
M106 P1 S0.8 H1 T50                         ; fan1: thermostatc control on, fan at 80%
M950 F2 C"fan2" q500                        ; fan2: case cooling
M106 P2 S1 H1 T50                           ; fan2: thermostatc control on, fan at 100%
M950 P4 C"duex.fan8"                        ; P4: fan for controler board cooling
M42 P4 S0                                   ; P4 off
M950 P5 C"duex.fan7"                        ; P5: fan for chamber
M42 P5 S0                                   ; P5 off
;
;-------------------------
; Tools
;-------------------------
;
M563 P0 D0 H1 F0                            ; define tool 0
G10 P0 X0 Y0 Z0                             ; set tool 0 axis offsets
G10 P0 R0 S0                                ; set initial tool 0 active and standby temperatures to 0C
;
;-------------------------
; Linear Advance
;-------------------------
;
M572 D0 S0.07                               ; https://duet3d.dozuki.com/Wiki/Pressure_advance
;
;-------------------------
; MCU temperature
;-------------------------
;
M912 P0 S-2                                 ; adjustment for the MCU sensor 
;
;-------------------------
; RGB leds
;-------------------------
;
M950 P1 C"duex.fan4"                        ; for R-value
M950 P2 C"duex.fan5"                        ; for G-value
M950 P3 C"duex.fan6"                        ; for B-value
M42 P1 S1.0                                 ; R = 255
M42 P2 S1.0                                 ; G = 255
M42 P3 S1.0                                 ; B = 255
;
;-------------------------
; set Z probe parameters
; https://duet3d.dozuki.com/Wiki/Connecting_a_Z_probe#Section_BLTouch
;-------------------------
;
G31 P500 X0.0 Y21.0 P25                     ; set Z probe trigger value and offset, for trigger height see "config-override.g"
;
;-------------------------
; load stored parameters
;-------------------------
;
M501                                        ; load "config-override.g"
;
