/obj/structure/window/harem1
	name = "harem window"
	icon = 'modular_rmh/icons/obj/structures/roguewindow.dmi'
	icon_state = "harem1-solid"

/obj/structure/window/harem2
	name = "harem window"
	icon = 'modular_rmh/icons/obj/structures/roguewindow.dmi'
	icon_state = "harem2-solid"
	opacity = TRUE

/obj/structure/window/harem3
	name = "harem window"
	icon = 'modular_rmh/icons/obj/structures/roguewindow.dmi'
	icon_state = "harem3-solid"

/obj/structure/door/viewport/stone
	desc = "stone door"
	icon_state = "stone"
	max_integrity = 1500
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
	broken_repair = /obj/item/natural/stone

/obj/structure/door/viewport/stone/broken
	desc = "A broken stone door from an era bygone. A new one must be constructed in its place."
	icon_state = "stonebr"
	density = 0
	opacity = 0
	max_integrity = 150
	obj_broken = 1

#define TORTURE_STAGE_DAMAGE 1
#define TORTURE_STAGE_WAIT_DISLOCATE 2
#define TORTURE_STAGE_WAIT_DISMEMBER 3
#define TORTURE_STAGE_DONE 4

/obj/structure/bondage
	name = "restraint"
	desc = "A crude restraint meant to hold someone in place."
	anchored = TRUE
	density = TRUE
	can_buckle = TRUE
	max_buckled_mobs = 1
	buckle_lying = 0
	buckle_prevents_pull = TRUE
	buckleverb = "strap"
	breakoutextra = 10 MINUTES
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	blade_dulling = DULLING_BASHCHOP
	max_integrity = 200
	resistance_flags = NONE

	var/strap_self_time = 2 SECONDS
	var/strap_other_time = 4 SECONDS

/obj/structure/bondage/Initialize(mapload)
	. = ..()
	LAZYINITLIST(buckled_mobs)

/obj/structure/bondage/buckle_mob(mob/living/M, force = FALSE, check_loc = TRUE)
	if(!anchored)
		return FALSE

	if(force)
		return ..()

	var/mob/living/user = usr
	if(!user)
		return ..()

	if(!istype(M, /mob/living/carbon/human))
		to_chat(user, span_warning("It doesn't look like [M.p_they()] can fit into this properly!"))
		return FALSE

	if(M != user)
		var/valid_restraint = FALSE
		var/mob/living/carbon/carbon = M
		if(carbon.handcuffed || HAS_TRAIT(M, TRAIT_RESTRAINED))
			valid_restraint = TRUE

		if(!valid_restraint)
			for(var/obj/item/grabbing/G in M.grabbedby)
				if(G.grab_state >= GRAB_AGGRESSIVE)
					valid_restraint = TRUE
					break

		if(!valid_restraint)
			to_chat(user, span_warning("I must grab them more forcefully or restrain them to put them in [src]."))
			return FALSE

		M.visible_message(span_danger("[user] starts strapping [M] into [src]!"), \
			span_userdanger("[user] starts strapping you into [src]!"))

		if(!do_after(user, strap_other_time, src))
			return FALSE
	else
		M.visible_message(span_notice("[user] starts positioning [user.p_them()]self into [src]..."), \
			span_notice("I start positioning myself into [src]..."))

		if(!do_after(user, strap_self_time, src))
			return FALSE

	return ..(M, force, FALSE)

/obj/structure/bondage/chains
	name = "chains"
	desc = "Heavy chains bolted into place."
	icon = 'modular_rmh/icons/obj/structures/bondage.dmi'
	icon_state = "CHAINS"
	SET_BASE_PIXEL(-16, 0)
	density = FALSE
	layer = ABOVE_MOB_LAYER
	attacked_sound = list('sound/combat/hits/onmetal/metalimpact (1).ogg','sound/combat/hits/onmetal/metalimpact (2).ogg')
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	buckleverb = "chain"

/obj/structure/bondage/x_pillory
	name = "x-pillory"
	desc = "A brutal restraint shaped like a cross."
	icon = 'modular_rmh/icons/obj/structures/bondage.dmi'
	icon_state = "x_pillory"
	SET_BASE_PIXEL(-16, 0)
	layer = ABOVE_MOB_LAYER

/obj/structure/bondage/gloryhole
	name = "gloryhole"
	desc = "A wooden partition with a suspicious hole."
	icon = 'modular_rmh/icons/obj/structures/bondage.dmi'
	icon_state = "gloryhole"
	density = TRUE
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	buckleverb = "position"

/obj/structure/bondage/gloryhole/post_buckle_mob(mob/living/M)
	. = ..()
	M.set_mob_offsets("bed_buckle", _x = 0, _y = 16)

/obj/structure/bondage/gloryhole/post_unbuckle_mob(mob/living/M)
	. = ..()
	M.reset_offsets("bed_buckle")

/obj/structure/bondage/torture_table
	name = "torture table"
	desc = "A cruel table meant for restraining captives."
	icon = 'modular_rmh/icons/obj/structures/tort_table.dmi'
	icon_state = "tort_table"
	SET_BASE_PIXEL(-16, 0)
	layer = TABLE_LAYER
	plane = GAME_PLANE
	buckle_lying = 90
	max_integrity = 250
	debris = list(/obj/item/natural/wood/plank = 1)
	var/buckle_offset_y = 6

/obj/structure/bondage/torture_table/post_buckle_mob(mob/living/M)
	. = ..()
	M.set_mob_offsets("bed_buckle", _x = 0, _y = buckle_offset_y)

