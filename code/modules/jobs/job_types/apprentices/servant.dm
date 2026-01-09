/datum/job/servant
	title = "Manor slave"

	tutorial = "You were raised as a primer slave to serve. \
	You were trained in gladiatorial combat to fight when commanded \
	and in housekeeping and entertainment to please when not. \
	You are the unseen labor that keeps the royal court fed, protected, and indulged."

	department_flag = APPRENTICES
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_SERVANT
	faction = FACTION_TOWN
	total_positions = 3
	spawn_positions = 3
	bypass_lastclass = TRUE
	allowed_ages = ALL_AGES_LIST_CHILD
	allowed_races = RACES_PLAYER_ALL
	forced_flaw = /datum/charflaw/indentured

	outfit = /datum/outfit/servant
	give_bank_account = TRUE
	cmode_music = 'sound/music/cmode/towner/CombatPrisoner.ogg'
	can_have_apprentices = FALSE

/datum/outfit/servant/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == MALE)
		shirt = /obj/item/clothing/shirt/undershirt/formal
		if(H.age == AGE_OLD)
			pants = /obj/item/clothing/pants/trou/formal // no one wants to see your wrinkly legs, codger
		else
			pants = /obj/item/clothing/pants/trou/formal/shorts
		belt = /obj/item/storage/belt/leather/suspenders
		shoes = /obj/item/clothing/shoes/boots
		beltl = /obj/item/storage/keyring/manorguard
		backl = /obj/item/storage/backpack/satchel
		backpack_contents = list(/obj/item/recipe_book/cooking = 1, /obj/item/storage/belt/pouch/coins/poor = 1, /obj/item/rope/chain = 2, /obj/item/needle = 1)
	else
		armor = /obj/item/clothing/shirt/dress/maid/servant
		shoes = /obj/item/clothing/shoes/simpleshoes
		belt = /obj/item/storage/belt/leather/cloth_belt
		pants = /obj/item/clothing/pants/tights/colored/white
		cloak = /obj/item/clothing/cloak/apron/maid
		head = /obj/item/clothing/head/maidband
		beltl = /obj/item/storage/keyring/manorguard
		backl = /obj/item/storage/backpack/satchel
		backpack_contents = list(/obj/item/recipe_book/cooking = 1, /obj/item/storage/belt/pouch/coins/poor = 1, /obj/item/rope/chain = 2, /obj/item/needle = 1)
		neck = /obj/item/clothing/neck/leathercollar

	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, pick(1,1,2), TRUE)
	H.adjust_skillrank(/datum/skill/labor/butchering, 1, TRUE)
	H.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/music, pick(0,1,1), TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/stealing, 3, TRUE)
	H.change_stat(STATKEY_SPD, 2)
	H.change_stat(STATKEY_INT, 2)
	ADD_TRAIT(H, TRAIT_ROYALSERVANT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_GOODLOVER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)

/datum/job/servant/after_spawn(mob/living/carbon/spawned, client/player_client)
	..()
	if(!ishuman(spawned))
		return
	var/mob/living/carbon/human/H = spawned
	SSticker.OnRoundstart(CALLBACK(src, PROC_REF(offer_weapon_choice), H, player_client))

/datum/job/servant/proc/offer_weapon_choice(mob/living/carbon/human/H, client/player_client)
	var/client/chooser = player_client || H?.client
	if(!H || QDELETED(H) || !chooser)
		return

	var/list/weapons = list(
		"Pikeman" = list(/obj/item/weapon/polearm/spear/billhook, /obj/item/weapon/sword/arming),
		"Fencer" = /obj/item/weapon/sword/rapier,
		"Bow" = list(/obj/item/gun/ballistic/revolver/grenadelauncher/bow/long, /obj/item/ammo_holder/quiver/arrows),
		"Crossbow" = list(/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow, /obj/item/ammo_holder/quiver/bolts),
		"Knife" = /obj/item/weapon/knife/dagger/steel
	)
	var/weapon_choice = browser_input_list(chooser, "Choose your weapon.", "TAKE UP ARMS", weapons)
	if(QDELETED(H) || !chooser)
		return
	if(!weapon_choice)
		return

	var/list/spawn_items = weapons[weapon_choice]
	if(!islist(spawn_items))
		spawn_items = list(spawn_items)
	for(var/obj/item/spawn_item as anything in spawn_items)
		give_or_drop(H, spawn_item)

	switch(weapon_choice)
		if("Pikeman")
			H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
			H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)

		if("Fencer")
			H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)

		if("Bow")
			H.adjust_skillrank(/datum/skill/combat/bows, 3, TRUE)

		if("Crossbow")
			H.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)

		if("Knife")
			H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)

/datum/job/servant/proc/give_or_drop(mob/living/carbon/human/H, path)
	if(!H || QDELETED(H) || !path)
		return

	var/obj/item/I = new path(H.drop_location())
	if(!H.put_in_hands(I))
		to_chat(H, span_warning("My hands are full. [I] drops to the floor."))

