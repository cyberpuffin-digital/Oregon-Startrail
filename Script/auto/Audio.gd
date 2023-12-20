extends AudioStreamPlayer
## Audio controller

## Used to signal a change in the TTS system
signal tts_is(enabled: bool)

## List of Background songs
enum BgSongs {
	## Going Home Again
	EARTH,
	## Happy House Hunters
	WOLF_1061C,
	## SPDR - Jupiter
	EUROPA,
	## SPDR - Mercury
	MARS,
	## SPDR - Space Chatter
	MOON,
	## SPDR - Venus
	KUIPER_BELT,
	## Tech Time
	TRAVEL,
}

## Paths for background music
const BgPaths: Array = [
	## Earth
	"res://Audio/background/Going_Home_Again_130bpm_120s.ogg",
	## Worlf_1061C
	"res://Audio/background/Happy_House_Hunters_128bpm_122s.ogg",
	## Europa
	"res://Audio/background/SPDR - Jupiter - Massive, Heavy Wind, Big.ogg",
	## Mars
	"res://Audio/background/SPDR - Mercury - Solar Wind, Eruption, Pulsating.ogg",
	## Moon
	"res://Audio/background/SPDR - Space Chatter 4 - Radio, Mission Control.ogg",
	## Kuiper Belt
	"res://Audio/background/SPDR - Venus - Evil, Harsh Winds, Extreme Weather.ogg",
	## Travel
	"res://Audio/background/Tech_Time_146bpm_120s.ogg",
]

## Sound Effects
const SfxPaths: Array = [
	"res://Audio/sfx/scifi_ui_beep_button_01.wav",
	"res://Audio/sfx/select1.wav",
	"res://Audio/sfx/select2.wav",
	"res://Audio/sfx/select3.wav"
]

## Music muted
var music_muted: bool
## Music volume (db)
var music_volume: float
## Current music selection
var selection: int
## SFX muted
var sfx_muted: bool
## SFX selected
var sfx_selection: int
## SFX player
var sfx_stream_player: AudioStreamPlayer
## SFX volume (db)
var sfx_volume: float
## Track whether to enable TTS
var tts_enabled: bool = true
## Voice pitch
var tts_pitch: float = 1.0
## Playback rate
var tts_rate: float = 1.0
## TTS Voice to use (ID string)
var tts_voice_selected: String
## Volume
var tts_volume: int = 75

func _ready() -> void:
	Audio.get_the_children()
	Audio.connect_to_signals()
	Audio.set_the_children()
	Log.quiet("Audio controller loaded.")

	return

## Find and connect to SFX elements in the scene
func add_sfx_to_tree() -> void:
	if !get_tree():
		return

	var sfx_callable: Callable

	for sfx_child in get_tree().get_nodes_in_group("sfx"):
		sfx_callable = Callable(Audio.play_sfx)

		if sfx_child.has_method("is_pressed"):
			if !sfx_child.pressed.is_connected(sfx_callable):
				if sfx_child.pressed.connect(sfx_callable) != OK:
					Log.error("Failed to connect %s to SFX check" % [sfx_child.name])

					continue
				Log.silly("Connected %s to SFX check" % [sfx_child.name])

	return

## Change music to the [direction]
func change_music_to_the(direction: String = "right") -> void:
	Audio.set_background_music(
		Audio.selection + (-1 if direction.to_lower() == "left" else 1)
	)

	return

## Determine if message should be sent to TTS
func check_tts(msg_in: String, queued = false) -> void:
	if Audio.tts_enabled:
		if Audio.tts_voice_selected.is_empty():
			Log.error("No TTS Voice selected.")

			return
		Audio.send_to_tts(msg_in, queued)
	else:
		Log.debug("TTS Disabled.")

	return

