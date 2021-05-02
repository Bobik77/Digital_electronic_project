# **HC-SR04** Ultrasound distance sensor
Pro snímání vzdálenosti byl použit senzor dle zadání **HC-SR04**. Jeho datasheet je uveden v příloze.
## **Propozice:**
* Napájení 5V, 15mA (realna spotřeba 5mA)
* TTL uroveň 5V
* Rozsah 2cm až 400cm
* Pracovní kmitočet 40 kHz

Na pin `TRIGER` se přivede kladná úroveň minimální délky 10us. Po cca 0,8ms se pin `ECHO` překlopí do kladné úrovně po čas přímo-úměrný vzdálenosti (Viz oscilogram). Další Trigger by měl příjít až po překlopení Echa zpět na LOW. 

Více viz. [HCSR04_datasheet](HCSR04_datasheet.pdf)

**Vzorec výpočtu vzdálenosti:**
```
D = Pulsewidth / 58     ...[cm,us]
````

![osc_principe](Img/Oscilograms/osc_principe.png)

## Chybový stav:
Pokud nedojde k návratu echolokačního signálu zpátky k senzoru, nebo pokud je senzor zanesený a nefunkční, trvá ECHO signál cca 195ms. Bylo by vhodné tento stav detekovat jako poruchový. Pokud tedy `Pulsewidth > 190ms`, bude tento stav vyhodnocen jako porucha/odstavení a senzor bude vyřazen z provozu => deaktivuje se.
![Fail state](Img/Oscilograms/osc_fault.png)

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
## Notes
`10.4.` Podařilo se zprovoznit kostru programu. Nefunkční podmínky ošetření stavu rozsahu. Objevují se problémy s časováním, nevím proč. Fungují obě detekce chyb. Při druhé je akorat stavova hlaška `0000_0000`  přepsana ihned zpatky starou hodnotou TODO. Ve výpočtu ošetřit poslední tik.. nebo přednastiavit counter do 1čky místo do nuly.. aby přesně seděl počet načýtaných tiků. Testbench je praven pro další použití

## TODO
* Aserty v tb
* vyřešit ošetření rozsahu
* vyřešit chybové hlášky
* doladit problémy s časováním
* finalni simulace na tb

## Přilohy:
* sensor_driver.vhd
* tb_sensor_driver.vhd

## Popis struktury:
Vyčítání dat ze senzoru je založeno na principu FSM. Probíhá v následujících stavech:
1) `idle` (prodleva mezi jednotlivými měřeními)
2) `trigger` vyslání trigger impulzu délky 100us
3) `tarry` prodleva mezi seběžnou hranou trigger impulzu a náběžnou hranou echo pulzu (vyčkávání na echo response)
4) `counting` čítání délky echo pulzu,, po ukončení čítání se proces opakuje.

## Popis problému:
V procesu `sensor_get_data` po ukončení čítání *(state counting; podmínka  if (echo_i = '0'))* je obsažené vyhodnocení délky echo responsu. Je zde přepočet na cm, ošetření rozsahu hodnot, a přiřazení výtupního vektoru na port.

Právě zde se vyskytuje problem. Jakoby některé řádky procesu proběhly, jíné ne, nebo se provedou až po dalším zavolání funkce (viz screenshot simulace1 > přiřazeni z s_distance na výstup proběhne až při dalším zavolání >> na výstupu je vždy hodnota z předchozího měření). K ošetření podmínek také nedojde, na výstupu se vysktují i čísla mimo rosah (při přiřayení pak dojde k přeteční výstupního vektoru)

pozn.: Provizorně jsem zkusil problém vyřešit tím způsobem, že jsem přiřazení výstupního vektoru na výstupní port prováděl v každém hodinovém cyklu. Tím se přiřadil výstup o další hodnový tik později (viz screenshot simluace2). I tak ale nedojde k vzhodnocení podmínek ošetření stavů...

Možná je problém s použitím proměných/konstant typu integer. V literatuře jsem k tomuto žádnou připomínku nenašel, proto se obracím na Vás.

*Výčet programu case pro state `counting`:*

```vhdl
 when counting =>
   -- wait for fall of echo pulse and count time
        if (echo_i = '0') then
            -- compute distance (in cm)
            s_distance <= (s_counter+1)/5800;  
            -- range threatment
            if (s_distance > 255) then s_distance <= 255; end if;  -- Max of range
            if (s_distance < 1)   then s_distance <= 1;   end if;  -- Min of range  
            -- mazbe TODO threatment of range of sensor itself (2cm-4meters)
            -- TODO threatments are not funstion
            s_counter <= 0;   -- reset counter
            s_state <= idle;  -- change state
            -- output assigment
            distance_o <= std_logic_vector(to_unsigned(s_distance, 8));
        --  too far obstacle if echo pulse is too long
        elsif (s_counter >= c_max_echo_time) then
             distance_o <= c_out_msg_too_far; -- set special event message
             s_state <= fault;
             s_counter <= 0;   -- reset counter
        end if;
```

Odpověď mi bude klidně stačit písemě, případně pro domluvení online konzultace se domluvíme, časově se  vrámci možností přizpůsobím.
Kontakt na mě:
mail: xvanek39@vutbr.cz;
nebo volejte na 731937719

Děkuji mnohokrát za Vaší pomoc
S pozdravem Vaněk Pavel
