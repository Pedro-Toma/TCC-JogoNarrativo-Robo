extends Node2D

func _ready() -> void:
	Instructions.closed.connect(_on_instructions_closed)
	GameState.fase_central_atual = 0
	$CanvasLayer/FadeTransition.show()
	$CanvasLayer/FadeTransition/AnimationPlayer.play("fade_out")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$ButtonManager/Start.grab_focus()
	GlobalMusic.play_music("main")

func _input(event):
	if event is InputEventMouseMotion:
		var focused_node = get_viewport().gui_get_focus_owner()
		if focused_node:
			focused_node.release_focus()
	elif not visible or Instructions.visible:
		return
	elif event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down") or \
		 event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right"):
		
		if get_viewport().gui_get_focus_owner() == null:
			$ButtonManager/Start.grab_focus()
			get_viewport().set_input_as_handled()

func _on_start_pressed() -> void:
	$CanvasLayer/FadeTransition.show()
	$CanvasLayer/FadeTransition/Timer.start()
	$CanvasLayer/FadeTransition/AnimationPlayer.play("fade_in")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_timer_timeout() -> void:
	if GameState.first_time_playing:
		GameState.first_time_playing = false
		get_tree().change_scene_to_file("res://scenes/intro.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/optional_tutorial.tscn")
	
func _on_instructions_pressed() -> void:
	set_buttons_focus_mode(Control.FOCUS_NONE)
	Instructions.toggle_instructions()

func _on_instructions_closed():
	set_buttons_focus_mode(Control.FOCUS_ALL)
	$ButtonManager/Instructions.grab_focus()
	
func set_buttons_focus_mode(mode):
	$ButtonManager/Start.focus_mode = mode
	$ButtonManager/Quit.focus_mode = mode
	$ButtonManager/Instructions.focus_mode = mode
