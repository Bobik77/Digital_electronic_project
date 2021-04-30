  # Control Unit
  ### Popis modulu 
Řídící jednota získává vzdálenostní data ze Sensor driveru. Jedná se o 3 signály, které jsou ve formě 8. bitového kódu. Signály jsou porovnány a ten který má nejnižší hodnotu představuje nejmenší vzdálenost. Poté jsou signály převedeny na 3. bitové a ten který aktuálně reprezentuje nejmenší vzdálenost je odeslán do Sound driveru. Zároveň jsou všechny převedené 3. bitové signály zvlášť odeslány do LED driveru.

  
Obrázky simulací ukazují různé stavy, které mohu nastat a potvrzují, že na výstupu pro Sound driveru se nachází vždy ta nejnižší hodnota.
![Obr1](Img/Obr1.png)
![Obr2](Img/Obr2.png)
![Obr3](Img/Obr3.png)

