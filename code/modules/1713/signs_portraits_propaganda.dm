/obj/structure/sign/portrait

/* // this has never worked, not sure why, but its disabled now
/obj/structure/sign/portrait/verb/tear()
	set category = null
	set src in oview(1, usr)
	if (!locate(src) in get_step(usr, usr.dir))
		return FALSE
	visible_message("<span class = 'danger'>[usr] starts to tear down [src]...</span>")
	if (do_after(usr, 30, get_turf(src)))
		visible_message("<span class = 'danger'>[usr] tears down [src]!</span>")
		qdel(src)*/

/obj/structure/sign/portrait/hitler
	name = "Portrait of Hitler"
	desc = "Our glorious Fuhrer!"
	icon_state = "hitler"

/obj/structure/sign/portrait/lenin
	name = "Portrait of Lenin"
	icon_state = "lenin"

/obj/structure/sign/portrait/stalin
	name = "Portrait of Stalin"
	icon_state = "stalin"

/obj/structure/sign/portrait/hirohito
	name = "Portrait of Hirohito"
	icon_state = "hirohito"

/obj/structure/sign/portrait/kinggeorge
	name = "Portrait of King George V"
	icon_state = "kinggeorgev"

/obj/structure/sign/portrait/jackgray
	name = "Portrait of Jack Grayson"
	icon_state = "jackgray"
