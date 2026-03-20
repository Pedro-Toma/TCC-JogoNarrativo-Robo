extends CanvasLayer

@onready var control: Control = $Control
@onready var background: ColorRect = $Control/Background

func _ready():
	hide()
	control.modulate.a = 0
	background.modulate.a = 0
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func toggle_instructions():
	
	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	
	if !visible:
		show() 
		tween.tween_property(background, "modulate:a", 0.8, 0.3)
		tween.tween_property(control, "modulate:a", 1.0, 0.3)
	else:
		tween.tween_property(control, "modulate:a", 0.0, 0.3)
		tween.tween_property(background, "modulate:a", 0.0, 0.3)
		await tween.finished
		hide()


func _on_button_pressed() -> void:
	toggle_instructions()
