extends Area2D

@export var central_level = ""
@export var tp_ativo: bool = false
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var can_interact = false
var player_ref = null
var total_items: int = 0
var items_collected: int = 0

func _ready():
	var items = get_tree().get_nodes_in_group("RequiredItems")
	total_items = items.size()
	if total_items == 0:
		activate_teleport()
	else:
		for item in items:
			item.collected.connect(_on_item_collected)
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") && can_interact == true:
		player_ref.pode_mover = false
		anim.play("on")

func _on_item_collected():
	items_collected += 1
	print("Coletou 1 item")
	
	if items_collected >= total_items:
		activate_teleport()

func activate_teleport():
	tp_ativo = true

func load_next_scene():
	get_tree().change_scene_to_file("res://scenes/" + central_level + ".tscn")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"): 
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
