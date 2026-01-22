
/datum/job/advclass/guilder/death_monk
	title = "Eastern Monk"
	tutorial = "You are a Master of Martial Arts, a Death Monk that hails from the Sect of Heavenly Deathfist. \
		Master of unarmed combat in the name of Psydon and the Scholar-Empress of Tianxia, the Ink-Jade Empire far east of Grenzelhoft.\
		Despite your faith in Psydon, you have taken on contracts and eventually service within the Thieves Guild. \
		Whether it's because you have fallen wayward or believe you can enact change within."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_JADE
	category_tags = list(CTAG_CRIME)
	outfit = /datum/outfit/guilder/death_monk
	cmode_music = 'sound/music/cmode/guild/Combat_Monk.ogg'
	total_positions = 10

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_END = 2,
		STATKEY_CON = 2,
		STATKEY_SPD = 2
	)

	skills = list(
		/datum/skill/combat/swords = 3,
		/datum/skill/misc/athletics = 5,
		/datum/skill/combat/unarmed = 5,
		/datum/skill/combat/wrestling = 5,
		/datum/skill/misc/climbing = 5,
		/datum/skill/misc/sneaking = 4,
		/datum/skill/misc/stealing = 3,
		/datum/skill/misc/swimming = 3,
		/datum/skill/misc/medicine = 2,
		/datum/skill/misc/sewing = 2,
		/datum/skill/misc/reading = 2,
		/datum/skill/craft/cooking = 1,
	)

	job_packs = list(
		/datum/job_pack/death_monk/fists,
		/datum/job_pack/death_monk/katar,
		/datum/job_pack/death_monk/staff
	)

	traits = list(
		TRAIT_DODGEEXPERT,
		TRAIT_STRONG_GRABBER,
		TRAIT_PSYDONIAN_GRIT,
		TRAIT_PSYDONITE,
	)
	languages = list(/datum/language/oldpsydonic)


/datum/job_pack/death_monk/fists
	name = "Pugilist"
	pack_stats = list(STATKEY_STR = 1)

	pack_skills = list(
		/datum/skill/combat/unarmed = 1,
		/datum/skill/combat/wrestling = 1
	)
	pack_traits = list(
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_IGNOREDAMAGESLOWDOWN
	)

	pack_contents = list(
		/obj/item/clothing/gloves/bandages/pugilist = ITEM_SLOT_HANDS
	)

/datum/job_pack/death_monk/katar
	name = "Katar Stabber"
	pack_stats = list(STATKEY_STR = 1)


	pack_traits = list(
		TRAIT_CRITICAL_RESISTANCE
	)

	pack_contents = list(
		/obj/item/clothing/gloves/bandages/weighted = ITEM_SLOT_HANDS
	)


/datum/job_pack/death_monk/katar/pick_pack(mob/living/carbon/human/picker)
	. = ..()
	picker.put_in_hands(/obj/item/weapon/katar)


/datum/job_pack/death_monk/staff
	name = "Staff Master"

	pack_skills = list(
		/datum/skill/combat/polearms = 4
	)
	pack_stats = list(
		STATKEY_PER = 1,
		STATKEY_END = 1
	)


	pack_traits = list(
		TRAIT_CRITICAL_RESISTANCE
	)

	pack_contents = list(
		/obj/item/clothing/gloves/bandages/weighted = ITEM_SLOT_HANDS
	)


/datum/job_pack/death_monk/katar/pick_pack(mob/living/carbon/human/picker)
	. = ..()
	picker.put_in_hands(/obj/item/weapon/polearm/woodstaff/quarterstaff)

/datum/outfit/guilder/death_monk
	name = "Death Monk"
	shoes = /obj/item/clothing/shoes/shortboots
	armor = /obj/item/clothing/armor/monk_robe
	shirt = /obj/item/clothing/shirt/undershirt/easttats/death_monk
	backr = /obj/item/storage/backpack/satchel/black
	belt = /obj/item/storage/belt/leather/rope/dark
	pants = /obj/item/clothing/pants/tights/colored/black
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/colored/brown
	neck = /obj/item/clothing/neck/psycross/silver
	wrists = /obj/item/clothing/wrists/bracers/psythorns
	backpack_contents = list(
		/obj/item/key/crime = 1,
		/obj/item/storage/belt/pouch/coins/mid = 1,
	)
