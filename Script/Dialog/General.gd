extends Control
## General Options menu

var verbosity_menu_button: MenuButton

func _ready() -> void:
	self.get_the_children()
	self.connect_to_signals()
	self.set_verbosity_button_text()

	return

## Connect to relevant signals in the scene
func connect_to_signals() -> void:
	self.verbosity_menu_button.get_popup().id_pressed.connect(select_verbosity)

	return

## Get the relevant children in the scene
func get_the_children() -> void:
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

## Set verbosity menu button's text to current verbosity level
func set_verbosity_button_text() -> void:
	self.verbosity_menu_button.text = tr(Log.Level.keys()[Config.verbosity].to_upper())

	return
