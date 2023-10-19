extends Control
## Audio options tab

## Music mute check
var music_mute_check_box: CheckBox
## Music volume slider
var music_volume_slider: HSlider
## SFX mute check
var sfx_mute_check_box: CheckBox
## SFX volume slider
var sfx_volume_slider: HSlider

func _ready() -> void:
	self.get_the_children()
	self.connect_to_signals()
	self.set_the_children()

	return

## Connect to relevant signals in the scene
func connect_to_signals() -> void:
	self.music_mute_check_box.toggled.connect(self.toggle_mute.bind("music"))
	self.music_mute_check_box.pressed.connect(Audio.play_sfx)
	self.music_volume_slider.value_changed.connect(Audio.play_sfx_with_useless_argument)
	self.music_volume_slider.value_changed.connect(self.set_volume_slider.bind("music"))
	self.sfx_mute_check_box.pressed.connect(Audio.play_sfx)
	self.sfx_mute_check_box.toggled.connect(self.toggle_mute.bind("sfx"))
	self.sfx_volume_slider.value_changed.connect(Audio.play_sfx_with_useless_argument)
	self.sfx_volume_slider.value_changed.connect(self.set_volume_slider.bind("sfx"))

	return

## Get the relevant children in the scene
func get_the_children() -> void:
	self.music_mute_check_box = get_node("%MusicMuteCheckBox")
	self.music_volume_slider = get_node("%MusicVolumeHSlider")
	self.sfx_mute_check_box = get_node("%SfxMuteCheckBox")
	self.sfx_volume_slider = get_node("%SfxVolumeHSlider")

	return

## Set initial state for children in the scene
func set_the_children() -> void:
	self.music_mute_check_box.set_pressed_no_signal(
		AudioServer.is_bus_mute(AudioServer.get_bus_index("Music"))
	)
	self.music_volume_slider.set_value_no_signal(
		db_to_linear(
			AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
		)
	)
	self.sfx_mute_check_box.set_pressed_no_signal(
		AudioServer.is_bus_mute(AudioServer.get_bus_index("Sfx"))
	)
	self.sfx_volume_slider.set_value_no_signal(
		db_to_linear(
			AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sfx"))
		)
	)

	return

#		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), in_value)

## Handle slider changes
func set_volume_slider(value: float, which_bus: String) -> void:
	value = clampf(value, 0, 100)
	Audio.set_volume_from_linear(value, which_bus)

	return

## Handle check box toggling
func toggle_mute(pressed: bool, which_bus: String) -> void:
	Audio.set_mute(pressed, which_bus)

	return
