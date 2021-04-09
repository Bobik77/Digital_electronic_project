# **HC-SR04** Ultrasound distance sensor

## **Propozice:**
* Napájení 5V, 15mA (realna spotřeba 5mA)
* TTL uroveň 5V
* Rozsah 2cm až 400cm
* Pracovní kmitočet 40 kHz

Na pin `TRIGER` se přivede kladná úroveň minimální délky 10us. Po cca 0,8ms se pin `ECHO` překlopí do kladné úrovně po čas přímo-úměrný vzdálenosti (Viz oscilogram). Další Trigger by měl příjít až po překlopení Echa zpět na LOW. 

Více viz. [HCSRO4_datasheet](HCSRO4_datasheet.pdf)

**Vzorec výpočtu vzdálenosti:**
```
D = Pulsewidth / 58     ...[cm,us]
````

![osc_principe](img/Oscilograms/osc_principe.png)

## Chybový stav:
Pokud nedojde k návratu echolokačního signálu zpátky k senzoru, nebo pokud je senzor zanesený a nefunkční, trvá ECHO signál cca 195ms. Bylo by vhodné tento stav detekovat jako poruchový. Pokud tedy `Pulsewidth > 190ms`, bude tento stav vyhodnocen jako porucha/odstavení a senzor bude vyřazen z provozu => deaktivuje se.
![Fail state](img/Oscilograms/osc_fault.png)

## **Požadavky na interface:**

* Převod 5V/3V3 logiky
* Snímání s přesností na 1cm (tj. 58us)
* Kontrola `ECHO = LOW` před dalším triggerem
* Detekce nefunkčnosti (`Pulsewidth > 190ms`)
* Detekce odpojení
## Návrh:
**Časování měření**
Po vytvoření `Trigger` pulzu se vyčka na Echo signal a začne čítání čítačem. Po ukončení `Echo` signálu se přečte daná hodnota a pošle se na výstup do řídící logiky *(8b)*

add1. pro vytvoření dostatečně dlouhého `Trigger` signalu se muže užit jeden a ten stejný časovač.
add2. i pro kontrolu, ošetření poruchy či odpojení, se použije ten stejný čítač. Na konci každého stavu se vyresetuje.

## Stavy:
* Při resetu se nastaví první stav a vynuluje se čítač
1.  Nastavení `Trigger = HIGH`, začne se čítat
2.  Po dočítání 20us se nastaví `Trigger = LOW`, resetuje se čítač
3.  Čeká se na `Echo = HIGH`, při uplynutí více než 20ms se bude stav detekovat jako odpojení. V opačném případě se resetuje čítač a pokračuje se na další stav
4. Čeká se na `Echo = LOW`, při uplynutí více než 190ms se bude stav detekovat jako  příliž vzdálená překážka.
5.Hodnota z čítače se přepočítá a zapíše na výstup, Čítač se resetuje
6. Po uplynutí určité doby se započne děj znovu