extends Node2D

const DIALOG_SCREEN = preload("res://entities/dialog_screen.tscn") # Caminho da sua cena

@export_category("Objects")
@export var hud: CanvasLayer

# Estrutura de dados do diálogo
var dialog_data: Dictionary = {
	0: {
		"face": "res://sprites/bella_face.png",
		"dialog": "Olá! Sejam todos bem-vindos ao canal.",
		"title": "Bella",
		"subtitle": "Pressione Enter para pular"
	},
	1: {
		"face": "res://sprites/bella_face.png",
		"dialog": "Neste canal vocês encontrarão diversos tutoriais",
		"title": "Bella",
		"subtitle": "Pressione Enter para pular"
	},
	2: {
		"face": "res://sprites/red_face.png",
		"dialog": "Você esqueceu de falar dos cursos!",
		"title": "Red",
		"subtitle": "Pressione Enter para pular"
	},
	3: {
		"face": "res://sprites/bella_face.png",
		"dialog": "Bem lembrado! Link na descrição.",
		"title": "Bella",
		"subtitle": "Pressione Enter para pular"
	}
}

func _ready() -> void:

	var new_dialog = DIALOG_SCREEN.instantiate()
	new_dialog.data = dialog_data # Passa os dados para a cena de diálogo
	hud.add_child(new_dialog)
