/client/verb/who()
	set name = "Whom"
	set category = "OOC"

	var/msg = ""

	var/list/Lines = list()

	var/wled = 0
	if(holder)
		to_chat(src, "<span class='info'>Loading Whom, please wait...</span>")
		for(var/client/C in GLOB.clients)
			var/entry = "<span class='info'>\t[C.key]"
			if(C.holder && C.holder.fakekey)
				entry += " <i>(as [C.holder.fakekey])</i>"
			if (isnewplayer(C.mob))
				entry += " - <font color='darkgray'><b>In Lobby</b></font>"

			else
				if(ishuman(C.mob))
					var/mob/living/carbon/human/H = C.mob
					entry += " - Playing as [C.mob.real_name][H.job ? " ([H.job])" : ""]"
				else
					entry += " - Playing as [C.mob.real_name]"
				switch(C.mob.stat)
					if(UNCONSCIOUS)
						entry += " - <font color='darkgray'><b>UNCON</b></font>"
					if(DEAD)
						if(isobserver(C.mob))
							var/mob/dead/observer/O = C.mob
							if(O.started_as_observer)
								entry += " - <font color='gray'>Observing</font>"
							else
								entry += " - <b>GHOST</b>"
						else
							entry += " - <b>DEAD</b>"
				if(C.mob.mind)
					if(C.mob.mind.special_role)
						entry += " - <b><font color='red'>[C.mob.mind.special_role]</font></b>"
			if(C.whitelisted())
				wled++
				entry += "(WL)"
			entry += "</span>"
			Lines += entry
	else
		for(var/client/C in GLOB.clients)
			var/usedkey = get_display_ckey(C.key)
			Lines += "<span class='info'>[usedkey]</span>"
	for(var/line in sortList(Lines))
		msg += "[line]\n"
	msg += "<b>Players at the table:</b> [length(Lines)]"
	if(holder)
		msg += "<br><b>Whitelisted players:</b> [wled]"
	to_chat(src, msg)

