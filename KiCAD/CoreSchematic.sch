EESchema Schematic File Version 4
LIBS:CoreSchematic-cache
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 3
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Sheet
S 2275 3325 1275 625 
U 5F7E1AAB
F0 "USB Con + Prog" 50
F1 "USB_Connection.sch" 50
F2 "E>U" I R 3550 3500 50 
F3 "+5V_USB" I L 2275 3500 50 
F4 "RST" I R 3550 3675 50 
F5 "PROG" I R 3550 3750 50 
F6 "U>E" I R 3550 3425 50 
$EndSheet
$Comp
L dk_RF-Transceiver-Modules:ESP32-WROOM-32 MOD101
U 1 1 5F7FCC8F
P 6475 2300
F 0 "MOD101" H 6875 2450 60  0000 C CNN
F 1 "ESP32-WROOM-32" H 7175 2350 60  0000 C CNN
F 2 "digikey-footprints:ESP32-WROOM-32D" H 6675 2500 60  0001 L CNN
F 3 "https://www.espressif.com/sites/default/files/documentation/esp32-wroom-32_datasheet_en.pdf" H 6675 2600 60  0001 L CNN
F 4 "1904-1010-1-ND" H 6675 2700 60  0001 L CNN "Digi-Key_PN"
F 5 "ESP32-WROOM-32" H 6675 2800 60  0001 L CNN "MPN"
F 6 "RF/IF and RFID" H 6675 2900 60  0001 L CNN "Category"
F 7 "RF Transceiver Modules" H 6675 3000 60  0001 L CNN "Family"
F 8 "https://www.espressif.com/sites/default/files/documentation/esp32-wroom-32_datasheet_en.pdf" H 6675 3100 60  0001 L CNN "DK_Datasheet_Link"
F 9 "/product-detail/en/espressif-systems/ESP32-WROOM-32/1904-1010-1-ND/8544305" H 6675 3200 60  0001 L CNN "DK_Detail_Page"
F 10 "SMD MODULE, ESP32-D0WDQ6, 32MBIT" H 6675 3300 60  0001 L CNN "Description"
F 11 "Espressif Systems" H 6675 3400 60  0001 L CNN "Manufacturer"
F 12 "Active" H 6675 3500 60  0001 L CNN "Status"
	1    6475 2300
	1    0    0    -1  
$EndComp
$Sheet
S 2275 4275 1125 475 
U 5F8276A0
F0 "Power" 50
F1 "Power.sch" 50
F2 "CHG_In" I L 2275 4425 50 
$EndSheet
Wire Wire Line
	2275 3500 2125 3500
Wire Wire Line
	2125 3500 2125 4425
Wire Wire Line
	2125 4425 2275 4425
Wire Wire Line
	6475 4400 6575 4400
Wire Wire Line
	6575 4400 6625 4400
Connection ~ 6575 4400
Wire Wire Line
	6675 4400 6775 4400
Connection ~ 6675 4400
Wire Wire Line
	6625 4400 6625 4650
Connection ~ 6625 4400
Wire Wire Line
	6625 4400 6675 4400
$Comp
L power:GND #PWR0109
U 1 1 5F831A50
P 6625 4650
F 0 "#PWR0109" H 6625 4400 50  0001 C CNN
F 1 "GND" H 6630 4477 50  0000 C CNN
F 2 "" H 6625 4650 50  0001 C CNN
F 3 "" H 6625 4650 50  0001 C CNN
	1    6625 4650
	1    0    0    -1  
$EndComp
$Comp
L XasParts:MAX98357A AMP101
U 1 1 5F83213D
P 9650 3475
F 0 "AMP101" H 10075 3450 50  0000 L CNN
F 1 "MAX98357A" H 10075 3375 50  0000 L CNN
F 2 "Package_DFN_QFN:QFN-16-1EP_3x3mm_P0.5mm_EP1.9x1.9mm_ThermalVias" H 9750 3125 50  0001 C CNN
F 3 "" H 9750 3125 50  0001 C CNN
	1    9650 3475
	1    0    0    -1  
