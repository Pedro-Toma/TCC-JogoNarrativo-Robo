extends Area2D

@export var central_level = ""
@export var tp_ativo: bool = false
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var can_interact = false
var player_ref = null

func _ready():
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") && can_interact == true:
		player_ref.pode_mover = false
		anim.play("on")

func load_next_scene():
	get_tree().change_scene_to_file("res://scenes/" + central_level + ".tscn")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player": 
		player_ref = body
		if tp_ativo:
			can_interact = true

func _on_body_exited(_body: Node2D) -> void:
	can_interact = false

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "on":
		player_ref.pode_mover = true
		GameState.fase_central_atual += 1
		load_next_scene()
