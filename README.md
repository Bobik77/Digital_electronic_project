# Parking assistant with HC-SR04 ultrasonic sensor

### Team members:

Turák Samuel   `ID: 221059`

~~Vala David  `ID: xxxxxx`.~~

Vaněk Pavel  `ID: 221072`

Varmužová Zdeňka `ID: 219104`

Zbořil Dominik `ID: 221074`

[Project folder link](https://github.com/Bobik77/Digital_electronic_project)

### Project objectives
* the task:
    * Parking assistant with HC-SR04 ultrasonic sensor, sound signaling using PWM, 
    signaling by LED bargraph.

## Hardware description

## VHDL modules description and simulations
For additional description see README.md files for each module in folder Doc.
### `sensor_driver`

### `control_unit`
Takes input data from `sensor_driver` and convers them into required output. 
The inputs are three 8b signals, one from each of the sensors. The output is 
a 3b singal for each direction. These signals are input signals for `led_driver`. 
The last output from this module is aslo a 3b signal, which is actually the one of
the previous three with the smallest value. This signal goes to `sound_player`.

### `led_driver`
The module `led_driver` is the controller of 12 LED diodes. The input signals (3x3b) 
are sorted by value into 6 states. For the greatist distance (over 200 cm) is output 
zero and no led is shining. As the distance is increasing, the leds lights up gradually. 
First and second lit green, the third lid yellow and the last one lid red. For the 
lowest distance are all four leds flashing red.


### `sound_player`
Input signal is 3b from `control_unit` ...

## TOP module description and simulations

## Video

## References

---------------------------------------------------------

# Základní skica topologie
![work_schelude](Doc/work_schelude.png)
# Rozvrh práce
Do 16.4. mějme hotové source kódy. Během víkendu to dáme dohromady a zkusíme první funkčnost. Níže je rozpis práce jednotlivých členů. Libovolně upravujte připisujte, založte si vlastní oddíl...


## Samuel - Audio signalizace
* Vstup z řízení `3b`. 
* `000` odpovídá stavu **vypnuto**
* `001` až `111` odpovídá dalekému stavu až blízkému stavu
* Pomocí **PWM** modulace vytvořit sinusový signál pro reproduktor
* Podle blízkosti se bude měnit rychlost pískání
* může se měnit i kmitočet 

## Zdeni - Led signalizace
* 3x4 **RGB LED** ,každé 4 pro jeden směr - lze řešit separátně, takže stačí napsat jeden modul a zkopírovat.
* Vstup z řízení `3b`. 
* `000` odpovídá stavu **vypnuto**
* `001` až `111` odpovídá dalekému stavu až blízkému stavu
* Zelená pro daleký stav, červená pro blízký stav. stačí rozlišit **4 stavy** (chlapi jsou stejně barvoslepí)
* Pro poslední (nejbižší) stav , může LED začít rychle blikat

## Dominik - Řídící logika
* Vyhodnocení změřené vzdálenosti z driveru senzoru a to převede na 3 b výstup pro **světelnou** a **audio** signalizaci
* Vstup z **senzor_driver** `8b`
* Výstup LED signalizace `3x3b`
* Výstup AUDIO signalizace `1x3b` (vždy se vezme ta nejbližší vzdálenost)
* `000` odpovídá stavu **vypnuto**
* `001` až `111` odpovídá dalekému stavu 
* Ošetření rychlých změn
* Ošetření krátkých zákmitů senzoru (glitch)
*  Průměrování vzorků..?
* Do budoucna možná PCB..? (domluvíme se)

## Pavel - Distance sensor
* Simulace, testbench a driver k senzoru vzdálenosti
* výstup `8b` do řídící logiky

## David - Svačinář
* nám všem doveze kafe a sváču
* ...protože se zatím neozval.
* Pro mě preso bez mlíka a cukru...díky :)

## 22.duben.
Další rozvrh práce na další dva týdny

**TODO list:**
* Top architektura + testbench + celková simulace `PAVEL/SAM` (až po PWM)
* Dokumentace (celková) `ZDENI`
    * Video (5min)
    * Git
    * Projít kódy (komenty)
* PWM driver `SAM`
* LUT (look up table -> memory module) `PAVEL`
* HW `DOMINIK`
    * schemata
    * PCB
    * (hodí se i 3D model ;) )

**Všichni:**
* Letmá dokumentace modulů (vstupy výstupy, simulace...)

# Notes
*Sem pište obecné připomínky, myšlenky, o kterých chcete informovat ostatní. Pro zbytek si založte ve složce dokumentace `Doc` vlastní podsložku která se bude vztahovat k dokumantaci vašeho bloku systému*

* Kdyby cokoliv hořelo, volejte **kdykoliv** na muj tel 731937719, nebo napište na discord.
* dopište nahoru do sekce members svoje id
