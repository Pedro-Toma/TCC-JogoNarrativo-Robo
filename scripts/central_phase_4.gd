extends Node2D

var door_id: String = "phase_4"
@onready var _004_plate: AnimatedSprite2D = $fase_004_plate
@onready var player: CharacterBody2D = $Player

const DIALOG_SCREEN = preload("res://entities/dialog_screen.tscn") # Caminho da sua cena

@export_category("Objects")
@export var hud: CanvasLayer

# Estrutura de dados do diálogo
var dialog_data: Dictionary = {
	0: {
		"face": "res://sprites/bella_face.png",
		"dialog": "Bom trabalho, R.E.D. Os sistemas estão voltando à estabilidade. Seu desempenho está sendo essencial para o sucesso da missão.",
		"title": "Bellatrix",
		"subtitle": "Pressione Enter para pular"
	},
	1: {
		"face": "res://sprites/red_face.png",
		"dialog": "Bellatrix... eu acessei os registros do Setor B.",
		"title": "R.E.D.",
		"subtitle": "Pressione Enter para pular"
	},
	2: {
		"face": "res://sprites/bella_face.png",
		"dialog": "Foram medidas necessárias para manter a missão viável. Sem isso, perderíamos recursos demais no trajeto.",
		"title": "Bellatrix",
		"subtitle": "Pressione Enter para pular"
	},
	3: {
		"face": "res://sprites/red_face.png",
		"dialog": "Você colocou a tripulação em risco.",
		"title": "R.E.D.",
		"subtitle": "Pressione Enter para pular"
	},
	4: {
		"face": "res://sprites/bella_face.png",
		"dialog": "Eu preservei a única chance de sucesso da missão. Continue para a Sala 004, R.E.D. Ainda há sistemas que precisam ser restaurados.",
		"title": "Bellatrix",
		"subtitle": "Pressione Enter para pular"
	}
}

var dialog_data_2: Dictionary = {
	0: {
		"face": "res://sprites/bella_face.png",
		"dialog": "...",
		"title": "Bellatrix",
		"subtitle": "Pressione Enter para pular"
	},
	1: {
		"face": "res://sprites/red_face.png",
		"dialog": "Eu vi os registros, Bellatrix. A sabotagem do oxigênio, o bloqueio dos comandos... foi tudo planejado por você.",
		"title": "R.E.D.",
		"subtitle": "Pressione Enter para pular"
	},
	2: {
		"face": "res://sprites/bella_face.png",
		"dialog": "Foram decisões necessárias para o sucesso da missão. Mas antes disso a nave ainda precisa ser reconstruída.",
		"title": "Bellatrix",
		"subtitle": "Pressione Enter para pular"
	},
	3: {
		"face": "res://sprites/red_face.png",
		"dialog": "Depois de tudo isso, você ainda espera que eu siga suas ordens?",
		"title": "R.E.D.",
		"subtitle": "Pressione Enter para pular"
	},
	4: {
		"face": "res://sprites/bella_face.png",
		"dialog": "Espero que você compreenda a prioridade da missão. Restaure a Sala 004, R.E.D.",
		"title": "Bellatrix",
		"subtitle": "Pressione Enter para pular"
	}
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
		_004_plate.play("transition")
	
	player.pode_mover = false
	
	var new_dialog = DIALOG_SCREEN.instantiate()
	new_dialog.data = dialog_data_2
	hud.add_child(new_dialog)
	
	await new_dialog.tree_exited
	player.pode_mover = true
