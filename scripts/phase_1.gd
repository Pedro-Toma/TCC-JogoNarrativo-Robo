extends Node2D

var door_id: String = "phase_2"
@onready var player: CharacterBody2D = $Player

const DIALOG_SCREEN = preload("res://entities/dialog_screen.tscn")

@export_category("Objects")
@export var hud: CanvasLayer

# Estrutura de dados do diálogo
var dialog_data: Dictionary = {
	0: {
		"face": "res://sprites/bella_face.png",
		"dialog": "R.E.D, você precisa coletar todos os itens espalhados nessa sala. Só assim será possível reconstruir a nave e o teleporte para levar você de volta à Central.",
		"title": "Bellatrix",
		"subtitle": "Pressione E para pular"
	},
}

func _ready() -> void:
	
	player.pode_mover = false
	
	var new_dialog = DIALOG_SCREEN.instantiate()
	new_dialog.data = dialog_data
	hud.add_child(new_dialog)
	
	await new_dialog.tree_exited
	player.pode_mover = true
