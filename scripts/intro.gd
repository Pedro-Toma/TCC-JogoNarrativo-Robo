extends Control

# variáveis para controlar o tempo de escrita dos caracteres
@export var letter_time = 0.08
@export var punctuation_time = 0.2
@export var space_time = 0.1
@export var between_sentences_time = 1.0
@export var next_scene: String
@onready var label = $Label

# texto a ser mostrado
@export_multiline var story: Array[String] = [
	"A energia da Terra está acabando.",
	"À beira da extinção, descobrimos na galáxia vizinha uma fonte de energia impossível:
energia infinita em forma de matéria.",
	"Tangível. Coletável. Estável.",
	"Você faz parte da última missão de coleta.",
	"Uma nave. Uma tripulação.",
	"A unidade R.E.D. e os robôs operados pela IA Bellatrix.",
	"Sem margem de erro.",
	"Sem segunda chance.",
	"Traga a substância… ou a Terra apaga de vez.",
]

# variáveis para controlar letra a ser escrita, tempo de intervalo
# e se jogador pulou a interação
var current_line_index = 0
var wait_tween: Tween
var skipped = false

# armazena as variáveis originais de tempo dos caracteres
var orig_letter_time = letter_time
var orig_punctuation_time = punctuation_time
var orig_space_time = space_time

func _ready():
	# ao carregar a cena, volta com os tempos originais
	# para mostrar cada caractere
	orig_letter_time = letter_time
	orig_punctuation_time = punctuation_time
	orig_space_time = space_time
	display_sentence()

func display_sentence():
	# se acabou a lista de frases, muda de cena
	if current_line_index >= story.size():
		go_to_game()
		return

	# prepara o texto
	skipped = false
	letter_time = orig_letter_time
	punctuation_time = orig_punctuation_time
	space_time = orig_space_time
	
	# pega a frase atual
	label.text = story[current_line_index]
	label.visible_ratio = 0.0 # começa invisível
	
	write_sentence()
	
func write_sentence():
	# verifica quantos caracteres tem na frase
	var total_characters = label.get_total_character_count()
	
	# loop de caracteres
	while label.visible_characters < total_characters:
		
		label.visible_characters += 1 # mostra o próximo caractere
		
		# identifica o caractere atual e calcula o tempo de escrita
		var current_character = label.text[label.visible_characters - 1]
		var current_time = letter_time
		match current_character:
			" ": current_time = space_time
			".","!","?": current_time = punctuation_time
		
		# cria tween para controlar tempo de escrita do caractere
		wait_tween = create_tween()
		wait_tween.tween_interval(current_time)
		await wait_tween.finished
	
	# se pulou interação tempo entre frases diminui
	if not skipped:
		await get_tree().create_timer(between_sentences_time).timeout
	else:
		await get_tree().create_timer(0.5).timeout
	next_sentence()

func next_sentence():
	current_line_index += 1
	display_sentence()

func go_to_game():
	get_tree().change_scene_to_file("res://scenes/" + next_scene + ".tscn")
	
# Opcional: Permitir pular com Espaço/Enter
func _input(event):
	if event.is_action_pressed("interact") and not skipped:
			skipped = true
			
			letter_time = 0.0
			punctuation_time = 0.0
			space_time = 0.0
			
			if wait_tween and wait_tween.is_valid():
				wait_tween.set_speed_scale(1000.0)
