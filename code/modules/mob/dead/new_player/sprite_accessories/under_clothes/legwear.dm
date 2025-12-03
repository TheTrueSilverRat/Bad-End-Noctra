
/datum/sprite_accessory/legwear
	abstract_type = /datum/sprite_accessory/legwear
	icon = 'modular/icons/obj/items/clothes/on_mob/stockings.dmi'
	color_key_name = "Legwear"
	layer = LEGWEAR_LAYER
	var/legwear_type
	var/hides_breasts = FALSE

/datum/sprite_accessory/legwear/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/tag = icon_state
	pixel_y = -1
	if(owner.gender == FEMALE)
		tag = tag + "_f"
		pixel_y = 0
	if(is_species(owner,/datum/species/dwarf))
		tag = tag + "_dwarf"
		pixel_y = 0
	if(is_species(owner,/datum/species/elf) && owner.gender == MALE)
		tag = tag + "_f"
		pixel_y = -2
	return tag

/datum/sprite_accessory/legwear/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_PANTS)

/datum/sprite_accessory/legwear/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return is_human_part_visible(owner, HIDEJUMPSUIT)

/datum/sprite_accessory/legwear/stockings
	name = "stockings"
	icon_state = "stockings"
	legwear_type = /obj/item/legwears

/datum/sprite_accessory/legwear/stockings/silk
	name = "silk stockings"
	icon_state = "silk"
	legwear_type = /obj/item/legwears/silk

/datum/sprite_accessory/legwear/stockings/fishnet
	name = "fishnet stockings"
	icon_state = "fishnet"
	legwear_type = /obj/item/legwears/fishnet

/datum/sprite_accessory/legwear/stockings/thigh
	name = "Thigh highs"
	icon_state = "thigh"
	legwear_type = /obj/item/legwears/thigh
