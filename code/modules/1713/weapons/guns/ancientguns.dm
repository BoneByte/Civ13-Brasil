///for fire lances, hand cannons, arquebuses

obj/item/weapon/gun/projectile/ancient
	name = "Antiga arma portátil"
	desc = "Uma antiga arma portátil de pólvora negra"
	icon = 'icons/obj/guns/ancient.dmi'
	icon_state = "handcannon"
	item_state = "musket"
	w_class = ITEM_SIZE_HUGE
	throw_range = 3
	throw_speed = 2
	force = 13
	throwforce = 8
	max_shells = 1 //duh
	slot_flags = SLOT_SHOULDER
	caliber = "stoneball"
	recoil = 5 //extra kickback
	handle_casings = REMOVE_CASINGS
	load_method = SINGLE_CASING
	ammo_type = /obj/item/ammo_casing/stoneball
	load_shell_sound = 'sound/weapons/guns/interact/clip_reload.ogg'
	accuracy = TRUE
	gun_type = GUN_TYPE_RIFLE
	attachment_slots = ATTACH_BARREL
	accuracy_increase_mod = 2.00
	accuracy_decrease_mod = 6.00
	KD_chance = KD_CHANCE_HIGH
	stat = "rifle"
	move_delay = 5
	fire_delay = 12
	var/lighted = FALSE
	var/gunpowder = FALSE
	var/bullet = FALSE
	gtype = "rifle"

	accuracy_list = list(

		// small body parts: head, hand, feet
		"small" = list(
			SHORT_RANGE_STILL = 54,
			SHORT_RANGE_MOVING = 22,

			MEDIUM_RANGE_STILL = 33,
			MEDIUM_RANGE_MOVING = 12,

			LONG_RANGE_STILL = 12,
			LONG_RANGE_MOVING = 5,

			VERY_LONG_RANGE_STILL = 7,
			VERY_LONG_RANGE_MOVING = 3),

		// medium body parts: limbs
		"medium" = list(
			SHORT_RANGE_STILL = 60,
			SHORT_RANGE_MOVING = 29,

			MEDIUM_RANGE_STILL = 38,
			MEDIUM_RANGE_MOVING = 19,

			LONG_RANGE_STILL = 14,
			LONG_RANGE_MOVING = 8,

			VERY_LONG_RANGE_STILL = 12,
			VERY_LONG_RANGE_MOVING = 5),

		// large body parts: chest, groin
		"large" = list(
			SHORT_RANGE_STILL = 72,
			SHORT_RANGE_MOVING = 36,

			MEDIUM_RANGE_STILL = 55,
			MEDIUM_RANGE_MOVING = 29,

			LONG_RANGE_STILL = 40,
			LONG_RANGE_MOVING = 19,

			VERY_LONG_RANGE_STILL = 31,
			VERY_LONG_RANGE_MOVING = 12),
	)

	load_delay = 200
	aim_miss_chance_divider = 3.00

