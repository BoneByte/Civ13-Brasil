/mob/living/human/var/next_emote = list(
	"surrender" = -1,
	"vocal" = -1,
	"special" = -1,
	"normal" = -1)

var/list/vocal_emotes = list(
	"cry",
	"giggle",// not actually vocal but it will be
	"laugh",
	"chuckle",
	"scream",
	"sigh",
	"sneeze",
	"yawn",
	"charge",
	"gasp")

/mob/living/human/emote(var/act,var/m_type=1,var/message = null)

	if (!vocal_emotes.Find(act) && world.time < next_emote["normal"])
		return

	else if (vocal_emotes.Find(act) && world.time < next_emote["vocal"])
		return

	// putting this here stops spam screaming
	if (vocal_emotes.Find(act))
		next_emote["vocal"] = world.time + 30
	else
		next_emote["normal"] = world.time + 30

	// no more screaming when you shoot yourself
	var/do_after = 0
	if (act == "scream")
		do_after = 1

	spawn (do_after)
		if (stat == UNCONSCIOUS || stat == DEAD)
			return

		var/param = null

		if (findtext(act, "-", TRUE, null))
			var/t1 = findtext(act, "-", TRUE, null)
			param = copytext(act, t1 + 1, length(act) + 1)
			act = copytext(act, TRUE, t1)

		if (findtext(act,"s",-1) && !findtext(act,"_",-2))//Removes ending s's unless they are prefixed with a '_'
			act = copytext(act,1,length(act))

		var/muzzled = istype(wear_mask, /obj/item/clothing/mask/muzzle) || istype(wear_mask, /obj/item/weapon/grenade)
		//var/m_type = 1

/*		for (var/obj/item/weapon/implant/I in src)
			if (I.implanted)
				I.trigger(act, src)*/

		if (stat == 2.0/* && (act != "deathgasp")*/)
			return

		switch(act)
			if ("dance")
				if (!restrained() && world.time >= next_emote["special"])
					message = "dances."
					m_type = 1

					var/src_oloc = loc
					var/turns = 0
					spawn while (1)
						if (src_oloc != loc)
							break
						dir = pick(NORTH, EAST, SOUTH, WEST)
						++turns
						if (turns >= 10)
							break
						sleep(2)
					next_emote["special"] = world.time + 30
			/*
			if ("airguitar")
				if (!restrained())
					message = "is strumming the air and headbanging like a safari chimp."
					m_type = 1
*/
			if ("blink")
				message = "blinks."
				m_type = 1

			if ("blink_r")
				message = "blinks rapidly."
				m_type = 1

			if ("arco")
				if (!buckled)
					var/M = null
					if (param)
						for (var/mob/A in view(null, null))
							if (param == A.name)
								M = A
								break
					if (!M)
						param = null

					if (param)
						message = "bows to [param]."
					else
						message = "bows."
				m_type = 1