$EndComp
Wire Wire Line
	9650 3825 9750 3825
Wire Wire Line
	9750 3825 9850 3825
Connection ~ 9750 3825
Wire Wire Line
	9750 3825 9750 3950
$Comp
L power:GND #PWR0107
U 1 1 5F832563
P 9750 3950
F 0 "#PWR0107" H 9750 3700 50  0001 C CNN
F 1 "GND" H 9755 3777 50  0000 C CNN
F 2 "" H 9750 3950 50  0001 C CNN
F 3 "" H 9750 3950 50  0001 C CNN
	1    9750 3950
	1    0    0    -1  
$EndComp
Wire Wire Line
	9600 2425 9650 2425
$Comp
L power:+BATT #PWR0104
U 1 1 5F8327F3
P 9650 2275
F 0 "#PWR0104" H 9650 2125 50  0001 C CNN
F 1 "+BATT" H 9665 2448 50  0000 C CNN
F 2 "" H 9650 2275 50  0001 C CNN
F 3 "" H 9650 2275 50  0001 C CNN
	1    9650 2275
	1    0    0    -1  
$EndComp
Wire Wire Line
	9650 2275 9650 2425
Connection ~ 9650 2425
Wire Wire Line
	9650 2425 9700 2425
Text GLabel 4700 3300 0    50   Input ~ 0
SDA
Text GLabel 4700 3400 0    50   Input ~ 0
SCL
$Comp
L Device:R_Small R103
U 1 1 5F86472B
P 4775 3100
F 0 "R103" H 4834 3146 50  0000 L CNN
F 1 "10k" H 4834 3055 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 4775 3100 50  0001 C CNN
F 3 "~" H 4775 3100 50  0001 C CNN
	1    4775 3100
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R104
U 1 1 5F8647A0
P 5025 3100
F 0 "R104" H 5084 3146 50  0000 L CNN
F 1 "10k" H 5084 3055 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 5025 3100 50  0001 C CNN
F 3 "~" H 5025 3100 50  0001 C CNN
	1    5025 3100
	1    0    0    -1  
$EndComp
Wire Wire Line
	4700 3300 4775 3300
Wire Wire Line
	4775 3300 4775 3200
Wire Wire Line
	4700 3400 5025 3400
Wire Wire Line
	5025 3400 5025 3200
Connection ~ 4775 3300
Connection ~ 5025 3400
Wire Wire Line
	5025 3400 5975 3400
Wire Wire Line
	4775 3300 5975 3300
Wire Wire Line
	4775 3000 4900 3000
Wire Wire Line
	4900 3000 4900 2925
Connection ~ 4900 3000
Wire Wire Line
	4900 3000 5025 3000
$Comp
L power:+3.3V #PWR0106
U 1 1 5F8667CE
P 4900 2925
F 0 "#PWR0106" H 4900 2775 50  0001 C CNN
F 1 "+3.3V" H 4915 3098 50  0000 C CNN
F 2 "" H 4900 2925 50  0001 C CNN
F 3 "" H 4900 2925 50  0001 C CNN
	1    4900 2925
	1    0    0    -1  
$EndComp
Wire Wire Line
	6675 2200 6675 2100
$Comp
L power:+3.3V #PWR0101
U 1 1 5F8670DA
P 6675 1600
F 0 "#PWR0101" H 6675 1450 50  0001 C CNN
F 1 "+3.3V" H 6690 1773 50  0000 C CNN
F 2 "" H 6675 1600 50  0001 C CNN
F 3 "" H 6675 1600 50  0001 C CNN
	1    6675 1600
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C102
U 1 1 5F86729F
P 6575 2100
F 0 "C102" V 6346 2100 50  0000 C CNN
F 1 "0.1uF" V 6437 2100 50  0000 C CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 6575 2100 50  0001 C CNN
F 3 "~" H 6575 2100 50  0001 C CNN
	1    6575 2100
	0    1    1    0   
