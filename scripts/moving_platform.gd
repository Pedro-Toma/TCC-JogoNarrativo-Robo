extends AnimatableBody2D

@onready var target: Sprite2D = $Target

@export var time = 1 # tempo de movimento até o target

func _ready() -> void:
	
	target.visible = false # esconde o target da cena
	
	# cria variável para fazer a plataforma se mover até a posição correta
	# e coloca o movimento em loop
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position", target.global_position, time)
	tween.tween_property(self, "global_position", global_position, time)
	tween.set_loops()
	
