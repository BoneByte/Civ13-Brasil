//not really a subtype of hostile animals, but it is harmful so it goes here.
/mob/living/simple_animal/mosquito
	name = "mosquitoes"
	desc = "Annoying and dangerous."
	icon = 'icons/mob/critter.dmi'
	icon_state = "mosquitoes1"
	icon_living = "mosquitoes1"
	icon_dead = "blank"
	icon_gib = "blank"
	speak = list("bzzzz","zzzzzzz")
	emote_see = list("buzz around", "fly around")
	speak_chance = TRUE
	move_to_delay = 3
	see_in_dark = 9
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	meat_amount = 0
	response_help  = "waves"
	response_disarm = "waves"
	response_harm   = "slaps"
	attacktext = "bitten"
	health = 5
	maxHealth = 5
	mob_size = MOB_MINISCULE
	stop_automated_movement_when_pulled = FALSE
	stop_automated_movement = TRUE
	wander = FALSE
	density = FALSE
	layer = 4.1

/mob/living/simple_animal/mosquito/New()
	..()


/mob/living/simple_animal/mosquito/Life()
	..()
	if (weather == WEATHER_EXTREME || weather == WEATHER_WET)
		spawn(1000)//Wait a bit
			var/area/A = get_area(loc)
			if (findtext(A.icon_state,"rain") || findtext(A.icon_state,"snow") || findtext(A.icon_state,"monsoon")|| findtext(A.icon_state,"sandstorm"))//If still weather
				qdel(src)
	if (stat != DEAD)
		if (prob(70))
			var/done = FALSE
			for (var/mob/living/human/H in range(6, src))
				if (map && ((map.ID == MAP_NOMADS_AFRICA && H.s_tone > -175) || map.ID != MAP_NOMADS_AFRICA))
					if (done == FALSE)
						walk_towards(src, H, 3)
						done = TRUE
			if (done == FALSE)
				walk_rand(src,4)
		else if (prob(15))
			var/done = FALSE
			for (var/obj/structure/sink/S in range(8, src))
				if (done == FALSE)
					walk_towards(src, S, 3)
					done = TRUE
			if (done == FALSE)
				walk_rand(src,4)
		else
			walk_rand(src,4)
		if (prob(10))
			for (var/mob/living/human/TG in range(1,src))
				if (map && ((map.ID == MAP_NOMADS_AFRICA && TG.s_tone > -175) || map.ID != MAP_NOMADS_AFRICA))
					visible_message("<span class = 'danger'>\The [src] bite [TG]!")
					var/dmod = 1
					if (TG.find_trait("Weak Immune System"))
						dmod = 2
					TG.adjustBruteLoss(1,2)
					if (prob(20*dmod) && TG.disease == 0)
						TG.disease_progression = 0
						TG.disease_type ="malaria"
						TG.disease = 1
/mob/living/simple_animal/mosquito/bullet_act(var/obj/item/projectile/Proj)
	return

/mob/living/simple_animal/mosquito/attack_hand(mob/living/human/M as mob)
	M.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	visible_message("[M] swats away the [src]!","You swat away the [src]!")
	if (prob(40))
		walk_away(src, M, 3, 3)
		return
	if (prob(10))
		if (origin)
			var/obj/structure/sink/S = origin
			S.mosquito_count--
		qdel(src)
		return

/mob/living/simple_animal/mosquito/attackby(var/obj/item/O, var/mob/user)
	if (istype(O, /obj/item/weapon/swatter/modern))
		if (prob(75))
			visible_message("[user] swats \the [src] with \the [O]!")
			if (origin)
				var/obj/structure/sink/S = origin
				S.mosquito_count--
			qdel(src)
			return
		else
			visible_message("[user] misses \the [src]!")
			return
	else if (istype(O, /obj/item/weapon/swatter))
		if (prob(30))
			visible_message("[user] swats \the [src] with \the [O]!")
			if (origin)
				var/obj/structure/sink/S = origin
				S.mosquito_count--
			qdel(src)
			return
		else
			visible_message("[user] misses \the [src]!")
			return
	else
		return

/obj/structure/curtain/Crossed(var/mob/living/simple_animal/mosquito/M)
	if (icon_state != "open" && istype(M, /mob/living/simple_animal/mosquito))
		walk(M,0)
		walk(M,turn(dir,180),3)
	else
		..()