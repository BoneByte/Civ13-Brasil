/obj/map_metadata/bank_robbery
	ID = MAP_BANK_ROBBERY
	title = "The Goldstein Bank Heist"
	lobby_icon = "icons/lobby/bank_robbery.png"
	no_winner ="O roubo ainda está rolando!"
	caribbean_blocking_area_types = list(
		/area/caribbean/no_mans_land/invisible_wall,
		/area/caribbean/no_mans_land/invisible_wall/inside)
	respawn_delay = 0

	faction_organization = list(
		CIVILIAN,
		RUSSIAN,)

	roundend_condition_sides = list(
		list(RUSSIAN) = /area/caribbean/british/land/inside/objective,
		list(CIVILIAN) = /area/caribbean/japanese/land/inside/command, //doesn't exist on the map
		)

	age = "1993"
	ordinal_age = 7
	faction_distribution_coeffs = list(CIVILIAN = 0.65, RUSSIAN = 0.35)
	battle_name = "Goldstein Bank Heist"
	mission_start_message = "<font size=4>Os assaltantes tem <b>5 minutos</b> Para se preparar antes que a negociação acabe!<br>O departamento de policia vai ganhar se capturar a sala do <b>Cofre</b> dentro do banco <b>Depois de evacuar TODOS os reféns</b>.<br>Os Assaltantes vão ganhar se conseguirem roubar <b>10'000 dólares</b> do Cofre antes de <b>25 minutos!</b></font>"
	faction1 = CIVILIAN
	faction2 = RUSSIAN
	grace_wall_timer = 3000
	gamemode = "Bank Robbery"
	songs = list(
		"George Baker Selection - Little Green Bag:1" = "sound/music/little_green_bag.ogg",)

	var/list/civilians_killed = list(
		"Police" = 0,
		"Robbers" = 0,
		)
	var/total_killed = 0
	var/civilians_alive = 12
	var/civilians_evacuated = 0
	var/kill_treshold = 3
	var/arrested_criminals = 0

/obj/map_metadata/bank_robbery/New()
	..()
	kill_treshold = rand(2,5)
	spawn(900)
		civ_counter()
		civ_collector()
		civ_status()
		round_status()
		supplies()

/obj/map_metadata/bank_robbery/job_enabled_specialcheck(var/datum/job/J)
	..()
	if (J.is_heist == TRUE)
		. = TRUE
		if(civilians_killed["Robbers"] >= kill_treshold || civilians_evacuated == civilians_alive)
			if (J.title == "SWAT Officer")
				J.whitelisted = FALSE
				J.max_positions = 20
				J.total_positions = 20
		if (J.title == "Vyacheslav Grigoriev")
			. = FALSE
		if (J.title == "Rednikov Guard")
			. = FALSE
		if (J.title == "DEA Agent")
			. = FALSE
	else if (J.title == "Paramedic")
		. = TRUE
	else
		. = FALSE

/obj/map_metadata/bank_robbery/faction1_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 3000 || admin_ended_all_grace_periods)

/obj/map_metadata/bank_robbery/faction2_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 3000 || admin_ended_all_grace_periods)

/obj/map_metadata/bank_robbery/roundend_condition_def2name(define)
	..()
	switch (define)
		if (CIVILIAN)
			return "Departamento de Policia"
		if (RUSSIAN)
			return "Assaltantes"

/obj/map_metadata/bank_robbery/roundend_condition_def2army(define)
	..()
	switch (define)
		if (CIVILIAN)
			return "Departamento de Policia"
		if (RUSSIAN)
			return "Assaltantes"

/obj/map_metadata/bank_robbery/army2name(army)
	..()
	switch (army)
		if ("CIVILIAN")
			return "Police Department"
		if ("Russos")
			return "Assaltantes"

/obj/map_metadata/bank_robbery/cross_message(faction)
	return "<font size = 4>O Departamento de Policia começou a invasão!</font>"

/obj/map_metadata/bank_robbery/reverse_cross_message(faction)
	return ""

/obj/map_metadata/bank_robbery/short_win_time(faction)
	if (!(alive_n_of_side(faction1)) || !(alive_n_of_side(faction2)))
		return 1200
	else
		return 1200 // 2 minutes

