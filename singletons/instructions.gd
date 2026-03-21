extends CanvasLayer

signal closed

@onready var control: Control = $Control
@onready var background: ColorRect = $Control/Background

func _ready():
	hide()
	control.modulate.a = 0
	background.modulate.a = 0
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _input(event):
	if not visible:
		return
	if event is InputEventMouseMotion:
		var focused_node = get_viewport().gui_get_focus_owner()
		if focused_node:
			focused_node.release_focus()
	elif event.is_action_pressed("ui_left"):
		toggle_instructions()
	elif event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down") or \
		 event.is_action_pressed("ui_right"):
		
		if get_viewport().gui_get_focus_owner() == null:
			$Control/Button.grab_focus()
			get_viewport().set_input_as_handled()
func toggle_instructions():
	
	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	
	if !visible:
		show()
		$Control/Button.grab_focus()
		tween.tween_property(background, "modulate:a", 0.8, 0.3)
		tween.tween_property(control, "modulate:a", 1.0, 0.3)
		await tween.finished
	else:
		tween.tween_property(control, "modulate:a", 0.0, 0.3)
		tween.tween_property(background, "modulate:a", 0.0, 0.3)
		await tween.finished
		hide()
		closed.emit()


func _on_button_pressed() -> void:
	toggle_instructions()