/*
			if ("custom")
				var/input = sanitize(input("Choose an emote to display.") as text|null)
				if (!input)
					return
				var/input2 = WWinput(src, "Is this a visible or hearable emote?", "Emote", "Visible", list("Visible", "Hearable"))
				if (input2 == "Visible")
					m_type = 1
				else if (input2 == "Hearable")
					if (miming)
						return
					m_type = 2
				else
					alert("Unable to use this emote, must be either hearable or visible.")
					return
				return custom_emote(m_type, message)
*/
			if ("me")

				//if (silent && silent > 0 && findtext(message,"\"",1, null) > 0)
				//	return //This check does not work and I have no idea why, I'm leaving it in for reference.

				if (client)
					if (client.prefs.muted & MUTE_IC)
						src << "<span class = 'red'>You cannot send IC messages (muted).</span>"
						return
					if (client.handle_spam_prevention(message,MUTE_IC))
						return
				if (stat)
					return
				if (!(message))
					return
				return custom_emote(m_type, message)

			if ("salute")
				if (!buckled)
					var/M = null
					if (param)
						for (var/mob/A in view(null, null))
							if (param == A.name)
								M = A
								break
					if (!M)
						param = null

					if (param)
						message = "salutes to [param]."
					else
						message = "faz a saudação."
				m_type = 1

			if ("choke")
				if (miming)
					message = "clutches [get_visible_gender() == MALE ? "his" : get_visible_gender() == FEMALE ? "her" : "their"] throat desperately!"
					m_type = 1
				else
					if (!muzzled)
						message = "chokes!"
						m_type = 2
					else
						message = "faz um barulho estranho."
						m_type = 2

			if ("clap")
				if (!restrained())
					message = "aplaude."
					m_type = 2
					if (miming)
						m_type = 1
			if ("flap")
				if (!restrained())
					message = "flaps [get_visible_gender() == MALE ? "his" : get_visible_gender() == FEMALE ? "her" : "their"] wings."
					m_type = 2
					if (miming)
						m_type = 1

			if ("aflap")
				if (!restrained())
					message = "flaps [get_visible_gender() == MALE ? "his" : get_visible_gender() == FEMALE ? "her" : "their"] wings ANGRILY!"
					m_type = 2
					if (miming)
						m_type = 1

			if ("drool")
				message = "baba."
				m_type = 1

			if ("eyebrow")
				message = "levanta a monocelha."
				m_type = 1

			if ("chuckle")
				if (miming)
					message = "faz uma risadinha"
					m_type = 1
				else
					if (!muzzled)
						message = "risadinha."
						m_type = 2
						playsound(get_turf(src), "chuckle_[gender]", 100)
					else
						message = "faz um barulho."
						m_type = 2

			if ("twitch")
				message = "começa a tremer."
				m_type = 1
/*
			if ("twitch_s")
				message = "twitches."
				m_type = 1
*/
			if ("faint")
				message = "desmaia."
				if (sleeping)
					return //Can't faint while asleep
				sleeping += 10 //Short-short nap
				m_type = 1

			if ("nap")
				message = "adormece suavemente."
				if (sleeping)
					return //Can't faint while asleep
				sleeping += 30 //short nap
				m_type = 1

			if ("cough")
				if (miming)
					message = "parece tossir!"
					m_type = 1
				else
					if (!muzzled)
						message = "tosse!"
						m_type = 2
						playsound(get_turf(src), "cough_[gender]", 100)
					else
						message = "faz um barulho de tosse."
						m_type = 2

			if ("frown")
				message = "carrancas."
				m_type = 1

			if ("nod")
				message = "acena com a cabeça."
				m_type = 1

			if ("blush")
				message = "fica com cara de vergonha."
				m_type = 1

			if ("wave")
				message = "levanta a mão e acena."
				m_type = 1

			if ("gasp")
				if (miming)
					message = "parece estar ofegante!"
					m_type = 1
				else
					if (!muzzled)
						message = "ofega!"
						m_type = 2
						playsound(get_turf(src), "gasp_[gender]", 100)
					else
						message = "faz um pequeno barulho."
						m_type = 2

			if ("giggle")
				if (miming)
					message = "risinhos silenciosamente!"
					m_type = 1
				else
					if (!muzzled)
						message = "risadinhas."
						m_type = 2
					else
						message = "faz um barulho."
						m_type = 2