/obj/map_metadata/bank_robbery/long_win_time(faction)
	if (!(alive_n_of_side(faction1)) || !(alive_n_of_side(faction2)))
		return 1200
	else
		return 3000 // 2 minutes

/obj/map_metadata/bank_robbery/update_win_condition()
	if (win_condition_spam_check)
		return FALSE
	if (processes.ticker.playtime_elapsed >= 18000)
		ticker.finished = TRUE
		var/message = "O Departamento de Polícia cercou toda a vizinhança e está perseguindo cada assaltantes, um a um. Os assaltantes falharam em seu assalto!"
		world << "<font size = 4><span class = 'notice'>[message]</span></font>"
		show_global_battle_report(null)
		win_condition_spam_check = TRUE
		return FALSE
	else
		for(var/obj/structure/money_bag/C in world)
			if (C.storedvalue >= 10000) // total value stored = 12400+. So roughly 3/4th
				var/message = "Os Assaltantes roubaram os 10 milhões, eles venceram!"
				world << "<font size = 4><span class = 'notice'>[message]</span></font>"
				show_global_battle_report(null)
				win_condition_spam_check = TRUE
				ticker.finished = TRUE
				return FALSE
		if (civilians_evacuated == civilians_alive || civilians_alive == 0 || total_killed == 12)
			if ((current_winner && current_loser && world.time > next_win) && no_loop_o == FALSE)
				ticker.finished = TRUE
				world << "<font size = 4><span class = 'notice'>O Departamento de Polícia tomou o controle total do Banco!</span></font>"
				show_global_battle_report(null)
				win_condition_spam_check = TRUE
				no_loop_o = TRUE
				return FALSE
			else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.33, TRUE))
				if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.33))
					if (last_win_condition != win_condition.hash)
						current_win_condition = "O departamento de policia está capturando o Cofre! Eles vão vencer em {time} minutos."
						next_win = world.time + short_win_time(CIVILIAN)
						announce_current_win_condition()
						current_winner = roundend_condition_def2army(roundend_condition_sides[1][1])
						current_loser = roundend_condition_def2army(roundend_condition_sides[2][1])
			else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.01, TRUE))
				if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.01))
					if (last_win_condition != win_condition.hash)
						current_win_condition = "O departamento de policia está capturando o Cofre! Eles vão vencer em {time} minutos."
						next_win = world.time + short_win_time(CIVILIAN)
						announce_current_win_condition()
						current_winner = roundend_condition_def2army(roundend_condition_sides[1][1])
						current_loser = roundend_condition_def2army(roundend_condition_sides[2][1])
			else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.33, TRUE))
				if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.33))
					if (last_win_condition != win_condition.hash)
						current_win_condition = "O departamento de policia está capturando o Cofre! Eles vão vencer em {time} minutos."
						next_win = world.time + short_win_time(CIVILIAN)
						announce_current_win_condition()
						current_winner = roundend_condition_def2army(roundend_condition_sides[2][1])
						current_loser = roundend_condition_def2army(roundend_condition_sides[1][1])
			else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.01, TRUE))
				if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.01))
					if (last_win_condition != win_condition.hash)
						current_win_condition = "O departamento de policia está capturando o Cofre! Eles vão vencer em {time} minutos."
						next_win = world.time + short_win_time(CIVILIAN)
						announce_current_win_condition()
						current_winner = roundend_condition_def2army(roundend_condition_sides[2][1])
						current_loser = roundend_condition_def2army(roundend_condition_sides[1][1])
			else
				if (current_win_condition != no_winner && current_winner && current_loser)
					world << "<font size = 3>Os Assaltantes conseguiram recuperar o controle do Cofre!</font>"
					current_winner = null
					current_loser = null
				next_win = -1
				current_win_condition = no_winner
				win_condition.hash = 0
			last_win_condition = win_condition.hash
			return TRUE

/obj/map_metadata/bank_robbery/check_caribbean_block(var/mob/living/human/H, var/turf/T)
	if (!istype(H) || !istype(T))
		return FALSE
	var/area/A = get_area(T)
	if (istype(A, /area/caribbean/no_mans_land/invisible_wall))
		if (istype(A, /area/caribbean/no_mans_land/invisible_wall/one))
			if (H.original_job.is_outlaw == TRUE && !H.original_job.is_law == TRUE)
				return TRUE
		else if (istype(A, /area/caribbean/no_mans_land/invisible_wall/two))
			if (H.original_job.is_law == TRUE && !H.original_job.is_outlaw == TRUE)
				return TRUE
		else
			return !faction1_can_cross_blocks()
	return FALSE

