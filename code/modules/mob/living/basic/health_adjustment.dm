/**
 * Adjusts the health of a simple mob by a set amount
 *
 * Arguments:
 * * amount The amount that will be used to adjust the mob's health
 * * updating_health If the mob's health should be immediately updated to the new value
 * * forced If we should force update the adjustment of the mob's health no matter the restrictions, like GODMODE
 * returns the net change in bruteloss after applying the damage amount
 */
/mob/living/basic/proc/adjust_health(amount, updating_health = TRUE, forced = FALSE)
	. = FALSE
	if(!forced && (status_flags & GODMODE))
		return 0
	. = bruteloss // bruteloss value before applying damage
	bruteloss = round(clamp(bruteloss + amount, 0, maxHealth * 2), DAMAGE_PRECISION)
	if(updating_health)
		updatehealth()
	return . - bruteloss

/mob/living/basic/adjustBruteLoss(amount, updating_health = TRUE, forced = FALSE, required_bodytype)
	if(!forced && (status_flags & GODMODE))
		return 0
	if(on_damage_adjustment(BRUTE, amount, forced) & COMPONENT_IGNORE_CHANGE)
		return 0
	if(forced)
		. = adjust_health(amount * CONFIG_GET(number/damage_multiplier), updating_health, forced)
	else if(damage_coeff[BRUTE])
		. = adjust_health(amount * damage_coeff[BRUTE] * CONFIG_GET(number/damage_multiplier), updating_health, forced)

/mob/living/basic/adjustFireLoss(amount, updating_health = TRUE, forced = FALSE, required_bodytype)
	if(!forced && (status_flags & GODMODE))
		return 0
	if(on_damage_adjustment(BURN, amount, forced) & COMPONENT_IGNORE_CHANGE)
		return 0
	if(forced)
		. = adjust_health(amount * CONFIG_GET(number/damage_multiplier), updating_health, forced)
	else if(damage_coeff[BURN])
		. = adjust_health(amount * damage_coeff[BURN] * CONFIG_GET(number/damage_multiplier), updating_health, forced)

/mob/living/basic/adjustOxyLoss(amount, updating_health = TRUE, forced = FALSE, required_biotype, required_respiration_type)
	if(!forced && (status_flags & GODMODE))
		return 0
	if(on_damage_adjustment(OXY, amount, forced) & COMPONENT_IGNORE_CHANGE)
		return 0
	if(forced)
		. = adjust_health(amount * CONFIG_GET(number/damage_multiplier), updating_health, forced)
	else if(damage_coeff[OXY])
		. = adjust_health(amount * damage_coeff[OXY] * CONFIG_GET(number/damage_multiplier), updating_health, forced)

/mob/living/basic/adjustToxLoss(amount, updating_health = TRUE, forced = FALSE, required_biotype)
	if(!forced && (status_flags & GODMODE))
		return 0
	if(on_damage_adjustment(TOX, amount, forced) & COMPONENT_IGNORE_CHANGE)
		return 0
	if(forced)
		. = adjust_health(amount * CONFIG_GET(number/damage_multiplier), updating_health, forced)
	else if(damage_coeff[TOX])
		. = adjust_health(amount * damage_coeff[TOX] * CONFIG_GET(number/damage_multiplier), updating_health, forced)

/mob/living/basic/adjustCloneLoss(amount, updating_health = TRUE, forced = FALSE, required_biotype)
	if(on_damage_adjustment(CLONE, amount, forced) & COMPONENT_IGNORE_CHANGE)
		return 0
	if(forced)
		. = adjust_health(amount * CONFIG_GET(number/damage_multiplier), updating_health, forced)
	else if(damage_coeff[CLONE])
		. = adjust_health(amount * damage_coeff[CLONE] * CONFIG_GET(number/damage_multiplier), updating_health, forced)

/mob/living/basic/adjustStaminaLoss(amount, updating_stamina = TRUE, forced = FALSE, required_biotype)
	if(on_damage_adjustment(STAMINA, amount, forced) & COMPONENT_IGNORE_CHANGE)
		return 0
	. = staminaloss
	if(forced)
		staminaloss = max(0, min(BASIC_MOB_MAX_STAMINALOSS, staminaloss + amount))
	else
		staminaloss = max(0, min(BASIC_MOB_MAX_STAMINALOSS, staminaloss + (amount * damage_coeff[STAMINA])))
	if(updating_stamina)
		update_stamina()
	. -= staminaloss
