/datum/round_event_control/disaster_stink
	name = "Reeking Curse"
	track = EVENT_TRACK_OMENS
	typepath = /datum/round_event/disaster_stink
	weight = 0
	max_occurrences = 0
	min_players = 0

	tags = list(
		TAG_CURSE,
		TAG_WIDESPREAD,
		TAG_DISASTER,
	)

/datum/round_event/disaster_stink/start()
	. = ..()
	for(var/mob/living/carbon/human/H as anything in GLOB.player_list)
		if(!H.client || H.stat == DEAD || H.client.is_afk())
			continue
		H.set_hygiene(HYGIENE_LEVEL_DISGUSTING)
		var/datum/species/species = H.dna?.species
		if(species)
			species.handle_hygiene(H)

/datum/round_event_control/disaster_arousal
	name = "Fevered Desire"
	track = EVENT_TRACK_OMENS
	typepath = /datum/round_event/disaster_arousal
	weight = 0
	max_occurrences = 0
	min_players = 0

	tags = list(
		TAG_CURSE,
		TAG_WIDESPREAD,
		TAG_DISASTER,
	)

/datum/round_event/disaster_arousal/start()
	. = ..()
	for(var/mob/living/carbon/human/H as anything in GLOB.player_list)
		if(!H.client || H.stat == DEAD || H.client.is_afk())
			continue
		var/list/arousal_data = list()
		SEND_SIGNAL(H, COMSIG_SEX_GET_AROUSAL, arousal_data)
		var/current_arousal = arousal_data["arousal"] || 0
		if(current_arousal < 90)
			SEND_SIGNAL(H, COMSIG_SEX_SET_AROUSAL, 90)

/datum/round_event_control/disaster_thirst
	name = "Parching Curse"
	track = EVENT_TRACK_OMENS
	typepath = /datum/round_event/disaster_thirst
	weight = 0
	max_occurrences = 0
	min_players = 0

	tags = list(
		TAG_CURSE,
		TAG_WATER,
		TAG_WIDESPREAD,
		TAG_DISASTER,
	)

/datum/round_event/disaster_thirst/start()
	. = ..()
	for(var/mob/living/carbon/human/H as anything in GLOB.player_list)
		if(!H.client || H.stat == DEAD || H.client.is_afk())
			continue
		if(H.hydration > HYDRATION_LEVEL_THIRSTY)
			H.set_hydration(HYDRATION_LEVEL_THIRSTY)

/datum/round_event_control/disaster_meteorstorm
	name = "Meteor Storm"
	track = EVENT_TRACK_OMENS
	typepath = /datum/round_event/disaster_meteorstorm
	weight = 0
	max_occurrences = 0
	min_players = 0

	tags = list(
		TAG_CURSE,
		TAG_MAGIC,
		TAG_DISASTER,
	)

/datum/round_event/disaster_meteorstorm
	var/buildings_to_hit = 3
	var/locations_per_building = 2
	var/max_meteors_per_location = 6
	var/meteor_effect_type = /obj/effect/temp_visual/target/meteor/no_fire

/datum/round_event/disaster_meteorstorm/start()
	. = ..()
	var/list/areas = list()
	for(var/area/indoors/town/A in GLOB.areas)
		areas += A
	if(!length(areas))
		return

	areas = shuffle(areas)
	var/limit = min(buildings_to_hit, areas.len)
	for(var/i in 1 to limit)
		var/area/indoors/town/target_area = areas[i]
		var/list/turfs = get_area_turfs(target_area)
		if(!length(turfs))
			continue
		var/list/open_turfs = list()
		for(var/turf/T as anything in turfs)
			if(isfloorturf(T))
				open_turfs += T
		if(!length(open_turfs))
			continue
		open_turfs = shuffle(open_turfs)
		var/location_limit = min(locations_per_building, open_turfs.len)
		for(var/j in 1 to location_limit)
			cast_meteor_storm(open_turfs[j])

/datum/round_event/disaster_meteorstorm/proc/cast_meteor_storm(turf/center)
	var/list/candidates = list()
	for(var/turf/T as anything in RANGE_TURFS(5, center))
		if(T.density)
			continue
		candidates += T
	if(!length(candidates))
		return
	candidates = shuffle(candidates)
	var/limit = min(max_meteors_per_location, candidates.len)
	for(var/i in 1 to limit)
		new meteor_effect_type(candidates[i])
