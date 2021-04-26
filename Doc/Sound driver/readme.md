# Sound driver
Obsahuje moduly:
* sound_memory.vhd
* sound_logic.vhd
* pwm DAC `TODO`
* sampler (vyčítání vzorků) `TODO`

## sound_memory:
Modul obsahuje v paměti asi 0.8 sec dlouhý krátký úsek audia (mono).

Převod do unsigned integeru byl proveden za pomocí [skriptu v matlabu](waw2array.m). Výsledek je uložen v [txt souboru](sound_string.txt); pro snadnější formátování po 50 samplech na řádek.

 Audio je normalizováno (pro maximální rozkmit).

**Tech. specifikace:**
* Rozlišení: 8b
* Počet vzorků: 2303
* Vzorkovací kmitočet 96000 Hz
* Velikost souboru 8kiB

### Simulace vyčítání z paměti:
![sim1](img/simulations/memory_test.png)
### Detail vyčítání z paměti:
![sim1](img/simulations/memory_test_detail.png)