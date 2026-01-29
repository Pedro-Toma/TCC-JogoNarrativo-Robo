extends Node

# dicionário para armazenar o estado das portas
# chave: id da porta, valor: estado da porta (true = aberta)
# Valor: Estado da porta (bool, true para aberta)
var door_states = {}
# portas trancadas
var door_locked = ["fase_central_1_bloqueada_1","fase_central_1_bloqueada_2","fase_central_1_bloqueada_3",
				   "fase_central_2_bloqueada_1","fase_central_2_bloqueada_2"
				  ]
# portas concluídas (fases)
var door_finished = ["fase_central_2_finished_1"]
var has_double_jump = false
var has_wall_jump = false

# função para registrar que uma porta foi aberta
func open_door(door_id: String):
	door_states[door_id] = true

# função para fechar a porta
func close_door(door_id: String):
	door_states[door_id] = false

# função para verificar se porta deve estar aberta
func is_door_open(door_id: String) -> bool:
	# retorna true se a chave existir e o valor for true. Senão, retorna false.
	return door_states.get(door_id, false)

# função para verificar se porta está trancada
func is_door_locked(door_id: String) -> bool:
	if door_id in door_locked:
		return true
	return false

# função para verificar se porta está concluída
func is_door_finished(door_id: String) -> bool:
	if door_id in door_finished:
		return true
	return false
