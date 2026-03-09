extends Area2D

signal button_pressed(button_color)

@export_enum("red", "blue") var button_color: String = "red"
@export var message: String = ""

@onready var label: Label = $MarginContainer/MarginContainer/Label
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var can_interact: bool = false
var already_pressed: bool = false

func _ready() -> void:
	anim.play("idle_" + button_color)
	label.text = message

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and can_interact and not already_pressed:
		already_pressed = true 
		
		anim.play("pressed_" + button_color) 
		
		button_pressed.emit(button_color)
		
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not already_pressed:
		can_interact = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		can_interact = false
