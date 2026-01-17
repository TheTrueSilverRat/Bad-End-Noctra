//By Vide Noir https://github.com/EaglePhntm.
//container organ that can refill self through nutrients etc.
/obj/item/organ/genitals/filling_organ
	name = "self filling organ"

	//faster healing cause those will be rippin alot
	healing_factor = STANDARD_ORGAN_HEALING*3
	decay_factor = STANDARD_ORGAN_DECAY

	//self generating liquid stuff, dont use with absorbing stuff
	var/storage_per_size = 100 //added per organ size
	var/datum/reagent/reagent_to_make = /datum/reagent/consumable/nutriment //naturally generated reagent
	var/refilling = FALSE //slowly refills when not hungry
	var/reagent_generate_rate = 3 //with refilling
	var/hungerhelp = FALSE //if refilling, absorbs reagent_to_make as nutrients if hungry. Conversion is to nutrients direct even if you brew poison in there.
	var/uses_nutrient = TRUE //incase someone for some reason wanna make an OP paradox i guess.
	var/organ_sizeable = FALSE //if organ can be resized in prefs etc, SET THIS RIGHT, IT'S IMPORTANT.
	var/max_reagents = 30 //use if organ not sizeable, it auto calculates with sizeable organs and uses it as a base.
	var/startsfilled = FALSE

	//absorbing etc content liquid stuff, non self generated.
	var/absorbing = FALSE //absorbs liquids within slowly. Wont absorb reagent_to_make type, refilling and hungerhelp are irrelevant to this.
	var/absorbrate = 1 //refilling and hungerhelp are irrelevant to this, each life tick. NO LESS THAN 1 DIGESTS RIGHT.
	var/absorbmult = 1 //free gains
	var/driprate = 0.1
	var/spiller = FALSE //toggles if it will spill its stored_items when not plugged.
	var/blocker = ITEM_SLOT_SHIRT //pick an item slot
	var/additional_blocker
	var/max_femcum = 0
	var/processspeed = 5 SECONDS//will apply the said seconds cooldown each time before any spill or absorb happens.
	var/bloatable = FALSE //will it give bloat debuffs when filled, not good to use with refilling organs.

	//pregnancy vars
	var/fertility = FALSE //can it be impregnated
	var/pregnant = FALSE // is it pregnant

	//misc
	var/list/altnames = list("bugged place", "bugged organ") //used in thought messages.
	var/last_size_alert = 0

	COOLDOWN_DECLARE(liquidcd)

/obj/item/organ/genitals/filling_organ/Insert(mob/living/carbon/M, special, drop_if_replaced) //update size cap n shit on insert
	. = ..()
	if(organ_sizeable)
		max_reagents = storage_per_size + (storage_per_size * organ_size)
	create_reagents(max_reagents)
	if(!refilling && M.mind) //mind check so goblins etc have milk on spawn.
		startsfilled = FALSE
	if(special && startsfilled) // won't fill the organ if you insert this organ via surgery
		reagents.add_reagent(reagent_to_make, reagents.maximum_volume)

