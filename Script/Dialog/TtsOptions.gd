extends Control

var tts_enabled_check_box: CheckBox
var tts_pitch_slider: HSlider
var tts_pitch_value_label: Label
var tts_rate_slider: HSlider
var tts_rate_value_label: Label
var tts_voice_item_list: ItemList
var tts_volume_slider: HSlider
var tts_volume_value_label: Label

func _ready() -> void:
	self.get_the_children()
	self.connect_to_signals()
	self.set_the_children()

	return

## Connect to relevant signals in the scene
func connect_to_signals() -> void:
	self.tts_enabled_check_box.toggled.connect(self.toggle_tts.bind(true))
	self.tts_pitch_slider.value_changed.connect(self.set_tts_pitch.bind(true))
	self.tts_rate_slider.value_changed.connect(self.set_tts_rate.bind(true))
	self.tts_volume_slider.value_changed.connect(self.set_tts_volume.bind(true))
	self.tts_voice_item_list.item_selected.connect(self.set_tts_voice.bind(true))

	return

## Get the relevant children in the scene
func get_the_children() -> void:
	self.tts_enabled_check_box = get_node("%TTSEnabledCheckBox")
	self.tts_pitch_slider = get_node("%PitchHSlider")
	self.tts_pitch_value_label = get_node("%PitchValueLabel")
	self.tts_rate_slider = get_node("%RateHSlider")
	self.tts_rate_value_label = get_node("%RateValueLabel")
	self.tts_voice_item_list = get_node("%TTSVoicesItemList")
	self.tts_volume_slider = get_node("%VolumeHSlider")
	self.tts_volume_value_label = get_node("%VolumeValueLabel")

	return

## Set the children to the current state
func set_the_children() -> void:
	self.tts_enabled_check_box.set_pressed_no_signal(Audio.tts_enabled)
	self.toggle_tts(Audio.tts_enabled, false)
	self.tts_pitch_slider.set_value_no_signal(Audio.tts_pitch * 10)
	self.set_tts_pitch(Audio.tts_pitch * 10, false)
	self.tts_rate_slider.set_value_no_signal(Audio.tts_rate * 10)
	self.set_tts_rate(Audio.tts_rate * 10, false)
	self.tts_volume_slider.set_value_no_signal(Audio.tts_volume)
	self.set_tts_volume(Audio.tts_volume, false)
	self.update_tts_voice_list()

	return

## Set Text To Speech voice pitch[br]
## Expected input: 0 - 20
func set_tts_pitch(value_in: float = 10, read_aloud: bool = false) -> void:
	# Convert slider value to float and clamp between 0.0 and 2.0
	value_in = fposmod(fposmod(round(value_in), 21) / 10, 3.0)
	Audio.tts_pitch = value_in
	self.tts_pitch_value_label.set_text("%.1f" % [Audio.tts_pitch])
	if read_aloud:
		Audio.check_tts("%s %.1f" % [tr("TTSPITCH"), Audio.tts_pitch])
	Log.verbose("TTS Pitch set to %s" % [value_in])

	return

## Set Text To Speech playback rate[br]
## Expected input: 0 - 100
func set_tts_rate(value_in: float = 10, read_aloud: bool = false) -> void:
	# Convert slider value to float and clamp between 0.0 and 10.0
	value_in = fposmod(fposmod(round(value_in), 101) / 10, 11.0)
	Audio.tts_rate = value_in
	self.tts_rate_value_label.set_text("%.1f" % [Audio.tts_rate])
	if read_aloud:
		Audio.check_tts("%s %.1f" % [tr("TTSRATE"), Audio.tts_rate])
	Log.verbose("TTS Rate set to %s" % [value_in])

	return

## Set Text To Speech voice to use
func set_tts_voice(index: int, read_aloud: bool = false) -> void:
	Audio.tts_voice_selected = self.tts_voice_item_list.get_item_metadata(index)
	if read_aloud:
		Audio.check_tts("%s %s" % [tr("TTSVOICELABEL"), self.tts_voice_item_list.get_item_text(index)])
	Log.verbose("TTS Voice selected: %s" % [Audio.tts_voice_selected])

	return

## Set Text To Speech volume[br]
## Expected input: 0 - 100
func set_tts_volume(value_in: int = 75, read_aloud: bool = false) -> void:
	value_in = posmod(value_in, 101)
	Audio.tts_volume = value_in
	self.tts_volume_value_label.set_text("%s" % [Audio.tts_volume])
	if read_aloud:
		Audio.check_tts("%s %s" % [tr("TTSVOLUME"), Audio.tts_volume])
	Log.verbose("TTS Volume set to %s" % [value_in])

	return

## Callback for toggling TTS
func toggle_tts(pressed: bool, read_aloud: bool = false) -> void:
	Audio.tts_enabled = pressed
	Audio.tts_is.emit(Audio.tts_enabled)
	if read_aloud:
		Audio.check_tts(tr("TTSENABLED"))
	Log.verbose("TTS %sabled" % ["en" if Audio.tts_enabled else "dis"])

	return

## Build the item list of TTS voices to select from
func update_tts_voice_list() -> void:
	var current_locale: String = OS.get_locale_language()
	var index: int

	# Add the voices to the TTS voice list
	self.tts_voice_item_list.clear()
	for voice in DisplayServer.tts_get_voices():
		if voice["language"].begins_with(current_locale):
			index = self.tts_voice_item_list.add_item(voice["name"])
			self.tts_voice_item_list.set_item_metadata(index, voice["id"])
			if voice["id"] == Audio.tts_voice_selected:
				self.tts_voice_item_list.select(index)
	self.tts_voice_item_list.sort_items_by_text()
	self.tts_voice_item_list.ensure_current_is_visible()

	return