/*
			if ("glare")
				var/M = null
				if (param)
					for (var/mob/A in view(null, null))
						if (param == A.name)
							M = A
							break
				if (!M)
					param = null

				if (param)
					message = "glares at [param]."
				else
					message = "glares."*/

			if ("stare")
				var/M = null
				if (param)
					for (var/mob/A in view(null, null))
						if (param == A.name)
							M = A
							break
				if (!M)
					param = null

				if (param)
					message = "encara em [param]."
				else
					message = "encara."

			if ("look")
				var/M = null
				if (param)
					for (var/mob/A in view(null, null))
						if (param == A.name)
							M = A
							break

				if (!M)
					param = null

				if (param)
					message = "olha em [param]."
				else
					message = "olha."
				m_type = 1

			if ("grin")
				message = "sorri."
				m_type = 1

			if ("cry")
				if (miming)
					message = "chora."
					m_type = 1
				else
					if (!muzzled)
						message = "chora."
						m_type = 2
						playsound(get_turf(src), "cry_[gender]", 100)
					else
						message = "faz um barulho fraco. [get_visible_gender() == MALE ? "He" : get_visible_gender() == FEMALE ? "She" : "They"] [get_visible_gender() == NEUTER ? "frown" : "frowns"]."
						m_type = 2

			if ("charge")
				if (miming)
					message = "encargos!"
					m_type = 1
				else
					if (!muzzled)
						message = "encargos!"
						m_type = 2
						//Racial charges take priority over normal faction charges
						//Manually set race variables take charge over TDM nonhuman races
						//You should never have more then two races.
						if (orc == 1)
							playsound(get_turf(src), "charge_ORC", 100)
						else if (wolfman == 1)
							playsound(get_turf(src), "charge_WOLFMAN", 100)
						else if (ant == 1)
							playsound(get_turf(src), "charge_ANT", 100)
						else if (crab == 1)
							playsound(get_turf(src), "charge_CRAB", 100)
						else if (lizard == 1)
							playsound(get_turf(src), "charge_LIZARD", 100)
						else if (gorillaman == 1)
							playsound(get_turf(src), "charge_GORILLA", 100)
						else //If you are not a special race, check normal factions.
							//You should never have more then two factions.
							switch(faction_text)
								if (CIVILIAN)
									if (original_job.is_rcw)
										playsound(get_turf(src), "charge_RUSSIAN", 100)
									else if (original_job.is_warlords)
										playsound(get_turf(src), "charge_AFRICAN", 100)
									else if (original_job.is_yellowag)
										playsound(get_turf(src), "charge_AFRICAN", 100)
									else if (original_job.is_event)
										playsound(get_turf(src), "charge_BLUGOSLAVIA", 100)
									else if (original_job.is_dra)
										playsound(get_turf(src), "charge_IRANIAN", 100)
									else if (original_job.is_heist && original_job.is_law)
										playsound(get_turf(src), "charge_POLICE", 100)
								if (PIRATES)
									if (original_job.is_event)
										playsound(get_turf(src), "charge_REDMENIA", 100)
									else
										playsound(get_turf(src), "charge_PIRATES", 100)
								if (FINNISH)
									playsound(get_turf(src), "charge_FINNISH", 100)
								if (BRITISH)
									playsound(get_turf(src), "charge_BRITISH", 100)
								if (FRENCH)
									if (original_job.is_crusader)
										playsound(get_turf(src), "charge_CRUSADER", 100)
									else
										playsound(get_turf(src), "charge_FRENCH", 100)
								if (SPANISH)
									playsound(get_turf(src), "charge_SPANISH", 100)
								if (PORTUGUESE)
									playsound(get_turf(src), "charge_PORTUGUESE", 100)
								if (INDIANS)
									if (original_job.is_warlords)
										playsound(get_turf(src), "charge_AFRICAN", 100)
									else if (original_job.is_blugi)
										playsound(get_turf(src), "charge_AFRICAN", 100)
									else if (original_job.is_gta)
										playsound(get_turf(src), "charge_CORINTHIANS", 100)
									else
										playsound(get_turf(src), "charge_INDIANS", 100)

								if (DUTCH)
									playsound(get_turf(src), "charge_DUTCH", 100)
								if (ROMAN)
									playsound(get_turf(src), "charge_ROMAN", 100)
								if (GREEK)
									playsound(get_turf(src), "charge_GREEK", 100)
								if (ARAB)
									playsound(get_turf(src), "charge_ARAB", 100)
								if (CHECHEN)
									playsound(get_turf(src), "charge_ARAB", 100)
								if (JAPANESE)
									playsound(get_turf(src), "charge_JAPANESE", 100)
								if (RUSSIAN)
									if (original_job.is_heist && original_job.is_outlaw)
										playsound(get_turf(src), "charge_RUROBBERS", 100)
									else
										playsound(get_turf(src), "charge_RUSSIAN", 100)
								if (GERMAN)
									playsound(get_turf(src), "charge_GERMAN", 100)
								if (AMERICAN)
									if (map.ID == MAP_ARAB_TOWN)
										playsound(get_turf(src), "charge_ISRAELI", 100)
									else if (original_job_title == "Filipino Scout")
										playsound(get_turf(src), "charge_FILIPINO", 100)
									else if (original_job.is_gta)
										playsound(get_turf(src), "charge_FLAMENGO", 100)
									else
										playsound(get_turf(src), "charge_AMERICAN", 100)
								if (VIETNAMESE)
									playsound(get_turf(src), "charge_VIETNAMESE", 100)
								if (FILIPINO)
									playsound(get_turf(src), "charge_FILIPINO", 100)
					else
						message = "faz um barulho fraco."
						m_type = 2

			if ("sigh")
				if (miming)
					message = "suspira."
					m_type = 1
				else
					if (!muzzled)
						message = "suspira."
						m_type = 2
						playsound(get_turf(src), "sigh_[gender]", 100)
					else
						message = "faz um barulho pequeno."
						m_type = 2

			if ("laugh")
				if (miming)
					message = "age como se ri."
					m_type = 1
				else
					if (!muzzled)
						message = "ri."
						m_type = 2
						playsound(get_turf(src), "laugh_[gender]", 100)
					else
						message = "faz um barulho."
						m_type = 2

			if ("mumble")
				message = "murmura!"
				m_type = 2
				if (miming)
					m_type = 1

			if ("grumble")
				if (miming)
					message = "resmunga!"
					m_type = 1
				if (!muzzled)
					message = "resmunga!"
					m_type = 2
				else
					message = "makes a noise."
					m_type = 2

			if ("groan")
				if (miming)
					message = "parece gemer!"
					m_type = 1
				else
					if (!muzzled)
						message = "geme!"
						m_type = 2
					else
						message = "faz um barulho de doente mental."
						m_type = 2

			if ("moan")
				if (miming)
					message = "lamenta"
					m_type = 1
				else
					message = "lamenta!"
					m_type = 2

			if ("johnny")
				var/M
				if (param)
					M = param
				if (!M)
					param = null
				else
					if (miming)
						message = "tira um trago de um cigarro e sopra \"[M]\" fumaça"
						m_type = 1
					else
						message = "fala, \"[M], por favor. Ele tinha uma família.\" [name] tira um trago de um cigarro e sopra seu nome na fumaça."
						m_type = 2

			if ("point")
				if (!restrained())
					var/mob/M = null
					if (param)
						for (var/atom/A as mob|obj|turf|area in view(null, null))
							if (param == A.name)
								M = A
								break

					if (!M)
						message = "aponta."
					else
						pointed(M)

					if (M)
						message = "aponta para [M]."
					else
				m_type = 1

			if ("raise")
				if (!restrained())
					message = "levanta a mão."
				m_type = 1

			if ("shake")
				message = "sacode a cabeça de[get_visible_gender() == MALE ? "his" : get_visible_gender() == FEMALE ? "her" : "their"]"
				m_type = 1

			if ("shrug")
				message = "shrugs."
				m_type = 1

			if ("signal")
				if (!restrained())
					var/t1 = round(text2num(param))
					if (isnum(t1))
						if (t1 <= 5 && (!r_hand || !l_hand))
							message = "estrala os dedos de [t1]"
						else if (t1 <= 10 && (!r_hand && !l_hand))
							message = "estrala os dedos de [t1]"
				m_type = 1

			if ("smile")
				message = "sorri"
				m_type = 1

			if ("shiver")
				message = "calafrios."
				m_type = 2
				if (miming)
					m_type = 1
