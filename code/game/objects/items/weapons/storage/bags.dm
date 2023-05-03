/*
 *	These absorb the functionality of the plant bag, ore satchel, etc.
 *	They use the use_to_pickup, quick_gather, and quick_empty functions
 *	that were already defined in weapon/storage, but which had been
 *	re-implemented in other classes.
 *
 *	Contains:
 *		Trash Bag
 *		Mining Satchel
 *		Plant Bag
 *		Sheet Snatcher
 *		Cash Bag
 *
 *	-Sayu
 */

//  Generic non-item
/obj/item/weapon/storage/bag
	allow_quick_gather = TRUE
	allow_quick_empty = TRUE
	display_contents_with_number = FALSE // UNStABLE AS FuCK, turn on when it stops crashing clients
	use_to_pickup = TRUE
	slot_flags = SLOT_BELT
	flags = FALSE

// -----------------------------
//		  Trash bag
// -----------------------------
/obj/item/weapon/storage/bag/trash
	name = "trash bag"
	desc = "It's the heavy-duty black polymer kind. Time to take out the trash!"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "trashbag0"
	item_state = "trashbag"

	w_class = ITEM_SIZE_TINY
	max_w_class = 2
	can_hold = list() // any

/obj/item/weapon/storage/bag/trash/update_icon()
	if (contents.len >= 2 && contents.len < 4)
		icon_state = "trashbag1"
		w_class = ITEM_SIZE_SMALL
	else if (contents.len >= 4 && contents.len < 7)
		icon_state = "trashbag2"
		w_class = ITEM_SIZE_NORMAL
	else if (contents.len >= 7)
		icon_state = "trashbag3"
		w_class = ITEM_SIZE_LARGE
	else
		icon_state = "trashbag0"
		w_class = ITEM_SIZE_TINY

// -----------------------------
//		Plastic Bag
// -----------------------------

/obj/item/weapon/storage/bag/plasticbag
	name = "plastic bag"
	desc = "It's a very flimsy, very noisy alternative to a bag."
	icon = 'icons/obj/trash.dmi'
	icon_state = "plasticbag"
	item_state = "plasticbag"

	w_class = ITEM_SIZE_LARGE
	max_w_class = 2
	can_hold = list() // any
	allow_quick_gather = FALSE
	allow_quick_empty = TRUE
	use_to_pickup = FALSE
// -----------------------------
//		Mining Satchel
// -----------------------------
/*
/obj/item/weapon/storage/bag/ore
	name = "mining satchel"
	desc = "This little bugger can be used to store and transport ores."
	icon = 'icons/obj/mining.dmi'
	icon_state = "satchel"
	slot_flags = SLOT_BELT | SLOT_POCKET
	w_class = ITEM_SIZE_NORMAL
	max_storage_space = 100
	max_w_class = 3
	can_hold = list(/obj/item/stack/ore)
*/
// -----------------------------
//		  Plant bag
// -----------------------------
/*
/obj/item/weapon/storage/bag/plants
	name = "plant bag"
	icon = 'icons/obj/hydroponics_machines.dmi'
	icon_state = "plantbag"
	max_storage_space = 100
	max_w_class = 3
	w_class = ITEM_SIZE_SMALL
	can_hold = list(/obj/item/weapon/reagent_containers/food/snacks/grown,/obj/item/seeds,/obj/item/weapon/grown)
*/

// -----------------------------
//		Sheet Snatcher
// -----------------------------
// Because it stacks stacks, this doesn't operate normally.
// However, making it a storage/bag allows us to reuse existing code in some places. -Sayu

/obj/item/weapon/storage/bag/sheetsnatcher
	name = "sheet snatcher"
	icon = 'icons/obj/mining.dmi'
	icon_state = "sheetsnatcher"
	desc = "A patented storage system designed for any kind of mineral sheet."

	var/capacity = 300; //the number of sheets it can carry.
	w_class = ITEM_SIZE_NORMAL
	storage_slots = 7

	allow_quick_empty = TRUE // this function is superceded
	New()
		..()
		//verbs -= /obj/item/weapon/storage/verb/quick_empty
		//verbs += /obj/item/weapon/storage/bag/sheetsnatcher/quick_empty

	can_be_inserted(obj/item/W as obj, stop_messages = FALSE)
		if (!istype(W,/obj/item/stack/material))
			if (!stop_messages)
				usr << "The snatcher does not accept [W]."
			return FALSE
		var/current = FALSE
		for (var/obj/item/stack/material/S in contents)
			current += S.amount
		if (capacity == current)//If it's full, you're done
			if (!stop_messages)
				usr << "<span class='warning'>The snatcher is full.</span>"
			return FALSE
		return TRUE


