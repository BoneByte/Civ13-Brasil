
/obj/map_metadata/operation_falcon
	ID = MAP_OPERATION_FALCON
	title = "Operation Falcon"
	lobby_icon = "icons/lobby/operation_falcon.png"
	no_winner = "The battle for the city is still going on."
	caribbean_blocking_area_types = list(/area/caribbean/no_mans_land/invisible_wall,/area/caribbean/no_mans_land/invisible_wall/one,/area/caribbean/no_mans_land/invisible_wall/two)
	respawn_delay = 600

	faction_organization = list(
		DUTCH,
		RUSSIAN)

	roundend_condition_sides = list(
		list(DUTCH) = /area/caribbean/german/reichstag/roof/objective,
		list(RUSSIAN) = /area/caribbean/german/reichstag/roof/objective,
		)
	age = "2017"
	ordinal_age = 8
	faction_distribution_coeffs = list(DUTCH = 0.5, RUSSIAN = 0.5)
	battle_name = "Operation Falcon"
	mission_start_message = "<font size=4>Both factions have <b>10 minutes</b> to prepare before the ceasefire ends!</font><br><big>Points are added to each team for each minute they control the <b>Radio Post, North City, Factory and Lumber Company</b>.<br>First team to reach <b>70</b> points wins!</font>"
	faction1 = DUTCH
	faction2 = RUSSIAN
	valid_weather_types = list(WEATHER_NONE, WEATHER_WET, WEATHER_EXTREME)
	songs = list(
		"Doe Maar - The Bomb (De Bom):1" = "sound/music/de_bom.ogg",)
	gamemode = "Area Control"
	ambience = list('sound/ambience/battle1.ogg')
	var/rus_points = 0
	var/dutch_points = 0
	var/win_points = 70 // Amount of points needed to win

	var/faction1_flag = "netherlands"
	var/faction2_flag = "russian"

	var/a1_control = "nobody"
	var/a1_name = "Radio Post"

	var/a2_control = "nobody"
	var/a2_name = "North City"

	var/a3_control = "nobody"
	var/a3_name = "Factory"

	var/a4_control = "nobody"
	var/a4_name = "Lumber Company"
	grace_wall_timer = 10 MINUTES
	no_hardcore = TRUE

/obj/map_metadata/operation_falcon/New()
	..()
	spawn(3000)
		points_check()
		spawn(rand(500,800))
			jet_flyby()

/obj/map_metadata/operation_falcon/job_enabled_specialcheck(var/datum/job/J)
	..()
	if (J.is_operation_falcon == TRUE)
		. = TRUE
	else
		. = FALSE

/obj/map_metadata/operation_falcon/roundend_condition_def2name(define)
	..()
	switch (define)
		if (DUTCH)
			return "Dutch"
		if (RUSSIAN)
			return "Russian"
/obj/map_metadata/operation_falcon/roundend_condition_def2army(define)
	..()
	switch (define)
		if (DUTCH)
			return "Dutch Royal Army"
		if (RUSSIAN)
			return "Russian Armed Forces"

/obj/map_metadata/operation_falcon/army2name(army)
	..()
	switch (army)
		if ("Dutch Royal Army")
			return "Dutch"
		if ("Russian Armed Forces")
			return "Russian"


/obj/map_metadata/operation_falcon/cross_message(faction)
	return "<font size = 4>Operation Falcon has begun!</font>"

/obj/map_metadata/operation_falcon/reverse_cross_message(faction)
	return "<span class = 'userdanger'>Both teams may no longer cross the invisible wall!</span>"

