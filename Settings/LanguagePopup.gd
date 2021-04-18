extends Control


onready var item_list = $DraggablePopup/ItemList
var locales = []

	
func popup_centered():
	$DraggablePopup.popup_centered()
	
	item_list.clear()
	locales.clear()
	var idx = 0
	var selected_idx = 0
	for locale in TranslationServer.get_loaded_locales():
		item_list.add_item(tr(TranslationServer.get_locale_name(locale)), Define.languageTexture)
		item_list.set_item_tooltip_enabled(idx, false)
		locales.append(locale)
		if TranslationServer.get_locale() == locale:
			selected_idx = idx
		idx += 1
	
	item_list.select(selected_idx)


func _on_ItemList_item_selected(index):
	TranslationServer.set_locale(locales[index])
