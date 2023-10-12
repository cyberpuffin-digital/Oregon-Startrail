extends Control
## General Options menu

## Label to display current locale
var current_locale_label: Label
## I want to cheat Checkbox
var i_want_to_cheat_check_box: CheckBox
## Menu button for selecting locale
var locale_menu_button: MenuButton
## Global scale value label
var scale_value_label: Label
## Global scale slider
var scale_slider: HSlider
## Log verbosity level menu button
var verbosity_menu_button: MenuButton


func _ready() -> void:
	self.get_the_children()
	self.connect_to_signals()
	self.set_the_children()

	return

## Connect to relevant signals in the scene
func connect_to_signals() -> void:
#	self.i_want_to_cheat_check_box.toggled.connect
	self.locale_menu_button.get_popup().id_pressed.connect(select_locale)
	self.scale_slider.value_changed.connect(self.set_ui_scale)
	self.verbosity_menu_button.get_popup().id_pressed.connect(self.select_verbosity)

	return

## Get the relevant children in the scene
func get_the_children() -> void:
	self.current_locale_label = get_node("%CurrentLocaleLabel")
	self.i_want_to_cheat_check_box = get_node("%LetMeCheatCheckBox")
	self.locale_menu_button = get_node("%LocaleSelectMenuButton")
	self.scale_value_label = get_node("%ScaleValueLabel")
	self.scale_slider = get_node("%ScaleHSlider")
	self.verbosity_menu_button = get_node("%VerbosityMenuButton")

	return

## Set locale to [id]
func select_locale(id: int) -> void:
	id = clamp(id, 0, Config.LOCALES.size())
	Config.locale = id
	Config.locale_chosen = true
	TranslationServer.set_locale(Config.LOCALES[id])
	self.set_current_locale_label()
	Config.save_file()

	return

## Adjust verbosity based on user selection
func select_verbosity(id: int) -> void:
	id = posmod(id, Log.Level.size())
	Config.verbosity = id
	self.set_verbosity_button_text()
	Log.quiet("Verbosity set to %s" % Log.Level.keys()[Config.verbosity])
	Config.save_file()

	return

## Update locale label with current setting
func set_current_locale_label() -> void:
	self.current_locale_label.text = tr(self.locale_menu_button.get_popup().get_item_text(Config.locale))

	return

## Set initial state for scene children
func set_the_children() -> void:
	self.set_verbosity_button_text()
	self.scale_slider.set_value_no_signal(floori(Config.ui_scale * 10))
	self.scale_value_label.text = "%.1f" % [Config.ui_scale]

	return

## Scale UI for visibility from the slider[br]
## Expected input: 1 - Config.MAX_SCALE * 10
func set_ui_scale(value: float) -> void:
	value = clampf(round(value) / 10, Config.MIN_SCALE, Config.MAX_SCALE)
	Config.set_ui_scale(value)
	self.scale_value_label.text = "%.1f" % [value]
	Controller.show_options()

	return

## Set verbosity menu button's text to current verbosity level
func set_verbosity_button_text() -> void:
	self.verbosity_menu_button.text = tr(Log.Level.keys()[Config.verbosity].to_upper())

	return
