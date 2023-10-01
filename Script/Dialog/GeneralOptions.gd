extends Control
## General Options menu

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
	self.verbosity_menu_button.get_popup().id_pressed.connect(self.select_verbosity)
	self.scale_slider.value_changed.connect(self.set_ui_scale)

	return

## Get the relevant children in the scene
func get_the_children() -> void:
	self.scale_value_label = get_node("%ScaleValueLabel")
	self.scale_slider = get_node("%ScaleHSlider")
	self.verbosity_menu_button = get_node("%VerbosityMenuButton")

	return

## Adjust verbosity based on user selection
func select_verbosity(id: int) -> void:
	id = posmod(id, Log.Level.size())
	Config.verbosity = id
	self.set_verbosity_button_text()
	Log.quiet("Verbosity set to %s" % Log.Level.keys()[Config.verbosity])
	Config.save_file()

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
	value = clampf(round(value) / 10, 0.1, Config.MAX_SCALE)
	Config.set_ui_scale(value)
	self.scale_value_label.text = "%.1f" % [value]
	Controller.show_options()

	return

## Set verbosity menu button's text to current verbosity level
func set_verbosity_button_text() -> void:
	self.verbosity_menu_button.text = tr(Log.Level.keys()[Config.verbosity].to_upper())

	return