/*
			if ("pale")
				message = "fica palido por um segundo."
				m_type = 1
*/
			if ("tremble")
				message = "treme com medo!"
				m_type = 1

			if ("sneeze")
				if (miming)
					message = "espirra"
					m_type = 1
				else
					if (!muzzled)
						message = "espirra."
						m_type = 2
						playsound(get_turf(src), "sneeze_[gender]", 100)
					else
						message = "makes a strange noise."
						m_type = 2

			if ("sniff")
				message = "sniff."
				m_type = 2
				if (miming)
					m_type = 1

			if ("snore")
				if (miming)
					message = "ronca que nem um porco."
					m_type = 1
				else
					if (!muzzled)
						message = "ronca."
						m_type = 2
					else
						message = "makes a noise."
						m_type = 2
/*
			if ("whimper")
				if (miming)
					message = "appears hurt."
					m_type = 1
				else
					if (!muzzled)
						message = "whimpers."
						m_type = 2
					else
						message = "makes a weak noise."
						m_type = 2
*/
			if ("wink")
				message = "winks."
				m_type = 1

			if ("yawn")
				if (!muzzled)
					message = "yawns."
					m_type = 2
					if (miming)
						m_type = 1
					else
						playsound(get_turf(src), "yawn_[gender]", 100)

			if ("collapse")
				Paralyse(2)
				message = "collapsa!"
				m_type = 2
				if (miming)
					m_type = 1

			if ("hug")
				m_type = 1
				if (!restrained())
					var/M = null
					if (param)
						for (var/mob/A in view(1, null))
							if (param == A.name)
								M = A
								break
					if (M == src)
						M = null

					if (M)
						message = "abraça [M]."
					else
						message = "abraça [get_visible_gender() == MALE ? "himself" : get_visible_gender() == FEMALE ? "herself" : "themselves"]."

			if ("handshake")
				m_type = 1
				if (!restrained() && !r_hand)
					var/mob/M = null
					if (param)
						for (var/mob/A in view(1, null))
							if (param == A.name)
								M = A
								break
					if (M == src)
						M = null

					if (M)
						if (M.canmove && !M.r_hand && !M.restrained())
							message = "aperta a mão de [M]."
						else
							var/datum/gender/g = gender_datums[gender]
							message = "resiste [g.his] mão a [M]."

			if ("scream")
				if (miming)
					message = "grita!"
					m_type = 1
				else
					if (!muzzled)
						message = "grita!"
						m_type = 2
						warning_scream_sound(src, FALSE)
					else
						message = "makes a very loud noise."
						m_type = 2

			if ("painscream")
				if (miming)
					message = "faz um grito de dor!"
					m_type = 1
				else
					if (!muzzled)
						message = "grita de dor!"
						m_type = 2
						scream_sound(src, FALSE)
					else
						message = "makes a very loud noise."
						m_type = 2

			if ("surrender")
				if (world.time >= next_emote["surrender"])
					if (original_job_title == "Gladiator")
						message = "rende!"
						Weaken(50)
						if (l_hand) unEquip(l_hand)
						if (r_hand) unEquip(r_hand)
						next_emote["surrender"] = world.time + 600
						surrendered = TRUE
						spawn(600)
							surrendered = FALSE
					else
						message = "se rende!!"
						Weaken(50)
						if (l_hand) unEquip(l_hand)
						if (r_hand) unEquip(r_hand)
						next_emote["surrender"] = world.time + 600
						surrendered = TRUE
						spawn(600)
							surrendered = FALSE

			if ("pee")
				handle_piss()

			if ("poop")
				handle_shit()

			if ("help")
				src << {"blink, blink_r, blush, bow-(none)/mob, burp, choke, chuckle, clap, collapse, cough,
	cry, drool, eyebrow, frown, gasp, giggle, groan, grumble, handshake, hug-(none)/mob,
	grin, laugh, look-(none)/mob, moan, mumble, nod, point-atom, raise, salute, shake, shiver, shrug,
	sigh, signal-#1-10, smile, sneeze, sniff, snore, stare-(none)/mob, scream, surrender, tremble, twitch,
	wink, yawn, charge, piss, poop"}

			else
				src << "<span class = 'notice'>Unusable emote '[act]'. Say *help for a list.</span>"

		if (muzzled && m_type == 2)
			src << "<span class = 'warning'>Você não consegue fazer barulho enquanto algo está em sua boca.</span>"
			return

		if (message)
			log_emote("[name]/[key] : [message]")
			if (act == "surrender" && message == "se rende!")
				custom_emote(m_type,message,"userdanger")
			else if (act == "surrender" && message=="se rende!")
				custom_emote(m_type,message,"userdanger_yellow")
			else
				custom_emote(m_type,message)
