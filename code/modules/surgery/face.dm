//Procedures in this file: Facial reconstruction surgery
//////////////////////////////////////////////////////////////////
//						FACE SURGERY							//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/face
	priority = 2
	can_infect = FALSE
	can_use(mob/living/user, mob/living/human/target, target_zone, obj/item/tool)
		if (!hasorgans(target))
			return FALSE
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		if (!affected)
			return FALSE
		return target_zone == "mouth"

/datum/surgery_step/generic/cut_face
	allowed_tools = list(
		1 = list("/obj/item/weapon/surgery/scalpel",100),
		2 = list("/obj/item/weapon/surgery/scalpel/bronze",85),
		3 = list("/obj/item/weapon/material/kitchen/utensil/knife",75),
		4 = list("/obj/item/weapon/material/shard",50),
	)

	min_duration = 90
	max_duration = 110

	can_use(mob/living/user, mob/living/human/target, target_zone, obj/item/tool)
		return ..() && target_zone == "mouth" && target.op_stage.face == FALSE

	begin_step(mob/user, mob/living/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] starts to cut open [target]'s face and neck with \the [tool].", \
		"You start to cut open [target]'s face and neck with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/human/target, target_zone, obj/item/tool)
		user.visible_message("<span class = 'notice'>[user] has cut open [target]'s face and neck with \the [tool].</span>" , \
		"<span class = 'notice'>You have cut open [target]'s face and neck with \the [tool].</span>",)
		target.op_stage.face = TRUE

	fail_step(mob/living/user, mob/living/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class = 'red'>[user]'s hand slips, slicing [target]'s throat wth \the [tool]!</span>" , \
		"<span class = 'red'>Your hand slips, slicing [target]'s throat wth \the [tool]!</span>" )
		affected.createwound(CUT, 60)
		target.losebreath += 10

/datum/surgery_step/face/mend_vocal
	allowed_tools = list(
		1 = list("/obj/item/weapon/surgery/hemostat",100),
		2 = list("/obj/item/weapon/surgery/hemostat/bronze",85),
	)

	min_duration = 70
	max_duration = 90

	can_use(mob/living/user, mob/living/human/target, target_zone, obj/item/tool)
		return ..() && target.op_stage.face == TRUE

	begin_step(mob/user, mob/living/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] starts mending [target]'s vocal cords with \the [tool].", \
		"You start mending [target]'s vocal cords with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/human/target, target_zone, obj/item/tool)
		user.visible_message("<span class = 'notice'>[user] mends [target]'s vocal cords with \the [tool].</span>", \
		"<span class = 'notice'>You mend [target]'s vocal cords with \the [tool].</span>")
		target.op_stage.face = 2

	fail_step(mob/living/user, mob/living/human/target, target_zone, obj/item/tool)
		user.visible_message("<span class = 'red'>[user]'s hand slips, clamping [target]'s trachea shut for a moment with \the [tool]!</span>", \
		"<span class = 'red'>Your hand slips, clamping [user]'s trachea shut for a moment with \the [tool]!</span>")
		target.losebreath += 10

/datum/surgery_step/face/fix_face
	allowed_tools = list(
		1 = list("/obj/item/weapon/surgery/retractor",100),
		2 = list("/obj/item/weapon/surgery/retractor/bronze",85),
		3 = list("/obj/item/weapon/crowbar",55),
		4 = list("/obj/item/weapon/material/kitchen/utensil/fork",75),
	)

	min_duration = 80
	max_duration = 100

	can_use(mob/living/user, mob/living/human/target, target_zone, obj/item/tool)
		return ..() && target.op_stage.face == 2

	begin_step(mob/user, mob/living/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] starts pulling the skin on [target]'s face back in place with \the [tool].", \
		"You start pulling the skin on [target]'s face back in place with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/human/target, target_zone, obj/item/tool)
		user.visible_message("<span class = 'notice'>[user] pulls the skin on [target]'s face back in place with \the [tool].</span>",	\
		"<span class = 'notice'>You pull the skin on [target]'s face back in place with \the [tool].</span>")
		target.op_stage.face = 3

	fail_step(mob/living/user, mob/living/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class = 'red'>[user]'s hand slips, tearing skin on [target]'s face with \the [tool]!</span>", \
		"<span class = 'red'>Your hand slips, tearing skin on [target]'s face with \the [tool]!</span>")
		target.apply_damage(10, BRUTE, affected, sharp=1, sharp=1)

/datum/surgery_step/face/cauterize
	allowed_tools = list(
		1 = list("/obj/item/weapon/surgery/cautery",100),
		2 = list("/obj/item/weapon/surgery/cautery/bronze",85),
		3 = list("/obj/item/clothing/mask/smokable/cigarette/cigar",60),
		4 = list("/obj/item/flashlight/torch",75),
	)

	min_duration = 70
	max_duration = 100

	can_use(mob/living/user, mob/living/human/target, target_zone, obj/item/tool)
		return ..() && target.op_stage.face > 0

	begin_step(mob/user, mob/living/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] is beginning to cauterize the incision on [target]'s face and neck with \the [tool]." , \
		"You are beginning to cauterize the incision on [target]'s face and neck with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class = 'notice'>[user] cauterizes the incision on [target]'s face and neck with \the [tool].</span>", \
		"<span class = 'notice'>You cauterize the incision on [target]'s face and neck with \the [tool].</span>")
		affected.open = FALSE
		affected.status &= ~ORGAN_BLEEDING
		if (target.op_stage.face == 3)
			var/obj/item/organ/external/head/h = affected
			h.disfigured = FALSE
		target.op_stage.face = FALSE

	fail_step(mob/living/user, mob/living/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class = 'red'>[user]'s hand slips, leaving a small burn on [target]'s face with \the [tool]!</span>", \
		"<span class = 'red'>Your hand slips, leaving a small burn on [target]'s face with \the [tool]!</span>")
		target.apply_damage(4, BURN, affected)