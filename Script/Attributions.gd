extends Control

enum Buttons {
	BFXR,
	OpenDyslexic,
	SFXR
}

## Button link to BFXR homepage
var bfxr_button: Button
## Button link to Open Dyslexic homepage
var opendyslexic_button: Button
## Button link to SFXR homepage
var sfxr_button:Button

func _ready() -> void:
	self.get_the_children()
	self.connect_to_signals()

	return

## Connect to signals relevant to this scene
func connect_to_signals() -> void:
	self.bfxr_button.pressed.connect(self.open_button_link.bind(Buttons.BFXR))
	self.opendyslexic_button.pressed.connect(
		self.open_button_link.bind(Buttons.OpenDyslexic)
	)
	self.sfxr_button.pressed.connect(self.open_button_link.bind(Buttons.SFXR))

	return

## Find children relevant in this scene
func get_the_children() -> void:
	self.bfxr_button = get_node("%BfxrButton")
	self.opendyslexic_button = get_node("%OpenDyslexicButton")
	self.sfxr_button = get_node("%SfxrButton")

	return

func open_button_link(button_in: int) -> void:

	match button_in:
		Buttons.BFXR:
			pass
		Buttons.

	return
