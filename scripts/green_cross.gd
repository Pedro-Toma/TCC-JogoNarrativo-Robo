extends Area2D


signal collected
var is_collected = false
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer


func _on_body_entered(body: Node2D) -> void:
	if is_collected:
		return
	if body.is_in_group("Player"):
		is_collected = true
		audio.play() # da play no audio de coleta
		hide() # esconde item da interface
		set_deferred("monitoring", false) # não monitora área para evitar bugs
		await audio.finished
		collected.emit()
		queue_free() # libera item do jogo