// Modified handle_item_insertion.  Would prefer not to, but...
	handle_item_insertion(obj/item/W as obj, prevent_warning = FALSE)
		var/obj/item/stack/material/S = W
		if (!istype(S)) return FALSE

		var/amount
		var/inserted = FALSE
		var/current = FALSE
		for (var/obj/item/stack/material/S2 in contents)
			current += S2.amount
		if (capacity < current + S.amount)//If the stack will fill it up
			amount = capacity - current
		else
			amount = S.amount

		for (var/obj/item/stack/material/sheet in contents)
			if (S.type == sheet.type) // we are violating the amount limitation because these are not sane objects
				sheet.amount += amount	// they should only be removed through procs in this file, which split them up.
				S.amount -= amount
				inserted = TRUE
				break

		if (!inserted || !S.amount)
			usr.remove_from_mob(S)
			usr.update_icons()	//update our overlays
			if (usr.client && usr.s_active != src)
				usr.client.screen -= S
			S.dropped(usr)
			if (!S.amount)
				qdel(S)
			else
				S.loc = src

		orient2hud(usr)
		if (usr.s_active)
			usr.s_active.show_to(usr)
		update_icon()
		return TRUE


// Sets up numbered display to show the stack size of each stored mineral
// NOTE: numbered display is turned off currently because it's broken
	orient2hud(mob/user as mob)
		var/adjusted_contents = contents.len

		//Numbered contents display
		var/list/datum/numbered_display/numbered_contents
		if (display_contents_with_number)
			numbered_contents = list()
			adjusted_contents = FALSE
			for (var/obj/item/stack/material/I in contents)
				adjusted_contents++
				var/datum/numbered_display/D = new/datum/numbered_display(I)
				D.number = I.amount
				numbered_contents.Add( D )

		var/row_num = FALSE
		var/col_count = min(7,storage_slots) -1
		if (adjusted_contents > 7)
			row_num = round((adjusted_contents-1) / 7) // 7 is the maximum allowed width.
		slot_orient_objs(row_num, col_count, numbered_contents)
		return


// Modified quick_empty verb drops appropriate sized stacks
	quick_empty()
		var/location = get_turf(src)
		for (var/obj/item/stack/material/S in contents)
			while (S.amount)
				var/obj/item/stack/material/N = new S.type(location)
				var/stacksize = min(S.amount,N.max_amount)
				N.amount = stacksize
				S.amount -= stacksize
			if (!S.amount)
				qdel(S) // todo: there's probably something missing here
		orient2hud(usr)
		if (usr.s_active)
			usr.s_active.show_to(usr)
		update_icon()

// Instead of removing
	remove_from_storage(obj/item/W as obj, atom/new_location)
		var/obj/item/stack/material/S = W
		if (!istype(S)) return FALSE

		//I would prefer to drop a new stack, but the item/attack_hand code
		// that calls this can't recieve a different object than you clicked on.
		//Therefore, make a new stack internally that has the remainder.
		// -Sayu

		if (S.amount > S.max_amount)
			var/obj/item/stack/material/temp = new S.type(src)
			temp.amount = S.amount - S.max_amount
			S.amount = S.max_amount

		return ..(S,new_location)

// -----------------------------
//		   Cash Bag
// -----------------------------

/obj/item/weapon/storage/bag/cash
	name = "cash bag"
	icon = 'icons/obj/storage.dmi'
	icon_state = "moneybag"
	desc = "A bag for carrying lots of cash. It's got a big dollar sign printed on the front."
	max_storage_space = 15
	max_w_class = 3
	w_class = ITEM_SIZE_SMALL
	can_hold = list(/obj/item/stack/money, /obj/item/stack/material/gold, /obj/item/stack/material/silver, /obj/item/stack/material/diamond)