/obj/map_metadata/bank_robbery/proc/civ_collector()
	for(var/turf/T in get_area_turfs(/area/caribbean/british/land/outside))
		for (var/mob/living/simple_animal/civilian/CVL in T)
			if(CVL.stat != DEAD)
				qdel(CVL)
				civilians_evacuated++
		for (var/mob/living/human/H in T) // To be commented or removed out if causing too much issues
			if (H.faction_text == "RUSSIAN")
				if (H.stat != DEAD && H.client)
					if (H.restrained())
						arrested_criminals++
						spawn(10)
							H.ghostize()
							qdel(H)
							WWalert(H,"Você foi preso.", "Se Fodeu!")
	spawn(300)
		civ_collector()

/obj/map_metadata/bank_robbery/proc/civ_counter()
	total_killed = civilians_killed["Robbers"]+civilians_killed["Police"]
	civilians_alive = 12 - total_killed
	spawn(100)
		civ_counter()

/obj/map_metadata/bank_robbery/proc/civ_status()
	spawn(1200)
		world << "<big>Reféns Evacuados: [civilians_evacuated]/[civilians_alive] </big>"
		world << "<big>Reféns Vivos: [civilians_alive] </big>"
		world << "<big>Reféns Mortos: [total_killed] </big>"
		civ_status()

/obj/map_metadata/bank_robbery/proc/round_status()
	var/spamcheck = FALSE
	if (civilians_evacuated == civilians_alive && civilians_alive != 0 && spamcheck == FALSE)
		world << "<big><span class ='warning'>Todos os reféns vivos restantes foram evacuados! A Polícia está agora protegendo o edifício com mais unidades!</span></big>"
		spamcheck = TRUE
	else if (civilians_alive == 0 && spamcheck == FALSE)
		world << "<big><span class = 'danger'>Todos os reféns foram mortos! Que banho de sangue! A Polícia está agora protegendo agressivamente o edifício com mais unidades!</danger></big>"
		spamcheck = TRUE
	round_status()

/obj/map_metadata/bank_robbery/proc/supplies() //To be rebalanced
	var/next_level_police = 0
	var/next_level_robbers = 0
	if (civilians_killed["Police"] >= kill_treshold && next_level_robbers == 0)
		for (var/obj/structure/altar/stone/D in world)
			if (D.name == "robber drop")
				var/turf/T = get_turf(D)
				new /obj/item/weapon/grenade/coldwar/rgd5(T)
				new /obj/item/weapon/grenade/coldwar/rgd5(T)
				new /obj/item/weapon/grenade/coldwar/rgd5(T)
				new /obj/item/weapon/reagent_containers/food/drinks/bottle/molotov(T)
				new /obj/item/weapon/reagent_containers/food/drinks/bottle/molotov(T)
				new /obj/item/weapon/gun/projectile/automatic/rpk74(T)
				new /obj/item/weapon/gun/projectile/automatic/rpk74(T)
				new /obj/item/weapon/gun/projectile/automatic/rpk74(T)
				new /obj/item/ammo_magazine/rpk74/drum(T)
				new /obj/item/ammo_magazine/rpk74/drum(T)
				new /obj/item/ammo_magazine/rpk74/drum(T)
				new /obj/item/ammo_magazine/rpk74/drum(T)
				new /obj/item/ammo_magazine/rpk74/drum(T)
				new /obj/item/ammo_magazine/rpk74/drum(T)
				new /obj/item/clothing/head/helmet/modern/sovietfacehelmet(T)
				new /obj/item/clothing/head/helmet/modern/sovietfacehelmet(T)
				new /obj/item/clothing/head/helmet/modern/sovietfacehelmet(T)
		next_level_robbers = 1
		return
	if (civilians_evacuated >= civilians_alive/2 && civilians_alive != 0 && next_level_police == 0)
		world << "<big><span class = 'notice'>Metade dos reféns foi evacuada, equipamento adicional é emitido para a Polícia.</span></big>"
		for (var/obj/structure/altar/stone/D in world)
			if (D.name == "police drop")
				var/turf/T = get_turf(D)
				new /obj/item/weapon/gun/projectile/shotgun/pump/remington870(T)
				new /obj/item/weapon/gun/projectile/shotgun/pump/remington870(T)
				new /obj/item/weapon/gun/projectile/shotgun/pump/remington870(T)
				new /obj/item/ammo_magazine/shellbox/beanbag(T)
				new /obj/item/ammo_magazine/shellbox(T)
				new /obj/item/ammo_magazine/shellbox(T)
				new /obj/item/ammo_magazine/shellbox/rubber(T)
				new /obj/item/weapon/shield/balistic(T)
				new /obj/item/weapon/shield/balistic(T)
		next_level_police = 1
		return
	if (civilians_evacuated >= civilians_alive && civilians_alive != 0 && next_level_police == 1)
		world << "<big><span class = 'notice'>Todos os reféns foram evacuados, equipamento adicional é emitido para a Polícia, já que mais unidades da SWAT estão a caminho.</span></big>"
		for (var/obj/structure/altar/stone/D in world)
			if (D.name == "police drop")
				var/turf/T = get_turf(D)
				new /obj/item/weapon/grenade/chemical/cs_gas/m7a2(T)
				new /obj/item/weapon/grenade/chemical/cs_gas/m7a2(T)
				new /obj/item/weapon/grenade/chemical/cs_gas/m7a2(T)
				new /obj/item/weapon/grenade/chemical/cs_gas/m7a2(T)
		next_level_police = 2
		return
	spawn(10)
		supplies()

