extends AudioStreamPlayer2D
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

## Music muted
var music_muted: bool
## Music volume (db)
var music_volume: float
## Current music selection
var selection: int
## SFX muted
var sfx_muted: bool
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
	Audio.configure_tts()
	Audio.selection = 0
	Audio.stream = load(Audio.BgPaths[Audio.selection])
	Audio.play.call_deferred()
	Log.quiet("Audio controller loaded.")

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
