extends ConfirmationDialog

func _ready() -> void:
	self.get_the_children()
	self.connect_to_signals()


func connect_to_signals() -> void:
	Controller.show_options_dialog.connect(self.show_dialog)

	return

## Get the relevant children in the scene
func get_the_children() -> void:

	return

func show_dialog() -> void:
	popup_centered_ratio()

	return
