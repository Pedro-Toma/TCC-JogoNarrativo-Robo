extends Node2D

@onready var black_screen: ColorRect = $"Transition Layer/blackScreen"
@onready var player: CharacterBody2D = $Player

func _ready() -> void:
	player.pode_mover = false
	black_screen.modulate.a = 0.0
	black_screen.visible = false
	
	var camera = get_viewport().get_camera_2d()
	# aplica o zoom na câmera
	if camera and camera.has_method("zoom_in"):
		await camera.zoom_in()

	GlobalMusic.switch_music("final")
	
	if camera and camera.has_method("apply_shake"):
		await camera.apply_shake(5.0, 2.0)
		await camera.apply_shake(10.0, 2.0)
		player.go_to_locked_state("off")
		await camera.apply_shake(15.0, 2.0)
	
	black_screen.visible = true
	var tween = create_tween()
	tween.tween_interval(0.5)
	tween.tween_property(black_screen, "modulate:a", 1, 3)
	await tween.finished
	
	get_tree().change_scene_to_file("res://scenes/after_tutorial_intro.tscn")
	
