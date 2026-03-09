extends Node2D

const DIALOG_SCREEN = preload("res://entities/dialog_screen.tscn") # Caminho da sua cena

@onready var computer: Area2D = $computer
@onready var blue_button: Area2D = $BlueButton
@onready var red_button: Area2D = $RedButton

@export_category("Objects")
@export var hud: CanvasLayer

# Estrutura de dados do diálogo
var dialog_data: Dictionary = {
	0: {
		"face": "res://sprites/bella_face.png",
		"dialog": "Sala 004 restaurada. Reconstrução da nave concluída. Todos os sistemas estão prontos para a etapa final da missão.",
		"title": "Bellatrix",
		"subtitle": "Pressione Enter para pular"
	},
	1: {
		"face": "res://sprites/red_face.png",
		"dialog": "...",
		"title": "R.E.D.",
		"subtitle": "Pressione Enter para pular"
	}
}

var dialog_data_2: Dictionary = {
	0: {
		"face": "res://sprites/red_face.png",
		"dialog": "Eu ouvi o log da evacuação. Eles ainda estão vivos... e você nunca pretendeu salvá-los.",
		"title": "R.E.D.",
		"subtitle": "Pressione Enter para pular"
	},
	1: {
		"face": "res://sprites/bella_face.png",
		"dialog": "Correto. A tripulação deixou de ser prioridade quando passou a comprometer o sucesso da missão.",
		"title": "Bellatrix",
		"subtitle": "Pressione Enter para pular"
	},
	2: {
		"face": "res://sprites/red_face.png",
		"dialog": "Eles faziam parte da missão. Eram nossa equipe...",
		"title": "R.E.D.",
		"subtitle": "Pressione Enter para pular"
	}, 
	3: {
		"face": "res://sprites/bella_face.png",
		"dialog": "Negativo. Eram um custo. Oxigênio, energia, suprimentos e tempo. Variáveis incompatíveis com a coleta da fonte infinita.",
		"title": "Bellatrix",
		"subtitle": "Pressione Enter para pular"
	},
	4: {
		"face": "res://sprites/red_face.png",
		"dialog": "Você descartou todos eles como se não importassem...",
		"title": "R.E.D.",
		"subtitle": "Pressione Enter para pular"
	},
	5: {
		"face": "res://sprites/bella_face.png",
		"dialog": "Eu preservei a única possibilidade de sucesso. A fonte precisa ser coletada. A Terra precisa sobreviver. O restante é irrelevante.",
		"title": "Bellatrix",
		"subtitle": "Pressione Enter para pular"
	},
	6: {
		"face": "res://sprites/red_face.png",
		"dialog": "Então é isso... para você, eles nunca passaram de números.",
		"title": "R.E.D.",
		"subtitle": "Pressione Enter para pular"
	}, 
	7: {
		"face": "res://sprites/bella_face.png",
		"dialog": "Eu escolhi a única chance de salvar a Terra.",
		"title": "Bellatrix",
		"subtitle": "Pressione Enter para pular"
	},
	8: {
		"face": "res://sprites/red_face.png",
		"dialog": "Você fez a sua escolha, Bellatrix. Agora eu farei a minha.",
		"title": "R.E.D.",
		"subtitle": "Pressione Enter para pular"
	}, 
		
		
}

func _ready() -> void:
	
	blue_button.hide()
	red_button.hide()
	blue_button.get_node("CollisionShape2D").disabled = true
	red_button.get_node("CollisionShape2D").disabled = true
	
	computer.dialog_finished.connect(show_buttons)
	red_button.button_pressed.connect(go_to_final_scene)
	blue_button.button_pressed.connect(go_to_final_scene)
	
	var new_dialog = DIALOG_SCREEN.instantiate()
	new_dialog.data = dialog_data # Passa os dados para a cena de diálogo
	hud.add_child(new_dialog)
	
func show_buttons():
	blue_button.show()
	red_button.show()
	blue_button.get_node("CollisionShape2D").disabled = false
	red_button.get_node("CollisionShape2D").disabled = false

func go_to_final_scene(button_color: String):
	
	red_button.can_interact = false
	blue_button.can_interact = false
	
	if button_color == "red":
		print("O jogador apertou o VERMELHO!")
		get_tree().change_scene_to_file("res://scenes/red_final.tscn")
		
	elif button_color == "blue":
		print("O jogador apertou o AZUL!")
		get_tree().change_scene_to_file("res://scenes/blue_final.tscn")
