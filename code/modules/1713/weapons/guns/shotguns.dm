/obj/item/weapon/gun/projectile/shotgun
	maxhealth = 45
	gun_type = GUN_TYPE_SHOTGUN
	fire_sound = 'sound/weapons/guns/fire/shotgun.ogg'
	icon = 'icons/obj/guns/rifles.dmi'
	// 15% more accurate than SMGs
	equiptimer = 17
	magazine_type = /obj/item/ammo_magazine/shellbox
	accuracy_list = list(

		// small body parts: head, hand, feet
		"small" = list(
			SHORT_RANGE_STILL = 56,
			SHORT_RANGE_MOVING = 45,

			MEDIUM_RANGE_STILL = 45,
			MEDIUM_RANGE_MOVING = 36,

			LONG_RANGE_STILL = 16,
			LONG_RANGE_MOVING = 13,

			VERY_LONG_RANGE_STILL = 8,
			VERY_LONG_RANGE_MOVING = 7),

		// medium body parts: limbs
		"medium" = list(
			SHORT_RANGE_STILL = 68,
			SHORT_RANGE_MOVING = 54,

			MEDIUM_RANGE_STILL = 45,
			MEDIUM_RANGE_MOVING = 36,

			LONG_RANGE_STILL = 18,
			LONG_RANGE_MOVING = 15,

			VERY_LONG_RANGE_STILL = 10,
			VERY_LONG_RANGE_MOVING = 8),

		// large body parts: chest, groin
		"large" = list(
			SHORT_RANGE_STILL = 91,
			SHORT_RANGE_MOVING = 72,

			MEDIUM_RANGE_STILL = 68,
			MEDIUM_RANGE_MOVING = 54,

			LONG_RANGE_STILL = 45,
			LONG_RANGE_MOVING = 36,

			VERY_LONG_RANGE_STILL = 18,
			VERY_LONG_RANGE_MOVING = 15),
	)

	accuracy_increase_mod = 1.00
	accuracy_decrease_mod = 1.00
	KD_chance = KD_CHANCE_HIGH
	stat = "rifle"

	gtype = "shotgun"

/obj/item/weapon/gun/projectile/shotgun/pump
	name = "Pump-Action Shotgun"
	desc = "Uma espingarda com 12 balas"
	icon_state = "shotgun"
	item_state = "shotgun"
	max_shells = 6
	w_class = ITEM_SIZE_LARGE
	force = 10
	flags =  CONDUCT
	slot_flags = SLOT_SHOULDER
	caliber = "12gauge"
	load_method = SINGLE_CASING
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot
	handle_casings = HOLD_CASINGS
	stat = "rifle"
	move_delay = 4
	var/recentpump = FALSE // to prevent spammage
	load_delay = 5

/obj/item/weapon/gun/projectile/shotgun/pump/consume_next_projectile()
	if (chambered)
		return chambered.BB
	return null

/obj/item/weapon/gun/projectile/shotgun/pump/attack_self(mob/living/user as mob)
	if (world.time >= recentpump + 10)
		pump(user)
		recentpump = world.time

/obj/item/weapon/gun/projectile/shotgun/pump/proc/pump(mob/M as mob)
	playsound(M, 'sound/weapons/guns/interact/shotgun_pump.ogg', 60, TRUE)

	if (chambered)//We have a shell in the chamber
		chambered.loc = get_turf(src)//Eject casing
		chambered.randomrotation()
		chambered = null

	if (loaded.len)
		var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
		loaded -= AC //Remove casing from loaded list.
		chambered = AC

	update_icon()

/obj/item/weapon/gun/projectile/shotgun/coachgun
	name = "Coach Gun"
	desc = "Uma espingarda de cano duplo, comumente usada por mensageiros e em diligências."
	icon_state = "doublebarreled"
	item_state = "shotgun"
	max_shells = 2
	w_class = ITEM_SIZE_LARGE
	force = 10
	flags =  CONDUCT
	slot_flags = SLOT_SHOULDER
	caliber = "12gauge"
	load_method = SINGLE_CASING
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot
	handle_casings = HOLD_CASINGS
	stat = "rifle"
	move_delay = 4
	var/open = FALSE
	var/recentpump = FALSE // to prevent spammage
	load_delay = 5
	blackpowder = TRUE
/obj/item/weapon/gun/projectile/shotgun/coachgun/consume_next_projectile()
	if (chambered)
		return chambered.BB
	return null
/obj/item/weapon/gun/projectile/shotgun/coachgun/update_icon()
	..()
	if (open)
		icon_state = "doublebarreled_open"
	else
		icon_state = "doublebarreled"

/obj/item/weapon/gun/projectile/shotgun/coachgun/attack_self(mob/living/user as mob)
	if (world.time >= recentpump + 10)
		if (open)
			open = FALSE
			user << "<span class='notice'>Você fecha \o [src].</span>"
			icon_state = "doublebarreled"
			if (loaded.len)
				var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
				loaded -= AC //Remove casing from loaded list.
				chambered = AC
		else
			open = TRUE
			user << "<span class='notice'>Você quebra e abre \o [src].</span>"
			icon_state = "doublebarreled_open"
		recentpump = world.time

