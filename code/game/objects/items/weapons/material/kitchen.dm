/obj/item/weapon/material/kitchen
	icon = 'icons/obj/kitchen.dmi'

/*
 * Utensils
 */
/obj/item/weapon/material/kitchen/utensil
	w_class = ITEM_SIZE_TINY
	thrown_force_divisor = TRUE
	attack_verb = list("atacou", "perfurou", "cutucou")
	sharp = TRUE
	edge = TRUE
	force_divisor = 0.1 // 6 when wielded with hardness 60 (steel)
	thrown_force_divisor = 0.25 // 5 when thrown with weight 20 (steel)
	var/loaded	  //Descriptive string for currently loaded food object.
	var/scoop_food = TRUE
	var/shiv = 0
	var/usespeed = 0.2


/obj/item/weapon/material/kitchen/utensil/New()
	..()
	if (prob(60))
		pixel_y = rand(0, 4)
	create_reagents(5)
	return

/obj/item/weapon/material/kitchen/utensil/attack(mob/living/human/M as mob, mob/living/human/user as mob)
	if (!istype(M))
		return ..()

	if (user.a_intent != I_HELP || !scoop_food)
		if (user.targeted_organ == "eyes")
			return eyestab(M,user)
		else if (user.targeted_organ == "head" && (sharp || edge) && ishuman(M))
			M.resolve_item_attack(src, user, user.targeted_organ)
		else
			return ..()

	if (reagents.total_volume > 0)
		reagents.trans_to_mob(M, reagents.total_volume, CHEM_INGEST)
		if (M == user)
			if (!M.can_eat(loaded))
				return
			else if (M.get_fullness() > 580)
				user << "<span class='danger'>Você não pode forçar mais comida a descer pela sua garganta.</span>"
				return
			M.visible_message("<span class='notice'>\The [user] comeu [loaded] do \the [src].</span>")
		else
			user.visible_message("<span class='warning'>\The [user] começa a alimentar \the [M]!</span>")
			if (!(M.can_force_feed(user, loaded) && do_mob(user, M, 5 SECONDS)))
				return
			else if (M.get_fullness() > 580)
				user << "<span class='danger'>Você não pode forçar mais comida a descer a garganta de [M]'s.</span>"
				return
			M.visible_message("<span class='notice'>\The [user] alimenta [loaded] para \the [M] with \the [src].</span>")
		playsound(M.loc,'sound/items/eatfood.ogg', rand(10,40), TRUE)
		overlays.Cut()
		return
	else
		user << "<span class='warning'>Você não tem nada em \the [src].</span>"	//if we have help intent and no food scooped up DON'T STAB OURSELVES WITH THE FORK
		return

/obj/item/weapon/material/kitchen/utensil/fork
	name = "garfo"
	desc = "É um garfo. com certeza é pontiagudo."
	icon_state = "fork"

/obj/item/weapon/material/kitchen/utensil/chopsticks
	name = "pauzinhos"
	desc = "É um par de pauzinhos. Wan' sum rice muhda fukka?"
	icon_state = "chopsticks"
	material = "wood"
	applies_material_colour = FALSE
/obj/item/weapon/material/kitchen/utensil/spoon
	name = "colher"
	desc = "É uma colher. Você pode ver seu próprio rosto de cabeça para baixo nele."
	icon_state = "spoon"
	attack_verb = list("atacou", "cutucou")
	edge = FALSE
	sharp = FALSE
	force_divisor = 0 //no dmg. no more memes
/*
 * Knives
 */
#define SLASH 1
#define STAB 2
#define BASH 3

/obj/item/weapon/material/kitchen/utensil/knife
	name = "faca"
	desc = "Uma faca para comer. Pode cortar qualquer alimento."
	icon_state = "knife"
	force_divisor = 0.1 // 6 when wielded with hardness 60 (steel)
	scoop_food = FALSE
	slot_flags = SLOT_BELT|SLOT_POCKET//|SLOT_MASK
	edge = TRUE
	sharp = TRUE
	var/atk_mode = SLASH
	var/suicide = FALSE // for the hari kiri action

