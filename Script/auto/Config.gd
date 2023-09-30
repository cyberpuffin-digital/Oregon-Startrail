extends Node
## Configuration
##
## Handle user preferences and settings

const LOCALES: Array = [
	## English
	"en",
	## English - Canadian
	"en_CA",
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
	## Arabic
	"ar"
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
#	Config.load_file()

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

	Config.load_file_general()

	Log.verbose("User preferences loaded from %s" % [Config.SAVE_FILE_PATH])

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

	Config.save_file_general()

	err = Config.handler.save(Config.SAVE_FILE_PATH)

	if err == OK:
		Log.verbose("Config file saved to %s" % [Config.SAVE_FILE_PATH])

		return true

	Log.error("Failed to save config file (%s): ErrNo: %d" % [
		Config.SAVE_FILE_PATH, err
	])

	return false

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
