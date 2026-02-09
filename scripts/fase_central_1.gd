extends Node2D

@onready var player: CharacterBody2D = $Player

func _ready() -> void:
	GameState.has_double_jump = false
	GameState.has_wall_jump = false
	player.has_wall_jump = false
	player.max_jump_count = 1
