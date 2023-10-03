extends Node

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		check_key_input(event)

	return

## Global keyboard check
func check_key_input(event: InputEventKey) -> void:
	if event.is_pressed():
		match event.keycode:
			KEY_ESCAPE:
				match get_tree().current_scene.name:
					"MainMenu":
						Config.save_file()
						if OS.get_name() != "Web":
							get_tree().quit()
					"GameWindow":
						get_tree().change_scene_to_file("res://Scene/MainMenu.tscn")
					_:
						Log.error("Trying to escape from an unknown scene.")

				Log.quiet("Escape hit in %s scene" % [get_tree().current_scene.name])

	return