/obj/item/weapon/material/kitchen/utensil/knife/proc/handle_suicide(mob/living/user)
	..()
	if (!ishuman(user))
		return
	var/mob/living/human/M = user
	suicide = TRUE
	M.visible_message("<span class = 'red'>[user] enfiou [M.gender == FEMALE ? "ela" : "ele"] [src] no [M.gender == FEMALE ? "ela" : "ele"] intestino.</span>")
	if (!do_after(user, 60))
		M.visible_message("<span class = 'notice'>[user] falhou em cometer suicídio.</span>")
		suicide = FALSE
		return
	else
		user << "<span class = 'notice'>Ow...</span>"
		user.apply_effect(110,AGONY,0)
		user.apply_damage(src.sharpness*2.5, "brute", "groin")
		user.death()
		user.visible_message("<span class = 'warning'>[user] corta-se aberto.</span>")
		M.attack_log += "\[[time_stamp()]\] [M]/[M.ckey]</b> estriparam-se."
		suicide = FALSE

/obj/item/weapon/material/kitchen/utensil/knife/attack(atom/A, mob/living/user, target_zone)
	if (A == user)
		if (target_zone == "groin" && !suicide)
			handle_suicide(user)
			return TRUE
	return ..(A, user, target_zone)

/obj/item/weapon/material/kitchen/utensil/knife/razorblade
	name = "lâmina de barbear"
	desc = "Uma lâmina dobrável, usada para cortar barba e cabelos."
	icon = 'icons/obj/items.dmi'
	icon_state = "razorblade"
	item_state = "knife"
	force_divisor = 0.2
	w_class = ITEM_SIZE_TINY

/obj/item/weapon/material/kitchen/utensil/knife/attack_self(mob/user)
	..()
	if(atk_mode == SLASH)
		atk_mode = STAB
		user << "<span class='notice'>Agora você vai esfaquear.</span>"
		edge = FALSE
		sharp = TRUE
		attack_verb = list("esfaqueia")
		hitsound = "stab_sound"
		return

	else if(atk_mode == STAB)
		atk_mode = SLASH
		user << "<span class='notice'>Agora você vai cortar.</span>"
		attack_verb = list("cortou")
		hitsound = "slash_sound"
		edge = TRUE
		sharp = TRUE
		return

/obj/item/weapon/material/kitchen/utensil/knife/razorblade/attack(mob/living/human/M as mob, mob/living/user as mob)
	if (user.a_intent == I_DISARM && user.targeted_organ == "head" && (M in range(user,1) || M == user) && ishuman(M) && ishuman(user))
		visible_message("[user] starts cutting [M]'s hair...","você começa a cortar o cabelo de [M]'s ...")
		if (do_after(user, 80, M))
			var/list/hairlist = M.generate_valid_hairstyles(1,1)
			var/new_hstyle = WWinput(usr, "Selecione um estilo de cabelo.", "Asseio", WWinput_first_choice(hairlist), WWinput_list_or_null(hairlist))
			if (new_hstyle)
				M.h_style = new_hstyle
				for (var/hairstyle in hair_styles_list)
					var/datum/sprite_accessory/S = hair_styles_list[hairstyle]
					if (S.name == M.h_style)
						M.h_growth = S.growth
			if (M.gender == MALE)
				var/list/fhairlist = M.generate_valid_facial_hairstyles(1,1)
				var/new_fstyle = WWinput(usr, "Por favor, selecione um estilo de barba.", "Asseio", WWinput_first_choice(fhairlist), WWinput_list_or_null(fhairlist))
				if (new_fstyle)
					M.f_style = new_fstyle
					for (var/hairstyle in facial_hair_styles_list)
						var/datum/sprite_accessory/S = facial_hair_styles_list[hairstyle]
						if (S.name == M.f_style)
							M.f_growth = S.growth
			M.update_hair()
			M.update_body()
			visible_message("[user] acabou de cortar o cabelo de [M]'s .","Você terminou de cortar o cabelo de [M]'s .")
			return
	else
		return ..()

/obj/item/weapon/material/kitchen/utensil/knife/shank
	name = "haste"
	desc = "Uma pequena faca caseira usada muito na prisão."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "steelshank"
	item_state = "knife"
	applies_material_colour = FALSE
	unbreakable = FALSE
	drawsound = 'sound/items/unholster_knife.ogg'
	force_divisor = 0.4
	default_material = "steel"

