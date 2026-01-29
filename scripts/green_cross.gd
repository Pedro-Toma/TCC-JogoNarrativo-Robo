extends Area2D


func _on_body_entered(_body: Node2D) -> void:
	# se jogador entrou na zona do item
	print("Coletou 1 cruz")
	queue_free()
