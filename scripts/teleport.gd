extends Area2D

@export var central_level = ""

var can_interact = false

func _ready():
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") && can_interact == true:
		load_next_scene()

func load_next_scene():
	get_tree().change_scene_to_file("res://scenes/" + central_level + ".tscn")

func _on_body_entered(_body: Node2D) -> void:
	can_interact = true

func _on_body_exited(_body: Node2D) -> void:
	can_interact = false