/obj/map_metadata/operation_falcon/proc/points_check()
	if (processes.ticker.playtime_elapsed > 3000)
		var/c1 = 0
		var/c2 = 0
		var/cust_color = "white"
		for (var/mob/living/human/H in player_list)
			var/area/temp_area = get_area(H)
			if (istype(temp_area, /area/caribbean/no_mans_land/capturable/one))
				if (H.faction_text == "DUTCH" && H.stat == CONSCIOUS)
					c1++
				else if (H.faction_text == "RUSSIAN" && H.stat == CONSCIOUS)
					c2++
		if (c1 == c2 && c1 != 0)
			a1_control = "none"
			cust_color = "white"
		else if (c1 > c2)
			a1_control = "Dutch Royal Army"
			cust_color = "#FFA500"
		else if (c2 > c1)
			a1_control = "Russian Armed Forces"
			cust_color = "red"
		if (a1_control != "none")
			if (a1_control == "Russian Armed Forces")
				cust_color = "red"
				rus_points++
			else if (a1_control == "Dutch Royal Army")
				cust_color = "#FFA500"
				dutch_points++
			else
				cust_color = "white"
			world << "<big><b>[a1_name]</b>: <font color='[cust_color]'>[a1_control]</font></big>"
		else
			world << "<big><b>[a1_name]</b>: Nobody</big>"
		c1 = 0
		c2 = 0
		for (var/mob/living/human/H in player_list)
			var/area/temp_area = get_area(H)
			if (istype(temp_area, /area/caribbean/no_mans_land/capturable/two))
				if (H.faction_text == "DUTCH" && H.stat == CONSCIOUS)
					c1++
				else if (H.faction_text == "RUSSIAN" && H.stat == CONSCIOUS)
					c2++
		if (c1 == c2 && c1 != 0)
			a2_control = "none"
			cust_color = "white"
		else if (c1 > c2)
			a2_control = "Dutch Royal Army"
			cust_color = "#FFA500"
		else if (c2 > c1)
			a2_control = "Russian Armed Forces"
			cust_color = "red"
		if (a2_control != "none")
			if (a2_control == "Russian Armed Forces")
				cust_color = "red"
				rus_points++
			else if (a2_control == "Dutch Royal Army")
				cust_color = "#FFA500"
				dutch_points++
			else
				cust_color = "white"
			world << "<big><b>[a2_name]</b>: <font color='[cust_color]'>[a2_control]</font></big>"
		else
			world << "<big><b>[a2_name]</b>: Nobody</big>"
		c1 = 0
		c2 = 0
		for (var/mob/living/human/H in player_list)
			var/area/temp_area = get_area(H)
			if (istype(temp_area, /area/caribbean/no_mans_land/capturable/three))
				if (H.faction_text == "DUTCH" && H.stat == CONSCIOUS)
					c1++
				else if (H.faction_text == "RUSSIAN" && H.stat == CONSCIOUS)
					c2++
		if (c1 == c2 && c1 != 0)
			a3_control = "none"
			cust_color = "white"
		else if (c1 > c2)
			a3_control = "Dutch Royal Army"
			cust_color = "#FFA500"
		else if (c2 > c1)
			a3_control = "Russian Armed Forces"
			cust_color = "red"
		if (a3_control != "none")
			if (a3_control == "Russian Armed Forces")
				cust_color = "red"
				rus_points++
			else if (a3_control == "Dutch Royal Army")
				cust_color = "#FFA500"
				dutch_points++
			else
				cust_color = "white"
			world << "<big><b>[a3_name]</b>: <font color='[cust_color]'>[a3_control]</font></big>"
		else
			world << "<big><b>[a3_name]</b>: Nobody</big>"
		c1 = 0
		c2 = 0
		for (var/mob/living/human/H in player_list)
			var/area/temp_area = get_area(H)
			if (istype(temp_area, /area/caribbean/no_mans_land/capturable/four))
				if (H.faction_text == "DUTCH" && H.stat == CONSCIOUS)
					c1++
				else if (H.faction_text == "RUSSIAN" && H.stat == CONSCIOUS)
					c2++
		if (c1 == c2 && c1 != 0)
			a4_control = "none"
			cust_color = "white"
		else if (c1 > c2)
			a4_control = "Dutch Royal Army"
			cust_color = "#FFA500"
		else if (c2 > c1)
			a4_control = "Russian Armed Forces"
			cust_color = "red"
		if (a4_control != "none")
			if (a4_control == "Russian Armed Forces")
				cust_color = "red"
				rus_points++
			else if (a4_control == "Dutch Royal Army")
				cust_color = "#FFA500"
				dutch_points++
			else
				cust_color = "white"
			world << "<big><b>[a4_name]</b>: <font color='[cust_color]'>[a4_control]</font></big>"
		else
			world << "<big><b>[a4_name]</b>: Nobody</big>"

	switch (a1_control)
		if ("Dutch Royal Army")
			for (var/obj/structure/flag/objective/one/F in world)
				F.icon_state = "[faction1_flag]"
		if ("Russian Armed Forces")
			for (var/obj/structure/flag/objective/one/F in world)
				F.icon_state = "[faction2_flag]"
		else
			for (var/obj/structure/flag/objective/one/F in world)
				F.icon_state = "white"
	switch (a2_control)
		if ("Dutch Royal Army")
			for (var/obj/structure/flag/objective/two/F in world)
				F.icon_state = "[faction1_flag]"
		if ("Russian Armed Forces")
			for (var/obj/structure/flag/objective/two/F in world)
				F.icon_state = "[faction2_flag]"
		else
			for (var/obj/structure/flag/objective/two/F in world)
				F.icon_state = "white"
	switch (a3_control)
		if ("Dutch Royal Army")
			for (var/obj/structure/flag/objective/three/F in world)
				F.icon_state = "[faction1_flag]"
		if ("Russian Armed Forces")
			for (var/obj/structure/flag/objective/three/F in world)
				F.icon_state = "[faction2_flag]"
		else
			for (var/obj/structure/flag/objective/three/F in world)
				F.icon_state = "white"
	switch (a4_control)
		if ("Dutch Royal Army")
			for (var/obj/structure/flag/objective/four/F in world)
				F.icon_state = "[faction1_flag]"
		if ("Russian Armed Forces")
			for (var/obj/structure/flag/objective/four/F in world)
				F.icon_state = "[faction2_flag]"
		else
			for (var/obj/structure/flag/objective/four/F in world)
				F.icon_state = "white"

	spawn(600)
		points_check()
		spawn(5)
			world << "<big><b>Pontos Atuais:</big></b>"
			world << "<big>Dutch: [dutch_points]</big>"
			world << "<big>Russian: [rus_points]</big>"

