# Zvuková signalizace
Podle vzdálenosti od překážky parkovací asistent vydává akustickou signalizaci. Ta je realizována PWM D/A převodíkem, který ve smyčce přehrává krátká wav soubor. Tento PWM signál je poté ještě modulovaný (spínaný) v závislosti na vzdálenosti od překážky.

Simulace akustické signalizace pro různé stavy je přiložena ve [wav souboru](simulation_of_beep.wav).

Zvuková signalizace je obsluhována těmito bloky:
* sound_player.vhd
* sound_memory.vhd
* sound_logic.vhd
* pwm.vhd 
* sound_player.vhd

# sound_player.vhd

Tento modul má na starosti práci s pamětí a řízení PWM D/A převodníku. Přímo v sobě implementuje entitu paměťového bloku `sound_memory`. Lze zde také nastavit hlasitost konstantou `c_volume`. Vyšší konstanta znamená nižší hlasitost. (Vstupní amplituda z paměti se podělí touto konstantou a zapíše se na výstup `data_out`.)

Je zde vytvořen interní signál hodin `s_sample_clock`, který má periodu vzorkovacího kmitočtu (zde 96kHz). V taktu těchto zpomalených hodin dochází právě k vyčítání dat ze zvukové paměti. Po přečtení všech samplů (viz konst. `c_n_samples`) se opět opakuje vyčítání od adresy **`0000_0000`**.

**Specifikace:**
* Konstanta hlasitosti `c_volume`, (nastavitelné globální proměnou `g_VOLUME`)
* Konstanta samplovaciho kmitočtu (délka jednoho samplu v tiku hodin) `c_sample_period` (nastavitelné globální proměnou `g_TICKS_PER_SAMPLE`)
* vstup 100 MHz hodin `clk`
* výstup 8b, vektor pro řízení střídy PWM `data_out`
* výstup 12b, adresní sběrnice pro paměť (interni signal) `s_address`
* vstup 8b paměti (interni signal) `s_data_in`

### Simulace modulu sound_player:
Pro účely simulace:
* `c_sample_period` <= 2
* `c_volume` <= 4
* `c_n_samples` <= 100

Originální hodnoty:
* `c_sample_period` <= 1042 (96kHz při 100MHz clk)
* `c_volume` <=  ad. libitum
* `c_n_samples` <= 2303

![sim3](img/simulations/sound_player_test.png)
### Detail simulace:
![sim4](img/simulations/sound_player_test_detail.png)


# sound_memory (součást sound_player.vhd)
Modul obsahuje v paměti asi 0.8 sec krátký [úsek audia](bump.wav) (mono). Tento výsek je setříhán tak, aby při přehrávání ve smyčce na sebe navazoval a v reproduktoru se tedy neozývalo nepřijemné "lupání".

Sestříhání a úprava vzorku audia byla provedena v programu **LogicProX**. Zvuk má royality free licenci.

Převod do unsigned integeru byl proveden za pomocí [skriptu v MATLABu](waw2array.m). Výsledek je uložen v [.txt souboru](sound_string.txt); pro snadnější formátování po 50 samplech na řádek.

 Audio je normalizováno (pro maximální rozkmit).

**Tech. specifikace modulu:**
* Rozlišení: 8b
* Šíře adresní sběrnice 12b
* Počet uložených vzorků: 2303
* Vzorkovací kmitočet: 96 kHz
* Velikost souboru: 8kiB

### Simulace vyčítání z paměti:
![sim1](img/simulations/Memory_test.png)
### Detail vyčítání z paměti:
![sim2](img/simulations/Memory_test_detail.png)


# pwm.vhd:
V tomto module sa generuje pwm signál - signál ktorý môže nadobúdať len hodnoty 1 a 0, ale zmenou striedy (duty cycle, teda pomer signálu v stave 1 a 0), jeho priemerná hodnota môže nadobúdať tvar analogového signálu.
Modul berie 8-bitový output z modulu sound_player ako svoj input. Tento input určí veľkosť striedy v daný okamžik pre pwm signál.
Dokopy môže byť 256 rôznych možností pre veľkosť striedy.

Špecifikácie:
* vstup 100MHz `clk`
* vstup 8b `duty`
* výstup 1b `output`

### Simulácia pwm:
Pre účel simulácie sme použili frekvenciu pwm signálu 400 kHz, aby sa nám zobrazilo viacero nastavení striedy.
Nastavenia striedy na obrázku sme dali pomocou bitových kombinácii približne na hodnoty: 0%,3.5%,25%,50%,62%,75%,90%,100%
![pwm](img/simulations/pwm_sim.PNG)

# sound_logic.vhd:
Modul zoberie output z pwm modulu a z control unit. Jeho úlohou je vstupný signál čiastočne prerušovať, tak aby vznikalo pípanie.
Toto robíme tak, že generujeme signál s rozdielnou frekvenciou pre jednotlivé stavy. Tam kde je tento signál rovný 0, nastáva prerušenie vstupného signálu.  
Pri stave "000" vstupný signál je celý čas utĺmovaný a žiaden zvuk nevydáva.

Pri stave "001" vstupný signál signál pípa 500ms a je ticho 500ms.

Pri stave "010" a "011" vstupný signál signál pípa 300ms a je ticho 300ms.

Pri stave "100" a "101" vstupný signál signál pípa 200ms a je ticho 200ms.

Pri stave "110" vstupný signál signál pípa 100ms a je ticho 100ms.

Pri stave "111" vstupný signál je prepúšťaný celý čas a vydáva zvuk stále.

Pri ostatných inputoch utĺmovací signál mení svoju frekvenciu, pri niektorých "susedných" inputoch je frekvencia rovnaká, aby sme mali len 6 pípacích stavov.

Špecifikácie:
* vstup 100MHz `clk`
* vstup 3b `state`
* vstup 1b `sound_in`
* výstup 1b `sound_out`

### Simulácia pípania:
Pre účely simulácie sme nastavili trvanie každého stavu na 1 milisekundu a frekvencie utĺmoviaceho signálu sú v jednotkách nanosekúnd (normálne stovky milisekúnd)

![logic](img/simulations/sound_logic_sim.PNG)



  
