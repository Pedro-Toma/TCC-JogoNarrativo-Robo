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
		
		var hud_layer = get_tree().current_scene.find_child("Transition_Layer", true, false)
		if hud_layer:
			var color_rect = hud_layer.get_node("blackScreen")
			if color_rect:
				var tween = get_tree().create_tween()
				tween.tween_property(color_rect, "modulate:a", 0.0, 1.5)\
					.set_trans(Tween.TRANS_SINE)\
					.set_ease(Tween.EASE_IN_OUT)
		
		await audio.finished
		collected.emit()
		queue_free() # libera item do jogo
