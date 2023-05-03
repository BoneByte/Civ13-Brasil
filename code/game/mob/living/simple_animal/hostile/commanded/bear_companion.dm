/mob/living/simple_animal/hostile/commanded/bear
	name = "bear"
	desc = "A large brown bear."

	icon_state = "brownbear"
	icon_living = "brownbear"
	icon_dead = "brownbear_dead"
	icon_gib = "brownbear_gib"

	health = 75
	maxHealth = 75

	melee_damage_lower = 45
	melee_damage_upper = 55


	response_help = "pets"
	response_harm = "hits"
	response_disarm = "pushes"

	known_commands = list("stay", "stop", "attack", "follow")

/mob/living/simple_animal/hostile/commanded/bear/hit_with_weapon(obj/item/O, mob/living/user, var/effective_force, var/hit_zone)
	. = ..()
	if (!.)
		emote("roars in rage!")

/mob/living/simple_animal/hostile/commanded/bear/attack_hand(mob/living/human/M as mob)
	..()
	if (M.a_intent == I_HARM)
		emote("roars in rage!")