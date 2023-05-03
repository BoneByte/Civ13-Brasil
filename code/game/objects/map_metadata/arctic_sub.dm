/obj/map_metadata/arctic_sub
	ID = MAP_ARCTIC_SUB
	title = "Batalha pelo submarino"
	lobby_icon = "icons/lobby/arcticsub.png"
	caribbean_blocking_area_types = list(/area/caribbean/no_mans_land/invisible_wall/tundra/one)
	respawn_delay = 1200
	no_winner = "O cerco ainda está rolando"
	gamemode = "Submarine siege."
	no_hardcore = FALSE

	faction_organization = list(
		RUSSIAN,
		AMERICAN)

	roundend_condition_sides = list(
		list(AMERICAN) = /area/caribbean/british/land/inside/objective,
		list(RUSSIAN) = /area/caribbean/no_mans_land/capturable/one
		)
	age = "1960"
	ordinal_age = 7
	faction_distribution_coeffs = list(RUSSIAN = 0.7, AMERICAN = 0.3)
	battle_name = "Batalha pelo Submarino."
	mission_start_message = "<font size=4>Todas as Facções tem <b>8 minutos</b> Pra se preparar!<br>A tripulação do navio vai vencer se conseguirem segurar o cerco por <b>40 minutos</b>. Os soviéticos vencerão se entrarem e ocuparem a sala de comando por 5 minutos!.</font>"
	faction1 = AMERICAN
	faction2 = RUSSIAN
	valid_weather_types = list(WEATHER_NONE, WEATHER_WET, WEATHER_EXTREME)
	songs = list(
		"Visonia - Antarctic Love:1" = "sound/music/antarcticlove.ogg",)
	gamemode = "Siege"

/obj/map_metadata/arctic_sub/faction1_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 60000 || admin_ended_all_grace_periods)

/obj/map_metadata/arctic_sub/faction2_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 4800 || admin_ended_all_grace_periods)

/obj/map_metadata/arctic_sub/short_win_time(faction)
	if (!(alive_n_of_side(faction1)) || !(alive_n_of_side(faction2)))
		return 600
	else
		return 3000 // 5 minutes

/obj/map_metadata/arctic_sub/long_win_time(faction)
	if (!(alive_n_of_side(faction1)) || !(alive_n_of_side(faction2)))
		return 600
	else
		return 3000 // 5 minutes

/obj/map_metadata/arctic_sub/roundend_condition_def2name(define)
	..()
	switch (define)
		if (AMERICAN)
			return "Tripulação"
		if (RUSSIAN)
			return "Sovieticos"
/obj/map_metadata/arctic_sub/roundend_condition_def2army(define)
	..()
	switch (define)
		if (AMERICAN)
			return "Tripulação"
		if (RUSSIAN)
			return "Sovieticos"

/obj/map_metadata/arctic_sub/army2name(army)
	..()
	switch (army)
		if ("Tripulação")
			return "Tripulação"
		if ("Sovieticos")
			return "Sovietico"


/obj/map_metadata/arctic_sub/cross_message(faction)
	if (faction == RUSSIAN)
		return "<font size = 4>Os Sovieticos podem passar da parede invisivel!</font>"
	else if (faction == AMERICAN)
		return ""
	else
		return ""

/obj/map_metadata/berlin/reverse_cross_message(faction)
	if (faction == RUSSIAN)
		return "<span class = 'userdanger'>The Soviets may no longer cross the invisible wall!</span>"
	else if (faction == AMERICAN)
		return ""
	else
		return ""


/obj/map_metadata/arctic_sub/update_win_condition()

	if (world.time >= 24000)
		if (win_condition_spam_check)
			return FALSE
		ticker.finished = TRUE
		var/message = "A tripulação conseguiu bravamente defender o submarino! Os invasores fugiram covardemente!"
		world << "<font size = 4><span class = 'notice'>[message]</span></font>"
		show_global_battle_report(null)
		win_condition_spam_check = TRUE
		return FALSE
	if ((current_winner && current_loser && world.time > next_win) && no_loop_r == FALSE)
		ticker.finished = TRUE
		var/message = "Os <b>Sovieticos</b> Capturaram o submarino! A Batalha pelo Submarino. está acabada!"
		world << "<font size = 4><span class = 'notice'>[message]</span></font>"
		show_global_battle_report(null)
		win_condition_spam_check = TRUE
		no_loop_r = TRUE
		return FALSE
	// German major
	else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.33, TRUE))
		if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.33))
			if (last_win_condition != win_condition.hash)
				current_win_condition = "Os <b>Sovieticos</b> Conseguiram chegar na sala de comando! Eles vão vencer em {time} minutos"
				next_win = world.time + short_win_time(RUSSIAN)
				announce_current_win_condition()
				current_winner = roundend_condition_def2army(roundend_condition_sides[1][1])
				current_loser = roundend_condition_def2army(roundend_condition_sides[2][1])
	// German minor
	else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.01, TRUE))
		if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.01))
			if (last_win_condition != win_condition.hash)
				current_win_condition = "Os <b>Sovieticos</b> Conseguiram chegar na sala de comando! Eles vão vencer em {time} minutos"
				next_win = world.time + short_win_time(RUSSIAN)
				announce_current_win_condition()
				current_winner = roundend_condition_def2army(roundend_condition_sides[1][1])
				current_loser = roundend_condition_def2army(roundend_condition_sides[2][1])
	// Soviet major
	else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.33, TRUE))
		if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.33))
			if (last_win_condition != win_condition.hash)
				current_win_condition = "Os <b>Sovieticos</b> Conseguiram chegar na sala de comando! Eles vão vencer em {time} minutos."
				next_win = world.time + short_win_time(RUSSIAN)
				announce_current_win_condition()
				current_winner = roundend_condition_def2army(roundend_condition_sides[2][1])
				current_loser = roundend_condition_def2army(roundend_condition_sides[1][1])
	// Soviet minor
	else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.01, TRUE))
		if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.01))
			if (last_win_condition != win_condition.hash)
				current_win_condition = "Os <b>Sovieticos</b> Conseguiram chegar na sala de comando! Eles vão vencer em {time} minutos"
				next_win = world.time + short_win_time(RUSSIAN)
				announce_current_win_condition()
				current_winner = roundend_condition_def2army(roundend_condition_sides[2][1])
				current_loser = roundend_condition_def2army(roundend_condition_sides[1][1])
	else
		if (current_win_condition != no_winner && current_winner && current_loser)
			world << "<font size = 3>A <b>Tripulação</b> Recapturou a sala de comando!</font>"
			current_winner = null
			current_loser = null
		next_win = -1
		current_win_condition = no_winner
		win_condition.hash = 0
	last_win_condition = win_condition.hash
	return TRUE