obj/item/weapon/gun/projectile/ancient/firelance
	name = "Lança de Fogo"
	desc = "Uma lança com um recipiente de pólvora próximo à ponta, que pode ser preenchido com pólvora e projéteis."
	icon_state = "firelance0"
	item_state = "firelance"
	recoil = 4
	throw_speed = 4
	throw_range = 7
	cooldownw = 11
	force = 25
	throwforce = 12
	sharp = TRUE
	edge = TRUE
	accuracy_list = list(

		// small body parts: head, hand, feet
		"small" = list(
			SHORT_RANGE_STILL = 54*0.78,
			SHORT_RANGE_MOVING = 22*0.78,

			MEDIUM_RANGE_STILL = 33*0.73,
			MEDIUM_RANGE_MOVING = 12*0.73,

			LONG_RANGE_STILL = 12*0.65,
			LONG_RANGE_MOVING = 5*0.65,

			VERY_LONG_RANGE_STILL = 7*0.5,
			VERY_LONG_RANGE_MOVING = 3*0.5),

		// medium body parts: limbs
		"medium" = list(
			SHORT_RANGE_STILL = 60*0.78,
			SHORT_RANGE_MOVING = 29*0.78,

			MEDIUM_RANGE_STILL = 38*0.73,
			MEDIUM_RANGE_MOVING = 19*0.73,

			LONG_RANGE_STILL = 14*0.65,
			LONG_RANGE_MOVING = 8*0.65,

			VERY_LONG_RANGE_STILL = 12*0.5,
			VERY_LONG_RANGE_MOVING = 5*0.5),

		// large body parts: chest, groin
		"large" = list(
			SHORT_RANGE_STILL = 72*0.78,
			SHORT_RANGE_MOVING = 36*0.78,

			MEDIUM_RANGE_STILL = 55*0.73,
			MEDIUM_RANGE_MOVING = 29*0.73,

			LONG_RANGE_STILL = 40*0.65,
			LONG_RANGE_MOVING = 19*0.65,

			VERY_LONG_RANGE_STILL = 31*0.5,
			VERY_LONG_RANGE_MOVING = 12*0.5),
	)

	load_delay = 150
	aim_miss_chance_divider = 1.50
obj/item/weapon/gun/projectile/ancient/handcannon
	name = "Canhão de Mão"
	desc = "Um canhão de mão rudimentar, que consiste em um cano de ferro com uma coronha de madeira acoplada."
	icon_state = "handcannon"
	item_state = "handcannon"

obj/item/weapon/gun/projectile/ancient/arquebus
	name = "arcabuz"
	desc = "Um cano de ferro preso a uma coronha de madeira, com um pedaço de metal no meio para manter o arcabuz imóvel, aumentando a precisão."
	icon_state = "arquebus"
	item_state = "arquebus"
	attachment_slots = ATTACH_IRONSIGHTS
	fire_delay = 9
	recoil = 4

	accuracy_list = list(

		// small body parts: head, hand, feet
		"small" = list(
			SHORT_RANGE_STILL = 54*1.2,
			SHORT_RANGE_MOVING = 22*1.2,

			MEDIUM_RANGE_STILL = 33*1.25,
			MEDIUM_RANGE_MOVING = 12*1.25,

			LONG_RANGE_STILL = 12*1.3,
			LONG_RANGE_MOVING = 5*1.3,

			VERY_LONG_RANGE_STILL = 7*1.3,
			VERY_LONG_RANGE_MOVING = 3*1.3),

		// medium body parts: limbs
		"medium" = list(
			SHORT_RANGE_STILL = 60*1.2,
			SHORT_RANGE_MOVING = 29*1.2,

			MEDIUM_RANGE_STILL = 38*1.25,
			MEDIUM_RANGE_MOVING = 19*1.25,

			LONG_RANGE_STILL = 14*1.3*1.3,
			LONG_RANGE_MOVING = 8*1.3*1.3,

			VERY_LONG_RANGE_STILL = 12*1.3,
			VERY_LONG_RANGE_MOVING = 5*1.3),

		// large body parts: chest, groin
		"large" = list(
			SHORT_RANGE_STILL = 72*1.2,
			SHORT_RANGE_MOVING = 36*1.2,

			MEDIUM_RANGE_STILL = 55*1.25,
			MEDIUM_RANGE_MOVING = 29*1.25,

			LONG_RANGE_STILL = 40*1.3,
			LONG_RANGE_MOVING = 19*1.3,

			VERY_LONG_RANGE_STILL = 31*1.3,
			VERY_LONG_RANGE_MOVING = 12*1.3),
	)

