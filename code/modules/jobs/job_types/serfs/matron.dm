/datum/job/matron
	title = "Matron"

	tutorial = "Once you were a Matron of an Orphanage, where you raised orphans with both a firm and gentle hand. \
		\n\n Now all those days are gone, so you've resumed your old role.\
		Where you were a cunning rogue who once walked alongside legends.\
		Now while retired from adventuring, you've taken up your proper duties as a member of the Thieves Guild.\
		Guide the new generation and make sure that the Guild gets its dues and that contracts are done \
		Continue its success in this town even if you have to pay its masters a pretty coin or two."

	department_flag = PEASANTS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_MATRON
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1

	allowed_sexes = list(FEMALE)
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)
	allowed_races = RACES_PLAYER_NONEXOTIC
	blacklisted_species = list(SPEC_ID_HALFLING)

	outfit = /datum/outfit/matron
	give_bank_account = 35
	can_have_apprentices = TRUE
	cmode_music = 'sound/music/cmode/nobility/CombatSpymaster.ogg'

	spells = list(
		/datum/action/cooldown/spell/undirected/hag_call,
		/datum/action/cooldown/spell/undirected/seek_orphan,
	)

	exp_type = list(EXP_TYPE_LIVING, EXP_TYPE_ADVENTURER, EXP_TYPE_THIEF)
	exp_types_granted = list(EXP_TYPE_ADVENTURER, EXP_TYPE_THIEF)
	exp_requirements = list(
		EXP_TYPE_LIVING = 1200,
		EXP_TYPE_ADVENTURER = 300,
		EXP_TYPE_THIEF = 300
	)

	skills = list(
		/datum/skill/misc/sewing = 3,
		/datum/skill/misc/sneaking = 5,
		/datum/skill/misc/stealing = 5,
		/datum/skill/misc/lockpicking = 5,
		/datum/skill/craft/traps = 3,
		/datum/skill/misc/climbing = 5,
		/datum/skill/misc/athletics = 3,
		/datum/skill/craft/cooking = 4,
		/datum/skill/misc/medicine = 1,
		/datum/skill/misc/reading = 3,
		/datum/skill/combat/knives = 5,
		/datum/skill/combat/unarmed = 4,
		/datum/skill/combat/wrestling = 4,
	)

	jobstats = list(
		STATKEY_STR = -1,
		STATKEY_INT =  2,
		STATKEY_PER =  1,
		STATKEY_SPD =  2
	)

	mind_traits = list(
		TRAIT_KNOW_THIEF_DOORS
	)
	traits = list(
		TRAIT_THIEVESGUILD,
		TRAIT_SEEPRICES, //Needed for fencing shit
		TRAIT_ASSASSIN, //The local boss of the Thieves Guild would know the contracts
		TRAIT_OLDPARTY,
		TRAIT_DODGEEXPERT,
		TRAIT_STRONG_GRABBER,
		TRAIT_KITTEN_MOM,
	)

	languages = list(/datum/language/thievescant)

	spells = list(/datum/action/cooldown/spell/undirected/list_target/convert_role/mercenary)

/datum/job/matron/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.age == AGE_OLD)
		spawned.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/misc/lockpicking, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/misc/stealing, 2, TRUE)
		spawned.adjust_skillrank(/datum/skill/misc/sneaking, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)

		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_SPD, 1)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_END, 1)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_STR, 2) //offssets Old's penalty

/datum/outfit/matron
	name = "Matron"
	shirt = /obj/item/clothing/shirt/dress/gen/colored/black
	armor = /obj/item/clothing/armor/leather/vest/colored/black
	pants = /obj/item/clothing/pants/trou/beltpants
	belt = /obj/item/storage/belt/leather/cloth/lady
	shoes = /obj/item/clothing/shoes/boots/leather
	backr = /obj/item/storage/backpack/satchel
	cloak = /obj/item/clothing/cloak/matron

	backpack_contents = list(
		/obj/item/weapon/knife/dagger/steel/special = 1,
		/obj/item/key/matron = 1,
		/obj/item/key/crime = 1
	)

/datum/outfit/matron/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	beltl = /obj/item/storage/belt/pouch/coins/rich