## Configure Text To Speech system
func configure_tts() -> void:
	if DisplayServer.tts_get_voices().is_empty():
		Audio.tts_enabled = false
		Log.error("TTS subsystem is not available.")

		match OS.get_name():
			"Android", "iOS", "macOS", "Windows":
				Log.quiet("""
				TTS Libraries should be installed by default.  Please open a
				Github issue: https://github.com/cyberpuffin-digital/Oregon-Startrail/
				""")
			"UWP":
				Log.quiet("TTS not supported on this platform.")
			"Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD":
				Log.quiet("""
				TTS Subsystem can't be loaded.  Please ensure the required
				libraries are installed:
					* speech-dispatcher
					* festival
					* espeakup

				See https://docs.godotengine.org/en/stable/tutorials/audio/text_to_speech.html#requirements-for-functionality
				for more details.
				""")
			"Web":
				Log.quiet("TTS is not configured.")
			_:
				Log.quiet("Unrecognized OS, TTS disabled.")
	else:
		if self.tts_voice_selected.is_empty():
			self.tts_voice_selected = DisplayServer.tts_get_voices_for_language(
				OS.get_locale_language()
			)[0]

	return

## Connect to relevant signals
func connect_to_signals() -> void:
	get_tree().tree_changed.connect(Audio.add_sfx_to_tree)

	return

## Connect to nodes within the scene
func get_the_children() -> void:
	Audio.sfx_stream_player = get_node("EffectsAudioStreamPlayer")

	return

## Play sound effect
func play_sfx() -> void:
	if Audio.sfx_muted:
		return
	Audio.sfx_stream_player.play()

	return

func play_sfx_with_useless_argument(_useless) -> void:
	Audio.play_sfx()

## Send message to TTS Server
func send_to_tts(msg_in: String, queued: bool) -> void:
	Log.debug("Sending \"%s\" to TTS" % [msg_in])
	DisplayServer.tts_speak(
		msg_in, Audio.tts_voice_selected, Audio.tts_volume,
		Audio.tts_pitch, Audio.tts_rate, 0, !queued
	)

	return

## Set the background music [to] selection
func set_background_music(to: BgSongs) -> void:
	Audio.selection = to
	Audio.stop()
	Audio.stream = load(Audio.BgPaths[Audio.selection])
	Audio.play()

	return

## (Un)Mute the bus
func set_mute(muted: bool, which_bus: String) -> void:
	match which_bus.to_lower():
		"music":
			Audio.music_muted = muted
			AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), muted)
		"sfx":
			Audio.sfx_muted = muted
			AudioServer.set_bus_mute(AudioServer.get_bus_index("Sfx"), muted)
		_:
			Log.error("Unknown bus: %s" % [which_bus])
	Log.verbose("Set %s bus mute: %s" % [which_bus, muted])

	return

## Set the children to their initial state
func set_the_children() -> void:
	# BG Music
	Audio.selection = 0
	Audio.set_stream(load(Audio.BgPaths[Audio.selection]))
	Audio.play.call_deferred()

	# SFX
	Audio.sfx_selection = 0
	Audio.sfx_stream_player.set_stream(load(Audio.SfxPaths[Audio.sfx_selection]))

	# TTS
	Audio.configure_tts()

	return

## Set the volume on a bus, volume_in is expected in decibel (-inf - 0.0)
func set_volume(volume_in: float, which_bus: String) -> void:
	match which_bus.to_lower():
		"music":
			Audio.music_volume = volume_in
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), Audio.music_volume)
		"sfx":
			Audio.sfx_volume = volume_in
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sfx"), Audio.sfx_volume)
		_:
			Log.error("Unknown bus: %s" % [which_bus])
	Log.verbose("Set %s bus volume to %s" % [which_bus, volume_in])

	return

## Set audio bus from linear value
func set_volume_from_linear(volume_in: float, which_bus: String) -> void:
	Audio.set_volume(linear_to_db(volume_in), which_bus)

	return

## Stop TTS playback
func stop_tts() -> void:
	DisplayServer.tts_stop()
	Log.debug("TTS Server playback stopped.")

	return