obj/item/weapon/gun/projectile/ancient/matchlock
	name = "mosquete matchlock"
	desc = "Um mosquete que usa o sistema matchlock, no qual um fósforo aceso atua como espoleta, ativado por um gatilho."
	icon_state = "matchlock"
	item_state = "matchlock"
	attachment_slots = ATTACH_IRONSIGHTS
	fire_delay = 3
	recoil = 3

	accuracy_list = list(

		// small body parts: head, hand, feet
		"small" = list(
			SHORT_RANGE_STILL = 83*0.9,
			SHORT_RANGE_MOVING = 42*0.9,

			MEDIUM_RANGE_STILL = 73*0.9,
			MEDIUM_RANGE_MOVING = 37*0.9,

			LONG_RANGE_STILL = 63*0.9,
			LONG_RANGE_MOVING = 32*0.9,

			VERY_LONG_RANGE_STILL = 53*0.85,
			VERY_LONG_RANGE_MOVING = 27*0.85),

		// medium body parts: limbs
		"medium" = list(
			SHORT_RANGE_STILL = 88*0.9,
			SHORT_RANGE_MOVING = 44*0.9,

			MEDIUM_RANGE_STILL = 78*0.9,
			MEDIUM_RANGE_MOVING = 39*0.9,

			LONG_RANGE_STILL = 68*0.9,
			LONG_RANGE_MOVING = 34*0.9,

			VERY_LONG_RANGE_STILL = 58*0.85,
			VERY_LONG_RANGE_MOVING = 29*0.85),

		// large body parts: chest, groin
		"large" = list(
			SHORT_RANGE_STILL = 93*0.9,
			SHORT_RANGE_MOVING = 47*0.9,

			MEDIUM_RANGE_STILL = 83*0.9,
			MEDIUM_RANGE_MOVING = 42*0.9,

			LONG_RANGE_STILL = 73*0.9,
			LONG_RANGE_MOVING = 37*0.9,

			VERY_LONG_RANGE_STILL = 63*0.85,
			VERY_LONG_RANGE_MOVING = 32*0.85),
	)

obj/item/weapon/gun/projectile/ancient/jezailmatchlock
	name = "Mosquete Jezail Matchlock"
	desc = "Um mosquete árabe que usa o sistema matchlock, no qual um fósforo aceso atua como espoleta, ativado por um gatilho."
	icon_state = "matchlock"
	item_state = "matchlock_jezail"
	attachment_slots = ATTACH_IRONSIGHTS
	fire_delay = 3.2
	recoil = 2.8

	accuracy_list = list(

		// small body parts: head, hand, feet
		"small" = list(
			SHORT_RANGE_STILL = 84*0.9,
			SHORT_RANGE_MOVING = 38*0.9,

			MEDIUM_RANGE_STILL = 75*0.9,
			MEDIUM_RANGE_MOVING = 27*0.9,

			LONG_RANGE_STILL = 53*0.9,
			LONG_RANGE_MOVING = 22*0.9,

			VERY_LONG_RANGE_STILL = 43*0.85,
			VERY_LONG_RANGE_MOVING = 17*0.85),

		// medium body parts: limbs
		"medium" = list(
			SHORT_RANGE_STILL = 89*0.9,
			SHORT_RANGE_MOVING = 48*0.9,

			MEDIUM_RANGE_STILL = 69*0.9,
			MEDIUM_RANGE_MOVING = 27*0.9,

			LONG_RANGE_STILL = 68*0.9,
			LONG_RANGE_MOVING = 34*0.9,

			VERY_LONG_RANGE_STILL = 55*0.85,
			VERY_LONG_RANGE_MOVING = 14*0.85),

		// large body parts: chest, groin
		"large" = list(
			SHORT_RANGE_STILL = 93*0.9,
			SHORT_RANGE_MOVING = 47*0.9,

			MEDIUM_RANGE_STILL = 83*0.9,
			MEDIUM_RANGE_MOVING = 42*0.9,

			LONG_RANGE_STILL = 73*0.9,
			LONG_RANGE_MOVING = 37*0.9,

			VERY_LONG_RANGE_STILL = 63*0.85,
			VERY_LONG_RANGE_MOVING = 32*0.85),
	)