/obj/structure/bondage/torture_table/post_unbuckle_mob(mob/living/M)
	. = ..()
	M.reset_offsets("bed_buckle")

/obj/structure/bondage/torture_table/lever
	name = "torture table lever"
	desc = "A torture table fitted with a lever."
	icon_state = "tort_table_lever"
	SET_BASE_PIXEL(-16, 0)

	var/damage_per_second = 1
	var/dislocate_delay = 3 SECONDS
	var/dismember_delay = 3 SECONDS
	var/torture_active = FALSE
	var/list/torture_targets
	var/mob/living/last_operator
	var/lever_icon_state

/obj/structure/bondage/torture_table/lever/Initialize(mapload)
	. = ..()
	torture_targets = list()
	lever_icon_state = initial(icon_state)

/obj/structure/bondage/torture_table/lever/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/bondage/torture_table/lever/attack_hand_secondary(mob/living/user, params)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(torture_active)
		to_chat(user, span_warning("The lever is already engaged."))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(!has_buckled_mobs())
		to_chat(user, span_warning("There's no one strapped onto [src]."))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	user.changeNext_move(CLICK_CD_MELEE)
	last_operator = user
	torture_active = TRUE
	user.visible_message(span_warning("[user] pulls the lever on [src]!"), span_warning("I pull the lever on [src]!"))
	playsound(get_turf(src), 'sound/foley/lever.ogg', 80, TRUE)

	for(var/mob/living/M in buckled_mobs)
		if(isnull(torture_targets[M]))
			torture_targets[M] = TORTURE_STAGE_DAMAGE

	START_PROCESSING(SSobj, src)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/bondage/torture_table/lever/post_buckle_mob(mob/living/M)
	. = ..()
	if(torture_active)
		torture_targets[M] = TORTURE_STAGE_DAMAGE

/obj/structure/bondage/torture_table/lever/post_unbuckle_mob(mob/living/M)
	. = ..()
	torture_targets[M] = null
	if(!has_buckled_mobs())
		torture_active = FALSE
		icon_state = lever_icon_state
		STOP_PROCESSING(SSobj, src)

/obj/structure/bondage/torture_table/lever/process(delta_time)
	if(!torture_active)
		if(!has_buckled_mobs())
			STOP_PROCESSING(SSobj, src)
		return

	var/any_active = FALSE
	var/static/list/limb_zones = list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG)

	for(var/mob/living/M in buckled_mobs)
		if(QDELETED(M))
			continue
		if(isnull(torture_targets[M]))
			torture_targets[M] = TORTURE_STAGE_DAMAGE

		var/stage = torture_targets[M]
		if(stage == TORTURE_STAGE_DAMAGE)
			any_active = TRUE
			var/all_max = TRUE
			var/has_limb = FALSE

			for(var/zone in limb_zones)
				var/obj/item/bodypart/limb = M.get_bodypart(zone)
				if(!limb)
					continue
				has_limb = TRUE
				if(limb.brute_dam < limb.max_damage)
					var/damage_to_apply = min(limb.max_damage - limb.brute_dam, damage_per_second * delta_time)
					if(damage_to_apply > 0)
						M.apply_damage(damage_to_apply, BRUTE, zone)
				if(limb.brute_dam < limb.max_damage)
					all_max = FALSE

			if(!has_limb)
				torture_targets[M] = TORTURE_STAGE_DONE
			else if(all_max)
				torture_targets[M] = TORTURE_STAGE_WAIT_DISLOCATE
				addtimer(CALLBACK(src, PROC_REF(dislocate_limbs), M), dislocate_delay)
		else if(stage == TORTURE_STAGE_WAIT_DISLOCATE || stage == TORTURE_STAGE_WAIT_DISMEMBER)
			any_active = TRUE

	if(!any_active)
		torture_active = FALSE
		icon_state = lever_icon_state
		STOP_PROCESSING(SSobj, src)

/obj/structure/bondage/torture_table/lever/proc/dislocate_limbs(mob/living/M)
	if(QDELETED(M) || M.buckled != src)
		return
	if(torture_targets[M] != TORTURE_STAGE_WAIT_DISLOCATE)
		return

	var/static/list/limb_zones = list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG)
	var/has_limb = FALSE

	for(var/zone in limb_zones)
		var/obj/item/bodypart/limb = M.get_bodypart(zone)
		if(!limb)
			continue
		has_limb = TRUE
		if(!limb.has_wound(/datum/wound/dislocation))
			limb.add_wound(/datum/wound/dislocation)

	if(!has_limb)
		torture_targets[M] = TORTURE_STAGE_DONE
		return

	torture_targets[M] = TORTURE_STAGE_WAIT_DISMEMBER
	addtimer(CALLBACK(src, PROC_REF(dismember_limbs), M), dismember_delay)

/obj/structure/bondage/torture_table/lever/proc/dismember_limbs(mob/living/M)
	if(QDELETED(M) || M.buckled != src)
		return
	if(torture_targets[M] != TORTURE_STAGE_WAIT_DISMEMBER)
		return

	var/static/list/limb_zones = list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG)

	for(var/zone in limb_zones)
		var/obj/item/bodypart/limb = M.get_bodypart(zone)
		if(!limb)
			continue
		limb.dismember(BRUTE, BCLASS_CHOP, last_operator, limb.body_zone)

	torture_targets[M] = TORTURE_STAGE_DONE

#undef TORTURE_STAGE_DAMAGE
#undef TORTURE_STAGE_WAIT_DISLOCATE
#undef TORTURE_STAGE_WAIT_DISMEMBER
#undef TORTURE_STAGE_DONE
