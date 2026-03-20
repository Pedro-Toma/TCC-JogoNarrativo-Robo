extends Node2D

func _ready() -> void:
	$CanvasLayer/FadeTransition.show()
	$CanvasLayer/FadeTransition/AnimationPlayer.play("fade_out")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func _on_start_pressed() -> void:
	$CanvasLayer/FadeTransition.show()
	$CanvasLayer/FadeTransition/Timer.start()
	$CanvasLayer/FadeTransition/AnimationPlayer.play("fade_in")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/intro.tscn")
