/obj/machinery/vending/kink/Initialize()
	var/list/extra_products = list(
		/obj/item/clothing/under/dress/skirt/lustymaid = 5,
		/obj/item/clothing/under/dress/skirt/maidsexy = 5,
	)
	var/list/extra_contraband = list()
	var/list/extra_premium = list()

	LAZYADD(products, extra_products)
	LAZYADD(contraband, extra_contraband)
	LAZYADD(premium, extra_premium)
	. = ..()
