extends CanvasLayer

@onready var control: Control = $Control
@onready var background: ColorRect = $Control/Background

func _ready():
	hide()
	control.modulate.a = 0
	background.modulate.a = 0
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _input(event):
	if event.is_action_pressed("pause"):
		if get_tree().current_scene.name == "Menu":
			return
		if Instructions.visible:
			Instructions.toggle_instructions()
			return
			
		toggle_pause()

func toggle_pause():
	var new_state = !get_tree().paused
	
	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	
	if new_state:
		get_tree().paused = true
		show() 
		tween.tween_property(background, "modulate:a", 0.8, 0.3)
		tween.tween_property(control, "modulate:a", 1.0, 0.3)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		tween.tween_property(control, "modulate:a", 0.0, 0.3)
		tween.tween_property(background, "modulate:a", 0.0, 0.3)
		await tween.finished
		hide()
		if get_tree().current_scene.name != "Menu":
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = false

func _on_resume_pressed() -> void:
	toggle_pause()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_instructions_pressed() -> void:
	Instructions.toggle_instructions()
