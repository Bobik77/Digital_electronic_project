# Parking assistant with HC-SR04 ultrasonic sensor

### Team members

Turák Samuel

Vala David

Vaněk Pavel

Varmužová Zdeňka

[Project folder link](https://github.com/Bobik77/Digital_electronic_project)


# Základní skica topologie
![](doc/work_schelude.png)
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
* 3x **RGB LED** ,každá pro jeden směr - lze řešit separátně, takže stačí napsat jeden modul a zkopírovat.
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

# Notes
*Sem pište obecné připomínky, myšlenky, o kterých chcete informovat ostatní. Pro zbytek si založte ve složce dokumentace `Doc` vlastní podsložku která se bude vztahovat k dokumantaci vašeho bloku systému*

Kdyby cokoliv hořelo, volejte **kdykoliv** na muj tel 731937719, nebo napište na discord.