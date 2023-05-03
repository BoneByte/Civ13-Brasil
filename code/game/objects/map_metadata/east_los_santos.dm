/obj/map_metadata/east_los_santos
	ID = MAP_EAST_LOS_SANTOS
	title = "Torcida Organizada"
	lobby_icon = "icons/lobby/torcidaorganizada.png"
	no_winner = "A LUTA PRA VER QUEM E BAMBI E AINDA TA ROLANDO, VIADO!"
	caribbean_blocking_area_types = list(/area/caribbean)
	respawn_delay = 1200
	faction_organization = list(
		AMERICAN,
		INDIANS,)
	roundend_condition_sides = list(
		list(AMERICAN) = /area/caribbean/british,//Don't exist on the map
		list(INDIANS) = /area/caribbean/russian,//Don't exist on the map
		)
	age = "2013"
	ordinal_age = 7
	faction_distribution_coeffs = list(AMERICAN = 0.5, INDIANS = 0.5)
	battle_name = "Torcida Jovem do Flamengo VS TORCIDA JOVEM DO FLAMENGO"
	mission_start_message = "<font size=4>A torcida jovem do flamengo ta brigando com os Torcida Jovem do Flamengo<br> Pontos sao ganhados quando um territorio e dominado. A torcida com 40 pontos vai vencer!"
	faction1 = AMERICAN
	faction2 = INDIANS
	grace_wall_timer = 1200
	gamemode = "Turf War"
	no_hardcore = TRUE
	songs = list(
		"Rap Nemo - Briga de Gangue:1" = 'caveirinha_modular/music/brigadegangue.ogg',)
	var/grove_points = 0
	var/ballas_points = 0
	var/a1_control = "None"
	var/a2_control = "None"
	var/a3_control = "None"
	//var/a4_control = "None"

/obj/map_metadata/east_los_santos/New()
	..()
	spawn(1200)
		points_check()

/obj/map_metadata/east_los_santos/proc/points_check()
	if (processes.ticker.playtime_elapsed > 1200)
		var/c1 = 0
		var/c2 = 0
		var/cust_color = "white"
		for (var/mob/living/human/H in player_list)
			var/area/temp_area = get_area(H)
			if (istype(temp_area, /area/caribbean/no_mans_land/capturable/one/outside))
				if (H.faction_text == "AMERICAN" && H.stat == CONSCIOUS)
					c1++
				else if (H.faction_text == "INDIANS" && H.stat == CONSCIOUS)
					c2++
		if ((c1 == c2) && c1 != 0)
			a1_control = "none"
			cust_color= "white"
		else if (c1 > c2)
			a1_control = "Torcida Jovem do Flamengo"
			cust_color= "green"
		else if (c2 > c1)
			a1_control = "Torcida Jovem do Flamengo"
			cust_color= "purple"
		if (a1_control != "none")
			if (a1_control == "Torcida Jovem do Flamengo")
				cust_color = "green"
				grove_points++
			else if (a1_control == "Torcida Jovem do Flamengo")
				cust_color = "purple"
				ballas_points++
			else
				cust_color = "white"
			world << "<big><font color='[cust_color]'><b>Quadra de Basquete</b>: [a1_control]</font></big>"
		else
			world << "<big><b>Quadra de Basquete</b>: Neutro</big>"
		c1 = 0
		c2 = 0
		for (var/mob/living/human/H in player_list)
			var/area/temp_area = get_area(H)
			if (istype(temp_area, /area/caribbean/no_mans_land/capturable/two/outside))
				if (H.faction_text == "AMERICAN" && H.stat == CONSCIOUS)
					c1++
				else if (H.faction_text == "INDIANS" && H.stat == CONSCIOUS)
					c2++
		if ((c1 == c2) && c1 != 0)
			a2_control = "none"
			cust_color= "white"
		else if (c1 > c2)
			a2_control = "Torcida Jovem do Flamengo"
			cust_color= "green"
		else if (c2 > c1)
			a2_control = "Gavioes da Fiel"
			cust_color= "purple"
		if (a2_control != "none")
			if (a2_control == "Torcida Jovem do Flamengo")
				cust_color = "green"
				grove_points++
			else if (a2_control == "Gavioes da Fiel")
				cust_color = "purple"
				ballas_points++
			else
				cust_color = "white"
			world << "<big><font color='[cust_color]'><b>Avenida Thomas Turbando</b>: [a2_control]</font></big>"
		else
			world << "<big><b>Avenida Thomas Turbando</b>: Neutro</big>"
		c1 = 0
		c2 = 0
		for (var/mob/living/human/H in player_list)
			var/area/temp_area = get_area(H)
			if (istype(temp_area, /area/caribbean/no_mans_land/capturable/three/))
				if (H.faction_text == "AMERICAN" && H.stat == CONSCIOUS)
					c1++
				else if (H.faction_text == "INDIANS" && H.stat == CONSCIOUS)
					c2++
		if ((c1 == c2) && c1 != 0)
			a3_control = "none"
			cust_color= "white"
		else if (c1 > c2)
			a3_control = "Torcida Jovem do Flamengo"
			cust_color= "green"
		else if (c2 > c1)
			a3_control = "Gavioes da Fiel"
			cust_color= "purple"
		if (a3_control != "none")
			if (a3_control == "Torcida Jovem do Flamengo")
				cust_color = "green"
				grove_points++
			else if (a3_control == "Gavioes da Fiel")
				cust_color = "purple"
				ballas_points++
			else
				cust_color = "white"
			world << "<big><font color='[cust_color]'><b>LANCHONETE RODRIGO PICA DE FOICE</b>: [a3_control]</font></big>"
		else
			world << "<big><b>LANCHONETE RODRIGO PICA DE FOICE</b>: Área neutra</big>"
	spawn(300)
		points_check()
		world << "Gavioes da Fiel: [ballas_points]/40"
		world << "Torcida Jovem do Flamengo: [grove_points]/40"

