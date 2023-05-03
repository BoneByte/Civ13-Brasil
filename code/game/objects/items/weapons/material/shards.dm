// Glass shards

/obj/item/weapon/material/shard
	name = "shard"
	icon = 'icons/obj/shards.dmi'
	desc = "Made of nothing. How does this even exist?" // set based on material, if this desc is visible it's a bug (shards default to being made of glass)
	icon_state = "large"
	sharp = TRUE
	edge = TRUE
	w_class = ITEM_SIZE_SMALL
	force_divisor = 0.2 // 6 with hardness 30 (glass)
	thrown_force_divisor = 0.4 // 4 with weight 15 (glass)
	item_state = "shard-glass"
	attack_verb = list("stabbed", "slashed", "sliced", "cut")
	default_material = "glass"
	unbreakable = TRUE //It's already broken.
	drops_debris = FALSE

/obj/item/weapon/material/shard/set_material(var/new_material)
	..(new_material)
	if (!istype(material))
		return

	icon_state = "[material.shard_icon][pick("large", "medium", "small")]"
	pixel_x = rand(-8, 8)
	pixel_y = rand(-8, 8)
	update_icon()

	if (material.shard_type)
		name = "[material.display_name] [material.shard_type]"
		desc = "A small piece of [material.display_name]. It looks sharp, you wouldn't want to step on it barefoot. Could probably be used as ... a throwing weapon?"
		switch(material.shard_type)
			if (SHARD_SPLINTER, SHARD_SHRAPNEL)
				gender = PLURAL
			else
				gender = NEUTER
	else
		qdel(src)

/obj/item/weapon/material/shard/update_icon()
	if (material)
		color = material.icon_colour
		// TRUE-(1-x)^2, so that glass shards with 0.3 opacity end up somewhat visible at 0.51 opacity
		alpha = 255 * (1 - (1 - material.opacity)*(1 - material.opacity))
	else
		color = "#ffffff"
		alpha = 255


/obj/item/weapon/material/shard/Crossed(AM as mob|obj)
	..()
	if (isliving(AM))
		var/mob/M = AM

		if (M.buckled) //wheelchairs, office chairs, rollerbeds
			return

		playsound(loc, 'sound/effects/glass_step.ogg', 50, TRUE) // not sure how to handle metal shards with sounds
		if (ishuman(M))
			var/mob/living/human/H = M

			if (H.species.siemens_coefficient<0.5) //Thick skin.
				return

			if ( H.shoes || ( H.wear_suit && (H.wear_suit.body_parts_covered & FEET) ) )
				return

			M << "<span class='danger'>You step on \the [src]!</span>"

			var/list/check = list("l_foot", "r_foot")
			while (check.len)
				var/picked = pick(check)
				var/obj/item/organ/external/affecting = H.get_organ(picked)
				if (affecting)
					if (affecting.take_damage(5, FALSE))
						H.UpdateDamageIcon()
					H.updatehealth()
					if (!(H.species.flags & NO_PAIN))
						H.Weaken(3)
					return
				check -= picked
			return

// Preset types - left here for the code that uses them
/obj/item/weapon/material/shard/shrapnel/New(loc)
	..(loc, "steel")

/obj/item/weapon/material/shard/glass
/obj/item/weapon/material/shard/glass/New(loc) //why doesn't this exist before?
	..(loc, "glass")

/obj/item/weapon/material/shard/obsidian/New(loc) // all it is, is volcanic glass
	..(loc, "obsidian")