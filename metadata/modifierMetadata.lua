local relicIds = require "lookups/relicIds"

--[[
    Contains metadata for all buffs currently tracked in damage calculation.

    Shape:
        varPath  : The path to the var responsible for tracking this buff's activation status
        actMsg   : Debug message for buff activation
        disMsg   : Debug message for buff deactivation
        category : Modifier category for payload categorization (Prayer, BuffId, Perk, nil)
        enum     : Enum value to be sent to rotdb API
        actVal   : Activation value for VarPlayer modifiers, nil if VarClient
        offset   : Offset from starting logic tick for VarClient modifiers, 0 if var is already ending tick,
                   nil if VarPlayer. Value is in logic ticks,
        stackable: Boolean value for if the buff is stackable or toggleable
        routing  : Determines which listeners the related state can pass through and at what point

    Any var that has multiple relevant activation values will get multipl records.
    E.g., dracolich rapid fire buff get base if activation value is 1, elite if activation value is 2.

    Stackable buffs have an activation value of 1. There is no check for if the base buff is active, it is just considered moot if <= 0.
]]

local modifierMetadata = {}
modifierMetadata.bookActive = {
    varPath = var.VarPlayer.GOD_BOOK_ACTIVE,
    actMsg = "Pocket slot active",
    disMsg = "Pocket slot deactivated",
    category = "BuffId",
    enum = nil,
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.annihilationStacks = {
    varPath = var.VarPlayer.DMBH_WEAPON_MELEE_STACKS,
    actMsg = "Gravitate active",
    disMsg = "Gravitate deactivated",
    category = "BuffId",
    enum = "GRAVITATESTACKS",
    actVal = 1,
    offset = nil,
    stackable = true,
    routing = "Player"
}
modifierMetadata.baseDracolichRapidFire = {
    varPath = var.VarPlayer.COMBATV2_BUFF_DRACOLICH_SET_EFFECT,
    actMsg = "Base Dracolich rapid fire buff active",
    disMsg = "Base Dracolich rapid fire buff deactivated",
    category = "BuffId",
    enum = "RAPIDFIREBUFF",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.eliteDracolichRapidFire = {
    varPath = var.VarPlayer.COMBATV2_BUFF_DRACOLICH_SET_EFFECT,
    actMsg = "Elite Dracolich rapid fire buff active",
    disMsg = "Elite Dracolich rapid fire buff deactivated",
    category = "BuffId",
    enum = "RAPIDFIREBUFF",
    actVal = 2,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.rampage = {
    varPath = var.VarClient.COMBATV2_BUFF_DRAGON_BATTLEAXE_EFFECT_END_CLIENT,
    actMsg = "Rampage active",
    disMsg = "Rampage expired",
    category = "BuffId",
    enum = "DBA",
    actVal = nil,
    offset = 0,
    stackable = false,
    routing = "Client"
}
modifierMetadata.undeadSlayerSigil = {
    varPath = var.VarClient.COMBATV2_COOLDOWN_CONSTITUTION_UNDEAD_SLAYER_START_CLIENT,
    actMsg = "Undead slayer sigil active",
    disMsg = "Undead slayer sigil expired",
    category = "BuffId",
    enum = "UNDEADSLAYERSIGIL",
    actVal = nil,
    offset = 10.2 * 50,
    stackable = false,
    routing = "Client"
}
modifierMetadata.demonSlayerSigil = {
    varPath = var.VarClient.COMBATV2_COOLDOWN_CONSTITUTION_DEMON_SLAYER_START_CLIENT,
    actMsg = "Demon slayer sigil active",
    disMsg = "Demon slayer sigil expired",
    category = "BuffId",
    enum = "DEMONSLAYERSIGIL",
    actVal = nil,
    offset = 10.2 * 50,
    stackable = false,
    routing = "Client"
}
modifierMetadata.dragonSlayerSigil = {
    varPath = var.VarClient.COMBATV2_COOLDOWN_CONSTITUTION_DRAGON_SLAYER_START_CLIENT,
    actMsg = "Dragon slayer sigil active",
    disMsg = "Dragon slayer sigil expired",
    category = "BuffId",
    enum = "DRAGONSLAYERSIGIL",
    actVal = nil,
    offset = 10.2 * 50,
    stackable = false,
    routing = "Client"
}
modifierMetadata.vampyreSlayerSigil = {
    varPath = var.VarClient.COMBATV2_COOLDOWN_CONSTITUTION_VAMPYRE_SLAYER_START_CLIENT,
    actMsg = "Vampyre slayer sigil active",
    disMsg = "Vampyre slayer sigil expired",
    category = "BuffId",
    enum = "VAMPYRESLAYERSIGIL",
    actVal = nil,
    offset = 10.2 * 50,
    stackable = false,
    routing = "Client"
}
modifierMetadata.malevolence = {
    varPath = var.VarPlayer.CURSE_OVERHEAD_TURMOIL,
    actMsg = "Malevolence active",
    disMsg = "Malevolence deactivated",
    category = "Prayer",
    enum = "MALEVOLENCE",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.affliction = {
    varPath = var.VarPlayer.CURSE_OVERHEAD_TORMENT,
    actMsg = "Affliction active",
    disMsg = "Affliction deactivated",
    category = "Prayer",
    enum = "AFFLICTION",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.desolation = {
    varPath = var.VarPlayer.CURSE_OVERHEAD_ANGUISH,
    actMsg = "Desolation active",
    disMsg = "Desolation deactivated",
    category = "Prayer",
    enum = "DESOLATION",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.ruination = {
    varPath = var.VarPlayer.CURSE_RUINATION,
    actMsg = "Ruination active",
    disMsg = "Ruination deactivated",
    category = "Prayer",
    enum = "RUINATION",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.rendBleed = {
    varPath = var.VarPlayer.COMBATV2_TARGET_SIDE_PANEL_TARGET_MENAPHOS_GLOVES_BLEED,
    actMsg = "Gloves of Passage bleed buff active",
    disMsg = "Gloves of Passage bleed buff deactivated",
    category = "BuffId",
    enum = "SMASH",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.rend = {
    varPath = var.VarPlayer.MENAPHOS_SLAYER_GLOVE_EFFECT_ACTIVE,
    actMsg = "Gloves of Passage ability buff active",
    disMsg = "Gloves of Passage ability buff deactivated",
    category = "BuffId",
    enum = "SMASH",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.chaosRoar = {
    varPath = var.VarClient.COMBATV2_COOLDOWN_STRENGTH_CHAOS_ROAR_START_CLIENT,
    actMsg = "Chaos roar active",
    disMsg = "Chaos roar deactivated",
    category = "BuffId",
    enum = "CHAOSROAR",
    actVal = nil,
    offset = 7.2 * 50,
    stackable = false,
    routing = "Client"
}
modifierMetadata.berserk = {
    varPath = var.VarPlayer.COMBATV2_BUFF_MELEE_BERSERK_ACTIVE,
    actMsg = "Berserk active",
    disMsg = "Berserk deactivated",
    category = "BuffId",
    enum = "BERSERK",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.greaterFury = {
    varPath = var.VarClient.COMBATV2_BUFF_MELEE_GREATER_FURY_GUARANTEED_CRITICAL_STRIKE_END_CLIENT,
    actMsg = "Greater fury buff active",
    disMsg = "Greater fury buff deactivated",
    category = "BuffId",
    enum = "GREATERFURYBUFF",
    actVal = nil,
    offset = 0,
    stackable = false,
    routing = "Client"
}
modifierMetadata.fury = {
    varPath = var.VarClient.COMBATV2_COOLDOWN_STRENGTH_FURY_START_CLIENT,
    actMsg = "Fury buff active",
    disMsg = "Fury buff deactivated",
    category = "BuffId",
    enum = "FURYBUFF",
    actVal = nil,
    offset = 15 * 50,
    stackable = false,
    routing = "Client"
}
modifierMetadata.blackhold = {
    varPath = var.VarPlayer.GWD2_SOLO_ZAROS_GODSWORD_SPEC_DAMAGE_BONUS,
    actMsg = "Zaros godsword buff active",
    disMsg = "Zaros godsword buff deactivated",
    category = "BuffId",
    enum = "ZGS",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.reapersCrew = {
    varPath = var.VarPlayer.PASSIVE_REAPER_BOOST,
    actMsg = "Reapers crew active",
    disMsg = "Reapers crew deactivated",
    category = "BuffId",
    enum = "REAPERSCREW",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.puzzlebox2 = {
    varPath = var.VarPlayer.QUEST_DAUGHTER_MAIN,
    actMsg = "Puzzlebox tier 2 active",
    disMsg = "Puzzlebox tier 2 deactivated",
    category = "BuffId",
    enum = "PUZZLEBOX",
    actVal = 220,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.puzzlebox3 = {
    varPath = var.VarPlayer.MINIQUEST_ZAMORAK_CIVIL_WAR_1_MAIN,
    actMsg = "Puzzlebox tier 3 active",
    disMsg = "Puzzlebox tier 3 deactivated",
    category = "BuffId",
    enum = "PUZZLEBOX",
    actVal = 30,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.puzzlebox4 = {
    varPath = var.VarPlayer.MINIQUEST_ZAMORAK_CIVIL_WAR_2_MAIN,
    actMsg = "Puzzlebox tier 4 active",
    disMsg = "Puzzlebox tier 4 deactivated",
    category = "BuffId",
    enum = "PUZZLEBOX",
    actVal = 30,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.puzzlebox5 = {
    varPath = var.VarPlayer.MINIQUEST_ZAMORAK_CIVIL_WAR_3_MAIN,
    actMsg = "Puzzlebox tier 5 active",
    disMsg = "Puzzlebox tier 5 deactivated",
    category = "BuffId",
    enum = "PUZZLEBOX",
    actVal = 35,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.puzzlebox6 = {
    varPath = var.VarPlayer.QUEST_DAUGHTER2,
    actMsg = "Puzzlebox tier 6 active",
    disMsg = "Puzzlebox tier 6 deactivated",
    category = "BuffId",
    enum = "PUZZLEBOX",
    actVal = 255,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.puzzleboxToolbelt = {
    varPath = var.VarPlayer.TOOLBELT_SEASON2022_INFERNUS_PUZZLE_BOX,
    actMsg = "Puzzlebox toolbelted",
    disMsg = "Puzzlebox not toolbelted",
    category = "BuffId",
    enum = "PUZZLEBOX",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.berserkersFury = {
    varPath = nil,
    actMsg = "Berserkers fury active",
    disMsg = "Berserkers fury inactive",
    category = "BuffId",
    enum = "BERSERKERSFURY",
    actVal = relicIds["Berserker's Fury"],
    offset = nil,
    stackable = false,
    routing = "Relic"
}
modifierMetadata.frostblades = {
    varPath = var.VarClient.COMBATV2_BUFF_FROSTBLADES_END_CLIENT,
    actMsg = "Frostblades active",
    disMsg = "Frostblades expired",
    category = "BuffId",
    enum = "FROSTBLADES",
    actVal = nil,
    offset = 0,
    stackable = false,
    routing = "Client"
}
modifierMetadata.bloodlustEmpowered = {
    varPath = var.VarPlayer.COMBATV2_BUFF_MELEE_BLOODLUST_STACKS,
    actMsg = "Bloodlust empowered",
    disMsg = "Bloodlust depleted",
    category = "BuffId",
    enum = "BLOODLUST",
    actVal = 4,
    offset = nil,
    stackable = false,
    routing = "Stack to Static"
}
modifierMetadata.rubyAurora = {
    varPath = var.VarPlayer.SEREN_RUBY_BUFF,
    actMsg = "Ruby aurora active",
    disMsg = "Ruby aurora depleted",
    category = "BuffId",
    enum = "RUBYAURORA",
    actVal = 1,
    offset = nil,
    stackable = true,
    routing = "Player"
}
modifierMetadata.revengeStacks = {
    varPath = var.VarPlayer.COMBATV2_REVENGE_DAMAGE_SCALER,
    actMsg = "Revenge active",
    disMsg = "Revenge deactivated",
    category = "BuffId",
    enum = "REVENGE",
    actVal = 1,
    offset = nil,
    stackable = true,
    routing = "Player"
}
modifierMetadata.ruthlessStacks = {
    varPath = var.VarPlayer.INVENT_PERK_RUTHLESS_STACK_QUANTITY,
    actMsg = "Ruthless active",
    disMsg = "Ruthless deactivated",
    category = "BuffId",
    enum = "RUTHLESSSTACKS",
    actVal = 1,
    offset = nil,
    stackable = true,
    routing = "Player"
}
modifierMetadata.lengStacks = {
    varPath = var.VarPlayer.COMBATV2_BUFF_PRIMORDIAL_ICE_STACKS,
    actMsg = "Primoridial ice active",
    disMsg = "Primordial ice depleted",
    category = "BuffId",
    enum = "PRIMORDIALICE",
    actVal = 1,
    offset = nil,
    stackable = true,
    routing = "Player"
}
modifierMetadata.guardhouse1 = {
    varPath = var.VarPlayer.PLAYER_FORT_BUILDING_GUARDHOUSE,
    actMsg = "Guardhouse tier 1",
    disMsg = "Guardhouse changed",
    category = "BuffId",
    enum = "GUARDHOUSE",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.guardhouse2 = {
    varPath = var.VarPlayer.PLAYER_FORT_BUILDING_GUARDHOUSE,
    actMsg = "Guardhouse tier 2",
    disMsg = "Guardhouse changed",
    category = "BuffId",
    enum = "GUARDHOUSE",
    actVal = 2,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.guardhouse3 = {
    varPath = var.VarPlayer.PLAYER_FORT_BUILDING_GUARDHOUSE,
    actMsg = "Guardhouse tier 3",
    disMsg = "Guardhouse changed",
    category = "BuffId",
    enum = "GUARDHOUSE",
    actVal = 3,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.slayerLodge1 = {
    varPath = var.VarPlayer.DINO_BASE_CAMP_BUILDING_TIER_SLAYER_LODGE,
    actMsg = "Slayer lodge tier 1",
    disMsg = "Slayer lodge changed",
    category = "BuffId",
    enum = "SLAYERLODGE",
    actVal = 1,
    offset = nil,
    stackable = true,
    routing = "Player"
}
modifierMetadata.slayerLodge2 = {
    varPath = var.VarPlayer.DINO_BASE_CAMP_BUILDING_TIER_SLAYER_LODGE,
    actMsg = "Slayer lodge tier 2",
    disMsg = "Slayer lodge changed",
    category = "BuffId",
    enum = "SLAYERLODGE",
    actVal = 2,
    offset = nil,
    stackable = true,
    routing = "Player"
}
modifierMetadata.slayerLodge3 = {
    varPath = var.VarPlayer.DINO_BASE_CAMP_BUILDING_TIER_SLAYER_LODGE,
    actMsg = "Slayer lodge tier 3",
    disMsg = "Slayer lodge changed",
    category = "BuffId",
    enum = "SLAYERLODGE",
    actVal = 3,
    offset = nil,
    stackable = true,
    routing = "Player"
}
modifierMetadata.heroism = {
    varPath = var.VarPlayer.EGWD_ZAMORAK_BOSS_REWARD_ENCHANTMENT_RING_CHAMPION,
    actMsg = "Enchantment of Heroism active",
    disMsg = "Enchantment of Heroism deactivated",
    category = "BuffId",
    enum = "ENCHANTMENTOFHEROISM",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.shadows = {
    varPath = var.VarPlayer.EGWD_ZAMORAK_BOSS_REWARD_ENCHANTMENT_RING_STALKER,
    actMsg = "Enchantment of Shadows active",
    disMsg = "Enchantment of Shadows deactivated",
    category = "BuffId",
    enum = "ENCHANTMENTOFSHADOWS",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.metaphysics = {
    varPath = var.VarPlayer.EGWD_ZAMORAK_BOSS_REWARD_ENCHANTMENT_RING_CHANNELLER,
    actMsg = "Enchantment of Metaphysics active",
    disMsg = "Enchantment of Metaphysics deactivated",
    category = "BuffId",
    enum = "ENCHANTMENTOFMETAPHYSICS",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.dread = {
    varPath = var.VarPlayer.EGWD_ZAMORAK_BOSS_REWARD_ENCHANTMENT_NIGHTMARE_GAUNTLETS,
    actMsg = "Enchantment of Dread active",
    disMsg = "Enchantment of Dread deactivated",
    category = "BuffId",
    enum = "ENCHANTMENTOFDREAD",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.agony = {
    varPath = var.VarPlayer.EGWD_ZAMORAK_BOSS_REWARD_ENCHANTMENT_GLOVES_OF_PASSAGE,
    actMsg = "Enchantment of Agony active",
    disMsg = "Enchantment of Agony deactivated",
    category = "BuffId",
    enum = "ENCHANTMENTOFAGONY",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.flames = {
    varPath = var.VarPlayer.EGWD_ZAMORAK_BOSS_REWARD_ENCHANTMENT_KERAPAC_GLOVES,
    actMsg = "Enchantment of Flames active",
    disMsg = "Enchantment of Flames deactivated",
    category = "BuffId",
    enum = "ENCHANTMENTOFFLAMES",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.enchantmentAffliction = {
    varPath = var.VarPlayer.EGWD_ZAMORAK_BOSS_REWARD_ENCHANTMENT_INQUISITOR,
    actMsg = "Enchantment of Affliction active",
    disMsg = "Enchantment of Affliction deactivated",
    category = "BuffId",
    enum = "ENCHANTMENTOFAFFLICTION",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.savagery = {
    varPath = var.VarPlayer.EGWD_ZAMORAK_BOSS_REWARD_ENCHANTMENT_TERRASAUR,
    actMsg = "Enchantment of Savagery active",
    disMsg = "Enchantment of Savagery deactivated",
    category = "BuffId",
    enum = "ENCHANTMENTOFSAVAGERY",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.dispelling = {
    varPath = var.VarPlayer.EGWD_ZAMORAK_BOSS_REWARD_ENCHANTMENT_HEXHUNTER,
    actMsg = "Enchantment of Dispelling active",
    disMsg = "Enchantment of Dispelling deactivated",
    category = "BuffId",
    enum = "ENCHANTMENTOFDISPELLING",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.tumekensSharded = {
    varPath = var.VarPlayer.COMBATV2_INNATE_MASTERY_STAT_UPGRADE_TUMEKENS_LIGHT_TIER_UNLOCKED,
    actMsg = "Tumekens Light sharded",
    disMsg = "Tumekens Light not sharded",
    category = "BuffId",
    enum = "SHARDOFGENESIS",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.devourersSharded = {
    varPath = var.VarPlayer.COMBATV2_INNATE_MASTERY_STAT_UPGRADE_DEVOURERS_GUARD_TIER_UNLOCKED,
    actMsg = "Devourers Guard sharded",
    disMsg = "Devourers Guard not sharded",
    category = "BuffId",
    enum = "SHARDOFGENESIS",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.roarSharded = {
    varPath = var.VarPlayer.COMBATV2_INNATE_MASTERY_STAT_UPGRADE_SONG_OF_DESTRUCTION_TIER_UNLOCKED,
    actMsg = "Roar and Ode sharded",
    disMsg = "Roar and Ode not sharded",
    category = "BuffId",
    enum = "SHARDOFGENESIS",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.omniSharded = {
    varPath = var.VarPlayer.COMBATV2_INNATE_MASTERY_STAT_UPGRADE_OMNI_SOULBOUND_TIER_UNLOCKED,
    actMsg = "Omni Guard sharded",
    disMsg = "Omni Guard not sharded",
    category = "BuffId",
    enum = "SHARDOFGENESIS",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.bolgSharded = {
    varPath = var.VarPlayer.COMBATV2_INNATE_MASTERY_STAT_UPGRADE_BOW_OF_THE_LAST_GUARDIAN_TIER_UNLOCKED,
    actMsg = "Bow of the Last Guardian sharded",
    disMsg = "Bow of the Last Guardian not sharded",
    category = "BuffId",
    enum = "SHARDOFGENESIS",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.ezkSharded = {
    varPath = var.VarPlayer.COMBATV2_INNATE_MASTERY_STAT_UPGRADE_EK_ZEKKIL_TIER_UNLOCKED,
    actMsg = "Ek-Zekkil sharded",
    disMsg = "Ek-Zekkil not sharded",
    category = "BuffId",
    enum = "SHARDOFGENESIS",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.lengsSharded = {
    varPath = var.VarPlayer.COMBATV2_INNATE_MASTERY_STAT_UPGRADE_DARK_SHARDS_OF_LENG_TIER_UNLOCKED,
    actMsg = "Lengs sharded",
    disMsg = "Lengs not sharded",
    category = "BuffId",
    enum = "SHARDOFGENESIS",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.fsoaSharded = {
    varPath = var.VarPlayer.COMBATV2_INNATE_MASTERY_STAT_UPGRADE_FRACTURED_STAFF_OF_ARMADYL_TIER_UNLOCKED,
    actMsg = "FSOA sharded",
    disMsg = "FSOA not sharded",
    category = "BuffId",
    enum = "SHARDOFGENESIS",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.balanceOfPower = {
    varPath = var.VarPlayer.EGWD_ZAMORAK_BOSS_EDICT_BALANCE_OF_POWER_STACKS,
    actMsg = "Balance of Power active",
    disMsg = "Balance of Power deactivated",
    category = "BuffId",
    enum = "BALANCEOFPOWER",
    actVal = 1,
    offset = nil,
    stackable = true,
    routing = "Player"
}
modifierMetadata.guardiansTriumph = {
    varPath = var.VarPlayer.EGWD_ZAMORAK_BOSS_EDICT_GUARDIANS_TRIUMPH_STACKS,
    actMsg = "Guardians Triumph active",
    disMsg = "Guardians Triumph deactivated",
    category = "BuffId",
    enum = "GUARDIANSTRIUMPH",
    actVal = 1,
    offset = nil,
    stackable = true,
    routing = "Player"
}
modifierMetadata.flamebound = {
    varPath = var.VarPlayer.COMBATV2_BUFF_FLAMEBOUND_RIVAL_TARGET_NPC_UID,
    actMsg = "Flamebound applied",
    disMsg = "Flamebound not applied",
    category = "BuffId",
    enum = "FLAMEBOUNDRIVAL",
    actVal = nil,
    offset = nil,
    stackable = false,
    routing = "NPC match"
}
modifierMetadata.vulned = {
    varPath = var.VarPlayer.COMBATV2_TARGET_SIDE_PANEL_TARGET_VULNERABILITY,
    actMsg = "Vuln applied",
    disMsg = "Vuln not applied",
    category = "BuffId",
    enum = "VULNED",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.curse = {
    varPath = var.VarPlayer.COMBATV2_TARGET_SIDE_PANEL_TARGET_CURSE,
    actMsg = "Curse applied",
    disMsg = "Curse not applied",
    category = "BuffId",
    enum = "CURSED",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.smokeCloud = {
    varPath = var.VarPlayer.COMBATV2_TARGET_SIDE_PANEL_TARGET_MAGIC_SMOKE_CLOUD,
    actMsg = "Smoke Cloud applied",
    disMsg = "Smoke Cloud not applied",
    category = "BuffId",
    enum = "SMOKECLOUDED",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.kalgScroll = {
    varPath = var.VarClient.COMBATV2_LORE_ANCIENT_KALGERION_DEMON_SCROLL_END_EFFECT_CLIENT,
    actMsg = "Kalg Scroll applied",
    disMsg = "Kalg Scroll not applied",
    category = "BuffId",
    enum = "KALG",
    actVal = nil,
    offset = 0,
    stackable = false,
    routing = "Client"
}
modifierMetadata.stoneOfJas = {
    varPath = var.VarPlayer.COMBATV2_JAS_BOOST,
    actMsg = "Stone of jas applied",
    disMsg = "Stone of jas depleted",
    category = "BuffId",
    enum = "STONEOFJAS",
    actVal = 1,
    offset = nil,
    stackable = true,
    routing = "Player"
}
modifierMetadata.nopeNopeNope1 = {
    varPath = var.VarPlayer.COMBATV2_TARGET_SIDE_PANEL_TARGET_SPIDER_BOOST1,
    actMsg = "Nope nope nope 1 active",
    disMsg = "Nope nope nope 1 deactivated",
    category = "BuffId",
    enum = "NOPENOPENOPE",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.nopeNopeNope2 = {
    varPath = var.VarPlayer.COMBATV2_TARGET_SIDE_PANEL_TARGET_SPIDER_BOOST2,
    actMsg = "Nope nope nope 2 active",
    disMsg = "Nope nope nope 2 deactivated",
    category = "BuffId",
    enum = "NOPENOPENOPE",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.noFear = {
    varPath = var.VarPlayer.POF_REWARDS_PERK_ANIMAL_BGH_CORBICULA,
    actMsg = "No fear active",
    disMsg = "No fear deactivated",
    category = "BuffId",
    enum = "NOFEAR",
    actVal = 1,
    offset = nil,
    stackable = true,
    routing = "Player"
}
modifierMetadata.deathSwiftness = {
    varPath = var.VarPlayer.COMBATV2_BUFF_RANGED_DEATH_SWIFTNESS_ACTIVE,
    actMsg = "Death swiftness active",
    disMsg = "Death swiftness deactivated",
    category = "BuffId",
    enum = "DEATHSWIFTNESS",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.galeshot = {
    varPath = var.VarPlayer.COMBATV2_BUFF_RANGED_SEARING_WINDS_ACTIVE,
    actMsg = "Galeshot active",
    disMsg = "Galeshot deactivated",
    category = "BuffId",
    enum = "GALES",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.crimsonSalvo = {
    varPath = var.VarClient.COMBATV2_BUFF_RANGED_GHRAZI_T95_BONUS_DAMAGE_END_CLIENT,
    actMsg = "Crimson Salvo active",
    disMsg = "Crimson Salvo inactive",
    category = "BuffId",
    enum = "CRIMSONSALVO",
    actVal = nil,
    offset = 0,
    stackable = false,
    routing = "Client"
}
modifierMetadata.ecbSpec = {
    varPath = var.VarClient.COMBATV2_COOLDOWN_DUNGEON_ULTHVEN_2H_RANGED_SPECIAL_EFFECT_CLIENT,
    actMsg = "Eldritch Crossbow Special active",
    disMsg = "Eldritch Crossbow Special inactive",
    category = "BuffId",
    enum = "SPLITSOUL",
    actVal = nil,
    offset = 0,
    stackable = false,
    routing = "Client"
}
modifierMetadata.balanceByForce = {
    varPath = var.VarPlayer.COMBATV2_BUFF_BALANCE_BY_FORCE_ACTIVE,
    actMsg = "Balance by force active",
    disMsg = "Balance by force deactivated",
    category = "BuffId",
    enum = "BALANCEBYFORCE",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.wenStacks = {
    varPath = var.VarPlayer.DINARROW_WEN_BUFF_CHILL_STACKS,
    actMsg = "Wen arrow stacks active",
    disMsg = "Wen arrow stacks depleted",
    category = "BuffId",
    enum = "WENSTACKS",
    actVal = 1,
    offset = nil,
    stackable = true,
    routing = "Player"
}
modifierMetadata.bolgStacks = {
    varPath = var.VarPlayer.COMBATV2_BUFF_PERFECT_EQUILIBRIUM_STACKS,
    actMsg = "Perfect equilibrium stacks active",
    disMsg = "Perfect equilibrium depleted",
    category = "BuffId",
    enum = "PERFECTEQUILIBRIUMSTACKS",
    actVal = 1,
    offset = nil,
    stackable = true,
    routing = "Player"
}
modifierMetadata.sunshine = {
    varPath = var.VarPlayer.TSD_SUNSHINE_DAMAGE,
    actMsg = "Sunshine active",
    disMsg = "Sunshine inactive",
    category = "BuffId",
    enum = "SUNSHINE",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.runicCharge = {
    varPath = var.VarPlayer.COMBATV2_BUFF_MAGIC_WRACK_ACTIVE,
    actMsg = "Runic Charge active",
    disMsg = "Runic Charge inactive",
    category = "BuffId",
    enum = "RUNICCHARGE",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.concentratedBlastBonus = {
    varPath = var.VarPlayer.COMBATV2_NEXT_ATTACK_MAGIC_CONCENTRATED_BLAST_CRITICAL_STRIKE_BONUS,
    actMsg = "Concentrated blast bonus active",
    disMsg = "Concentrated blast bonus inactive",
    category = "BuffId",
    enum = "CONCENTRATEDBLASTBUFF",
    actVal = 1,
    offset = nil,
    stackable = true,
    routing = "Player"
}
modifierMetadata.channelledMight = {
    varPath = var.VarClient.COMBATV2_BUFF_MAGIC_ASPHYXIATE_CRITICAL_DAMAGE_END_CLIENT,
    actMsg = "Channelled Might active",
    disMsg = "Channelled Might inactive",
    category = "BuffId",
    enum = "CHANNELLEDMIGHT",
    actVal = nil,
    offset = 0,
    stackable = false,
    routing = "Client"
}
modifierMetadata.instability = {
    varPath = var.VarClient.COMBATV2_COOLDOWN_WEAPON_INSTABILITY_END_CLIENT,
    actMsg = "Instability active",
    disMsg = "Instability inactive",
    category = "BuffId",
    enum = "INSTABILITY",
    actVal = nil,
    offset = -30 * 50,
    stackable = false,
    routing = "Client"
}
modifierMetadata.conflagrate = {
    varPath = var.VarClient.COMBATV2_BUFF_SOULFIRE_COMBUST_END_EFFECT_CLIENT,
    actMsg = "Conflagrate active",
    disMsg = "Conflagrate inactive",
    category = "BuffId",
    enum = "CONFLAGRATE",
    actVal = nil,
    offset = 0,
    stackable = false,
    routing = "Client"
}
modifierMetadata.titheStacks = {
    varPath = var.VarPlayer.COMBATV2_BUFF_BLOOD_TITHE_STACKS,
    actMsg = "Tithe active",
    disMsg = "Tithe inactive",
    category = "BuffId",
    enum = "TITHESTACKS",
    actVal = 1,
    offset = nil,
    stackable = true,
    routing = "Player"
}
modifierMetadata.essenceCorruption = {
    varPath = var.VarPlayer.COMBATV2_BUFF_MAGIC_DEVOURER_T95_PASSIVE_STACKS,
    actMsg = "Essence Corruption active",
    disMsg = "Essence Corruption inactive",
    category = "BuffId",
    enum = "ESSENCECORRUPTION",
    actVal = 1,
    offset = nil,
    stackable = true,
    routing = "Player"
}
modifierMetadata.combusted = {
    varPath = var.VarPlayer.COMBATV2_TARGET_SIDE_PANEL_TARGET_COMBUST,
    actMsg = "Combust active",
    disMsg = "Combust inactive",
    category = "BuffId",
    enum = "COMBUSTED",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.livingDeath = {
    varPath = var.VarPlayer.COMBATV2_BUFF_NECROMANCY_UNDEAD_INSTINCT_ABILITY_STRUCT,
    actMsg = "Living Death active",
    disMsg = "Living Death inactive",
    category = "BuffId",
    enum = "LIVINGDEATH",
    actVal = nil,
    offset = nil,
    stackable = false,
    routing = "Living Death"
}
modifierMetadata.arisenFlesh = {
    varPath = var.VarPlayer.COMBATV2_BUFF_NECROMANCY_INVOKE_ARISEN_FLESH_ACTIVE,
    actMsg = "Arisen Flesh active",
    disMsg = "Arisen Flesh inactive",
    category = "BuffId",
    enum = "ARISENFLESH",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.necromancySplitSoul = {
    varPath = var.VarPlayer.COMBATV2_BUFF_NECROMANCY_SPLIT_SOUL_ACTIVE,
    actMsg = "Split soul active",
    disMsg = "Split soul inactive",
    category = "BuffId",
    enum = "SPLITSOUL",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.necrosis = {
    varPath = var.VarPlayer.COMBATV2_BUFF_NECROMANCY_NECROSIS_STACKS,
    actMsg = "Necrosis active",
    disMsg = "Necrosis depleted",
    category = "BuffId",
    enum = "NECROSIS",
    actVal = 1,
    offset = nil,
    stackable = true,
    routing = "Player"
}
modifierMetadata.residualSouls = {
    varPath = var.VarPlayer.COMBATV2_BUFF_NECROMANCY_RESIDUAL_SOUL_STACKS,
    actMsg = "Souls active",
    disMsg = "Souls depleted",
    category = "BuffId",
    enum = "SOULSTACKS",
    actVal = 1,
    offset = nil,
    stackable = true,
    routing = "Player"
}
modifierMetadata.deathSpark = {
    varPath = var.VarPlayer.COMBATV2_BUFF_NECRO_RASIAL_ARMGUARD_T95_PASSIVE_STACKS,
    actMsg = "Death spark active",
    disMsg = "Death spark depleted",
    category = "BuffId",
    enum = "DEATHSPARK",
    actVal = 1,
    offset = nil,
    stackable = true,
    routing = "Player"
}
modifierMetadata.rage = {
    varPath = var.VarPlayer.COMBATV2_BUFF_NECROMANCY_SPIRIT_SKELETON_WARRIOR_STACKS,
    actMsg = "Skeleton stacks active",
    disMsg = "Skeleton stacks depleted",
    category = "BuffId",
    enum = "RAGE",
    actVal = 1,
    offset = nil,
    stackable = true,
    routing = "Player"
}
modifierMetadata.valour = {
    varPath = var.VarPlayer.COMBATV2_BUFF_NECROMANCY_SPIRIT_PHANTOM_GUARDIAN_STACKS,
    actMsg = "Phantom guardian stacks active",
    disMsg = "Phantom guardian stacks depleted",
    category = "BuffId",
    enum = "VALOUR",
    actVal = 1,
    offset = nil,
    stackable = true,
    routing = "Player"
}
modifierMetadata.fulBookActive = {
    varPath = var.VarClient.COMBATV2_EGWD_FUL_GOD_BOOK_EFFECT_END_CLIENT,
    actMsg = "Ful book active",
    disMsg = "Ful book inactive",
    category = "BuffId",
    enum = nil,
    actVal = nil,
    offset = 0,
    stackable = false,
    routing = "Client"
}
modifierMetadata.amascutBookActive = {
    varPath = var.VarClient.COMBATV2_BUFF_RAID_REBIRTH1_AMASCUT_BOOK_END_CLIENT,
    actMsg = "Amascut book active",
    disMsg = "Amascut book inactive",
    category = "BuffId",
    enum = nil,
    actVal = nil,
    offset = 0,
    stackable = false,
    routing = "Client"
}
modifierMetadata.turmoil = {
    varPath = var.VarPlayer.CURSE_TURMOIL,
    actMsg = "Turmoil active",
    disMsg = "Turmoil depleted",
    category = "Prayer",
    enum = "TURMOIL",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.anguish = {
    varPath = var.VarPlayer.CURSE_ANGUISH,
    actMsg = "Anguish active",
    disMsg = "Anguish depleted",
    category = "Prayer",
    enum = "ANGUISH",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.torment = {
    varPath = var.VarPlayer.CURSE_TORMENT,
    actMsg = "Torment active",
    disMsg = "Torment depleted",
    category = "Prayer",
    enum = "TORMENT",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.sorrow = {
    varPath = var.VarPlayer.CURSE_SORROW,
    actMsg = "Sorrow active",
    disMsg = "Sorrow depleted",
    category = "Prayer",
    enum = "SORROW",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.leechRangedStrength = {
    varPath = var.VarPlayer.CURSE_LEECH_RANGED_STRENGTH,
    actMsg = "Leech Ranged Strength active",
    disMsg = "Leech Ranged Strength depleted",
    category = "Prayer",
    enum = "LEECHRANGEDSTRENGTH",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.leechMagicStrength = {
    varPath = var.VarPlayer.CURSE_LEECH_MAGIC_STRENGTH,
    actMsg = "Leech Magic Strength active",
    disMsg = "Leech Magic Strength depleted",
    category = "Prayer",
    enum = "LEECHMAGICSTRENGTH",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.leechMeleeStrength = {
    varPath = var.VarPlayer.CURSE_LEECH_STRENGTH,
    actMsg = "Leech Melee Strength active",
    disMsg = "Leech Melee Strength depleted",
    category = "Prayer",
    enum = "LEECHMELEESTRENGTH",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.leechNecromancyStrength = {
    varPath = var.VarPlayer.CURSE_LEECH_NECROMANCY_STRENGTH,
    actMsg = "Leech Necromancy Strength active",
    disMsg = "Leech Necromancy Strength depleted",
    category = "Prayer",
    enum = "LEECHNECROMANCYSTRENGTH",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.divineRage = {
    varPath = var.VarPlayer.COMBATV2_PRAYER_DIVINE_RAGE,
    actMsg = "Divine Rage active",
    disMsg = "Divine Rage depleted",
    category = "Prayer",
    enum = "DIVINERAGE",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.rigour = {
    varPath = var.VarPlayer.COMBATV2_PRAYER_RIGOUR,
    actMsg = "Rigour active",
    disMsg = "Rigour depleted",
    category = "Prayer",
    enum = "RIGOUR",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.augury = {
    varPath = var.VarPlayer.COMBATV2_PRAYER_AUGURY,
    actMsg = "Augury active",
    disMsg = "Augury depleted",
    category = "Prayer",
    enum = "AUGURY",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.piety = {
    varPath = var.VarPlayer.COMBATV2_PRAYER_PIETY,
    actMsg = "Piety active",
    disMsg = "Piety depleted",
    category = "Prayer",
    enum = "PIETY",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.chivalry = {
    varPath = var.VarPlayer.COMBATV2_PRAYER_CHIVALRY,
    actMsg = "Chivalry active",
    disMsg = "Chivalry depleted",
    category = "Prayer",
    enum = "CHIVALRY",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.sanctity = {
    varPath = var.VarPlayer.COMBATV2_PRAYER_SANCTITY,
    actMsg = "Sanctity active",
    disMsg = "Sanctity depleted",
    category = "Prayer",
    enum = "SANCTITY",
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.boostMeleeStrength = {
    varPath = var.VarPlayer.COMBATV2_PRAYER_BOOST_MELEE_STRENGTH,
    actMsg = "Boost Melee Strength active",
    disMsg = "Boost Melee Strength depleted",
    category = "Prayer",
    enum = nil,
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.boostRangedStrength = {
    varPath = var.VarPlayer.COMBATV2_PRAYER_BOOST_RANGED_STRENGTH,
    actMsg = "Boost Ranged Strength active",
    disMsg = "Boost Ranged Strength depleted",
    category = "Prayer",
    enum = nil,
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.boostMagicStrength = {
    varPath = var.VarPlayer.COMBATV2_PRAYER_BOOST_MAGIC_STRENGTH,
    actMsg = "Boost Magic Strength active",
    disMsg = "Boost Magic Strength depleted",
    category = "Prayer",
    enum = nil,
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.boostNecromancyStrength = {
    varPath = var.VarPlayer.COMBATV2_PRAYER_BOOST_NECROMANCY_STRENGTH,
    actMsg = "Boost Necromancy Strength active",
    disMsg = "Boost Necromancy Strength depleted",
    category = "Prayer",
    enum = nil,
    actVal = 1,
    offset = nil,
    stackable = false,
    routing = "Player"
}
modifierMetadata.biting = {
    varPath = var.VarPlayer.INVENT_PERK_BITING,
    actMsg = "Biting active",
    disMsg = "Biting depleted",
    category = "Perk",
    enum = "BITING",
    actVal = 1,
    offset = nil,
    stackable = true,
    routing = "Player",
    itemLevelCheckPath = var.VarPlayer.INVENT_PERK_BITING_EMPOWERED
}
modifierMetadata.genocidal = {
    varPath = var.VarPlayer.INVENT_PERK_GENOCIDAL,
    actMsg = "Genocidal active",
    disMsg = "Genocidal depleted",
    category = "Perk",
    enum = "GENOCIDAL",
    actVal = 1,
    offset = nil,
    stackable = true,
    routing = "Player",
    itemLevelCheckPath = nil
}
modifierMetadata.caroming = {
    varPath = var.VarPlayer.INVENT_PERK_CAROMING,
    actMsg = "Caroming active",
    disMsg = "Caroming depleted",
    category = "Perk",
    enum = "CAROMING",
    actVal = 1,
    offset = nil,
    stackable = true,
    routing = "Player",
    itemLevelCheckPath = nil
}
modifierMetadata.ultimatums = {
    varPath = var.VarPlayer.INVENT_PERK_ULTIMATUMS,
    actMsg = "Ultimatums active",
    disMsg = "Ultimatums depleted",
    category = "Perk",
    enum = "ULTIMATUMS",
    actVal = 1,
    offset = nil,
    stackable = true,
    routing = "Player",
    itemLevelCheckPath = nil
}
modifierMetadata.precise = {
    varPath = var.VarPlayer.INVENT_PERK_PRECISE,
    actMsg = "Precise active",
    disMsg = "Precise depleted",
    category = "Perk",
    enum = "PRECISE",
    actVal = 1,
    offset = nil,
    stackable = true,
    routing = "Player",
    itemLevelCheckPath = nil
}
modifierMetadata.eruptive = {
    varPath = var.VarPlayer.INVENT_PERK_ERUPTIVE,
    actMsg = "Eruptive active",
    disMsg = "Eruptive depleted",
    category = "Perk",
    enum = "ERUPTIVE",
    actVal = 1,
    offset = nil,
    stackable = true,
    routing = "Player",
    itemLevelCheckPath = nil
}
modifierMetadata.flanking = {
    varPath = var.VarPlayer.INVENT_PERK_FLANKING,
    actMsg = "Flanking active",
    disMsg = "Flanking depleted",
    category = "Perk",
    enum = "FLANKING",
    actVal = 1,
    offset = nil,
    stackable = true,
    routing = "Player",
    itemLevelCheckPath = nil
}


return modifierMetadata