/obj/item/weapon/material/kitchen/utensil/knife/shank/glass
	name = "haste"
	icon_state = "glassshank"
	force_divisor = 0.45
	default_material = "glass"

/obj/item/weapon/material/kitchen/utensil/knife/shank/iron
	name = "haste"
	icon_state = "ironshank"
	force_divisor = 0.4
	default_material = "iron"
/obj/item/weapon/material/kitchen/utensil/knife/shank/wood
	name = "haste"
	icon_state = "woodshank"
	applies_material_colour = FALSE
	force_divisor = 0.35
	default_material = "wood"

/obj/item/weapon/material/kitchen/utensil/knife/bowie
	name = "faca bowie"
	desc = "Uma faca Bowie bastante grande."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "bowie_knife"
	item_state = "knife"
	applies_material_colour = FALSE
	unbreakable = TRUE
	drawsound = 'sound/items/unholster_knife.ogg'
	force_divisor = 0.6

/obj/item/weapon/material/kitchen/utensil/knife/bowie/iron
	default_material = "iron"

/obj/item/weapon/material/kitchen/utensil/knife/dagger
	name = "punhal"
	desc = "Uma faca longa, afiada e semelhante a uma espada que é usada para combate corpo a corpo."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "dagger"
	item_state = "knife"
	applies_material_colour = FALSE
	unbreakable = TRUE
	drawsound = 'sound/items/unholster_knife.ogg'
	force_divisor = 0.75

/obj/item/weapon/material/kitchen/utensil/knife/dagger/iron
	default_material = "iron"

/obj/item/weapon/material/kitchen/utensil/knife/switchblade
	name = "canivete"
	desc = "Uma faca afiada, ocultável e com mole."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "switchblade"
	item_state = null
	applies_material_colour = FALSE
	unbreakable = TRUE
	hitsound = null
	attack_verb = list("afagou", "tocou")
	force_divisor = 0.05
	w_class = ITEM_SIZE_SMALL
	throwforce = 0
	throw_speed = 3
	throw_range = 5
	secondary_action = TRUE
	drawsound = 'sound/weapons/hiddenblade_deploy.ogg'
	var/active = FALSE

/obj/item/weapon/material/kitchen/utensil/knife/switchblade/update_icon()
	if(active)
		icon_state = "switchblade_open"
		item_state = "knife"
	else
		icon_state = "switchblade"
		item_state = null

/obj/item/weapon/material/kitchen/utensil/knife/switchblade/update_force()
	..()
	if(active)
		edge = TRUE
		sharp = TRUE
		throwforce = 5
		hitsound = 'sound/weapons/bladeslice.ogg'
		w_class = ITEM_SIZE_NORMAL
		force_divisor = 0.7
		attack_verb = list("atacou", "cortou", "perfurou", "fatiou", "rasgou", "cortou")
	else
		edge = FALSE
		sharp = FALSE
		hitsound = initial(hitsound)
		w_class = initial(w_class)
		force_divisor = initial(force_divisor)
		attack_verb = initial(attack_verb)

/obj/item/weapon/material/kitchen/utensil/knife/switchblade/secondary_attack_self(mob/living/human/user)
	if(!active)
		visible_message("<span class='warning'>Com um simples toque, [user] estende a lâmina em sua faca canivete.</span>", 3)
		playsound(loc, 'sound/weapons/switchblade.ogg', 15, 1)
		active = TRUE
	else
		visible_message("<span class='notice'>\The [user] retrai a lâmina em seu canivete.</span>", 3)
		active = FALSE
	update_force()
	update_icon()
	add_fingerprint(user)

/obj/item/weapon/material/kitchen/utensil/knife/fancy
	name = "faca chique"
	desc = "Uma faca cara."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "fancyknife"
	item_state = "knife"
	applies_material_colour = FALSE
	unbreakable = TRUE
	drawsound = 'sound/items/unholster_knife.ogg'
	force_divisor = 0.3

/obj/item/weapon/material/kitchen/utensil/knife/fancy/silver
	default_material = "silver"

