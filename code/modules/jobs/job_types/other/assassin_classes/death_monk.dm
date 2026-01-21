/datum/job/advclass/guilder/death_monk
	title = "Death Monk"
	tutorial = "You are a master martial artist that hails from the Sect of Heavenly Deathfist. \
		Master of unarmed combat in the name of Psydon and the Scholar-Emperor within the Jade Empire far east of Grenzelhoft.\
		Despite your faith in Psydon, you have taken on contracts and eventually service within the Thieves Guild. \n\n \
		Whether it's because you have fallen wayward or believe yo."
	allowed_races = RACES_PLAYER_JADE
	outfit = /datum/outfit/guilder/death_monk
	category_tags = list(CTAG_CRIME)
	cmode_music = 'sound/music/cmode/guild/Combat_Monk.ogg'
	total_positions = 5

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_END = 2,
		STATKEY_CON = 2,
		STATKEY_SPD = 2,
	)

	skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

	traits = list(
		TRAIT_DODGEEXPERT,
		TRAIT_STRONG_GRABBER,
		TRAIT_PSYDONIAN_GRIT,
		TRAIT_PSYDONITE,
	)

/datum/job/advclass/guilder/death_monk/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.title = "Eastern Monk"

/datum/outfit/guilder/death_monk
	name = "Death Monk"
	head = /obj/item/clothing/head/leather/duelhat
	cloak = /obj/item/clothing/cloak/half/duelcape
	armor = /obj/item/clothing/armor/leather/jacket/leathercoat/duelcoat
	shirt = /obj/item/clothing/shirt/undershirt
	gloves = /obj/item/clothing/gloves/leather/duelgloves
	pants = /obj/item/clothing/pants/trou/leather/advanced/colored/duelpants
	shoes = /obj/item/clothing/shoes/nobleboot/duelboots
	belt = /obj/item/storage/belt/leather/mercenary
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/mid = 1)
	scabbards = list(/obj/item/weapon/scabbard/sword)

/datum/outfit/mercenary/duelist/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	var/rando = rand(1,6)
	switch(rando)
		if(1 to 2)
			beltl = /obj/item/weapon/sword/rapier
		if(3 to 4)
			beltl = /obj/item/weapon/sword/rapier/silver //Correct, They have a chance to receive a silver rapier, due to them being from Valoria.
		if(5 to 6)
			beltl = /obj/item/weapon/sword/rapier/dec
