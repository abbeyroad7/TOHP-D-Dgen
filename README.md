# LootGen
A D&D Loot Generator with an emphasis on **"Theater of the Mind"** storytelling. Using AHK (Autohotkey) script, you can bind this utility to any hotkey of your choosing to overlay any Windows-based environment.

The script is built to randomly select a Prompt line from a loot table and swap out any present tag identifiers with a random line from a corresponding wordbank. Tag identifiers are read as {COLOR}, {RACE}, {BEAST} in the Table and can further add variety in the responses to yield a unique response every time the generator is run.

In addition, the script automatically copies generated text to your Clipboard for ease of use.

## Examples
{CONDITION} A tombstone  Reads 'Here lies {NAME}. Cause of death: {SUBJECT}'

![DeathByEveryone](https://github.com/abbeyroad7/TOHP-D-Dgen/blob/main/Loot/.Screenshots/DeathbyEveryone.png)

A quarter slice of {RACENAME} {cheese}

![AarokocraCheese](https://github.com/abbeyroad7/TOHP-DNDgen/blob/main/Loot/.Screenshots/AarokocraCheese.png)

{CONDITION} Flask of {RACE} beer  Tastes {FLAVOR}

![UrsineBeer](https://github.com/abbeyroad7/TOHP-D-Dgen/blob/main/Loot/.Screenshots/UrsineBeer.png)

# NameGen
Using a similar approach, the Name Generator is able to generate random names for 13 DND races currently, with plans to extend up through to 77 official/homebrew races!

An InputBox will prompt you on which race you would like to prompt for. If you would like to specify gender, add a space followed by either "m" or "f". The generator will then output 3 names, which automatically copy to your Clipboard.

## Examples
Prompt: human m
1. Ljam Forrester
2. Josaeus Goodbrother
3. Domnac Furrs

Prompt: dwarf f
Gundra Ironale
Bronmora Lurdig
Rilda Broadick