obj/item/weapon/gun/projectile/ancient/tanegashima
	name = "tanegashima"
	desc = "Um mosquete que usa o sistema de trava de fósforo, no qual um fósforo aceso atua como espoleta, ativado por um gatilho. Este é japonês, apresentado a eles pelos portugueses."
	icon_state = "tanegashima"
	item_state = "tanegashima"
	attachment_slots = ATTACH_IRONSIGHTS
	fire_delay = 3
	recoil = 3

	accuracy_list = list(

		// small body parts: head, hand, feet
		"small" = list(
			SHORT_RANGE_STILL = 84*0.9,
			SHORT_RANGE_MOVING = 43*0.9,

			MEDIUM_RANGE_STILL = 74*0.9,
			MEDIUM_RANGE_MOVING = 38*0.9,

			LONG_RANGE_STILL = 64*0.9,
			LONG_RANGE_MOVING = 33*0.9,

			VERY_LONG_RANGE_STILL = 54*0.85,
			VERY_LONG_RANGE_MOVING = 23*0.85),

		// medium body parts: limbs
		"medium" = list(
			SHORT_RANGE_STILL = 89*0.9,
			SHORT_RANGE_MOVING = 45*0.9,

			MEDIUM_RANGE_STILL = 79*0.9,
			MEDIUM_RANGE_MOVING = 40*0.9,

			LONG_RANGE_STILL = 69*0.9,
			LONG_RANGE_MOVING = 35*0.9,

			VERY_LONG_RANGE_STILL = 59*0.85,
			VERY_LONG_RANGE_MOVING = 30*0.85),

		// large body parts: chest, groin
		"large" = list(
			SHORT_RANGE_STILL = 94*0.9,
			SHORT_RANGE_MOVING = 48*0.9,

			MEDIUM_RANGE_STILL = 84*0.9,
			MEDIUM_RANGE_MOVING = 43*0.9,

			LONG_RANGE_STILL = 74*0.9,
			LONG_RANGE_MOVING = 38*0.9,

			VERY_LONG_RANGE_STILL = 64*0.85,
			VERY_LONG_RANGE_MOVING = 33*0.85),
	)
/obj/item/weapon/gun/projectile/ancient/attack_self(mob/user)
	return

