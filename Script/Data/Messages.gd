extends ScrollContainer

const LINE_LIMIT: int = 1000

var messages_text_edit: TextEdit
var syntax_highlight: CodeHighlighter

func _ready():
	self.get_the_children()
	self.connect_to_signals()
	self.set_the_children()

	return

## Connect to relevant signals in the scene
func connect_to_signals():
	Log.message_logged.connect(handle_log_msg)

	return

## Get the relevant children in the scene
func get_the_children():
	self.messages_text_edit = get_node("TextEdit")
	self.syntax_highlight = self.messages_text_edit.get_syntax_highlighter()

	return

## Add log messages to messages window
func handle_log_msg(msg: String) -> void:
	self.messages_text_edit.insert_line_at(0, "[%0.2f] %s" % [
		snappedf(Controller.get_game_time(), 0.01), msg
	])

	if self.messages_text_edit.get_line_count() > self.LINE_LIMIT:
		self.messages_text_edit.select(self.LINE_LIMIT, 0, self.LINE_LIMIT + 1, 0)
		self.messages_text_edit.delete_selection()

	self.messages_text_edit.set_v_scroll(0)

	return

## Set initial state for children in the scene
func set_the_children():
	self.messages_text_edit.clear()
	self.setup_syntax_highlight()

	return

## Setup text edit's syntax highlighter
func setup_syntax_highlight() -> void:
#	self.syntax_highlight.add_color_region("[", "]", Color(0.13756674528122, 0.53645831346512, 0.58346885442734))

	return