$EndComp
Connection ~ 6675 2100
Wire Wire Line
	6675 2100 6675 1725
$Comp
L Device:C C101
U 1 1 5F86747E
P 6525 1725
F 0 "C101" V 6273 1725 50  0000 C CNN
F 1 "C" V 6364 1725 50  0000 C CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 6563 1575 50  0001 C CNN
F 3 "~" H 6525 1725 50  0001 C CNN
	1    6525 1725
	0    1    1    0   
$EndComp
Connection ~ 6675 1725
Wire Wire Line
	6675 1725 6675 1600
Wire Wire Line
	6475 2100 6375 2100
Wire Wire Line
	6375 2100 6375 1925
$Comp
L power:GND #PWR0103
U 1 1 5F8678C6
P 6250 2050
F 0 "#PWR0103" H 6250 1800 50  0001 C CNN
F 1 "GND" H 6255 1877 50  0000 C CNN
F 2 "" H 6250 2050 50  0001 C CNN
F 3 "" H 6250 2050 50  0001 C CNN
	1    6250 2050
	1    0    0    -1  
$EndComp
Wire Wire Line
	6250 2050 6250 1925
Wire Wire Line
	6250 1925 6375 1925
Connection ~ 6375 1925
Wire Wire Line
	6375 1925 6375 1725
NoConn ~ 7375 2400
NoConn ~ 7375 2500
NoConn ~ 7375 3100
NoConn ~ 7375 3000
NoConn ~ 7375 2900
NoConn ~ 7375 2800
NoConn ~ 7375 2700
NoConn ~ 7375 2600
NoConn ~ 5975 2900
Wire Wire Line
	7375 3200 7850 3200
Text Label 7850 3200 2    50   ~ 0
E>U
Text Label 7850 3300 2    50   ~ 0
U>E
Wire Wire Line
	7850 3300 7375 3300
Wire Wire Line
	5975 2500 5550 2500
Text Label 5550 2500 0    50   ~ 0
GPIO0
Wire Wire Line
	5975 2400 5550 2400
Text Label 5550 2400 0    50   ~ 0
RESET
Wire Wire Line
	3550 3675 3875 3675
Text Label 3875 3675 2    50   ~ 0
RESET
Text Label 3875 3750 2    50   ~ 0
GPIO0
Wire Wire Line
	3875 3750 3550 3750
Text Label 3875 3500 2    50   ~ 0
E>U
Wire Wire Line
	3875 3500 3550 3500
Wire Wire Line
	3550 3425 3875 3425
Text Label 3875 3425 2    50   ~ 0
U>E
$Comp
L Motor:Motor_DC DIAL101
U 1 1 5F86F996
P 9900 1275
F 0 "DIAL101" H 10058 1271 50  0000 L CNN
F 1 "Motor_DC" H 10058 1180 50  0000 L CNN
F 2 "XasPrints:VU_Meter_Flat" H 9900 1185 50  0001 C CNN
F 3 "~" H 9900 1185 50  0001 C CNN
	1    9900 1275
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0102
U 1 1 5F86FC3F
P 9900 1650
F 0 "#PWR0102" H 9900 1400 50  0001 C CNN
F 1 "GND" H 9905 1477 50  0000 C CNN
F 2 "" H 9900 1650 50  0001 C CNN
F 3 "" H 9900 1650 50  0001 C CNN
	1    9900 1650
	1    0    0    -1  
$EndComp
Wire Wire Line
	9900 1575 9900 1600
