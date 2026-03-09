extends Control
class_name DialogScreen

var step: float = 0.03 # Velocidade padrão do texto
var id: int = 0 # Índice da mensagem atual
var data: Dictionary = {} # Dicionário que receberá os dados do diálogo

@export_category("Objects")
@export var name_label: Label
@export var dialog_label: RichTextLabel
@export var face_rect: TextureRect
@export var subtitle_label: Label

func _ready():
	initialize_dialog()

func initialize_dialog():
	# Atualiza nome, texto e imagem baseados no ID atual
	name_label.text = data[id]["title"]
	dialog_label.text = data[id]["dialog"]
	face_rect.texture = load(data[id]["face"])
	subtitle_label.text = data[id]["subtitle"]
	
	# Reinicia a animação de texto
	dialog_label.visible_ratio = 0
	
	# Loop para exibir as letras gradualmente
	while dialog_label.visible_ratio < 1:
		await get_tree().create_timer(step).timeout
		dialog_label.visible_characters += 1

func _process(_delta):
	# Atalho para acelerar o texto segurando "Enter" (ui_accept)
	if Input.is_action_pressed("skip"):
		if dialog_label.visible_ratio < 1 && dialog_label.visible_ratio > 0.05:
			step = 0.01 # Acelera
		else:
			step = 0.03 # Volta ao normal
			
	# Passar para a próxima mensagem ao pressionar "Enter"
	if Input.is_action_just_pressed("skip"):
		if dialog_label.visible_ratio == 1:
			id += 1
			if id == data.size():
				queue_free() # Fecha o diálogo ao fim das mensagens
			else:
				initialize_dialog()
