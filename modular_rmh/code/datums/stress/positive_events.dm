/datum/stress_event/allure
	timer = 2 MINUTES
	stress_change = -2
	desc = span_green("They have quite a tempting appeal!")

/datum/stress_event/allure_self
	timer = 30 SECONDS
	stress_change = 0
	desc = "I have quite a tempting appeal!"

/datum/status_effect/buff/darkling_darkly
	id = "Darkling"
	alert_type =  /atom/movable/screen/alert/status_effect/buff/darkling_darkly
	effectedstats = list("perception" = 1)
	duration = 5 SECONDS

/atom/movable/screen/alert/status_effect/buff/darkling_darkly
	name = "Darkling"
	desc = "You are at home in the dark. Unbothered."
	icon_state = "stressg"