$Comp
L Device:R_Small R101
U 1 1 5F870F8B
P 9250 900
F 0 "R101" H 9309 946 50  0000 L CNN
F 1 "R_Small" H 9309 855 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 9250 900 50  0001 C CNN
F 3 "~" H 9250 900 50  0001 C CNN
	1    9250 900 
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R102
U 1 1 5F870FD3
P 9250 1325
F 0 "R102" H 9309 1371 50  0000 L CNN
F 1 "R_Small" H 9309 1280 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 9250 1325 50  0001 C CNN
F 3 "~" H 9250 1325 50  0001 C CNN
	1    9250 1325
	1    0    0    -1  
$EndComp
Wire Wire Line
	9900 1600 9250 1600
Wire Wire Line
	9250 1600 9250 1425
Connection ~ 9900 1600
Wire Wire Line
	9900 1600 9900 1650
Wire Wire Line
	9900 1075 9250 1075
Wire Wire Line
	9250 1075 9250 1000
Wire Wire Line
	9250 1225 9250 1075
Connection ~ 9250 1075
$Comp
L Device:Speaker LS101
U 1 1 5F873FE5
P 10675 3025
F 0 "LS101" H 10845 3021 50  0000 L CNN
F 1 "Speaker" H 10845 2930 50  0000 L CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 10675 2825 50  0001 C CNN
F 3 "~" H 10665 2975 50  0001 C CNN
	1    10675 3025
	1    0    0    -1  
$EndComp
Wire Wire Line
	10475 3025 10200 3025
Wire Wire Line
	10200 3125 10475 3125
Text Label 8800 3175 0    50   ~ 0
OUT_LR
Text Label 8800 3275 0    50   ~ 0
OUT_BCK
Text Label 8800 3375 0    50   ~ 0
OUT_DATA
Wire Wire Line
	8800 3175 9250 3175
Wire Wire Line
	9250 3275 8800 3275
Wire Wire Line
	8800 3375 9250 3375
$Comp
L Device:C C103
U 1 1 5F878958
P 9350 2425
F 0 "C103" V 9098 2425 50  0000 C CNN
F 1 "C" V 9189 2425 50  0000 C CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 9388 2275 50  0001 C CNN
F 3 "~" H 9350 2425 50  0001 C CNN
	1    9350 2425
	0    1    1    0   
$EndComp
Wire Wire Line
	9500 2425 9600 2425
Connection ~ 9600 2425
$Comp
L power:GND #PWR0105
U 1 1 5F8795D9
P 9150 2425
F 0 "#PWR0105" H 9150 2175 50  0001 C CNN
F 1 "GND" V 9155 2297 50  0000 R CNN
F 2 "" H 9150 2425 50  0001 C CNN
F 3 "" H 9150 2425 50  0001 C CNN
	1    9150 2425
	0    1    1    0   
$EndComp
Wire Wire Line
	9150 2425 9200 2425
Wire Wire Line
	5975 3500 5550 3500
Text Label 5550 3500 0    50   ~ 0
MIC_LR
Wire Wire Line
	5975 3600 5550 3600
Text Label 5550 3600 0    50   ~ 0
MIC_BCK
Text Label 5550 3700 0    50   ~ 0
MIC_DATA
Wire Wire Line
	5550 3700 5975 3700
Text Label 5550 3800 0    50   ~ 0
OUT_LR
Text Label 5550 3900 0    50   ~ 0
OUT_BCK
Text Label 5550 4000 0    50   ~ 0
OUT_DATA
Wire Wire Line
	5550 4000 5975 4000
Wire Wire Line
	5975 3900 5550 3900
Wire Wire Line
	5550 3800 5975 3800
$Comp
L Connector:Conn_01x06_Female J101
U 1 1 5F883E5C
P 10000 5450
F 0 "J101" H 10027 5426 50  0000 L CNN
F 1 "Conn_01x06_Female" H 10027 5335 50  0000 L CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x06_P2.54mm_Vertical" H 10000 5450 50  0001 C CNN
F 3 "~" H 10000 5450 50  0001 C CNN
	1    10000 5450
	1    0    0    -1  
$EndComp
Wire Wire Line
	9800 5250 9300 5250
