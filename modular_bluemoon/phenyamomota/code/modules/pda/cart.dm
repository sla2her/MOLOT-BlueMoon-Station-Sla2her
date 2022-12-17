/obj/item/cartridge/civil
	name = "\improper Civil cartridge"
	icon_state = "cart"
	access = CART_MANIFEST

/obj/item/cartridge/engineering
	name = "\improper Power-ON cartridge"
	icon_state = "cart-e"
	access = CART_ENGINE | CART_DRONEPHONE | CART_MANIFEST
	bot_access_flags = FLOOR_BOT

/obj/item/cartridge/atmos
	name = "\improper BreatheDeep cartridge"
	icon_state = "cart-a"
	access = CART_ATMOS | CART_DRONEPHONE | CART_MANIFEST
	bot_access_flags = FLOOR_BOT | FIRE_BOT

/obj/item/cartridge/medical
	name = "\improper Med-U cartridge"
	icon_state = "cart-m"
	access = CART_MEDICAL
	bot_access_flags = MED_BOT

/obj/item/cartridge/chemistry
	name = "\improper ChemWhiz cartridge"
	icon_state = "cart-chem"
	access = CART_REAGENT_SCANNER | CART_CHEMISTRY | CART_MANIFEST
	bot_access_flags = MED_BOT

/obj/item/cartridge/security
	name = "\improper R.O.B.U.S.T. cartridge"
	icon_state = "cart-s"
	access = CART_SECURITY | CART_MANIFEST
	bot_access_flags = SEC_BOT

/obj/item/cartridge/detective
	name = "\improper D.E.T.E.C.T. cartridge"
	icon_state = "cart-eye"
	access = CART_SECURITY | CART_MEDICAL | CART_MANIFEST
	bot_access_flags = SEC_BOT

/obj/item/cartridge/janitor
	name = "\improper CustodiPRO cartridge"
	desc = "The ultimate in clean-room design."
	icon_state = "cart-j"
	access = CART_JANITOR | CART_DRONEPHONE | CART_MANIFEST
	bot_access_flags = CLEAN_BOT

/obj/item/cartridge/lawyer
	name = "\improper S.P.A.M. cartridge"
	desc = "Introducing the Station Public Announcement Messenger cartridge, featuring the unique ability to broadcast-mark messages, designed for lawyers across Nanotrasen to advertise their useful and important services."
	icon_state = "cart-law"
	access = CART_SECURITY | CART_MANIFEST
	spam_enabled = 1

/obj/item/cartridge/curator
	name = "\improper Lib-Tweet cartridge"
	icon_state = "cart-lib"
	access = CART_NEWSCASTER | CART_MANIFEST

/obj/item/cartridge/roboticist
	name = "\improper B.O.O.P. Remote Control cartridge"
	desc = "Packed with heavy duty triple-bot interlink!"
	icon_state = "cart-robo"
	bot_access_flags = FLOOR_BOT | CLEAN_BOT | MED_BOT | FIRE_BOT | CART_MANIFEST
	access = CART_DRONEPHONE

/obj/item/cartridge/signal/toxins
	name = "\improper Signal Ace 2 cartridge"
	desc = "Complete with integrated radio signaler!"
	icon_state = "cart-tox"
	access = CART_REAGENT_SCANNER | CART_ATMOS | CART_MANIFEST

/obj/item/cartridge/quartermaster
	name = "space parts & space vendors cartridge"
	desc = "Perfect for the Quartermaster on the go!"
	icon_state = "cart-q"
	access = CART_QUARTERMASTER | CART_MANIFEST
	bot_access_flags = MULE_BOT

/obj/item/cartridge/head
	name = "\improper Easy-Record DELUXE cartridge"
	icon_state = "cart-h"
	access = CART_MANIFEST | CART_STATUS_DISPLAY

/obj/item/cartridge/hop
	name = "\improper HumanResources9001 cartridge"
	icon_state = "cart-h"
	access = CART_MANIFEST | CART_STATUS_DISPLAY | CART_JANITOR | CART_SECURITY | CART_NEWSCASTER | CART_QUARTERMASTER | CART_DRONEPHONE
	bot_access_flags = MULE_BOT | CLEAN_BOT

/obj/item/cartridge/hos
	name = "\improper R.O.B.U.S.T. DELUXE cartridge"
	icon_state = "cart-hos"
	access = CART_MANIFEST | CART_STATUS_DISPLAY | CART_SECURITY
	bot_access_flags = SEC_BOT


/obj/item/cartridge/ce
	name = "\improper Power-On DELUXE cartridge"
	icon_state = "cart-ce"
	access = CART_MANIFEST | CART_STATUS_DISPLAY | CART_ENGINE | CART_ATMOS | CART_DRONEPHONE
	bot_access_flags = FLOOR_BOT | FIRE_BOT

/obj/item/cartridge/cmo
	name = "\improper Med-U DELUXE cartridge"
	icon_state = "cart-cmo"
	access = CART_MANIFEST | CART_STATUS_DISPLAY | CART_REAGENT_SCANNER | CART_MEDICAL
	bot_access_flags = MED_BOT

/obj/item/cartridge/rd
	name = "\improper Signal Ace DELUXE cartridge"
	icon_state = "cart-rd"
	access = CART_MANIFEST | CART_STATUS_DISPLAY | CART_REAGENT_SCANNER | CART_ATMOS | CART_DRONEPHONE
	bot_access_flags = FLOOR_BOT | CLEAN_BOT | MED_BOT | FIRE_BOT

/obj/item/cartridge/bartender
	name = "\improper B.O.O.Z.E cartridge"
	desc = "Now with 12% alcohol!"
	icon_state = "cart-bar"
	access = CART_BARTENDER | CART_MANIFEST