// MAP SPECIFIC OBJECTS//

/obj/structure/multiz/ladder/ww2/up/manhole/bank_robbery/attack_hand(var/mob/M)
	if (istype(M, /mob/living/human))
		var/mob/living/human/H = M
		if (H.faction_text != "RUSSIAN")
			H << "<span class = 'warning'>Você não consegue descobrir a escotilha!</span>"
			return
		else
			..()
	else
		..()

/obj/structure/multiz/ladder/ww2/manhole/bank_robbery/attack_hand(var/mob/M)
	if (istype(M, /mob/living/human))
		var/mob/living/human/H = M
		if (H.faction_text != "RUSSIAN")
			H << "<span class = 'warning'>Você não consegue descobrir a escotilha!</span>"
			return
		else
			if (processes.ticker.playtime_elapsed >= 6000) //To prevent from stalling the round
				H << "<span class = 'warning'>Eu não posso descer agora, preciso me concentrar no meu objetivo!</span>"
				return
			else
				if (ismob(H.pulling)) //To prevent from taking hostages and handcuffed policemen to the sewers
					H.stop_pulling()
					H << "<span class = 'warning'>O refém se recusa a descer com você!</span>"
				for (var/obj/item/weapon/grab/G in (H.r_hand||H.l_hand))
					qdel(G)
				..()
	else
		..()

/obj/structure/money_bag
	name = "Saco de Dinheiro"
	desc = ""
	icon = 'icons/obj/storage.dmi'
	icon_state = "duffel"
	anchored = TRUE
	opacity = FALSE
	density = TRUE
	flammable = FALSE
	var/storedvalue = 0
	var/prevent = FALSE
	not_movable = TRUE
	not_disassemblable = TRUE

/obj/structure/money_bag/New()
	..()
	desc = "Valor Armazenado: [storedvalue]."
	spawn(900)
		timer()
/obj/structure/money_bag/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W,/obj/item/stack/money) || istype(W,/obj/item/stack/material/gold) || istype(W,/obj/item/stack/material/silver) || istype(W,/obj/item/stack/material/diamond))
		storedvalue += (W.value*W.amount)
		desc = "Valor Armazenado: [storedvalue]."
		user << "Você coloca o [W] dentro do [src]."
		qdel(W)
		if (storedvalue >= 1500)
			map.update_win_condition()
	else
		return
/obj/structure/money_bag/proc/timer()
	spawn(1200)
		world << "<big>Dinheiro Armazenado: <b>[storedvalue]/10'000 Dolares</b></big>"
		timer()