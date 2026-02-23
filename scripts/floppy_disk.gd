extends Area2D

signal collected

func _on_body_entered(_body: Node2D) -> void:
	# se jogador entrou na zona do item
	print("Coletou 1 disquete")
	collected.emit()
	queue_free()