/obj/item/organ/genitals/filling_organ/on_life()
	var/mob/living/carbon/human/H = owner

	..()

	//get stored items
	var/list/stored_items = list()
	SEND_SIGNAL(H, COMSIG_HOLE_RETURN_ITEM_LIST_SINGLE, stored_items, slot)
	//get arousal data
	var/list/arousal_data = list()
	SEND_SIGNAL(H, COMSIG_SEX_GET_AROUSAL, arousal_data)
	//updates size caps
	var/captarget
	if(!isanimal(H))
		if(H.mind && organ_sizeable)
			captarget = storage_per_size + (storage_per_size * organ_size) // Updates the max_reagents in case the organ size changes
		else if(H.mind) //like vaginas, non sizeable organs
			captarget = max_reagents
		if(fertility && pregnant) //preg size reduce
			captarget *= 0.5
		if(length(stored_items))
			for(var/obj/item/thing as anything in stored_items)
				if(thing.type != /obj/item/dildo/plug) //plugs wont take space as they are especially for this.
					captarget -= thing.w_class*10 //anything else reduce space inside
		if(damage)
			captarget = max(0, captarget-damage*10)
		captarget = max(0, captarget)
		if(captarget != reagents.maximum_volume)
			reagents.maximum_volume = captarget
			if(H.has_quirk(/datum/quirk/selfawaregeni) && world.time > last_size_alert + 12 SECONDS)
				last_size_alert = world.time
				to_chat(H, span_blue("My [pick(altnames)] hold a different amount now."))

	//debuff checks
	if(bloatable) //its bloatable.
		if(reagents.total_volume > (reagents.maximum_volume/3)) //more than 1/3 full, light bloat.
			if(!reagents.total_volume > (reagents.maximum_volume/2)) //more than half full, heavy bloat.
				if(!owner.has_status_effect(/datum/status_effect/debuff/bloatone) && !owner.has_status_effect(/datum/status_effect/debuff/bloattwo))
					owner.apply_status_effect(/datum/status_effect/debuff/bloatone)
			else
				if(!owner.has_status_effect(/datum/status_effect/debuff/bloattwo))
					owner.apply_status_effect(/datum/status_effect/debuff/bloattwo)

	if(damage > low_threshold)
		if(prob(3))
			to_chat(H, span_warning("My [pick(altnames)] aches..."))
		if(prob(15) && damage > high_threshold) //internal bleeding ig
			owner.transfer_blood_to(src, round(damage/15), TRUE)
			to_chat(H, span_boldwarning("My [pick(altnames)] BLEED..!"))

	if(reagents.maximum_volume < reagents.total_volume) //overflow
		owner.visible_message(span_info("[owner]'s [pick(altnames)] spill some of it's stored_items due to damage!"),span_info("My [pick(altnames)] spill some of it's stored_items due to damage!"),span_unconscious("I hear a splash."))
		var/turf/ownerloc = owner.loc
		ownerloc.add_liquid_from_reagents(reagents, amount = reagents.maximum_volume-reagents.total_volume)
		reagents.remove_all(reagents.maximum_volume-reagents.total_volume)

	// modify nutrition to generate reagents
	if(istype(src, /obj/item/organ/genitals/filling_organ/vagina)) //generate lube from arousal
		if(arousal_data["arousal"] > VISIBLE_AROUSAL_THRESHOLD)
			refilling = TRUE
		else
			refilling = FALSE
		var/check_volume = 0
		if(reagent_to_make in reagents.reagent_list)
			check_volume = reagents.reagent_list[reagent_to_make].volume
		else
			check_volume = reagents.total_volume
		if((check_volume < max_femcum) && refilling)
			var/max_restore = reagent_generate_rate * 2
			var/restore_amount = min(max_restore, reagents.maximum_volume - max_femcum)
			reagents.add_reagent(reagent_to_make, restore_amount)
	else
		if(!damage) //cant regen or consume while damaged.
			if(!HAS_TRAIT(src, TRAIT_NOHUNGER)) //if not nohunger
				if(owner.nutrition < (NUTRITION_LEVEL_HUNGRY - 25) && hungerhelp) //consumes if hungry and uses nutrient, putting below the limit so person dont get stress message spam.
					var/remove_amount = min(reagent_generate_rate, reagents.total_volume)
					if(uses_nutrient) //add nutrient
						owner.adjust_nutrition(remove_amount) //since hunger factor is so tiny compared to the nutrition levels it has to fill
					reagents.remove_reagent(reagent_to_make, (remove_amount*4)) //we consume our own reagents for food less efficently, allowing running out (may undo this multiplier later.)
				else
					if((reagents.total_volume < reagents.maximum_volume) && refilling && owner.nutrition > (NUTRITION_LEVEL_FED + 25)) //if organ is not full.
						var/max_restore = owner.nutrition > (NUTRITION_LEVEL_WELL_FED) ? reagent_generate_rate * 2 : reagent_generate_rate
						var/restore_amount = min(max_restore, reagents.maximum_volume - reagents.total_volume) // amount restored if fed, capped by reagents.maximum_volume
						if(uses_nutrient) //consume nutrient
							owner.adjust_nutrition(-restore_amount)
						reagents.add_reagent(reagent_to_make, restore_amount)
			else //if nohunger, should just regenerate stuff for free no matter what, if refilling.
				if((reagents.total_volume < reagents.maximum_volume) && refilling)
					var/max_restore = reagent_generate_rate * 2
					var/restore_amount = min(max_restore, reagents.maximum_volume - reagents.total_volume)
					reagents.add_reagent(reagent_to_make, restore_amount)

	if(!COOLDOWN_FINISHED(src, liquidcd))
		return
	if(reagents.total_volume && absorbing) //slowly inject to your blood if they have reagents. Will not work if refilling because i cant properly seperate the reagents for which to keep which to dump.
		reagents.trans_to(owner, absorbrate, absorbmult, TRUE, FALSE)
	if(!length(stored_items)) //if nothing is plugging the hole, stuff will drip out.
		var/tempdriprate = driprate
		if((reagents.total_volume && spiller) || (reagents.total_volume > reagents.maximum_volume)) //spiller or above it's capacity to leak.
			var/obj/item/clothing/blockingitem = H.mob_slot_wearing(blocker)
			if(!isnull(additional_blocker))
				if(H.underwear)
					blockingitem = H.underwear
			if(blockingitem && !blockingitem.genital_access) //we aint dripping a drop.
			/*
				tempdriprate = 0.1 //if worn slot cover it, drip nearly nothing.
				if(owner.has_quirk(/datum/quirk/selfawaregeni))
					if(prob(5))
						to_chat(H, pick(span_info("A little bit of [english_list(reagents.reagent_list)] drips from my [pick(altnames)] to my [blockingitem.name]..."),
						span_info("Some liquid drips from my [pick(altnames)] to my [blockingitem.name]."),
						span_info("My [pick(altnames)] spills some liquid to my [blockingitem.name]."),
						span_info("Some [english_list(reagents.reagent_list)] drips from my [pick(altnames)] to my [blockingitem.name].")))
			*/
			else //we drippin
				if(prob(5)) //with selfawaregeni quirk you got some chance to see what type of liquid is dripping from you.
					//if(owner.has_quirk(/datum/quirk/selfawaregeni)) //we do have sensitiveness
					to_chat(H, pick(span_info("A little bit of [english_list(reagents.reagent_list)] drips from my [pick(altnames)]..."),
					span_info("Some liquid drips from my [pick(altnames)]."),
					span_info("My [pick(altnames)] spills some liquid."),
					span_info("Some [english_list(reagents.reagent_list)] drips from my [pick(altnames)].")))
				var/obj/item/reagent_containers/the_bottle
				if((owner.mobility_flags & MOBILITY_STAND))
					for(var/obj/item/reagent_containers/bottle in owner.loc) //having a bottle under us speed up leak greatly and transfer the leak there instead.
						if(bottle.reagents.total_volume >= bottle.reagents.maximum_volume)
							continue
						if(bottle.reagents.flags & REFILLABLE)
							the_bottle = bottle
							break
				if(!the_bottle) //no bottle so just spill
					var/turf/ownerloc = owner.loc
					ownerloc.add_liquid_from_reagents(reagents, amount = tempdriprate)
					reagents.remove_all(tempdriprate)
				else
					tempdriprate *= 50 //since default values are basically decimals.
					reagents.trans_to(the_bottle, min(tempdriprate))
					to_chat(owner, span_info("I collect the fluids dripping from me in \the [the_bottle]."))
	else //we got something in stored_items
		for(var/obj/item/reagent_containers/contentitem in stored_items) //we got a bottle inside
			if(contentitem.reagents && contentitem.spillable)
				/* lets mix things up
				if(refilling && reagents.total_volume) //producers fill bottles, others get filled.
					reagents.trans_to(reagents, rand(4,8))
				else
					if(contentitem.reagents.total_volume)
						contentitem.reagents.trans_to(reagents, rand(4,8))
				*/
				if(contentitem.reagents.total_volume) //stir the pot
					contentitem.reagents.trans_to(reagents, rand(4,8))
				if(refilling && reagents.total_volume)
					reagents.trans_to(contentitem, rand(4,8))

	COOLDOWN_START(src, liquidcd, processspeed)

