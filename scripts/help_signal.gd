extends Node2D

@onready var area: Area2D = $Area2D

func _ready() -> void:
	visible = false
	area.monitoring = false

func show_helper():
	visible = true
	area.monitoring = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		queue_free() 
