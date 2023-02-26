/datum/quirk/sheltered
	name = "Унесённый Взрывом"
	desc = "По тем или иным причинам вы либо не можете говорить на всеобщем, либо не выучили этот же самый всеобщий язык."
	value = 0
	mob_trait = TRAIT_SHELTERED
	gain_text = "<span class='danger'>Слова других теряют для вас всякий смысл...</span>"
	lose_text = "<span class='notice'>Вы начинаете собирать воедино то, что говорят люди!</span>"
	medical_record_text = "Пациент демонстрирует неспособность использовать обычные разговорные языки."

/datum/quirk/sheltered/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	H.remove_language(/datum/language/common)
// You can pick languages for your character, if you don't pick anything, enjoy the rest of the round understanding nothing.

/datum/quirk/sheltered/remove() //i mean, the lose text explains it, so i'm making it actually work
	var/mob/living/carbon/human/H = quirk_holder
	H.grant_language(/datum/language/common)

/datum/quirk/dnc_order
	name = "Приказ Не Клонировать"
	desc = "На вас записан приказ 'Не клонировать', в котором, как бы это странно не звучало, говорится, что вас нельзя клонировать. Вы все еще можете быть оживлены другими способами."
	value = -2
	mob_trait = TRAIT_DNC_ORDER
	medical_record_text = "Пациент имеет приказ DNC (Не Клонировать), в результате чего попытка воспользоваться клонированием будет отклонена."