/obj/item/weapon/gun/projectile/shotgun/coachgun/load_ammo(var/obj/item/A, mob/user)
	if (!open)
		user << "<span class='notice'>Você precisa abrir \o [src] primeiro!</span>"
		return
	..()

/obj/item/weapon/gun/projectile/shotgun/coachgun/unload_ammo(mob/user, var/allow_dump=1)
	if (!open)
		user << "<span class='notice'>Você precisa abrir \o [src] primeiro!</span>"
		return
	..()

/obj/item/weapon/gun/projectile/shotgun/coachgun/special_check(mob/user)
	if (open)
		user << "<span class='warning'>Você não pode atirar enquanto \o [src] está aberto!</span>"
		return FALSE
	return ..()

/obj/item/weapon/gun/projectile/shotgun/coachgun/handle_post_fire()
	..()
	if (loaded.len)
		var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
		loaded -= AC //Remove casing from loaded list.
		chambered = AC
	if (blackpowder)
		spawn (1)
			new/obj/effect/effect/smoke/chem(get_step(src, dir))
		spawn (6)
			new/obj/effect/effect/smoke/chem(get_step(src, dir))


/obj/item/weapon/gun/projectile/shotgun/pump/remington870
	name = "Remington 870 Express"
	desc = "Uma espingarda, o que tem de inútil nela?."
	icon_state = "remington870"
	item_state = "remington"
	max_shells = 7
	slot_flags = SLOT_SHOULDER
	caliber = "12gauge"
	load_method = SINGLE_CASING
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot
	handle_casings = HOLD_CASINGS
	move_delay = 4
	load_delay = 5

/obj/item/weapon/gun/projectile/shotgun/pump/remington870/brown
	icon_state = "remington870_brown"
	item_state = "remington_brown"

/obj/item/weapon/gun/projectile/shotgun/pump/ks23
	name = "KS-23"
	desc = "Uma 'doze' sovietica, calibre 23mm"
	icon_state = "ks23"
	item_state = "ks23"
	max_shells = 4
	slot_flags = SLOT_SHOULDER
	caliber = "12gauge" // To be converted to 23mm when proper shotgun ammo is added
	load_method = SINGLE_CASING
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot
	handle_casings = HOLD_CASINGS
	move_delay = 4
	load_delay = 5

/obj/item/weapon/gun/projectile/shotgun/mts225
	name = "MTS-225"
	desc = "A Russian 6-cylinder revolver shotgun, used by Russian hunters."
	icon_state = "mts225"
	item_state = "shotgun"
	max_shells = 5
	w_class = ITEM_SIZE_LARGE
	force = 10
	flags =  CONDUCT
	slot_flags = SLOT_SHOULDER
	caliber = "12gauge"
	load_method = SINGLE_CASING
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot
	handle_casings = HOLD_CASINGS
	stat = "rifle"
	move_delay = 4
	var/open = FALSE
	var/recentpump = FALSE // to prevent spammage
	load_delay = 3
/obj/item/weapon/gun/projectile/shotgun/mts225/consume_next_projectile()
	if (chambered)
		return chambered.BB
	return null
/obj/item/weapon/gun/projectile/shotgun/mts225/update_icon()
	..()
	if (open)
		icon_state = "mts225_open"
	else
		icon_state = "mts225"

/obj/item/weapon/gun/projectile/shotgun/mts225/attack_self(mob/living/user as mob)
	if (world.time >= recentpump + 10)
		if (open)
			open = FALSE
			user << "<span class='notice'>Você coloca o cilindro de volta \no [src].</span>"
			icon_state = "mts225"
			if (loaded.len)
				var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
				loaded -= AC //Remove casing from loaded list.
				chambered = AC
		else
			open = TRUE
			user << "<span class='notice'>Você retira o cilindro do [src].</span>"
			icon_state = "mts225_open"
		recentpump = world.time

/obj/item/weapon/gun/projectile/shotgun/mts225/load_ammo(var/obj/item/A, mob/user)
	if (!open)
		user << "<span class='notice'>Você precisa retirar o cilindro do [src] primeiro!</span>"
		return
	..()

/obj/item/weapon/gun/projectile/shotgun/coachgun/unload_ammo(mob/user, var/allow_dump=1)
	if (!open)
		user << "<span class='notice'>Você precisa retirar o cilindro do [src] primeiro!</span></span>"
		return
	..()

/obj/item/weapon/gun/projectile/shotgun/mts225/special_check(mob/user)
	if (open)
		user << "<span class='warning'>Você não pode atirar enquanto \o [src] não está com o cilindro fechado!</span>"
		return FALSE
	return ..()

/obj/item/weapon/gun/projectile/shotgun/mts225/handle_post_fire()
	..()
	if (loaded.len)
		var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
		loaded -= AC //Remove casing from loaded list.
		chambered = AC