/obj/item/weapon/material/kitchen/utensil/knife/trench
	name = "faca de trincheira"
	desc = "Uma faca bastante grande."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "trenchknife"
	item_state = "knife"
	applies_material_colour = FALSE
	unbreakable = TRUE
	drawsound = 'sound/items/unholster_knife.ogg'
	force_divisor = 0.7

/obj/item/weapon/material/kitchen/utensil/knife/trench/iron
	default_material = "iron"

/obj/item/weapon/material/kitchen/utensil/knife/meat
	name = "faca de carne"
	desc = "Uma faca bastante média."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "meatknife"
	item_state = "knife"
	applies_material_colour = FALSE
	unbreakable = TRUE
	drawsound = 'sound/items/unholster_knife.ogg'
	force_divisor = 0.4

/obj/item/weapon/material/kitchen/utensil/knife/shaggers
	name = "faca shagger"
	desc = "Uma faca improvisada malfeita pelo pessoal do gueto."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "shagger"
	item_state = "knife"
	applies_material_colour = FALSE
	unbreakable = TRUE
	drawsound = 'sound/items/unholster_knife.ogg'
	force_divisor = 0.4

/obj/item/weapon/material/kitchen/utensil/knife/fish
	name = "faca de peixe"
	desc = "Uma faca bastante média."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "fishknife"
	item_state = "knife"
	applies_material_colour = FALSE
	unbreakable = TRUE
	drawsound = 'sound/items/unholster_knife.ogg'
	force_divisor = 0.5

/obj/item/weapon/material/kitchen/utensil/knife/fish/silver
	default_material = "silver"

/obj/item/weapon/material/kitchen/utensil/knife/tacticalknife
	name = "faca tática"
	desc = "Uma faca bastante tática."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "tacticalknife"
	item_state = "knife"
	applies_material_colour = FALSE
	unbreakable = TRUE
	drawsound = 'sound/items/unholster_knife.ogg'
	force_divisor = 0.6

/obj/item/weapon/material/kitchen/utensil/knife/blackknife
	name = "faca preta"
	desc = "Uma faca bastante grande."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "blackknife"
	item_state = "knife"
	applies_material_colour = FALSE
	unbreakable = TRUE
	drawsound = 'sound/items/unholster_knife.ogg'
	force_divisor = 0.6

/obj/item/weapon/material/kitchen/utensil/knife/military
	name = "faca militar"
	desc = "Uma faca bastante grande."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "militaryknife"
	item_state = "knife"
	applies_material_colour = FALSE
	unbreakable = TRUE
	drawsound = 'sound/items/unholster_knife.ogg'
	force_divisor = 0.9

/obj/item/weapon/material/kitchen/utensil/knife/military/iron
	default_material = "iron"

/obj/item/weapon/material/kitchen/utensil/knife/shadowdagger
	name = "punhal de sombra"
	desc = "Uma faca tática."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "smolknife"
	item_state = "knife"
	applies_material_colour = FALSE
	unbreakable = TRUE
	drawsound = 'sound/items/unholster_knife.ogg'
	force_divisor = 0.6

/obj/item/weapon/material/kitchen/utensil/knife/shadowdaggersal
	name = "punhal de sombra"
	desc = "Uma faca tática."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "salamon"
	item_state = "knife"
	applies_material_colour = FALSE
	unbreakable = TRUE
	drawsound = 'sound/items/unholster_knife.ogg'
	force_divisor = 0.6

/obj/item/weapon/material/kitchen/utensil/knife/bread
	name = "Faca de pão"
	desc = "Uma faca bastante grande, hehe."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "breadknife"
	item_state = "knife"
	applies_material_colour = FALSE
	unbreakable = TRUE
	drawsound = 'sound/items/unholster_knife.ogg'
	force_divisor = 0.2

/obj/item/weapon/material/kitchen/utensil/knife/survival
	name = "faca de sobrevivência"
	desc = "Uma pequena faca de sobrevivência compacta, boa para ser usada em selva quando seu avião cai e ninguem alem de você sobrevive."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "survivalknife"
	item_state = "knife"
	applies_material_colour = FALSE
	unbreakable = TRUE
	drawsound = 'sound/items/unholster_knife.ogg'
	force_divisor = 0.3

