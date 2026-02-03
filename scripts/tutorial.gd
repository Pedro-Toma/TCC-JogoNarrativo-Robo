extends Node2D

@onready var black_screen: ColorRect = $TransitionLayer/BlackScreen
@onready var transition_layer: CanvasLayer = $TransitionLayer
		
func _ready():
	# pega a câmera sem precisa do caminhoe
	black_screen.modulate.a = 1.0
	black_screen.visible = true
	
	var tween = create_tween()
	tween.tween_interval(0.5)
	tween.tween_property(black_screen, "modulate:a", 0.0, 1.5)
	tween.tween_callback(transition_layer.queue_free)
	
	var camera = get_viewport().get_camera_2d()
	
	# aplica o zoom na câmera
	if camera and camera.has_method("intro_zoom"):
		camera.intro_zoom()
