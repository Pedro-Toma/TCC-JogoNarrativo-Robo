extends Area2D

func _on_body_entered(body: Node2D) -> void:

	if body.is_in_group("Player"):
		if body.has_method("enable_double_jump"):
			body.enable_double_jump()
			GameState.has_double_jump = true
			queue_free()
