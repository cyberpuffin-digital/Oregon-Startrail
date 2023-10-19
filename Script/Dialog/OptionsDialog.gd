extends ConfirmationDialog

var options_tab_container: TabContainer

func _ready() -> void:
	self.get_the_children()
	self.connect_to_signals()


func connect_to_signals() -> void:
	canceled.connect(Audio.play_sfx)
	canceled.connect(Config.load_file)
	confirmed.connect(Audio.play_sfx)
	confirmed.connect(Config.save_file)
	Controller.show_options_dialog.connect(self.show_dialog)
	self.options_tab_container.tab_clicked.connect(Audio.play_sfx_with_useless_argument)

	return

## Get the relevant children in the scene
func get_the_children() -> void:
	self.options_tab_container = get_node("TabContainer")

	return

## Callback handler for Controller signal
func show_dialog() -> void:
	popup_centered_ratio()

	return
