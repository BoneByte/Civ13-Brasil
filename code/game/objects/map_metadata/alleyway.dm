/obj/map_metadata/alleyway
	ID = MAP_ALLEYWAY
	title = "Alleyway"
	lobby_icon = "icons/lobby/alleyway.png"
	caribbean_blocking_area_types = list(/area/caribbean/no_mans_land/invisible_wall/jungle, /area/caribbean/no_mans_land/invisible_wall/inside, /area/caribbean/no_mans_land/invisible_wall/inside/one, /area/caribbean/no_mans_land/invisible_wall/inside/two)
	respawn_delay = 300
	no_winner ="A batalha pra dominar o bairro ainda está rolando!"
	faction_organization = list(
		JAPANESE,)

	roundend_condition_sides = list(
		list(JAPANESE) = /area/caribbean/colonies/british
		)
	age = "1989"
	ordinal_age = 8
	faction_distribution_coeffs = list(JAPANESE = 1)
	battle_name = "Yama-ichi gang fight"
	mission_start_message = "<font size=4>O <b>Clã Yamaguchi-Gumi</b> e o <b>Clã Ichiwa-Kai </b> Vão lutar no bairro aos arredores de Kore!</font>"
	faction1 = JAPANESE
	valid_weather_types = list(WEATHER_WET, WEATHER_NONE, WEATHER_EXTREME)
	songs = list(
		"Akira:1" = "sound/music/akira.ogg",)
	is_singlefaction = TRUE
	scores = list(
		"Yamaguchi-Gumi" = 0,
		"Ichiwa-Kai" = 0,
	)
	New()
		..()
		spawn(600)
			points_check()
/obj/map_metadata/alleyway/job_enabled_specialcheck(var/datum/job/J)
	..()
	if ((J.is_yakuza == TRUE && J.is_yama == TRUE) || (J.is_yakuza == TRUE && J.is_ichi == TRUE))
		. = TRUE
	else
		. = FALSE
/obj/map_metadata/alleyway/faction1_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 1200 || admin_ended_all_grace_periods)

/obj/map_metadata/alleyway/check_caribbean_block(var/mob/living/human/H, var/turf/T)
	if (!istype(H) || !istype(T))
		return FALSE
	var/area/A = get_area(T)
	if (istype(A, /area/caribbean/no_mans_land/invisible_wall))
		if (istype(A, /area/caribbean/no_mans_land/invisible_wall/inside/one))
			if (H.original_job.is_yama == TRUE && !H.original_job.is_ichi == TRUE)
				return TRUE
		else if (istype(A, /area/caribbean/no_mans_land/invisible_wall/inside/two))
			if (H.original_job.is_ichi == TRUE && !H.original_job.is_yama == TRUE)
				return TRUE
		else
			return !faction1_can_cross_blocks()
	return FALSE

/obj/map_metadata/alleyway/proc/points_check()
	world << "<big><b>Pontos Atuais:</big></b>"
	world << "<big>Yamaguchi-Gumi: [scores["Yamaguchi-Gumi"]]</big>"
	world << "<big>Ichiwa-Kai: [scores["Ichiwa-Kai"]]</big>"
	spawn(300)
		points_check()

/obj/map_metadata/alleyway/update_win_condition()

	if (processes.ticker.playtime_elapsed >= 12000 || world.time >= next_win && next_win != -1)
		if (win_condition_spam_check)
			return FALSE
		ticker.finished = TRUE
		var/message = ""
		message = "A Partida acabou!"
		if (scores["Ichiwa-Kai"] > scores["Yamaguchi-Gumi"])
			message = "A batalha acabou! O Clã <b>Ichiwa-Kai</b> foi vitorioso contra o Clã <b>Yamaguchi-Gumi</b>!"
			world << "<font size = 4><span class = 'notice'>[message]</span></font>"
			win_condition_spam_check = TRUE
			return FALSE
		else if (scores["Yamaguchi-Gumi"] > scores["Ichiwa-Kai"])
			message = "A batalha acabou! O Clã <b>Yamaguchi-Gumi</b> foi vitorioso contra o Clã <b>Ichiwa-Kai</b>!"
			world << "<font size = 4><span class = 'notice'>[message]</span></font>"
			win_condition_spam_check = TRUE
			return FALSE
		else
			message = "The battle has ended in a <b>stalemate</b>!"
			world << "<font size = 4><span class = 'notice'>[message]</span></font>"
			win_condition_spam_check = TRUE
			return FALSE
		last_win_condition = win_condition.hash
		return TRUE

/obj/map_metadata/alleyway/cross_message(faction)
	return "<font size = 4>A parede invisivel desaparece!</font>"

/obj/map_metadata/alleyway/reverse_cross_message(faction)
	return ""
