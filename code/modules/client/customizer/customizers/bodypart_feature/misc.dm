/datum/customizer/bodypart_feature/legwear
	name = "Legwear"
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/legwear)
	allows_disabling = TRUE
	default_disabled = TRUE

/datum/customizer_choice/bodypart_feature/legwear
	name = "Legwear"
	feature_type = /datum/bodypart_feature/legwear
	sprite_accessories = list(
		/datum/sprite_accessory/legwear/stockings,
		/datum/sprite_accessory/legwear/stockings/silk,
		/datum/sprite_accessory/legwear/stockings/fishnet,
		/datum/sprite_accessory/legwear/stockings/thigh,
		)
