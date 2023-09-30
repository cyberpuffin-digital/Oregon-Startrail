extends Node
## Configuration
##
## Handle user preferences and settings

const LOCALES: Array = [
	## English
	"en",
	## English - Canadian
	"en_CA",
	## Arabic
	"ar",
	## Mandarin
	"cmn",
	## Czech
	"cs",
	## German
	"de",
	## Spanish
	"es",
	## Finnish
	"fi",
	## French
	"fr",
	## Hindii
	"hi",
	## Italian
	"it",
	## Japanese
	"ja",
	## Korean
	"ko",
	## Polish
	"pl",
	## Portuguese
	"pt",
	## Russian
	"ru",
	## Ukrainian
	"uk",
]
## Path to user preference file
const SAVE_FILE_PATH: String = "user://options.cfg"

## Config file handler
var handler: ConfigFile
## Language / locale of choice
var locale: int
## Track whether the user has chosen a locale
var locale_chosen: bool
## Log verbosity level, corresponds to [enum Log.Level]
var verbosity: int = Log.Level.Debug

func _ready() -> void:
	Config.reset()
	# TODO: Figure out why this is freezing the game
	Config.load_file()

	return

## Check config file handler
func is_handler_valid() -> bool:
	if !(Config.handler is ConfigFile):
		Log.error("User Preference handler is invalid.")

		return false

	return true

## Load config file
func load_file() -> void:
	var err = Config.handler.load(Config.SAVE_FILE_PATH)

	if err != OK:
		Log.verbose("Failed to load, creating default file.")
		if !Config.save_file():
			Log.error("Failed to save default config (error: %d)." % [err])

			return

	Config.load_file_audio()
	Config.load_file_controller()
	Config.load_file_general()

	Log.verbose("User preferences loaded from %s" % [Config.SAVE_FILE_PATH])

	return

## Load general user preferences
func load_file_audio() -> void:
	var in_value

	# TTS Enabled
	in_value = Config.handler.get_value("Audio", "tts_enabled", true)
	if typeof(in_value) == TYPE_BOOL:
		Audio.tts_enabled = in_value

	# TTS Pitch
	in_value = Config.handler.get_value("Audio", "tts_pitch", 1.0)
	if typeof(in_value) == TYPE_FLOAT:
		Audio.tts_pitch = in_value

	# TTS Rate
	in_value = Config.handler.get_value("Audio", "tts_rate", 1.0)
	if typeof(in_value) == TYPE_FLOAT:
		Audio.tts_rate = in_value

	# TTS Voice
	in_value = Config.handler.get_value("Audio", "tts_voice_selected")
	if typeof(in_value) == TYPE_STRING and !in_value.is_empty():
		Audio.tts_voice_selected = in_value

	# TTS Volume
	in_value = Config.handler.get_value("Audio", "tts_volume", 75)
	if typeof(in_value) == TYPE_INT:
		Audio.tts_volume = in_value

	return

## Load controller data
func load_file_controller() -> void:
	var in_value

	# Current Waypoint
	in_value = Config.handler.get_value("Controller", "current_waypoint", 0)
	if typeof(in_value) == TYPE_INT:
		Controller.current_waypoint = in_value

	# Last Waypoint
	in_value = Config.handler.get_value("Controller", "last_waypoint", 0)
	if typeof(in_value) == TYPE_INT:
		Controller.last_waypoint = in_value

	# Next Waypoint
	in_value = Config.handler.get_value("Controller", "next_waypoint", 1)
	if typeof(in_value) == TYPE_INT:
		Controller.next_waypoint = in_value

	return

## Load general user preferences
func load_file_general() -> void:
	var in_value

	# Locale
	in_value = Config.handler.get_value("General", "locale", 0)
	if typeof(in_value) == TYPE_INT:
		Config.locale = in_value
		TranslationServer.set_locale(Config.LOCALES[Config.locale])

	# Locale chosen
	in_value = Config.handler.get_value("General", "locale_chosen", false)
	if typeof(in_value) == TYPE_BOOL:
		Config.locale_chosen = in_value

	# Verbosity
	in_value = Config.handler.get_value("General", "verbosity", Log.Level.Quiet)
	if typeof(in_value) == TYPE_INT:
		Config.verbosity = in_value

	return

## Reset configuration
func reset() -> void:
	Config.handler = ConfigFile.new()
	Config.verbosity = Log.Level.Quiet
	Config.locale = 0
	Config.locale_chosen = false

	return

## Save preferences to file
func save_file() -> bool:
	var err = Config.handler.load(Config.SAVE_FILE_PATH)

	Config.save_file_audio()
	Config.save_file_controller()
	Config.save_file_general()

	err = Config.handler.save(Config.SAVE_FILE_PATH)

	if err == OK:
		Log.verbose("Config file saved to %s" % [Config.SAVE_FILE_PATH])

		return true

	Log.error("Failed to save config file (%s): ErrNo: %d" % [
		Config.SAVE_FILE_PATH, err
	])

	return false

## Save Audio config to preference file.
func save_file_audio() -> void:
	if !Config.is_handler_valid():
		return

	var fields: Dictionary = {
		"tts_enabled": Audio.tts_enabled,
		"tts_pitch": Audio.tts_pitch,
		"tts_rate": Audio.tts_rate,
		"tts_voice_selected": Audio.tts_voice_selected,
		"tts_volume": Audio.tts_volume,
	}

	Config.save_to_file(fields, "Audio")
	Log.debug("Audio preferences written to preference handler.")

	return

## Save General config to preference file.
func save_file_controller() -> void:
	if !Config.is_handler_valid():
		return

	var fields: Dictionary = {
		"current_waypoint": Controller.current_waypoint,
		"last_waypoint": Controller.last_waypoint,
		"next_waypoint": Controller.next_waypoint,
	}

	Config.save_to_file(fields, "Controller")
	Log.debug("Controller state written to preference handler.")

	return

## Save General config to preference file.
func save_file_general() -> void:
	if !Config.is_handler_valid():
		return

	var fields: Dictionary = {
		"locale": Config.locale,
		"locale_chosen": Config.locale_chosen,
		"verbosity": Config.verbosity,
	}

	Config.save_to_file(fields, "General")
	Log.debug("General preferences written to preference handler.")

	return

## Save <fields> to <section> of preference file
func save_to_file(fields: Dictionary, section: String) -> void:
	if !Config.is_handler_valid():
		return

	for field in fields.keys():
		Config.handler.set_value(section, field, fields[field])

	return