/obj/map_metadata/operation_falcon/update_win_condition()
	if (processes.ticker.playtime_elapsed > 3000)
		if (rus_points < win_points && dutch_points < win_points)
			return TRUE
		if (rus_points >= win_points && rus_points > dutch_points)
			if (win_condition_spam_check)
				return FALSE
			ticker.finished = TRUE
			var/message = "The <b>Russians</b> have reached [rus_points] points and claimed victory in Operation Falcon!"
			world << "<font size = 4><span class = 'notice'>[message]</span></font>"
			show_global_battle_report(null)
			win_condition_spam_check = TRUE
			return FALSE
		if (dutch_points >= win_points && dutch_points > rus_points)
			if (win_condition_spam_check)
				return FALSE
			ticker.finished = TRUE
			var/message = "The <b>Dutch</b> have reached [dutch_points] points and claimed victory in Operation Falcon!"
			world << "<font size = 4><span class = 'notice'>[message]</span></font>"
			show_global_battle_report(null)
			win_condition_spam_check = TRUE
			return FALSE
	return TRUE

/obj/map_metadata/operation_falcon/check_caribbean_block(var/mob/living/human/H, var/turf/T)
	if (!istype(H) || !istype(T))
		return FALSE
	var/area/A = get_area(T)
	if (istype(A, /area/caribbean/no_mans_land/invisible_wall))
		if (istype(A, /area/caribbean/no_mans_land/invisible_wall/two))
			if (H.faction_text == faction1)
				return TRUE
		else if (istype(A, /area/caribbean/no_mans_land/invisible_wall/one))
			if (H.faction_text == faction2)
				return TRUE
		else
			return !faction1_can_cross_blocks()
	return FALSE

