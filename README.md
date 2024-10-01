# Rarity Library
Allows for the creation of custom Balatro rarities.
More info on this mod can be found in the appropriate forum channel in the Balatro discord.

Documentation:
CGLIBRARITIES (table)
Contains key-value pairings like so:
myRarity1 = { 
name = "My Rarity",
color = HEX("ffffff")
}
Used for colors and pools.
CGLIBWEIGHTS (table)
Contains key-value pairings like so:
0.7,
0.25,
0.05,
cry_epic = 0.007,
myRarity1 = 0.2
These are for the weights of jokers as they are placed in shops.

CGLIBGETWEIGHTS (function)
Used internally to easily fetch info regarding rarity weights.

CGLIB.Rarity (function) [rar:table]
Creates a custom rarity. Requires the following arguments inside rar:
key = string
name = string
color = color [[HEX("hexcode")]]
shopweight = number (vanilla ones add up to 1, common is 0.7, uncommon 0.25, rare 0.05) (default 0.3)
[optional]
oneHigher = number/string (for CGLIB.incrementRarity)
oneLower = number/string (for CGLIB.decrementRarity, which is not a thing atm)

CGLIB.incrementRarity (function) [rarity:number/string] (createcardoverride:boolean)
Returns the rarity one 'rarer' than what is passed to it. Returns a create_card friendly version (works with both Cryptid and without) if createcardoverride is true.