Text Label 9300 5350 0    50   ~ 0
MIC_LR
Text Label 9300 5450 0    50   ~ 0
MIC_DATA
Text Label 9300 5550 0    50   ~ 0
MIC_BCK
$Comp
L power:GND #PWR0112
U 1 1 5F885703
P 9300 5650
F 0 "#PWR0112" H 9300 5400 50  0001 C CNN
F 1 "GND" V 9305 5522 50  0000 R CNN
F 2 "" H 9300 5650 50  0001 C CNN
F 3 "" H 9300 5650 50  0001 C CNN
	1    9300 5650
	0    1    1    0   
$EndComp
$Comp
L power:+3.3V #PWR0113
U 1 1 5F8857EF
P 9300 5750
F 0 "#PWR0113" H 9300 5600 50  0001 C CNN
F 1 "+3.3V" V 9315 5878 50  0000 L CNN
F 2 "" H 9300 5750 50  0001 C CNN
F 3 "" H 9300 5750 50  0001 C CNN
	1    9300 5750
	0    -1   -1   0   
$EndComp
Wire Wire Line
	9300 5750 9800 5750
Wire Wire Line
	9300 5650 9800 5650
Wire Wire Line
	9300 5550 9800 5550
Wire Wire Line
	9800 5450 9300 5450
Wire Wire Line
	9300 5350 9800 5350
$Comp
L power:GND #PWR0111
U 1 1 5F88BF13
P 9300 5250
F 0 "#PWR0111" H 9300 5000 50  0001 C CNN
F 1 "GND" V 9305 5122 50  0000 R CNN
F 2 "" H 9300 5250 50  0001 C CNN
F 3 "" H 9300 5250 50  0001 C CNN
	1    9300 5250
	0    1    1    0   
$EndComp
$Comp
L Switch:SW_Push SW101
U 1 1 5F865053
P 2250 5800
F 0 "SW101" V 2204 5948 50  0000 L CNN
F 1 "SW_Push" V 2295 5948 50  0000 L CNN
F 2 "Button_Switch_Keyboard:SW_Cherry_MX_1.00u_PCB" H 2250 6000 50  0001 C CNN
F 3 "~" H 2250 6000 50  0001 C CNN
	1    2250 5800
	0    1    1    0   
$EndComp
$Comp
L Switch:SW_Push SW102
U 1 1 5F865245
P 2950 5800
F 0 "SW102" V 2904 5948 50  0000 L CNN
F 1 "SW_Push" V 2995 5948 50  0000 L CNN
F 2 "Button_Switch_Keyboard:SW_Cherry_MX_1.00u_PCB" H 2950 6000 50  0001 C CNN
F 3 "~" H 2950 6000 50  0001 C CNN
	1    2950 5800
	0    1    1    0   
$EndComp
$Comp
L Switch:SW_Push SW103
U 1 1 5F8652F3
P 3675 5800
F 0 "SW103" V 3629 5948 50  0000 L CNN
F 1 "SW_Push" V 3720 5948 50  0000 L CNN
F 2 "Button_Switch_Keyboard:SW_Cherry_MX_1.00u_PCB" H 3675 6000 50  0001 C CNN
F 3 "~" H 3675 6000 50  0001 C CNN
	1    3675 5800
	0    1    1    0   
$EndComp
Wire Wire Line
	2250 6000 2950 6000
Wire Wire Line
	2950 6000 3675 6000
Connection ~ 2950 6000
$Comp
L power:GND #PWR0114
U 1 1 5F86C29A
P 2950 6050
F 0 "#PWR0114" H 2950 5800 50  0001 C CNN
F 1 "GND" H 2955 5877 50  0000 C CNN
F 2 "" H 2950 6050 50  0001 C CNN
F 3 "" H 2950 6050 50  0001 C CNN
	1    2950 6050
	1    0    0    -1  
$EndComp
Wire Wire Line
	2950 6050 2950 6000
