extends StaticBody2D

# variáveis da cena
@onready var area_2d: Area2D = $Area2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var broken_timer: Timer = $BrokenTimer
@onready var destroyed_timer: Timer = $DestroyedTimer
@onready var reset_timer: Timer = $ResetTimer

var start_position: Vector2 # armazena posição original
var is_broken = false

func _ready() -> void:
	start_position = global_position

func _process(_delta: float) -> void:
	if is_broken:
		return
	# se não estiver quebrado, identificar corpos em cima do bloco
	var bodies = area_2d.get_overlapping_bodies()
	for body in bodies:
		if body is CharacterBody2D and body.is_in_group("Player"):
		# se for o player e ele estiver "no chão" apoiado no bloco
			if body.is_on_floor():
				# aplica animação de quebrado
				is_broken = true
				anim.play("broken")
				broken_timer.start()
		
func _on_broken_timer_timeout() -> void:

	# aplica animação de destruído na sequência
	anim.play("destroyed")
	destroyed_timer.start()

func _on_destroyed_timer_timeout() -> void:

	# aplica animação de caindo na sequência
	anim.play("falling")
	collision_layer = 0 # desativa colisão do bloco
	# calcula posição final, após a destruição
	var final_position = global_position + Vector2.DOWN * 100
	var fall_tween = create_tween()
	# faz o bloco destruído cair
	fall_tween.set_trans(Tween.TRANS_QUAD)
	fall_tween.set_ease(Tween.EASE_IN)
	fall_tween.tween_property(self, "global_position", final_position, 0.5)
	
	var fade_out_tween = create_tween()
	# deixa o resto do bloco invisível
	fade_out_tween.tween_property(anim, "modulate:a", 0, 0.5)
	reset_timer.start() # começa timer para volta do bloco na cena
	
func _on_reset_timer_timeout() -> void:
	
	# reseta as característica do bloco
	is_broken = false
	anim.play("default")
	collision_layer = 1 # reativa a colisão
	global_position = start_position

	# aplica fade in para aparição do bloco
	var fade_in_tween = create_tween()
	fade_in_tween.tween_property(anim, "modulate:a", 1, 0.5)
