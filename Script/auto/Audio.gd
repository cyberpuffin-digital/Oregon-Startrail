extends Node
## Audio controller

## Used to signal a change in the TTS system
signal tts_is(enabled: bool)

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
			"Android", "iOS", "macOS", "Windows", "Web":
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
	else:
		if self.tts_voice_selected.is_empty():
			self.tts_voice_selected = DisplayServer.tts_get_voices_for_language(
				OS.get_locale_language()
			)[0]

	return

func send_to_tts(msg_in: String, queued: bool) -> void:
	Log.debug("Sending \"%s\" to TTS" % [msg_in])
	DisplayServer.tts_speak(
		msg_in, Audio.tts_voice_selected, Audio.tts_volume,
		Audio.tts_pitch, Audio.tts_rate, 0, !queued
	)

	return