$Comp
L LED:WS2812B D103
U 1 1 5F870F86
P 2250 6900
F 0 "D103" H 2425 6650 50  0000 L CNN
F 1 "WS2812B" H 2425 6550 50  0000 L CNN
F 2 "XasPrints:IN-PI42TAS" H 2300 6600 50  0001 L TNN
F 3 "https://cdn-shop.adafruit.com/datasheets/WS2812B.pdf" H 2350 6525 50  0001 L TNN
	1    2250 6900
	1    0    0    -1  
$EndComp
$Comp
L LED:WS2812B D104
U 1 1 5F8718C3
P 2950 6900
F 0 "D104" H 3125 6650 50  0000 L CNN
F 1 "WS2812B" H 3125 6550 50  0000 L CNN
F 2 "XasPrints:IN-PI42TAS" H 3000 6600 50  0001 L TNN
F 3 "https://cdn-shop.adafruit.com/datasheets/WS2812B.pdf" H 3050 6525 50  0001 L TNN
	1    2950 6900
	1    0    0    -1  
$EndComp
$Comp
L LED:WS2812B D105
U 1 1 5F871941
P 3650 6900
F 0 "D105" H 3825 6650 50  0000 L CNN
F 1 "WS2812B" H 3825 6550 50  0000 L CNN
F 2 "XasPrints:IN-PI42TAS" H 3700 6600 50  0001 L TNN
F 3 "https://cdn-shop.adafruit.com/datasheets/WS2812B.pdf" H 3750 6525 50  0001 L TNN
	1    3650 6900
	1    0    0    -1  
$EndComp
Wire Wire Line
	2550 6900 2650 6900
Wire Wire Line
	3250 6900 3350 6900
Wire Wire Line
	2250 7200 2250 7350
Wire Wire Line
	2250 7350 2950 7350
Wire Wire Line
	2950 7350 2950 7200
Wire Wire Line
	2950 7350 3650 7350
Wire Wire Line
	3650 7350 3650 7200
Connection ~ 2950 7350
$Comp
L power:GND #PWR0117
U 1 1 5F87A4B8
P 2950 7450
F 0 "#PWR0117" H 2950 7200 50  0001 C CNN
F 1 "GND" H 2955 7277 50  0000 C CNN
F 2 "" H 2950 7450 50  0001 C CNN
F 3 "" H 2950 7450 50  0001 C CNN
	1    2950 7450
	1    0    0    -1  
$EndComp
Wire Wire Line
	2950 7350 2950 7450
Wire Wire Line
	3675 5600 3675 5175
Text Label 3675 5175 3    50   ~ 0
BTN0_PLAY
Text Label 2950 5175 3    50   ~ 0
BTN1_REC
Text Label 2250 5175 3    50   ~ 0
BTN2_STOP
Wire Wire Line
	2250 5175 2250 5600
Wire Wire Line
	2950 5175 2950 5600
Wire Wire Line
	2250 6600 2250 6550
Wire Wire Line
	2250 6550 2950 6550
Wire Wire Line
	2950 6550 2950 6600
Wire Wire Line
	2950 6550 3650 6550
Wire Wire Line
	3650 6550 3650 6600
Connection ~ 2950 6550
$Comp
L power:+BATT #PWR0116
U 1 1 5F890FB6
P 2950 6550
F 0 "#PWR0116" H 2950 6400 50  0001 C CNN
F 1 "+BATT" H 2965 6723 50  0000 C CNN
F 2 "" H 2950 6550 50  0001 C CNN
F 3 "" H 2950 6550 50  0001 C CNN
	1    2950 6550
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C104
U 1 1 5F893AC0
P 1250 6550
F 0 "C104" V 1021 6550 50  0000 C CNN
F 1 "1uF" V 1112 6550 50  0000 C CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 1250 6550 50  0001 C CNN
F 3 "~" H 1250 6550 50  0001 C CNN
	1    1250 6550
	0    1    1    0   
