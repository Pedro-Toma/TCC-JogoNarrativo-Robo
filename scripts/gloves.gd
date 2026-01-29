extends Area2D

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer


var is_collected = false

func _on_body_entered(body: Node2D) -> void:
	if is_collected:
		return
	
	# se jogador entrou na zona do item e tem o método
	# jogador recebe o power-up de wall jump
	if body.is_in_group("Player"):
		is_collected = true
		if body.has_method("enable_wall_jump"):
			body.enable_wall_jump()
			GameState.has_wall_jump = true
			audio.play() # da play no audio de coleta
			hide() # esconde item da interface
			set_deferred("monitoring", false) # não monitora área para evitar bugs
			await audio.finished
			queue_free() # libera item do jogo
