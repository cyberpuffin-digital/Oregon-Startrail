extends Node
## Logging singleton
##
## Handle logging and message delivery.

## Log send interval
const OUTPUT_MIN_INTERVAL: float = 0.1

## Verbosity levels
enum Level {
	## Vital messages only
	Quiet,
	## System messages
	Verbose,
	## A lot of messages
	Debug,
	## Some might say "too many" messages
	Silly
}

## Timer to send messages at interval
var message_timer: Timer
## Reference to first log message
var msg_first: LogMessage
## Reference to last log message
var msg_last: LogMessage

func _exit_tree() -> void:
	Log.clear_message_queue()

	return

func _ready() -> void:
	Log.configure_timer()
	Log.process_mode = Node.PROCESS_MODE_ALWAYS

	return

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		match event.keycode:
			KEY_F12:
				Log.verbose("Requesting log queue clear.")
				Log.clear_message_queue()

	return

## Add new message to the Log queue
func add_msg_to_queue(msg: String = "blank") -> void:
	if msg == "blank":
		Log.error("Can't add blank message to log queue.")

		return

	var new_log: LogMessage = LogMessage.new(msg)

	if Log.msg_first:
		Log.msg_last.set_next(new_log)
		Log.msg_last = new_log
	else: # empty queue
		Log.msg_first = new_log
		Log.msg_last = new_log

	return

## Clear message queue without waiting for timeout
func clear_message_queue() -> void:
	if !Log.msg_first:
		return
	while Log.msg_first:
		Log.send_message()

	print("%s: Message queue cleared." % [Time.get_datetime_string_from_system()])
	if Config.verbosity > Log.Level.Verbose:
		print_stack()

	return

func configure_timer() -> void:
	Log.message_timer = Timer.new()
	Log.message_timer.name = "Message interval"
	add_child(Log.message_timer)
	Log.message_timer.autostart = true
	Log.message_timer.one_shot = false
	Log.message_timer.paused = false
	Log.message_timer.wait_time = Log.OUTPUT_MIN_INTERVAL
	Log.message_timer.start()
	Log.message_timer.timeout.connect(Log.send_message)

	return

func debug(msg: String) -> void:
	if !Config:
		msg = "Deferred: %s" % [msg]
		call_deferred("debug", msg)

		return

	if Config.verbosity >= Log.Level.Debug:
		Log.add_msg_to_queue(msg)

	return

func error(msg: String) -> void:
	if Config.verbosity >= Log.Level.Debug:
		Log.add_msg_to_queue(msg)

	push_error("%s: %s\n%s" % [
		Time.get_datetime_string_from_system(), msg,
		Log.stack_to_string(get_stack(), false).rstrip("\n\r\t")
	])

	return

func quiet(msg: String) -> void:
	Log.add_msg_to_queue(msg)

	return

func send_message() -> void:
	if !Log.msg_first:
		return

	# Output message
	print_rich("[color=white][u]%s[/u]: %s[/color]" % [
		Time.get_datetime_string_from_system(), Log.msg_first.message
	])
	if Config.verbosity >= Log.Level.Debug:
		print_rich(Log.stack_to_string(Log.msg_first.stack, true))

	# Push to messages
	# TODO: Add messages tab to data area

	# Clear message
	Log.msg_first.queue_free()
	Log.msg_first = Log.msg_first.next_msg

	return

func silly(msg: String) -> void:
	if !Config:
		msg = "Deferred: %s" % [msg]
		call_deferred("silly", msg)

		return

	if Config.verbosity >= Log.Level.Silly:
		Log.add_msg_to_queue(msg)

	return

## Convert stack to pretty string
func stack_to_string(stack: Array, pretty: bool) -> String:
	var json_obj: JSON = JSON.new()
	var output_msg: String = ""

	for frame in stack:
		if json_obj.parse(str(frame)) != OK:
			Log.error("Failed to parse frame in log message stack.")
			continue

		# Skip specific log function
		if json_obj.data.source == "res://Script/auto/Log.gd":
			if json_obj.data.function in [
				"add_msg_to_queue", "debug", "error", "quiet", "send_message",
				"silly", "verbose", "_init"
			]:
				continue

		if pretty:
			output_msg += "[right]%s%s%s%s%s @ %s%s%s:%s%s%s[/right]" % [
				"[color=white]", "[code]", json_obj.data.function, "[/code]", "[/color]",
				"[color=blue]", json_obj.data.source, "[/color]",
				"[color=yellow]", json_obj.data.line, "[/color]",
			]
		else:
			output_msg += "\t%s:%s (%s)\n" % [
				json_obj.data.source,
				json_obj.data.line,
				json_obj.data.function,
			]

	return output_msg

func verbose(msg: String) -> void:
	if !Config:
		msg = "Deferred: %s" % [msg]
		call_deferred("verbose", msg)

		return

	if Config.verbosity >= Log.Level.Verbose:
		Log.add_msg_to_queue(msg)

	return

## Log message node
##
## Nodes in a linked list that carry log messages
class LogMessage:
	extends Node

	## Message data to send to output
	var message: String
	## Link to next message in list
	var next_msg: LogMessage
	## Call stack for this message
	var stack: Array

	## Store message data
	func _init(msg: String = "blank", stack_in: Array = get_stack()) -> void:
		if msg == "blank":
			Log.error("Can't create empty Log messages.")
		else:
			self.message = msg
			self.stack = stack_in
		self.name = "Log Message"

		return

	func set_next(next: LogMessage) -> void:
		if self.next_msg:
			Log.error("Next message is already set.")

			return

		self.next_msg = next

		return