/obj/item/weapon/material/kitchen/utensil/knife/bone
	name = "faca de osso tribal"
	desc = "Uma pequena faca com lâmina de osso e cabo estriado."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "boneknife"
	item_state = "knife"
	applies_material_colour = FALSE
	unbreakable = TRUE
	drawsound = 'sound/items/unholster_knife.ogg'
	force_divisor = 0.1
	default_material = "bone"

/obj/item/weapon/material/kitchen/utensil/knife/bone/New()
	..()
	name = "bone knife"

/obj/item/weapon/material/kitchen/utensil/knife/circumcision
	name = "faca de circuncisão"
	desc = "Uma pequena faca com cabo de osso, usada para realizar circuncisões, ou como popularmente é chamado, tirar a capa do menino.."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "circumcision"
	item_state = "knife"
	applies_material_colour = FALSE
	unbreakable = TRUE
	drawsound = 'sound/items/unholster_knife.ogg'
	force_divisor = 0.1

/obj/item/weapon/material/kitchen/utensil/knife/circumcision/New()
	..()
	name = "circumcision knife"

/obj/item/weapon/material/kitchen/utensil/knife/circumcision/attack(target as mob, mob/living/user as mob)
	if (istype(target, /mob/living/human))
		var/mob/living/human/H = target
		if (user.a_intent == I_HELP && H.gender == MALE)
			if (H.circumcised)
				user << "<span class = 'notice'>[H] já é circuncidado!</span>"
				return
			else
				visible_message("<span class = 'notice'>[user] começa a circuncidar [H]...</span>")
				if (do_after(user, 90, H) && !H.circumcised)
					visible_message("<span class = 'notice'>[user] circuncida com sucesso [H].</span>")
					H.circumcised = TRUE
					return
				else
					return ..()
		else
			return ..()
	else
		return ..()

/obj/item/weapon/material/kitchen/utensil/knife/attack(target as mob, mob/living/user as mob)
	return ..()

/obj/item/weapon/material/kitchen/utensil/knife/iron
	default_material = "iron"

/obj/item/weapon/material/kitchen/utensil/knife/bronze
	default_material = "bronze"

/obj/item/weapon/material/kitchen/utensil/knife/steel
	default_material = "steel"

/obj/item/weapon/material/kitchen/utensil/knife/wood
	default_material = "wood"

/obj/item/weapon/material/kitchen/utensil/knife/hook
	name = "gancho de açougue"
	desc = "Um gancho de metal afiado que se prende nas coisas."
	icon_state = "hook_knife"
	item_state = "hook_knife"

/obj/item/weapon/material/kitchen/utensil/knife/butcher
	name = "cutelo de açougueiro"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "butch"
	desc = "Uma enorme faca usada para cortar e picar carne."
	edge = FALSE
	force_divisor = 0.25 // 15 when wielded with hardness 60 (steel)
	attack_verb = list("cleaved", "slashed", "sliced", "torn", "ripped", "diced", "cut")
	drawsound = 'sound/items/unholster_knife.ogg'
	unbreakable = TRUE

/obj/item/weapon/material/kitchen/utensil/knife/tanto
	name = "tanto"
	desc = "Uma faca usada pelos japoneses há séculos. Feito para cortar e cortar, não cortar ou serrar. Muitas vezes, a ferramenta de escolha para o suicídio ritualístico."
	icon_state = "tanto"
	item_state = "tanto"
	block_chance = 10
	force_divisor = 0.4 // 42 when wielded with hardnes 60 (steel)
	thrown_force_divisor = 0.8 // 10 when thrown with weight 20 (steel)
	value = 60
	cooldownw = 6



/*
 * Rolling Pins
 */

/obj/item/weapon/material/kitchen/rollingpin
	name = "rolo de massa"
	desc = "Usado para nocautear o Barman."
	icon_state = "rolling_pin"
	attack_verb = list("espanca")
	default_material = "wood"
	force_divisor = 0.7 // 10 when wielded with weight 15 (wood)
	thrown_force_divisor = TRUE // as above
	hitsound = "swing_hit"
	flammable = TRUE
/obj/item/weapon/material/kitchen/rollingpin/attack(mob/living/M as mob, mob/living/user as mob)
	return ..()
