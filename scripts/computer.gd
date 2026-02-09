extends Area2D

var player_in_area = false
var lines: Array[String]

const central_0: Array[String] = [
	"ATENÇÃO: Detectamos uma anomalia crítica nos estabilizadores de gravidade do setor 7.",
	"Quer algumas dicas"
]
const central_1: Array[String] = [
	"OI"
]

func _unhandled_input(event: InputEvent) -> void:

	if player_in_area and event.is_action_pressed("interact"):
		
		match GameState.fase_central_atual:
			1: 
				lines = central_0
			2:
				lines = central_1
		
		DialogManager.start_dialog(global_position, lines)

func _on_body_entered(_body: Node2D) -> void:
	player_in_area = true
	
func _on_body_exited(_body: Node2D) -> void:
	player_in_area = false