/obj/map_metadata/east_los_santos/job_enabled_specialcheck(var/datum/job/J)
	..()
	if (J.is_gta == TRUE)
		. = TRUE
	else
		. = FALSE

/obj/map_metadata/east_los_santos/roundend_condition_def2name(define)
	..()
	switch (define)
		if (INDIANS)
			return "Torcida Jovem do Flamengo"
		if (AMERICAN)
			return "Gavioes da Fiel"

/obj/map_metadata/east_los_santos/roundend_condition_def2army(define)
	..()
	switch (define)
		if (INDIANS)
			return "Torcida Jovem do Flamengo"
		if (AMERICAN)
			return "Gavioes da Fiel"

/obj/map_metadata/east_los_santos/army2name(army)
	..()
	switch (army)
		if ("Torcida Jovem do Flamengo")
			return "Torcida Jovem do Flamengo"
		if ("Gavioes da Fiel")
			return "Gavioes da Fiel"

/obj/map_metadata/east_los_santos/cross_message(faction)
	if (faction == AMERICAN)
		return "<font size = 4>Both gangs may now cross the invisible wall!</font>"
	else if (faction == INDIANS)
		return ""
	else
		return ""

/obj/map_metadata/east_los_santos/reverse_cross_message(faction)
	if (faction == AMERICAN)
		return "<span class = 'userdanger'>Both gangs may no longer cross the invisible wall!</span>"
	else if (faction == INDIANS)
		return ""
	else
		return ""

