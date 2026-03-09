extends Node2D

var door_id: String = "phase_2"
@onready var _002_plate: AnimatedSprite2D = $fase_002_plate
@onready var player: CharacterBody2D = $Player

const DIALOG_SCREEN = preload("res://entities/dialog_screen.tscn") # Caminho da sua cena

@export_category("Objects")
@export var hud: CanvasLayer

# Estrutura de dados do diálogo
var dialog_data: Dictionary = {
	0: {
		"face": "res://sprites/bella_face.png",
		"dialog": "Muito bem, R.E.D. O sistema de energia foi restaurado, mas ainda temos muito trabalho pela frente.",
		"title": "Bellatrix",
		"subtitle": "Pressione Enter para pular"
	},
	1: {
		"face": "res://sprites/bella_face.png",
		"dialog": "Vá até o computador, abra a comporta da Sala 002 e analise tudo o que encontrou até agora.",
		"title": "Bellatrix",
		"subtitle": "Pressione Enter para pular"
	},
}

func _ready() -> void:
	
	player.pode_mover = false
	if GameState.has_signal("door_unlocked"):
		GameState.door_unlocked.connect(_on_door_unlocked)
	
	var new_dialog = DIALOG_SCREEN.instantiate()
	new_dialog.data = dialog_data # Passa os dados para a cena de diálogo
	hud.add_child(new_dialog)
	
	await new_dialog.tree_exited
	player.pode_mover = true

func _on_door_unlocked(unlocked_id: String) -> void:
	if unlocked_id == door_id:
		_002_plate.play("transition")
