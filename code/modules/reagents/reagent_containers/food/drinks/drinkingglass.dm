/obj/item/weapon/reagent_containers/food/drinks/drinkingglass
	name = "drinking glass"
	desc = "A standard drinking glass."
	icon_state = "glass-highball"
	amount_per_transfer_from_this = 5
	volume = 30
	center_of_mass = list("x"=16, "y"=10)
	var/glass_type = "highball"
	var/salted = FALSE
	var/umbrella = null
	var/cocktail_food = null
	var/image/fluid_image

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/New()
	..()
	fluid_image = image('icons/obj/drinks.dmi', "fluid-[glass_type]")
	update_icon()

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/on_reagent_change()
	update_icon()

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/update_icon()
	overlays = null
	if (umbrella)
		var/umbrella_icon = icon('icons/obj/drinks.dmi', "[glass_type]-umbrella[umbrella]")
		overlays += image("icon" = umbrella_icon, "layer" = FLOAT_LAYER - 1)
	if (cocktail_food)
		var/cocktail_food_icon = icon('icons/obj/drinks.dmi', "[glass_type]-[cocktail_food]")
		overlays += image("icon" = cocktail_food_icon, "layer" = FLOAT_LAYER - 1)
	if (salted)
		var/salted_icon = icon('icons/obj/drinks.dmi', "[glass_type]-salted")
		overlays += image("icon" = salted_icon, "layer" = FLOAT_LAYER)
	if (reagents.total_volume == FALSE)
		return
	if (reagents.total_volume > 0)
		if (!fluid_image)
			fluid_image = image('icons/obj/drinks.dmi', "fluid-[glass_type]")
		fluid_image.color = reagents.get_color()
		overlays += fluid_image
	if (reagents.has_reagent("beer", 1) && istype(src, /obj/item/weapon/reagent_containers/food/drinks/drinkingglass/beermug))
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "[icon_state]-10")
		if (reagents.total_volume > 1)		filling.icon_state = "[icon_state]--10"
		if (reagents.total_volume > 10) 	filling.icon_state = "[icon_state]-10"
		if (reagents.total_volume > 20)	filling.icon_state = "[icon_state]-20"
		if (reagents.total_volume > 30)	filling.icon_state = "[icon_state]-30"
		if (reagents.total_volume == 40)
			filling.icon_state = "[icon_state]-40"
			var/image/froth = image('icons/obj/reagentfillings.dmi', src, "beermug_overlay", layer + 0.1)
			overlays += froth
		filling.color = reagents.get_color()
		overlays += filling
		return
	if (reagents.has_reagent("beer", 1) && istype(src, /obj/item/weapon/reagent_containers/food/drinks/drinkingglass/beermug_fancy))
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "[icon_state]-10")
		if (reagents.total_volume > 1)		filling.icon_state = "[icon_state]--10"
		if (reagents.total_volume > 10) 	filling.icon_state = "[icon_state]-10"
		if (reagents.total_volume > 20)	filling.icon_state = "[icon_state]-20"
		if (reagents.total_volume > 30)	filling.icon_state = "[icon_state]-30"
		if (reagents.total_volume > 40)	filling.icon_state = "[icon_state]-40"
		if (reagents.total_volume == 50)
			filling.icon_state = "[icon_state]-50"
			var/image/froth = image('icons/obj/reagentfillings.dmi', src, "beermug_fancy_overlay", layer + 0.1)
			overlays += froth
		filling.color = reagents.get_color()
		overlays += filling
		return

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/cocktail_stuff))
		if (umbrella || cocktail_food)
			user << "<span class='warning'>There's not enough room to add [W.name]!</span>"
			return
		user << "<span class='notice'>You add [W.name] to [name].</span>"
		if (istype(W, /obj/item/cocktail_stuff/maraschino_cherry))
			cocktail_food = "cherry"
		else if (istype(W, /obj/item/cocktail_stuff/cocktail_olive))
			cocktail_food = "olive"
		else if (istype(W, /obj/item/cocktail_stuff/celery))
			cocktail_food = "celery"
		qdel(W)
		update_icon()
		return
	else if (W && W.reagents && istype(W, /obj/item/weapon/reagent_containers) && W.is_open_container() && W.reagents.has_reagent("sodiumchloride"))
		if (salted)
			user << "<span class='warning'>The rim of [name] is already salted!</span>"
			return
		else if (W.reagents.get_reagent_amount("sodiumchloride") >= 5)
			user << "<span class='notice'>You salt the rim of [name].</span>"
			W.reagents.remove_reagent("sodiumchloride", 5)
			salted = TRUE
			update_icon()
			return
		else
			user << "<span class='warning'>There's not enough salt in [W.name] to salt the rim!</span>"
			return
	else
		return ..()

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/attack_self(mob/user as mob)
	var/mob/living/human/H = user
	var/list/actions = list()

	if (cocktail_food)
		actions += "Remove the [cocktail_food]"
	if (!actions.len)
		user << "<span class='warning'>You can't think of anything to do with the glass.</span>"
		return

	var/action = input(user, "What do you want to do with [src]?") as null|anything in actions
	switch(action)
		if ("Remove the cherry")
			new /obj/item/cocktail_stuff/maraschino_cherry(H.loc)
			cocktail_food = null
		if ("Remove the olive")
			new /obj/item/cocktail_stuff/cocktail_olive(H.loc)
			cocktail_food = null
		if ("Remove the celery")
			new /obj/item/cocktail_stuff/celery(H.loc)
			cocktail_food = null
	update_icon()
	return

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/shot
	name = "shot glass"
	icon_state = "glass-shot"
	glass_type = "shot"
	amount_per_transfer_from_this = 15
	volume = 15

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/lowball
	name = "lowball glass"
	icon_state = "glass-lowball"
	glass_type = "lowball"
	volume = 30

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/cocktail
	name = "cocktail glass"
	icon_state = "glass-cocktail"
	glass_type = "cocktail"
	volume = 20

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/beermug
	name = "beer mug"
	icon_state = "beermug"
	glass_type = "beermug"
	volume = 40