/obj/item/weapon/gun/projectile/ancient/attackby(obj/W as obj, mob/user as mob)
	if (istype(W, /obj/item/flashlight))
		var/obj/item/flashlight/FL = W
		if (gunpowder && bullet && !lighted && FL.on)
			lighted = TRUE
			var/turf/target = null
			var/dirpick = 6
			if (istype(src, /obj/item/weapon/gun/projectile/ancient/firelance))
				dirpick = 4
			if (user.dir == NORTH)
				target = locate(user.x,user.y+dirpick,user.z)
			else if (user.dir == SOUTH)
				target = locate(user.x,user.y-dirpick,user.z)
			else if (user.dir == EAST)
				target = locate(user.x+dirpick,user.y,user.z)
			else if (user.dir == WEST)
				target = locate(user.x-dirpick,user.y,user.z)
			if (target)
				afterattack(target, user, FALSE)
			return
	else if (istype(W, /obj/item/stack/ammopart/stoneball))
		var/obj/item/stack/ammopart/stoneball/ST = W
		if (!bullet && gunpowder)
			user << "<span class='notice'>Você começa a recarregar o [src] com [W]...</span>"
			if (do_after(user, 100, src, can_move = TRUE))
				if (bullet == FALSE)
					user << "<span class='notice'>Você recarrega o [src].</span>"
					bullet = TRUE
					var/obj/item/ammo_casing/stoneball/SBL = new/obj/item/ammo_casing/stoneball
					loaded += SBL
					if (istype(src, /obj/item/weapon/gun/projectile/ancient/firelance))
						icon_state = "firelance1"
					if (istype(src, /obj/item/weapon/gun/projectile/ancient/matchlock))
						icon_state = "matchlock_cocked"
					if (istype(src, /obj/item/weapon/gun/projectile/ancient/tanegashima))
						icon_state = "tanegashima_cocked"
						lighted = TRUE
					if (ST.amount == 1)
						qdel(W)
					else
						ST.amount -= 1
					return
			else
				return
		else if (bullet)
			user << "<span class='notice'>Já existe um projétil em seu interior.</span>"
			return
		else if (!gunpowder)
			user << "<span class='notice'>Você precisa colocar a pólvora primeiro.</span>"
	else if (istype(W, /obj/item/weapon/reagent_containers))
		if (gunpowder)
			user << "<span class='notice'>[src] já está carregada com pólvora</span>"
			return
		else if (!W.reagents.has_reagent("gunpowder",1))
			user << "<span class = 'notice'>Você precisa de pólvora suficiente em um recipiente de pólvora em suas mãos para encher [src].</span>"
			return
		else
			user << "<span class='notice'>Você começa a colocar pólvora no [src]...</span>"
			if (do_after(user, 100, src, can_move = TRUE))
				if (gunpowder == FALSE)
					if (W.reagents.has_reagent("gunpowder",1))
						user << "<span class='notice'>Você termina de colocar pólvora no [src].</span>"
						W.reagents.remove_reagent("gunpowder",1)
						gunpowder = TRUE
						return
					else
						user << "<span class = 'notice'>Você precisa de pólvora suficiente em um recipiente de pólvora em suas mãos para encher o [src].</span>"
						return
	else
		..()

/obj/item/weapon/gun/projectile/ancient/special_check(mob/user)
	if (ishuman(user))
		var/mob/living/human/H = user
		if (H.faction_text == INDIANS)
			user << "<span class='warning'>Você não sabe como usar isso.</span>"
			return FALSE
	if (!gunpowder)
		user << "<span class='warning'>Você não pode atirar com o [src] sem pólvora!</span>"
		return FALSE
	if (!bullet)
		user << "<span class='warning'>Você não pode atirar com o [src] sem munição!</span>"
		return FALSE
	if (!lighted && !istype(src, /obj/item/weapon/gun/projectile/ancient/matchlock) && (/obj/item/weapon/gun/projectile/ancient/tanegashima))
		user << "<span class='warning'>Você não pode atirar com o [src] sem ascender!</span>"
		return FALSE
	if (!(user.has_empty_hand(both = FALSE)) && istype(src, /obj/item/weapon/gun/projectile/ancient/matchlock) && (/obj/item/weapon/gun/projectile/ancient/tanegashima))
		user << "<span class='warning'>Você precisa de duas mãos para atirar com o [src]!</span>"
		return FALSE
	return ..()

/obj/item/weapon/gun/projectile/ancient/unload_ammo(mob/user, var/allow_dump=1)
	return
	// you cant, sorry
	..()

/obj/item/weapon/gun/projectile/ancient/handle_post_fire()
	..()
	loaded = list()
	chambered = null
	gunpowder = FALSE
	lighted = FALSE
	bullet = FALSE
	if (istype(src, /obj/item/weapon/gun/projectile/ancient/firelance))
		icon_state = "firelance0"
	if (istype(src, /obj/item/weapon/gun/projectile/ancient/matchlock))
		icon_state = "matchlock"
	if (istype(src, /obj/item/weapon/gun/projectile/ancient/tanegashima))
		icon_state = "tanegashima"
	spawn (1)
		new/obj/effect/effect/smoke/chem(get_step(src, dir))
	spawn (5)
		new/obj/effect/effect/smoke/chem(get_step(src, dir))
	spawn (12)
		new/obj/effect/effect/smoke/chem(get_step(src, dir))