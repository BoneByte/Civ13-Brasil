/obj/map_metadata/arab_town
	ID = MAP_ARAB_TOWN
	title = "Arab Town"
	lobby_icon = "icons/lobby/modern.png"
	caribbean_blocking_area_types = list(/area/caribbean/no_mans_land/invisible_wall/desert)
	respawn_delay = 1200
	no_winner = "A operação ainda está em andamento"

	faction_organization = list(
		ARAB,
		AMERICAN)

	roundend_condition_sides = list(
		list(ARAB) = /area/caribbean/arab,
		list(AMERICAN) = /area/caribbean/british
		)
	age = "2006"
	ordinal_age = 8

	faction_distribution_coeffs = list(ARAB = 0.5, AMERICAN = 0.5)
	battle_name = "Batalha pela Cidade"
	mission_start_message = "<font size=4>O <b>Hezbollah</b> está na cidade. As tropas do <b>FDI</b> Precisam capturar o QG DO Hezbollah (Sudoeste) em menos de <b>40 minutos</b>!</font>"
	faction1 = ARAB
	faction2 = AMERICAN
	valid_weather_types = list(WEATHER_NONE, WEATHER_EXTREME)
	songs = list(
		"Al-Qussam:1" = "sound/music/alqassam.ogg",)
	artillery_count = 3
	valid_artillery = list("Explosive")

/obj/map_metadata/arab_town/job_enabled_specialcheck(var/datum/job/J)
	..()
	if (J.is_modernday == TRUE && (istype(J, /datum/job/american/idf) || istype(J, /datum/job/arab/hezbollah)))
		. = TRUE
	else
		. = FALSE

/obj/map_metadata/arab_town/faction1_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 30000 || admin_ended_all_grace_periods)

/obj/map_metadata/arab_town/faction2_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 3000 || admin_ended_all_grace_periods)


/obj/map_metadata/arab_town/roundend_condition_def2name(define)
	..()
	switch (define)
		if (ARAB)
			return "Hezbollah"
		if (AMERICAN)
			return "FDI"
/obj/map_metadata/arab_town/roundend_condition_def2army(define)
	..()
	switch (define)
		if (ARAB)
			return "Hezbollah"
		if (AMERICAN)
			return "Israelis"

/obj/map_metadata/arab_town/army2name(army)
	..()
	switch (army)
		if ("Hezbollah")
			return "Hezbollah"
		if ("Israelis")
			return "FDI"


/obj/map_metadata/arab_town/cross_message(faction)
	if (faction == AMERICAN)
		return "<font size = 4>As tropas do FDI podem passar pela parede invisivel!</font>"
	else if (faction == ARAB)
		return ""
	else
		return ""

/obj/map_metadata/arab_town/reverse_cross_message(faction)
	if (faction == AMERICAN)
		return "<span class = 'userdanger'>As tropas do FDI não podem mais passar pela marede invisivel!</span>"
	else if (faction == ARAB)
		return ""
	else
		return ""


var/no_loop_arab = FALSE

