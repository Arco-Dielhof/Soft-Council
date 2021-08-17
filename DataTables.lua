if SoftCouncil == nil then SoftCouncil = {} end

--  Data and Info from
--  https://wowpedia.fandom.com/wiki/DungeonEncounterID
--  https://wowpedia.fandom.com/wiki/InstanceID

SoftCouncil.InfoTable =
{
    Encounters =
    {
        -- Encounter IDs = https://wowpedia.fandom.com/wiki/DungeonEncounterID
        -- Instance IDs  = https://wowpedia.fandom.com/wiki/InstanceID
        [652] = {EncounterName =      "Attumen the Huntsman", RaidID = 532, RaidName = "Karazhan"},
        [653] = {EncounterName =                    "Moroes", RaidID = 532, RaidName = "Karazhan"},
        [654] = {EncounterName =          "Maiden of Virtue", RaidID = 532, RaidName = "Karazhan"},
        [655] = {EncounterName =                "Opera Hall", RaidID = 532, RaidName = "Karazhan"},
        [656] = {EncounterName =               "The Curator", RaidID = 532, RaidName = "Karazhan"},
        [657] = {EncounterName =         "Terestian Illhoof", RaidID = 532, RaidName = "Karazhan"},
        [658] = {EncounterName =             "Shade of Aran", RaidID = 532, RaidName = "Karazhan"},
        [659] = {EncounterName =               "Netherspite", RaidID = 532, RaidName = "Karazhan"},
        [660] = {EncounterName =               "Chess Event", RaidID = 532, RaidName = "Karazhan"},
        [661] = {EncounterName =         "Prince Malchezaar", RaidID = 532, RaidName = "Karazhan"},
        [662] = {EncounterName =                 "Nightbane", RaidID = 532, RaidName = "Karazhan"},

        [649] = {EncounterName =         "High King Maulgar", RaidID = 565, RaidName = "Gruul's Lair"},
        [650] = {EncounterName =    "Gruul the Dragonkiller", RaidID = 565, RaidName = "Gruul's Lair"},

        [651] = {EncounterName =               "Magtheridon", RaidID = 544, RaidName = "Magtheridon's Lair"},

        [623] = {EncounterName =      "Hydross the Unstable", RaidID = 548, RaidName = "Coilfang: Serpentshrine Cavern"},
        [624] = {EncounterName =          "The Lurker Below", RaidID = 548, RaidName = "Coilfang: Serpentshrine Cavern"},
        [625] = {EncounterName =       "Leotheras the Blind", RaidID = 548, RaidName = "Coilfang: Serpentshrine Cavern"},
        [626] = {EncounterName =    "Fathom-Lord Karathress", RaidID = 548, RaidName = "Coilfang: Serpentshrine Cavern"},
        [627] = {EncounterName =       "Morogrim Tidewalker", RaidID = 548, RaidName = "Coilfang: Serpentshrine Cavern"},
        [628] = {EncounterName =               "Lady Vashjr", RaidID = 548, RaidName = "Coilfang: Serpentshrine Cavern"},

        [730] = {EncounterName =                     "Al'ar", RaidID = 550, RaidName = "Tempest Keep"},
        [731] = {EncounterName =               "Void Reaver", RaidID = 550, RaidName = "Tempest Keep"},
        [732] = {EncounterName = "High Astromancer Solarian", RaidID = 550, RaidName = "Tempest Keep"},
        [733] = {EncounterName =      "Kael'thas Sunstrider", RaidID = 550, RaidName = "Tempest Keep"},

        [618] = {EncounterName =          "Rage Winterchill", RaidID = 534, RaidName = "The Battle for Mount Hyjal"},
        [619] = {EncounterName =                 "Anetheron", RaidID = 534, RaidName = "The Battle for Mount Hyjal"},
        [620] = {EncounterName =                 "Kaz'Rogal", RaidID = 534, RaidName = "The Battle for Mount Hyjal"},
        [621] = {EncounterName =                   "Azgalor", RaidID = 534, RaidName = "The Battle for Mount Hyjal"},
        [622] = {EncounterName =                "Archimonde", RaidID = 534, RaidName = "The Battle for Mount Hyjal"},

        [601] = {EncounterName =    "High Warlord Naj'entus", RaidID = 564, RaidName = "Black Temple"},
        [602] = {EncounterName = 	          "Supremus", RaidID = 564, RaidName = "Black Temple"},
        [603] = {EncounterName = 	    "Shade of Akama", RaidID = 564, RaidName = "Black Temple"},
        [604] = {EncounterName =           "Teron Gorefiend", RaidID = 564, RaidName = "Black Temple"},
        [605] = {EncounterName =         "Gurtogg Bloodboil", RaidID = 564, RaidName = "Black Temple"},
        [606] = {EncounterName = 	"Reliquary of Souls", RaidID = 564, RaidName = "Black Temple"},
        [607] = {EncounterName =            "Mother Shahraz", RaidID = 564, RaidName = "Black Temple"},
        [608] = {EncounterName =      "The Illidari Council", RaidID = 564, RaidName = "Black Temple"},
        [609] = {EncounterName =         "Illidan Stormrage", RaidID = 564, RaidName = "Black Temple"},
    },
    Consumables =
    {
        [28517] = {            "Super Rejuvenation Potion", {22850,},},
        [45051] = {                "Mad Alchemists Potion", {34440,},},
        [28515] = {                    "Ironshield Potion", {22849,},},
        [38929] = {                      "Fel Mana Potion", {31677,},},
        [28536] = {       "Major Arcane Protection Potion", {22845,},},
        [28511] = {         "Major Fire Protection Potion", {22841,},},
        [28512] = {        "Major Frost Protection Potion", {22842,},},
        [28538] = {         "Major Holy Protection Potion", {22847,},},
        [28513] = {       "Major Nature Protection Potion", {22844,},},
        [28537] = {       "Major Shadow Protection Potion", {22846,},},
        [28508] = {                   "Destruction Potion", {22839,},},
        [28507] = {                         "Haste Potion", {22838,},},
        [28506] = {                        "Heroic Potion", {22837,},},
        [28494] = {               "Insane strength Potion", {22828,},},
        [28492] = {                      "Sneaking Potion", {22826,},},
        [28548] = {                     "Shrouding Potion", {22871,},},
        [28504] = {         "Major Dreamless Sleep Potion", {22836,},},
        [38908] = {              "Fel Regeneration Potion", {31676,},},
        [28499] = {   "Super/Auchenai/Crystal Mana Potion", {22832, 32948, 33935,},},
        [28495] = {"Super/Auchenai/Crystal Healing Potion", {22829, 32947, 33934,},},
        [17534] = {              "Volatile Healing Potion", {28100},},
        [17531] = {                 "Unstable Mana Potion", {28101},},
        [41618] = {             "Bottled Nethergon Energy", {32902},},
        [41620] = {              "Bottled Nethergon Vapor", {32905},},
        [27869] = {                            "Dark Rune", {20520},},
        [16666] = {                         "Demonic Rune", {12662},},
	[28726] = {                       "Nightmare Seed", {22797},},
        [17528] = {                   "Mighty Rage Potion", {13442},},
    },
}
SoftCouncil.DataTable =
{
    Players =
    {

    },
	Dates =
    {

    },
}

SoftCouncil.RegisteredEvents = {} -- DO NOT DELETE, DYNAMIC USE!