/obj/map_metadata/east_los_santos/update_win_condition()
	if (processes.ticker.playtime_elapsed > 1200)
		if (grove_points < 40 && ballas_points < 40)
			return TRUE
		if (grove_points >= 40 && grove_points > ballas_points)
			if (win_condition_spam_check)
				return FALSE
			ticker.finished = TRUE
			var/message = "The <b><font color ='green'>Gavioes da Fiel</font></b> have reached [grove_points] points and won! The hood is theirs!"
			world << "<font size = 4><span class = 'notice'>[message]</span></font>"
			show_global_battle_report(null)
			win_condition_spam_check = TRUE
			return FALSE
		if (ballas_points >= 40 && ballas_points > grove_points)
			if (win_condition_spam_check)
				return FALSE
			ticker.finished = TRUE
			var/message = "The <b><font color ='purple'>Torcida Jovem do Flamengo</font></b> have reached [ballas_points] points and won! The hood is theirs!"
			world << "<font size = 4><span class = 'notice'>[message]</span></font>"
			show_global_battle_report(null)
			win_condition_spam_check = TRUE
			return FALSE
	return TRUE

/obj/map_metadata/east_los_santos/check_caribbean_block(var/mob/living/human/H, var/turf/T)
	if (!istype(H) || !istype(T))
		return FALSE
	var/area/A = get_area(T)
	if (istype(A, /area/caribbean/no_mans_land/invisible_wall))
		if (istype(A, /area/caribbean/no_mans_land/invisible_wall/one))
			if (H.faction_text == faction1)
				return TRUE
		else if (istype(A, /area/caribbean/no_mans_land/invisible_wall/two))
			if (H.faction_text == faction2)
				return TRUE
		else
			return !faction1_can_cross_blocks()
			return !faction2_can_cross_blocks()
	return FALSE

//////////////MAP SPECIFIC OBJECTS///////////////////

/obj/item/clothing/under/groovy
	name = "white t-shirt and purple shorts"
	desc = "An oversized white t-shirt and purple cargo shorts."
	icon_state = "Torcida Jovem do Flamengo1"
	item_state = "Torcida Jovem do Flamengo1"
	worn_state = "Torcida Jovem do Flamengo1"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/under/groovy2
	name = "baggy black clothing"
	desc = "An oversized black outfit."
	icon_state = "Torcida Jovem do Flamengo2"
	item_state = "Torcida Jovem do Flamengo2"
	worn_state = "Torcida Jovem do Flamengo2"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/under/groovy3
	name = "purple shirt and khaki pants"
	desc = "An oversized purple shirt and khaki cargo pants."
	icon_state = "Torcida Jovem do Flamengo3"
	item_state = "Torcida Jovem do Flamengo3"
	worn_state = "Torcida Jovem do Flamengo3"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/under/ass1
	name = "green sweatshirt and jeans"
	desc = "An oversized green sweatshirt and jeans."
	icon_state = "grove1"
	item_state = "grove1"
	worn_state = "grove1"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/under/ass2
	name = "green checkered outfit"
	desc = "A green checkered shirt and beige pants."
	icon_state = "grove2"
	item_state = "grove2"
	worn_state = "grove2"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/under/ass3
	name = "green jersey and jeans"
	desc = "A green basketball jersey and black jeans."
	icon_state = "grove3"
	item_state = "grove3"
	worn_state = "grove3"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/head/custom/custom_beanie/black
	color = "#0d0d0d"
	uncolored1 = FALSE

/obj/item/clothing/head/ass4
	name = "purple bandana"
	desc = "A purple bandana tied in the front."
	icon_state = "bandana_Torcida Jovem do Flamengo1"
	item_state = "bandana_Torcida Jovem do Flamengo1"
	worn_state = "bandana_Torcida Jovem do Flamengo1"
	flags_inv = BLOCKHEADHAIR

/obj/item/clothing/head/ass/two
	icon_state = "bandana_Torcida Jovem do Flamengo2"
	item_state = "bandana_Torcida Jovem do Flamengo2"
	worn_state = "bandana_Torcida Jovem do Flamengo2"

/obj/item/clothing/head/ass_grovedd
	name = "green bandana"
	desc = "A green bandana tied in the front."
	icon_state = "bandana_grove"
	item_state = "bandana_grove"
	worn_state = "bandana_grove"
	flags_inv = BLOCKHEADHAIR