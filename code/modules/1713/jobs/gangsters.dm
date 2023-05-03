///////////BALLAS/////////////////

/datum/job/indian/flamengo
	title = "Torcedor Corinthiano"
	en_meaning = FALSE
	can_be_female = FALSE
	spawn_location = "JoinLateFL"
	selection_color = "#FF0000"
	is_gta = TRUE
	min_positions = 1
	max_positions = 100
	default_language = "Portuguese"
	additional_languages = list()

/datum/job/indian/flamengo/equip(var/mob/living/human/H)
	if (!H)	return FALSE
	H.name = H.species.get_random_portuguese_name(H.gender)
	H.real_name = H.name
	var/new_hair = "Black"
	var/hex_hair = hair_colors[new_hair]
	H.r_hair = hex2num(copytext(hex_hair, 2, 4))
	H.g_hair = hex2num(copytext(hex_hair, 4, 6))
	H.b_hair = hex2num(copytext(hex_hair, 6, 8))
	H.r_facial = hex2num(copytext(hex_hair, 2, 4))
	H.g_facial = hex2num(copytext(hex_hair, 4, 6))
	H.b_facial = hex2num(copytext(hex_hair, 6, 8))

//clothing
	var/outfit = pick(1,2,3)
	switch(outfit)
		if (1)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(H), slot_shoes)
			H.equip_to_slot_or_del(new /obj/item/clothing/under/football/corinthians(H), slot_w_uniform)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/bandana(H), slot_head)
		if (2)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
			H.equip_to_slot_or_del(new /obj/item/clothing/under/football/corinthians(H), slot_w_uniform)
		if (3)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(H), slot_shoes)
			H.equip_to_slot_or_del(new /obj/item/clothing/under/football/corinthians(H), slot_w_uniform)
			var/obj/item/clothing/head/cap/cap1 = new /obj/item/clothing/head/cap(null)
			cap1.flipped = TRUE
			H.equip_to_slot_or_del(cap1, slot_head)

//weapons
	var/weap = rand(1,4)
	switch(weap)
		if (1)
			H.equip_to_slot_or_del(new /obj/item/weapon/melee/knuckle_duster(H), slot_r_hand)
		if (2)
			H.equip_to_slot_or_del(new /obj/item/weapon/melee/baseball_bat(H), slot_r_hand)
		if (3)
			H.equip_to_slot_or_del(new /obj/item/weapon/melee/baseball_bat/aluminium(H), slot_r_hand)
		if (4)
			H.equip_to_slot_or_del(new /obj/item/weapon/material/kitchen/utensil/knife/shaggers(H), slot_r_hand)

//corinthians
/datum/job/american/corinthians
	title = "Torcedor Flamenguista"
	en_meaning = FALSE
	can_be_female = FALSE
	spawn_location = "JoinLateCO"
	selection_color = "#058a00"
	is_gta = TRUE
	min_positions = 1
	max_positions = 100
	default_language = "Portuguese"
	additional_languages = list()

/datum/job/american/corinthians/equip(var/mob/living/human/H)
	if (!H)	return FALSE
	H.name = H.species.get_random_portuguese_name(H.gender)
	H.real_name = H.name
	var/new_hair = "Black"
	var/hex_hair = hair_colors[new_hair]
	H.r_hair = hex2num(copytext(hex_hair, 2, 4))
	H.g_hair = hex2num(copytext(hex_hair, 4, 6))
	H.b_hair = hex2num(copytext(hex_hair, 6, 8))
	H.r_facial = hex2num(copytext(hex_hair, 2, 4))
	H.g_facial = hex2num(copytext(hex_hair, 4, 6))
	H.b_facial = hex2num(copytext(hex_hair, 6, 8))
	H.s_tone = rand(-150,-120)

//clothing
	var/outfit = pick(1,2,3)
	switch(outfit)
		if (1)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(H), slot_shoes)
			H.equip_to_slot_or_del(new /obj/item/clothing/under/football/flamengo(H), slot_w_uniform)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/bandana(H), slot_head)
		if (2)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
			H.equip_to_slot_or_del(new /obj/item/clothing/under/football/flamengo(H), slot_w_uniform)
		if (3)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
			H.equip_to_slot_or_del(new /obj/item/clothing/under/football/flamengo(H), slot_w_uniform)
			var/obj/item/clothing/head/cap/cap1 = new /obj/item/clothing/head/cap(null)
			cap1.flipped = TRUE
			H.equip_to_slot_or_del(cap1, slot_head)

//weapons
	var/weap = rand(1,4)
	switch(weap)
		if (1)
			H.equip_to_slot_or_del(new /obj/item/weapon/melee/knuckle_duster(H), slot_r_hand)
		if (2)
			H.equip_to_slot_or_del(new /obj/item/weapon/melee/baseball_bat(H), slot_r_hand)
		if (3)
			H.equip_to_slot_or_del(new /obj/item/weapon/melee/baseball_bat/aluminium(H), slot_r_hand)
		if (4)
			H.equip_to_slot_or_del(new /obj/item/weapon/material/kitchen/utensil/knife/shaggers(H), slot_r_hand)
