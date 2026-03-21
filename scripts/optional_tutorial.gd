extends Node2D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$HBoxContainer/Yes.grab_focus()

func _on_yes_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/tutorial.tscn")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _on_no_pressed() -> void:
	GameState.fase_central_atual += 1
	get_tree().change_scene_to_file("res://scenes/cutscene.tscn")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
