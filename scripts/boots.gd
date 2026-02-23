extends Area2D

signal collected

func _on_body_entered(body: Node2D) -> void:
	# se jogador entrou na zona do item e tem o método
	# jogador recebe o power-up de double jump
	if body.is_in_group("Player"):
		if body.has_method("enable_double_jump"):
			body.enable_double_jump()
			GameState.has_double_jump = true
			collected.emit()
			queue_free()
