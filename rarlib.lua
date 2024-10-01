--- STEAMODDED HEADER
--- MOD_NAME: Rarity Library
--- MOD_ID: rarlib
--- MOD_AUTHOR: [cg]
--- PREFIX: rar
--- MOD_DESCRIPTION: Provides functions for easily creating custom Joker rarities.
--- PRIORITY: -1

CGLIBRARITIES = {}
CGLIBWEIGHTS = {
    0.7,
    0.25,
    0.05
}
function CGLIBGETWEIGHTS()
    local maxweights = 0
    local weightregiontable = {}
    for i, v in pairs(CGLIBWEIGHTS) do
        weightregiontable[i] = {maxweights, maxweights + v}
        maxweights = maxweights + v
    end
    if SMODS.Mods.Cryptid and SMODS.Mods.Cryptid.can_load and cry_enable_epics then
        weightregiontable.cry_epic = {maxweights, maxweights + 0.007}
    end
    return maxweights, weightregiontable
end
CGLIB = {}
Game:set_globals()
CGLIB.RarityExample = {
    key = "cg_coolrarity",
    name = "Cool Rarity",
    color = HEX("ffff8d"),
    shopweight = 0.1,
    oneHigher = 4, --legendary
    oneLower = 3, --rare
}



CGLIB.Rarity = function(rar)
    assert(type(rar) == "table", "Rarity is not a table.")
    assert(not CGLIBRARITIES[rar.key], "Rarity "..tostring(rar.key).." already exists as a custom rarity.")
    assert(not G.P_JOKER_RARITY_POOLS[rar.key], "Rarity "..tostring(rar.key).." already exists as a vanilla rarity.")
    assert(rar.name, "Rarity has no name.")
    assert(rar.color, "Rarity has no color.")
    


    CGLIBRARITIES[rar.key] = {
        name = rar.name,
        color = rar.color
    }
    CGLIBWEIGHTS[rar.key] = rar.shopweight or 0.3
    G.localization.misc.dictionary[rar.key] = rar.name
    G.P_JOKER_RARITY_POOLS[rar.key] = {}
    G.C.RARITY[rar.key] = rar.color
    if rar.oneHigher then
        CGLIB.rarityIncrementTable[rar.key] = rar.oneHigher
    end
    if rar.oneLower then
        CGLIB.rarityDecrementTable[rar.key] = rar.oneLower
    end
end

CGLIB.rarityIncrementTable = {}
CGLIB.rarityDecrementTable = {}
CGLIB.decrementRarity = function(rarity)

end


CGLIB.incrementRarity = function(rarity, createcardoverride)
    if rarity == 4 then
        if SMODS.Mods.Cryptid and SMODS.Mods.Cryptid.can_load then
            rarity = "cry_exotic"
        end
    end
    if type(rarity) == "number" and rarity ~= 4 then --dont increment up to 5 (nonexistent rarity)
        rarity = rarity + 1 --additional method: math.min(rarity + 1, 4)
    end
    if createcardoverride and SMODS.Mods.Cryptid and SMODS.Mods.Cryptid.can_load then
        if rarity == 1 then
            rarity = 0
        elseif rarity == 2 then
            rarity = 0.9
        elseif rarity == 3 then
            rarity = 0.99
        elseif rarity == 'cry_epic' then --convert to be compatible with cryptids create_card override
            rarity = 1
        end
    end
    if CGLIB.rarityIncrementTable[rarity] then
        rarity = CGLIB.rarityIncrementTable[rarity]
    end
    return rarity
end

--copypaste from cryptid
local get_badge_colourref = get_badge_colour
function get_badge_colour(key)
	local fromRef = get_badge_colourref(key)
	if CGLIBRARITIES[key] then
        return G.C.RARITY[key]
    end
	return fromRef
end

local is = SMODS.injectItems
function SMODS.injectItems()
	local m = is()
	for k, v in pairs(G.P_CENTERS) do
		v.key = k
		if v.rarity and (CGLIBRARITIES[v.rarity]) and v.set == "Joker" and not v.demo then
			table.insert(G.P_JOKER_RARITY_POOLS[v.rarity], v)
		end
	end
	return m
end


