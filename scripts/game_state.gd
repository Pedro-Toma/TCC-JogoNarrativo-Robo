extends Node

# Dicionário para armazenar o estado das portas.
# Chave: ID Único da porta (String, ex: "level1_door_a")
# Valor: Estado da porta (bool, true para aberta)
var door_states = {}
var door_locked = ["fase_central_1_bloqueada_1","fase_central_1_bloqueada_2","fase_central_1_bloqueada_3",
				   "fase_central_2_bloqueada_1","fase_central_2_bloqueada_2"
				  ]
var door_finished = ["fase_central_2_finished_1"]
var has_double_jump = false
var has_wall_jump = false
# Função para registrar que uma porta foi aberta
func open_door(door_id: String):
	door_states[door_id] = true

func close_door(door_id: String):
	door_states[door_id] = false

# Função para verificar se uma porta deve estar aberta
func is_door_open(door_id: String) -> bool:
	# Retorna true se a chave existir E o valor for true. Senão, retorna false (o padrão).
	return door_states.get(door_id, false)
	
func is_door_locked(door_id: String) -> bool:
	if door_id in door_locked:
		return true
	return false
	
func is_door_finished(door_id: String) -> bool:
	if door_id in door_finished:
		return true
	return false
