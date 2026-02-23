extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var transition_layer: CanvasLayer = $"Transition Layer"
@onready var black_screen: ColorRect = $"Transition Layer/blackScreen"

func _ready() -> void:
	GameState.has_double_jump = false
	GameState.has_wall_jump = false
	player.has_wall_jump = false
	player.max_jump_count = 1
	
	black_screen.modulate.a = 1.0
	black_screen.visible = true
	
	var tween = create_tween()
	tween.tween_interval(0.5)
	tween.tween_property(black_screen, "modulate:a", 0.0, 5)
	tween.tween_callback(transition_layer.queue_free)
	
	var camera = get_viewport().get_camera_2d()
	
	# aplica o zoom na câmera
	if camera and camera.has_method("intro_zoom"):
		camera.intro_zoom()
