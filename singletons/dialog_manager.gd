extends Node

signal dialog_finished
signal line_started_displaying
signal line_finished_displaying

@onready var text_box_scene = preload("res://entities/text_box_terminal.tscn")

var dialog_lines: Array[String] = []
var current_line_index = 0

var text_box
var text_box_position: Vector2

var is_dialog_active = false
var can_advance_line = false
var is_player_in_range = false

func start_dialog(position: Vector2, lines: Array[String]):
	
	# se hourve diálogo ativo, não começa outro
	if is_dialog_active:
		# se existir text_box, destrói ele
		if is_instance_valid(text_box):
			text_box.queue_free()
			
		# reseta variáveis
		is_dialog_active = false
		can_advance_line = false
		current_line_index = 0
		
	is_dialog_active = true
	is_player_in_range = true
	# recebe linha de texto e posição
	dialog_lines = lines
	text_box_position = position
	_show_text_box()

func _show_text_box():
	# cria objeto do tipo text_box e posiciona na cena
	text_box = text_box_scene.instantiate()
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	
	get_tree().current_scene.add_child(text_box)
	text_box.global_position = text_box_position
	
	can_advance_line = false
	text_box.display_text(dialog_lines[current_line_index])
	line_started_displaying.emit()
	
func _on_text_box_finished_displaying():
	# após mostrar todos os caracteres da linha, avança para a próxíma linha
	can_advance_line = true
	line_finished_displaying.emit()
	
func _unhandled_input(event):
	
	if(
		event.is_action_pressed("interact") &&
		is_dialog_active &&
		can_advance_line &&
		is_player_in_range
	):
		#bloqueia clique
		get_viewport().set_input_as_handled()
		
		text_box.queue_free()
		current_line_index += 1
		
		if current_line_index >= dialog_lines.size():
			is_dialog_active = false
			current_line_index = 0
			dialog_finished.emit()
			return
		
		_show_text_box()
