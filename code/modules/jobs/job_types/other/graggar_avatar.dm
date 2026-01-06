/datum/job/graggar_avatar
	title = "Avatar of Graggar"
	tutorial = "Graggar's hunger gnaws at your soul. You are his avatar, sent forth to crush the weak and feast in his name."
	department_flag = PEASANTS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_WRETCH
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	allowed_races = list(SPEC_ID_OGRE)
	cmode_music = 'sound/music/cmode/antag/combat_werewolf.ogg'
	outfit = /datum/outfit/graggar_avatar

	jobstats = list(
		STATKEY_STR = 4,
		STATKEY_CON = 6,
		STATKEY_END = 5,
	)

	skills = list(
		/datum/skill/combat/axesmaces = 4,
		/datum/skill/combat/polearms = 4,
		/datum/skill/combat/swords = 4,
		/datum/skill/combat/knives = 4,
		/datum/skill/combat/wrestling = 4,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/misc/athletics = 4,
		/datum/skill/misc/climbing = 2,
	)

	traits = list(
		TRAIT_BASHDOORS,
		TRAIT_STEELHEARTED,
		TRAIT_STRONGBITE,
		TRAIT_MEDIUMARMOR,
	)

/datum/job/graggar_avatar/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.patron?.type != /datum/patron/inhumen/graggar)
		spawned.set_patron(/datum/patron/inhumen/graggar, TRUE)
	if(spawned.dna?.species?.id != SPEC_ID_OGRE)
		spawned.set_species(/datum/species/ogre)
	to_chat(spawned, span_warning("Do what comes naturally."))

/datum/outfit/graggar_avatar
	name = "Avatar of Graggar"
	head = /obj/item/clothing/head/helmet/graggar/ogre
	armor = /obj/item/clothing/armor/plate/ogre
	shirt = /obj/item/clothing/armor/chainmail/hauberk/ogre
	pants = /obj/item/clothing/pants/chainlegs/ogre
	shoes = /obj/item/clothing/shoes/boots/armor/ogre
	gloves = /obj/item/clothing/gloves/plate/ogre
	wrists = /obj/item/clothing/wrists/bracers/ogre
	neck = /obj/item/clothing/neck/gorget/ogre
	belt = /obj/item/storage/belt/leather/ogre
	backr = /obj/item/weapon/greataxe/steel/doublehead/graggar
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/rope/chain = 1,
	)
