extends AcceptDialog

## Main Dialog tab container
var dialog_tab_container: TabContainer
## Start TTS reading button
var tts_start_button: Button
## Stop TTS reading button
var tts_stop_button: Button
## TTS Button container
var tts_button_hbox_container: HBoxContainer

func _ready() -> void:
	self.get_the_children()
	self.connect_to_signals()
	self.toggle_tts()

	return

## Connect to relevant signals in the scene
func connect_to_signals() -> void:
	canceled.connect(Audio.play_sfx)
	confirmed.connect(Audio.play_sfx)
	Audio.tts_is.connect(self.toggle_tts)
	self.tts_start_button.pressed.connect(self.read_active_tab)
	self.tts_stop_button.pressed.connect(Audio.stop_tts)
	self.tts_stop_button.pressed.connect(Audio.play_sfx)

	return

## Get the relevant children in the scene
func get_the_children() -> void:
	self.dialog_tab_container = get_node("%DialogTabContainer")
	self.tts_start_button = get_node("%TTSButtonStart")
	self.tts_stop_button = get_node("%TTSButtonStop")
	self.tts_button_hbox_container = get_node("%TTSButtonHBoxContainer")

	return

## Cycle through active tab and send text to TTS
func read_active_tab() -> void:
	Audio.stop_tts()

	for container in self.dialog_tab_container.get_current_tab_control().get_children():
		if container is VBoxContainer:
			for label in container.get_children():
				Audio.check_tts(tr(label.text), true)

	return

## Set the currently visible dialog
func set_dialog_tab(index: int = Controller.current_waypoint) -> void:
	index = posmod(index, Controller.Waypoint.size())
	self.dialog_tab_container.set_current_tab(index)

	match index:
		Controller.Waypoint.Earth:
			get_ok_button().text = tr("GEETHANKS")
			self.title = tr("DEPARTFROMEARTH")
		Controller.Waypoint.Moon:
			get_ok_button().text = tr("THANKSHUNGUP")
			self.title = tr("FAREWELLMOON")
		Controller.Waypoint.Mars:
			get_ok_button().text = tr("NEATTHANKS")
			self.title = tr("BYERED")
		Controller.Waypoint.Europa:
			get_ok_button().text = tr("THANKS")
			self.title = tr("OXYGENDONTGROW")
		Controller.Waypoint.KuiperBelt:
			get_ok_button().text = tr("GREATTHANKS")
			self.title = tr("KEEPWARM")
		Controller.Waypoint.Wolf1061c:
			get_ok_button().text = tr("DOOURBEST")
			self.title = tr("LIVELONGANDPROSPER")
		_:
			Log.error("Unknown dialog tab requested: %s" % [index])

	return

## Show or hide TTS speech button when TTS is set
func toggle_tts(enabled: bool = Audio.tts_enabled) -> void:
	self.tts_button_hbox_container.visible = enabled

	return
