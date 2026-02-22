# Lykkehjulet Festspil
Gameengine: Godot 4.5
Platform: Windows 11
Resolution: 1920x1080

## Regler
Runde starter med at et ord fra en tilfældig kategori vælges.
En spiller starter med at vælge mellem følgende handling:
- Spin hjulet og gæt en konsonant
- Køb en vokal for 500kr. (Udfylder alle bogstaver med vokalen i ordet/sætningen)
- gæt det fulde ord (hvis ordet gættes får spilleren en bonus)
Når alle runder er færdig vinder den spiller med flest penge

### Felter
- Penge: spiller får beløbet hvis de gætter en konsonanten og får lov til at gætte igen. Hvis konsonanten ikke er i ordet mister spilleren turen.
- Fallit: Spiller mister alle sine penge og turen.
- Tabt tur: spiller mister turen.
- Joker: spiller får en mulighed for at bruge jokeren hvis de gætter forkert på en konsonant eller vokal til at få en ekstra tur.

### Spil data
I mappen `game_data` er filen `common.json`, i denne fil kan kategorier udfyldes. Ordne har følgende krav:
- Ordenes maksimale længe skal være 13 karakterer, ellers skal vi indeles med "-".
- Totalt kan sætningen maksimalt indeholde 52 karaktere med mellemrum og "-" inkluderet.

