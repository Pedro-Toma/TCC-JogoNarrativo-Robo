extends Area2D

# máquina de estados das portas
enum DoorState {
	closed,
	opened,
	opening,
	closing,
	locked,
	finished
}

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D


@export var door_id: String = ""
@export var next_level = ""

var status: DoorState
var can_interact = false

func _ready():
	# se por foi aberta na outra cena, aplica animação de fechar e fechada
	# muda o estado da porta
	if GameState.is_door_open(door_id):
		GameState.close_door(door_id)
		status = DoorState.closing
		anim.play("closing")
		await anim.animation_finished
		if anim.animation == "closing":
			anim.play("locked")
			status = DoorState.locked
			if GameState.has_method("lock_door"):
				GameState.lock_door(door_id)
	# verificar se porta está trancada no gerenciador de estados do jogo
	elif GameState.is_door_locked(door_id):
		status = DoorState.locked
		anim.play("locked")
	# verificar se porta está concluída no gerenciador de estados do jogo
	elif GameState.is_door_finished(door_id):
		status = DoorState.finished
		anim.play("finished")
	# caso (default) porta fechada
	else:
		status = DoorState.closed
		anim.play("closed")
	if GameState.has_signal("door_unlocked"):
		GameState.door_unlocked.connect(_on_door_unlocked)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") && can_interact == true:
		# se jogador interagir com a porta e ela está fechando ou trancada (ignora)
		if status == DoorState.closing or status == DoorState.locked:
			return
		# verifica estado da porta
		match status:
			# abre a porta
			DoorState.closed:
				status = DoorState.opening
				anim.play("opening")
				await anim.animation_finished
				if anim.animation == "opening":
					status = DoorState.opened
			# entra na porta e carrega a próxima cena
			DoorState.opened:
				GameState.open_door(door_id)
				call_deferred("load_next_scene")
			# qualquer outro estado (ignora)
			_:
				pass

func load_next_scene():
	get_tree().change_scene_to_file("res://scenes/" + next_level + ".tscn")

func _on_body_entered(_body: Node2D) -> void:
	# se player entrou na área e a porta está fechada ou aberta ou abrindo (pode interagir)
	if status == DoorState.closed or status == DoorState.opened or status == DoorState.opening:
		can_interact = true

func _on_body_exited(_body: Node2D) -> void:
	# saiu da área, não pode interagir
	can_interact = false

func _on_door_unlocked(unlocked_id: String) -> void:
	if unlocked_id == door_id:
		if status == DoorState.locked:
			status = DoorState.closed
			anim.play("closed")