/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/beermug_fancy
	name = "fancy beer mug"
	icon_state = "beermug_fancy"
	glass_type = "beermug_fancy"
	volume = 50

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/wine
	name = "wine glass"
	icon_state = "glass-wine"
	glass_type = "wine"
	volume = 30

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/flute
	name = "flute glass"
	icon_state = "glass-flute"
	glass_type = "flute"
	volume = 20

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/wood
	name = "wood mug"
	icon_state = "wood_cup"
	glass_type = "mug"
	volume = 40
	flammable = TRUE

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/tankard
	name = "tankard"
	icon_state = "tankard"
	glass_type = "mug"
	volume = 40
	flammable = FALSE

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/waterskin
	name = "waterskin"
	desc = "A leather waterskin."
	icon = 'icons/obj/storage.dmi'
	icon_state = "waterskin"
	glass_type = "waterskin"
	slot_flags = SLOT_ID
	w_class = ITEM_SIZE_SMALL
	volume = 70
	flammable = TRUE

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/waterskin/cognac
	name = "cognac skin"
	desc = "A leather for holding your cognac reserves."
	New()
		..()
		reagents.add_reagent("cognac", 70)
/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/waterskin/tea
	name = "tea skin"
	desc = "A leather skin for holding your tea reserves."
	New()
		..()
		reagents.add_reagent("tea", 70)
/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/waterskin/mush
	name = "Fermented mush"
	desc = "A leather skin for holding your personal blend of fermented mush for use as a painkiller or as a great party drink."
	New()
		..()
		reagents.add_reagent("thirteenloko", 70)

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/mug
	name = "mug"
	desc = "A clay mug."
	icon_state = "mug"
	glass_type = "mug"
	volume = 30
	center_of_mass = list("x"=15, "y"=13)

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/mug/red
	name = "mug"
	desc = "A clay mug, this one is red."
	icon_state = "r_mug"
	glass_type = "mug"
	volume = 30
	center_of_mass = list("x"=15, "y"=13)

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/mug/brit
	name = "mug"
	desc = "A cup with the British flag emblazoned on it."
	icon_state = "brit_mug"
	volume = 30
	center_of_mass = list("x"=15, "y"=13)

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/tribalpot
	name = "tribal pot"
	desc = "A tribal clay pot."
	icon = 'icons/misc/tribal.dmi'
	icon_state = "tribalpot"
	glass_type = "pot"
	volume = 60

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/amphora
	name = "amphora"
	desc = "A clay amphora."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "amphora"
	glass_type = "amphora"
	volume = 150

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/amphora/wine
	name = "amphora of wine"
	New()
		..()
		reagents.add_reagent("wine", 120)
/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/amphora/water
	name = "amphora of water"
	New()
		..()
		reagents.add_reagent("water", 150)
/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/tribalpot/palmsap
	name = "tribal pot"
	desc = "A tribal clay pot."
	icon = 'icons/misc/tribal.dmi'
	icon_state = "tribalpot"
	glass_type = "pot"
	volume = 60

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/tribalpot/palmsap/New()
	..()
	name = "tribal pot with sap"
	desc = "A tribal pot filled with palm sap. Wait until it ferments to produce palm wine."
	volume = 0
	icon_state = "tribalpot_sap"
	spawn(1200)
		if (!src || !reagents)
			return
		name = "tribal pot"
		icon_state = "tribalpot"
		desc = "A tribal clay pot."
		volume = 60
		reagents.add_reagent("palmwine", 15)
		visible_message("The palm sap ferments into palm wine.")
		return


/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/soda
	New()
		..()
		on_reagent_change()