/obj/map_metadata/operation_falcon/proc/jet_flyby()
	var/flyby_type = rand(1,4)
	switch (flyby_type)
		if (1)
			var/direction = rand(1,3)
			var/sound/uploaded_sound
			switch (direction)
				if (1)
					uploaded_sound = sound('sound/effects/aircraft/f16_left-right.ogg', repeat = FALSE, wait = TRUE, channel = 777)
				if (2)
					uploaded_sound = sound('sound/effects/aircraft/f16_center.ogg', repeat = FALSE, wait = TRUE, channel = 777)
				if (3)
					uploaded_sound = sound('sound/effects/aircraft/f16_right-left.ogg', repeat = FALSE, wait = TRUE, channel = 777)
			uploaded_sound.priority = 250
			for (var/mob/M in player_list)
				if (!new_player_mob_list.Find(M))
					M << SPAN_NOTICE("<font size=3>The air rumbles as a F-16 flies overhead.</font>")
					M.client << uploaded_sound
		if(2)
			var/direction = rand(1,3)
			var/sound/uploaded_sound
			switch (direction)
				if (1)
					uploaded_sound = sound('sound/effects/aircraft/su25_left-right.ogg', repeat = FALSE, wait = TRUE, channel = 777)
				if (2)
					uploaded_sound = sound('sound/effects/aircraft/su25_center.ogg', repeat = FALSE, wait = TRUE, channel = 777)
				if (3)
					uploaded_sound = sound('sound/effects/aircraft/su25_right-left.ogg', repeat = FALSE, wait = TRUE, channel = 777)
			uploaded_sound.priority = 250
			for (var/mob/M in player_list)
				if (!new_player_mob_list.Find(M))
					M << SPAN_NOTICE("<font size=3>The air rumbles as a Su-25 flies overhead.</font>")
					M.client << uploaded_sound
		if(3)
			var/direction = rand(1,2)
			var/sound/uploaded_sound1
			var/sound/uploaded_sound2
			switch (direction)
				if (1)
					uploaded_sound1 = sound('sound/effects/aircraft/su25_left-right.ogg', repeat = FALSE, wait = TRUE, channel = 777)
					if (prob(80))
						uploaded_sound2 = sound('sound/effects/aircraft/f16_left-right_firing.ogg', repeat = FALSE, wait = TRUE, channel = 776)
					else
						uploaded_sound2 = sound('sound/effects/aircraft/f16_left-right.ogg', repeat = FALSE, wait = TRUE, channel = 776)
				if (2)
					uploaded_sound1 = sound('sound/effects/aircraft/su25_right-left.ogg', repeat = FALSE, wait = TRUE, channel = 777)
					if (prob(80))
						uploaded_sound2 = sound('sound/effects/aircraft/f16_right-left_firing.ogg', repeat = FALSE, wait = TRUE, channel = 776)
					else
						uploaded_sound2 = sound('sound/effects/aircraft/f16_right-left.ogg', repeat = FALSE, wait = TRUE, channel = 776)
			uploaded_sound1.priority = 250
			uploaded_sound2.priority = 250
			for (var/mob/M in player_list)
				if (!new_player_mob_list.Find(M))
					M << SPAN_DANGER("<font size=4>The air lights up as a Su-25 and a pursuing F-16 fly overhead.</font>")
					M.client << uploaded_sound1
					spawn(5 SECONDS)
						M.client << uploaded_sound2

	spawn(rand(1600,4000))
		jet_flyby()

////////MAP SPECIFIC OBJECTS////////

/obj/structure/computer/nopower/platoontracker
	name = "Military Asset Tracking System"
	desc = "A satellite-based system, allowing realtime tracking of your troops."
	icon = 'icons/obj/device.dmi'
	icon_state = "tracking"
	powered = TRUE
	powerneeded = FALSE
	anchored = TRUE
	density = TRUE
	operatingsystem = "unga OS 94"
	New()
		..()
		programs += new/datum/program/platoontracker