/obj/item/organ/genitals/filling_organ/proc/organ_jumped()
	var/mob/living/carbon/human/H = owner
	//var/obj/item/organ/genitals/filling_organ/forgan = src

	var/stealth = H.get_skill_level(/datum/skill/misc/sneaking)
	var/keepinsidechance = CLAMP((rand(25,100) - (stealth * 20)),0,100) //basically cant lose your item if you have 5 stealth.
	if(reagents.total_volume > reagents.maximum_volume / 2 && spiller && prob(keepinsidechance)) //if you have more than half full spiller organ.
		owner.visible_message(span_info("[owner]'s [pick(altnames)] spill some of it's stored_items with the pressure on it!"),span_info("My [pick(altnames)] spill some of it's stored_items with the pressure on it! [keepinsidechance]%"),span_unconscious("I hear a splash."))
		chem_splash(owner, 3, reagents)
		playsound(owner, 'sound/foley/waterenter.ogg', 15)

	/*if(!isanimal(H) && H.mind)
		var/list/stored_items = list()
		SEND_SIGNAL(H, COMSIG_HOLE_RETURN_ITEM_LIST_SINGLE, stored_items, slot)
		if(length(stored_items))
			for(var/obj/item/forganstored_items as anything in forgan.stored_items)
				if(!istype(forganstored_items, /obj/item/dildo)) //dildo keeps stuff in even if you have no pants ig
					var/obj/item/clothing/blockingitem = get_organ_blocker(H, zone)
					if(!blockingitem || blockingitem.genital_access) //checks if the item has genital_access, like skirts, if not, it blocks the thing from flying off.
						if(prob(keepinsidechance))
							if(H.client?.prefs.showrolls)
								to_chat(H, span_alert("Damn! I lose my [pick(altnames)]'s grip on [english_list(stored_items)]! [keepinsidechance]%"))
							else
								to_chat(H, span_alert("Damn! I lose my [pick(altnames)]'s grip on [english_list(stored_items)]!"))
							playsound(H, 'sound/misc/mat/insert (1).ogg', 20, TRUE, -2, ignore_walls = FALSE)
							forganstored_items.doMove(get_turf(H))
							forgan.stored_items -= forganstored_items
							var/yeet = rand(4)
							var/turf/selectedturf = pick(orange(H, yeet)) //object flies off the hole with pressure at a random turf, funny.
							forganstored_items.throw_at(selectedturf, yeet, 2)
						else
							if(H.client?.prefs.showrolls)
								if(keepinsidechance < 10)
									to_chat(H, span_blue("I easily maintain my [pick(altnames)]'s grip on [english_list(stored_items)]. [keepinsidechance]%"))
								else
									to_chat(H, span_info("Phew, I maintain my [pick(altnames)]'s grip on [english_list(stored_items)]. [keepinsidechance]%"))
							else
								if(keepinsidechance < 10)
									to_chat(H, span_blue("I easily maintain my [pick(altnames)]'s grip on [english_list(stored_items)]."))
								else
									to_chat(H, span_info("Phew, I maintain my [pick(altnames)]'s grip on [english_list(stored_items)]."))
				break*/

//had to make this ghetto ass shit, fucks sake
/mob/living/carbon/proc/mob_slot_wearing(zone)
	if(iscarbon(src))
		var/mob/living/carbon/human/user = src
		for(var/obj/item/clothing/equipped_item in user.get_equipped_items(include_pockets = FALSE))
			if(equipped_item.slot_flags & zone)
				return equipped_item
			else
				continue
