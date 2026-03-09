extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var transition_layer: CanvasLayer = $"Transition Layer"
@onready var black_screen: ColorRect = $"Transition Layer/blackScreen"
@onready var _001_plate: AnimatedSprite2D = $fase_001_plate
var door_id: String = "phase_1"


const DIALOG_SCREEN = preload("res://entities/dialog_screen.tscn") # Caminho da sua cena

@export_category("Objects")
@export var hud: CanvasLayer

# Estrutura de dados do diálogo
var dialog_data: Dictionary = {
	0: {
		"face": "res://sprites/bella_face.png",
		"dialog": "Olá, RED. É um alívio ver que seu núcleo de processamento ainda está intacto. Eu sou Bellatrix. Você sofreu um trauma severo durante a colisão. Não tente forçar a memória agora; apenas siga minhas orientações.",
		"title": "Bellatrix",
		"subtitle": "Pressione Enter para pular"
	},
	1: {
		"face": "res://sprites/red_face.png",
		"dialog": "Bellatrix? O que aconteceu? Onde está o resto da tripulação? A missão fracassou?",
		"title": "R.E.D.",
		"subtitle": "Pressione Enter para pular"
	},
	2: {
		"face": "res://sprites/bella_face.png",
		"dialog": "Diversas partes da nave foram danificadas devido a uma chuva de meteoritos que passou invisível pelos radares, comprometendo nossas estruturas externas e internas.",
		"title": "Bellatrix",
		"subtitle": "Pressione Enter para pular"
	},
	3: {
		"face": "res://sprites/bella_face.png",
		"dialog": "Já a tripulação teve de evacuar, por conta dos níveis de oxigênio terem chegado a um estado crítico.",
		"title": "Bellatrix",
		"subtitle": "Pressione Enter para pular"
	},
	4: {
		"face": "res://sprites/bella_face.png",
		"dialog": "Quanto à missão, ainda temos esperança e grandes chances de sucesso, mas não muito tempo... Precisamos das suas habilidades para reconstruirmos a nave. Vá até a sala 001 para religar completamente o sistema de energização.",
		"title": "Bellatrix",
		"subtitle": "Pressione Enter para pular"
	},
	5: {
		"face": "res://sprites/red_face.png",
		"dialog": "OK! Vamos nessa!",
		"title": "R.E.D.",
		"subtitle": "Pressione Enter para pular"
	}
}
func _ready() -> void:
	player.pode_mover = false
	GameState.has_double_jump = false
	GameState.has_wall_jump = false
	player.has_wall_jump = false
	player.max_jump_count = 1
	
	black_screen.modulate.a = 1.0
	black_screen.visible = true
	
	var tween = create_tween()
	tween.tween_interval(0.5)
	tween.tween_property(black_screen, "modulate:a", 0.5, 5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	var camera = get_viewport().get_camera_2d()
	
	# aplica o zoom na câmera
	if camera and camera.has_method("intro_zoom"):
		await camera.intro_zoom()
		
	if GameState.has_signal("door_unlocked"):
		GameState.door_unlocked.connect(_on_door_unlocked)
	
	var new_dialog = DIALOG_SCREEN.instantiate()
	new_dialog.data = dialog_data # Passa os dados para a cena de diálogo
	hud.add_child(new_dialog)
	
	await new_dialog.tree_exited
	player.pode_mover = true

func _on_door_unlocked(unlocked_id: String) -> void:
	if unlocked_id == door_id:
		_001_plate.play("transition")
