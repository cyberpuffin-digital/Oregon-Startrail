extends AcceptDialog

## Tab index for each dialog section
enum DialogTabs {
	## Starting welcome message
	Welcome,
}

## Main Dialog tab container
var dialog_tab_container: TabContainer
## TTS read button
var tts_button: Button
## TTS Button container
var tts_button_hbox_container: HBoxContainer

func _ready() -> void:
	self.get_the_children()
	self.connect_to_signals()
	self.toggle_tts()

	return

## Connect to relevant signals in the scene
func connect_to_signals() -> void:
	Audio.tts_is.connect(self.toggle_tts)
	Controller.ready_to_start.connect(self.start_dialog)
	self.tts_button.pressed.connect(self.read_active_tab)

	return

## Get the relevant children in the scene
func get_the_children() -> void:
	self.dialog_tab_container = get_node("%DialogTabContainer")
	self.tts_button = get_node("%TTSButton")
	self.tts_button_hbox_container = get_node("%TTSButtonHBoxContainer")

	return

## Cycle through active tab and send text to TTS
func read_active_tab() -> void:
	for container in self.dialog_tab_container.get_current_tab_control().get_children():
		if container is VBoxContainer:
			for label in container.get_children():
				Audio.check_tts(tr(label.text), true)

	return

## Show dialog in initial state if Controller settings are correct
func start_dialog() -> void:
	if Controller.travel_state == State.Ready_To_Start:
		self.dialog_tab_container.set_current_tab(self.DialogTabs.Welcome)
		get_ok_button().text = tr("GEETHANKS")
		self.title = tr("EMBARKFROMEARTH")
		popup_centered_ratio()
	else:
		Log.error("Invalid travel state (%s) to show welcome dialog." % [
			Controller.travel_state
		])

	return

## Show or hide TTS speech button when TTS is set
func toggle_tts(enabled: bool = Audio.tts_enabled) -> void:
	self.tts_button_hbox_container.visible = enabled

	return
