/obj/item/clothing/accessory/storage
	name = "load bearing equipment"
	desc = "Used to hold things when you don't have enough hands."
	icon_state = "webbing"
	slot = "utility"
	var/slots = 3
	var/obj/item/weapon/storage/internal/hold
	w_class = ITEM_SIZE_NORMAL

/obj/item/clothing/accessory/storage/New()
	..()
	hold = new/obj/item/weapon/storage/internal(src)
	hold.storage_slots = slots

/obj/item/clothing/accessory/storage/attack_hand(mob/user as mob)
	if (has_suit)	//if we are part of a suit
		hold.open(user)
		return

	if (hold.handle_attack_hand(user))	//otherwise interact as a regular storage item
		..(user)

/obj/item/clothing/accessory/storage/MouseDrop(obj/over_object as obj)
	if (has_suit)
		return

	if (hold.handle_mousedrop(usr, over_object))
		..(over_object)

/obj/item/clothing/accessory/storage/attackby(obj/item/W as obj, mob/user as mob)
	return hold.attackby(W, user)

/obj/item/clothing/accessory/storage/emp_act(severity)
	hold.emp_act(severity)
	..()

/obj/item/clothing/accessory/storage/attack_self(mob/user as mob)
	user << "<span class='notice'>You empty [src].</span>"
	var/turf/T = get_turf(src)
	hold.hide_from(usr)
	for (var/obj/item/I in hold.contents)
		hold.remove_from_storage(I, T)
	add_fingerprint(user)