/obj/map_metadata/arab_town/update_win_condition()

	if (world.time >= 24000)
		if (win_condition_spam_check)
			return FALSE
		ticker.finished = TRUE
		var/message = "O Hezbollah conseguiu defender o QG!"
		world << "<font size = 4><span class = 'notice'>[message]</span></font>"
		show_global_battle_report(null)
		win_condition_spam_check = TRUE
		return FALSE
	if ((current_winner && current_loser && world.time > next_win) && no_loop_arab == FALSE)
		ticker.finished = TRUE
		var/message = "As Forças de Defesa de Israel Capturaram o QG do Hezbollah! Hezbollah recua covardemente!"
		world << "<font size = 4><span class = 'notice'>[message]</span></font>"
		show_global_battle_report(null)
		win_condition_spam_check = TRUE
		no_loop_arab = TRUE
		return FALSE
	// German major
	else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.33, TRUE))
		if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.33))
			if (last_win_condition != win_condition.hash)
				current_win_condition = "O FDI domina o QG do Hezbollah! Eles vão vencer em {time} minutos"
				next_win = world.time +  short_win_time(ARAB)
				announce_current_win_condition()
				current_winner = roundend_condition_def2army(roundend_condition_sides[1][1])
				current_loser = roundend_condition_def2army(roundend_condition_sides[2][1])
	// German minor
	else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.01, TRUE))
		if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.01))
			if (last_win_condition != win_condition.hash)
				current_win_condition = "O FDI domina o QG do Hezbollah! Eles vão vencer em {time} minutos"
				next_win = world.time +  short_win_time(ARAB)
				announce_current_win_condition()
				current_winner = roundend_condition_def2army(roundend_condition_sides[1][1])
				current_loser = roundend_condition_def2army(roundend_condition_sides[2][1])
	// Soviet major
	else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.33, TRUE))
		if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.33))
			if (last_win_condition != win_condition.hash)
				current_win_condition = "O FDI domina o QG do Hezbollah! Eles vão vencer em {time} minutos"
				next_win = world.time +  short_win_time(AMERICAN)
				announce_current_win_condition()
				current_winner = roundend_condition_def2army(roundend_condition_sides[2][1])
				current_loser = roundend_condition_def2army(roundend_condition_sides[1][1])
	// Soviet minor
	else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.01, TRUE))
		if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.01))
			if (last_win_condition != win_condition.hash)
				current_win_condition = "O FDI domina o QG do Hezbollah! Eles vão vencer em {time} minutos"
				next_win = world.time + short_win_time(AMERICAN)
				announce_current_win_condition()
				current_winner = roundend_condition_def2army(roundend_condition_sides[2][1])
				current_loser = roundend_condition_def2army(roundend_condition_sides[1][1])
	else
		if (current_win_condition != no_winner && current_winner && current_loser)
			world << "<font size = 3>O Hezbollah Conseguiu recapturar o QG!</font>"
			current_winner = null
			current_loser = null
		next_win = -1
		current_win_condition = no_winner
		win_condition.hash = 0
	last_win_condition = win_condition.hash
	return TRUE

/obj/map_metadata/arab_town_2
	ID = MAP_ARAB_TOWN_2
	title = "Arab Town II"
	lobby_icon = "icons/lobby/modern.png"
	caribbean_blocking_area_types = list(/area/caribbean/no_mans_land/invisible_wall/desert)
	respawn_delay = 1200

	faction_organization = list(
		AMERICAN,
		ARAB)

	roundend_condition_sides = list(
		list(AMERICAN) = /area/caribbean/british,
		list(ARAB) = /area/caribbean/arab
		)
	age = "2006"
	ordinal_age = 8
	faction_distribution_coeffs = list(AMERICAN = 0.5, ARAB = 0.5)
	battle_name = "Batalha pela cidade"
	mission_start_message = "<font size=4>Capture toda a cidade e defenda o QG! A parede invisivel vai cair em <b>6 minutos</b>.</font>"
	faction1 = AMERICAN
	faction2 = ARAB
	valid_weather_types = list(WEATHER_NONE, WEATHER_EXTREME)
	songs = list(
		"Al-Qussam:1" = "sound/music/alqassam.ogg",)
	artillery_count = 3
	valid_artillery = list("Explosive")

/obj/map_metadata/arab_town_2/job_enabled_specialcheck(var/datum/job/J)
	..()
	if (J.is_modernday && istype(J, /datum/job/american) && !istype(J, /datum/job/american/idf))
		. = TRUE
	else if (J.is_specops && istype(J, /datum/job/arab))
		. = TRUE
	else
		. = FALSE

/obj/map_metadata/arab_town_2/faction2_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 3000 || admin_ended_all_grace_periods)

/obj/map_metadata/arab_town_2/faction1_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 3000 || admin_ended_all_grace_periods)


/obj/map_metadata/arab_town_2/roundend_condition_def2name(define)
	..()
	switch (define)
		if (ARAB)
			return "Insurgentes"
/obj/map_metadata/arab_town/roundend_condition_def2army(define)
	..()
	switch (define)
		if (ARAB)
			return "Insurgentes"

/obj/map_metadata/arab_town/army2name(army)
	..()
	switch (army)
		if ("Insurgentes")
			return "Insurgentes"


/obj/map_metadata/arab_town/cross_message(faction)
	if (faction == AMERICAN)
		return "<font size = 4>Todas as Facções podem passar pela parede invisivel agora!</font>"
	else if (faction == ARAB)
		return ""
	else
		return ""

/obj/map_metadata/arab_town/reverse_cross_message(faction)
	if (faction == AMERICAN)
		return "<span class = 'userdanger'>Both factions may no longer cross the invisible wall!</span>"
	else if (faction == ARAB)
		return ""
	else
		return ""
