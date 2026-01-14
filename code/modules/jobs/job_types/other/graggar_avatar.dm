/datum/job/graggar_avatar
	title = "Avatar of Graggar"
	tutorial = "Graggar's hunger gnaws at your soul. You are his avatar, sent forth to crush the weak and feast in his name."
	department_flag = PEASANTS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_WRETCH
	faction = FACTION_TOWN
	total_positions = 0
	spawn_positions = 0
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
		TRAIT_HEAVYARMOR,
	)

/datum/job/graggar_avatar/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.patron?.type != /datum/patron/inhumen/graggar)
		spawned.set_patron(/datum/patron/inhumen/graggar, TRUE)
	if(spawned.dna?.species?.id != SPEC_ID_OGRE)
		spawned.set_species(/datum/species/ogre)
	to_chat(spawned, span_warning("Do what comes naturally."))
	addtimer(CALLBACK(src, PROC_REF(offer_weapon_choice), spawned, player_client), 1)

/datum/job/graggar_avatar/proc/offer_weapon_choice(mob/living/carbon/human/H, client/player_client)
	var/client/chooser = player_client || H?.client
	if(!H || QDELETED(H) || !chooser)
		return

	var/list/weapons = list(
		"CRUSHER" = /obj/item/weapon/mace/goden/steel/ogre/graggar,
		"EXECUTIONER" = /obj/item/weapon/greataxe/steel/doublehead/graggar/ogre,
		"None"
	)
	var/weapon_choice = input(chooser, "Choose your weapon.", "WEAPON SELECTION") as null|anything in weapons
	if(!weapon_choice || weapon_choice == "None")
		return

	var/path = weapons[weapon_choice]
	if(path)
		give_or_drop(H, path)

/datum/job/graggar_avatar/proc/give_or_drop(mob/living/carbon/human/H, path)
	if(!H || QDELETED(H) || !path)
		return

	var/obj/item/I = new path(H.drop_location())
	if(!H.put_in_hands(I))
		to_chat(H, span_warning("My hands are full. [I] drops to the floor."))

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
	beltr = /obj/item/weapon/knife/cleaver/ogre
	backl = /obj/item/weapon/sword/long/greatsword/zwei/ogre
	backr = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/weapon/mace/cudgel/ogre = 1,
		/obj/item/rope/chain = 1,
		/obj/item/flashlight/flare/torch/lantern = 1
	)