/datum/job/tapster
	title = "Tapster"
	f_title = "Alemaid"
	tutorial = "The Innkeeper needed waiters and extra hands. So here am I, serving the food and drinks while ensuring the tavern rooms are kept clean."
	department_flag = APPRENTICES
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_SERVANT
	faction = FACTION_TOWN
	total_positions = 2
	spawn_positions = 2

	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/tapster
	give_bank_account = TRUE
	can_have_apprentices = FALSE
	cmode_music = 'sound/music/cmode/towner/CombatInn.ogg'

	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/tapster

	jobstats = list(
		STATKEY_SPD = 1,
		STATKEY_END = 1
	)

	skills = list(
		/datum/skill/combat/knives = 2,
		/datum/skill/misc/reading = 1,
		/datum/skill/craft/cooking = 3,
		/datum/skill/labor/butchering = 1,
		/datum/skill/misc/medicine = 1,
		/datum/skill/labor/farming = 1,
		/datum/skill/misc/sewing = 2,
		/datum/skill/craft/crafting = 1,
		/datum/skill/misc/sneaking = 2,
		/datum/skill/misc/stealing = 3
	)

	traits = list(
		TRAIT_BOOZE_SLIDER
	)

/datum/job/tapster/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.adjust_skillrank(/datum/skill/misc/music, pick(0,1,1), TRUE)

/datum/outfit/tapster
	name = "Tapster Base"
	shoes = /obj/item/clothing/shoes/simpleshoes
	pants = /obj/item/clothing/pants/tights/colored/uncolored
	shirt = /obj/item/clothing/shirt/undershirt/colored/uncolored
	belt = /obj/item/storage/belt/leather/rope
	beltl = /obj/item/storage/belt/pouch/coins/poor
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/recipe_book/cooking = 1, TRUE)
	neck = /obj/item/key/tavern

/datum/outfit/tapster/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == MALE)
		armor = /obj/item/clothing/armor/leather/vest/colored/black
	else
		cloak = /obj/item/clothing/cloak/apron

/datum/job/matron_assistant
	title = "Orphanage Assistant"
	tutorial = "I once was an orphan, the matron took me in and now I am forever in her debt. \
	That orphanage, those who were like me need guidance, I shall assist the matron in her tasks."
	department_flag = APPRENTICES
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_SERVANT
	faction = FACTION_TOWN
	total_positions = 0
	spawn_positions = 0
	bypass_lastclass = TRUE
	give_bank_account = TRUE
	can_have_apprentices = FALSE

	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/matron_assistant

	jobstats = list(
		STATKEY_SPD = 1,
		STATKEY_END = 1
	)

	skills = list(
		/datum/skill/combat/knives = 2,
		/datum/skill/misc/reading = 1,
		/datum/skill/craft/cooking = 3,
		/datum/skill/labor/butchering = 1,
		/datum/skill/misc/medicine = 1,
		/datum/skill/labor/farming = 1,
		/datum/skill/misc/sewing = 2,
		/datum/skill/craft/crafting = 1,
		/datum/skill/misc/sneaking = 2,
		/datum/skill/misc/stealing = 3,
	)

/datum/job/matron_assistant/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.adjust_skillrank(/datum/skill/misc/music, pick(0,1,1), TRUE)

/datum/outfit/matron_assistant
	name = "Orphanage Assistant Base"
	shoes = /obj/item/clothing/shoes/simpleshoes
	pants = /obj/item/clothing/pants/tights/colored/uncolored
	shirt = /obj/item/clothing/shirt/undershirt/colored/uncolored
	belt = /obj/item/storage/belt/leather/rope
	beltl = /obj/item/storage/belt/pouch/coins/poor
	neck = /obj/item/key/matron
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/recipe_book/cooking = 1)

/datum/outfit/matron_assistant/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == MALE)
		armor = /obj/item/clothing/armor/leather/vest/colored/black
	else
		cloak = /obj/item/clothing/cloak/apron

/datum/job/gaffer_assistant
	title = "Ring Servant"
	tutorial = "I never had what it took to be a mercenary, but I offered my service to the Guild regardless. \
	My vow is to serve whomever holds the ring of Burden while avoiding its curse from befalling me."
	department_flag = APPRENTICES
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_SERVANT
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	bypass_lastclass = TRUE
	give_bank_account = TRUE
	cmode_music = 'sound/music/cmode/adventurer/CombatIntense.ogg'

	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/gaffer_assistant
	exp_types_granted = list(EXP_TYPE_MERCENARY)

	jobstats = list(
		STATKEY_SPD = 1,
		STATKEY_END = 1
	)

	skills = list(
		/datum/skill/combat/knives = 2,
		/datum/skill/misc/reading = 1,
		/datum/skill/craft/cooking = 3,
		/datum/skill/labor/butchering = 1,
		/datum/skill/misc/medicine = 1,
		/datum/skill/labor/farming = 1,
		/datum/skill/misc/sewing = 2,
		/datum/skill/craft/crafting = 1,
		/datum/skill/misc/sneaking = 2,
		/datum/skill/misc/stealing = 3,
		/datum/skill/labor/mathematics = 1,
	)

/datum/job/gaffer_assistant/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.adjust_skillrank(/datum/skill/misc/music, pick(0,1,1), TRUE)

/datum/outfit/gaffer_assistant
	name = "Ring Servant"
	shoes = /obj/item/clothing/shoes/simpleshoes
	pants = /obj/item/clothing/pants/tights/colored/uncolored
	shirt = /obj/item/clothing/shirt/undershirt/colored/uncolored
	belt = /obj/item/storage/belt/leather/rope
	beltl = /obj/item/storage/belt/pouch/coins/poor
	beltr = /obj/item/storage/keyring/gaffer_assistant
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/recipe_book/cooking = 1)

/datum/outfit/gaffer_assistant/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == MALE)
		armor = /obj/item/clothing/armor/leather/vest/colored/black
	else
		cloak = /obj/item/clothing/cloak/apron
