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

![osc_principe](Oscilograms/osc_principe.png)

## Chybový stav:
Pokud nedojde k návratu echolokačního signálu zpátky k senzoru, nebo pokud je senzor zanesený a nefunkční, trvá ECHO signál cca 195ms. Bylo by vhodné tento stav detekovat jako poruchový. Pokud tedy `Pulsewidth > 190ms`, bude tento stav vyhodnocen jako porucha/odstavení a senzor bude vyřazen z provozu => deaktivuje se.
![Fail state](Oscilograms/osc_fault.png)

## **Požadavky na interface:**

* Převod 5V/3V3 logiky
* Snímání s přesností na 1cm (tj. 58us)
* Kontrola `ECHO = LOW` před dalším triggerem
* Detekce nefunkčnosti (`Pulsewidth > 190ms`)