$EndComp
Connection ~ 2250 6550
$Comp
L power:GND #PWR0115
U 1 1 5F898D1C
P 1150 6550
F 0 "#PWR0115" H 1150 6300 50  0001 C CNN
F 1 "GND" V 1155 6422 50  0000 R CNN
F 2 "" H 1150 6550 50  0001 C CNN
F 3 "" H 1150 6550 50  0001 C CNN
	1    1150 6550
	0    1    1    0   
$EndComp
$Comp
L LED:WS2812B D101
U 1 1 5F8A3AD0
P 10700 4300
F 0 "D101" H 11041 4346 50  0000 L CNN
F 1 "WS2812B" H 10775 4025 50  0000 L CNN
F 2 "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm" H 10750 4000 50  0001 L TNN
F 3 "https://cdn-shop.adafruit.com/datasheets/WS2812B.pdf" H 10800 3925 50  0001 L TNN
	1    10700 4300
	1    0    0    -1  
$EndComp
$Comp
L LED:WS2812B D102
U 1 1 5F8A4930
P 1550 6900
F 0 "D102" H 1725 6650 50  0000 L CNN
F 1 "WS2812B" H 1725 6550 50  0000 L CNN
F 2 "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm" H 1600 6600 50  0001 L TNN
F 3 "https://cdn-shop.adafruit.com/datasheets/WS2812B.pdf" H 1650 6525 50  0001 L TNN
	1    1550 6900
	1    0    0    -1  
$EndComp
Wire Wire Line
	1550 7200 1550 7350
Wire Wire Line
	1550 7350 2250 7350
Connection ~ 2250 7350
Wire Wire Line
	1350 6550 1550 6550
Wire Wire Line
	1550 6550 1550 6600
Wire Wire Line
	1550 6550 2250 6550
Connection ~ 1550 6550
Wire Wire Line
	1850 6900 1950 6900
Wire Wire Line
	1250 6900 775  6900
Text Label 775  6900 0    50   ~ 0
BTN_LEDS
Wire Wire Line
	3950 6900 4550 6900
Text Label 4550 6900 2    50   ~ 0
SPEAKER_LED
Text Label 9900 4300 0    50   ~ 0
SPEAKER_LED
$Comp
L power:+3.3V #PWR0108
U 1 1 5F8BF47C
P 10700 3950
F 0 "#PWR0108" H 10700 3800 50  0001 C CNN
F 1 "+3.3V" H 10715 4123 50  0000 C CNN
F 2 "" H 10700 3950 50  0001 C CNN
F 3 "" H 10700 3950 50  0001 C CNN
	1    10700 3950
	1    0    0    -1  
$EndComp
Wire Wire Line
	10700 3950 10700 4000
$Comp
L power:GND #PWR0110
U 1 1 5F8C21FC
P 10700 4675
F 0 "#PWR0110" H 10700 4425 50  0001 C CNN
F 1 "GND" H 10705 4502 50  0000 C CNN
F 2 "" H 10700 4675 50  0001 C CNN
F 3 "" H 10700 4675 50  0001 C CNN
	1    10700 4675
	1    0    0    -1  
$EndComp
Wire Wire Line
	10700 4675 10700 4600
Wire Wire Line
	5975 3200 5450 3200
Text Label 5450 3200 0    50   ~ 0
BTN_LEDS
Text Label 5425 2600 0    50   ~ 0
BTN0_PLAY
Text Label 5425 2700 0    50   ~ 0
BTN1_REC
Text Label 5425 2800 0    50   ~ 0
BTN2_STOP
Wire Wire Line
	5425 2800 5975 2800
Wire Wire Line
	5425 2700 5975 2700
Wire Wire Line
	5425 2600 5975 2600
Wire Wire Line
	9900 4300 10400 4300
NoConn ~ 11000 4300
Wire Wire Line
	9850 3825 9950 3825
Connection ~ 9850 3825
$EndSCHEMATC
