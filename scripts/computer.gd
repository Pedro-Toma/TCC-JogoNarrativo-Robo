extends Area2D

var player_in_area = false

const lines: Array[String] = [
	"ATENÇÃO: Detectamos uma anomalia crítica nos estabilizadores de gravidade do setor 7. Recomenda-se a evacuação imediata de todo o pessoal não essencial. O bloqueio de segurança foi ativado automaticamente para conter a despressurização. Por favor, dirija-se à cápsula de fuga mais próxima e aguarde instruções do capitão.",
	"Quer algumas dicas"
]

func _unhandled_input(event: InputEvent) -> void:


	if player_in_area and event.is_action_pressed("interact"):
		# envia posição do pc e texto para o dialog manager
		DialogManager.start_dialog(global_position, lines)

func _on_body_entered(_body: Node2D) -> void:
	player_in_area = true
	
func _on_body_exited(_body: Node2D) -> void:
	player_in_area = false
