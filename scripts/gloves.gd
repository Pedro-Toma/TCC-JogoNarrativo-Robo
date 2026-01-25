extends Area2D

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

var is_collected = false

func _on_body_entered(body: Node2D) -> void:
	if is_collected:
		return
		
	if body.is_in_group("Player"):
		is_collected = true
		if body.has_method("enable_wall_jump"):
			body.enable_wall_jump()
			GameState.has_wall_jump = true
			audio.play()
			hide()
			set_deferred("monitoring", false)
			await audio.finished 
			queue_free()
