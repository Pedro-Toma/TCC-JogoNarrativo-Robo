extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("ENTROU")
		if body.has_method("enable_wall_jump"):
			body.enable_wall_jump()
			GameState.has_wall_jump = true
			queue_free()
