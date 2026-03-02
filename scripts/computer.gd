extends Area2D

var player_in_area = false
var lines: Array[String]
var is_dialog_active = false
var already_interacted = false

@onready var interact_prompt: Sprite2D = $InteractPrompt
@onready var block_message: Sprite2D = $BlockMessage
@export var unlock_door: String = ""

const central_0: Array[String] = [
	"ATENÇÃO: Detectamos uma anomalia crítica nos estabilizadores de gravidade do setor 7.",
	"Quer algumas dicas"
]
const central_1: Array[String] = [
	"OI"
]

func _ready() -> void:
	interact_prompt.hide()
	block_message.show()
	DialogManager.dialog_finished.connect(_on_dialog_finished)

func _unhandled_input(event: InputEvent) -> void:

	if player_in_area and event.is_action_pressed("interact"):
		
		match GameState.fase_central_atual:
			1: 
				lines = central_0
			2:
				lines = central_1
		
		is_dialog_active = true 
		
		interact_prompt.hide()
		
		DialogManager.start_dialog(global_position, lines)

func _on_dialog_finished() -> void:
	is_dialog_active = false
	if not already_interacted:
		GameState.unlock_door(unlock_door)
		already_interacted = true
	
	if player_in_area:
		block_message.hide()
		interact_prompt.show()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"): 
		player_in_area = true
		
		if not is_dialog_active:
			block_message.hide()
			interact_prompt.show()
	
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_area = false
		interact_prompt.hide()
		
		if not is_dialog_active && not already_interacted:
			block_message.show()
