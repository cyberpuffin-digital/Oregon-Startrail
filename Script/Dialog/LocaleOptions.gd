extends Control

## Label to display current locale
var current_locale_label: Label
## Menu button for selecting locale
var locale_menu_button: MenuButton

func _ready() -> void:
	self.get_the_children()
	self.connect_to_signals()
	self.set_current_locale_label()

	return

## Connect to relevant signals in the scene
func connect_to_signals() -> void:
	self.locale_menu_button.get_popup().id_pressed.connect(select_locale)

	return

## Get the relevant children in the scene
func get_the_children() -> void:
	self.current_locale_label = get_node("%CurrentLocaleLabel")
	self.locale_menu_button = get_node("%LocaleSelectMenuButton")

	return

func select_locale(id: int) -> void:
	id = clamp(id, 0, Config.LOCALES.size())
	Config.locale = id
	Config.locale_chosen = true
	TranslationServer.set_locale(Config.LOCALES[id])
	self.set_current_locale_label()
	Config.save_file()

	return

## Update locale label with current setting
func set_current_locale_label() -> void:
	self.current_locale_label.text = tr(self.locale_menu_button.get_popup().get_item_text(Config.locale))

	return
