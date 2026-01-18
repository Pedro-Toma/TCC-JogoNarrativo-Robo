extends Area2D

enum LeverState {
	active,
	inactive,
	activation
}

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

@export var lever_id: String = ""

var status: LeverState
var can_interact = true

func _ready():
	status = LeverState.inactive

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") && can_interact == true:
		match status:
			LeverState.inactive:
				status = LeverState.activation
				anim.play("activation")
				anim.connect("animation_finished", Callable(self, "on_lever_activation_finished"), CONNECT_ONE_SHOT)
			_:
				pass

func on_lever_activation_finished():
	if anim.animation == "activation":
		status = LeverState.active

func _on_body_entered(_body: Node2D) -> void:
	if LeverState.inactive:
		can_interact = true

func _on_body_exited(_body: Node2D) -> void:
	can_interact = false


func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "activation":
		status = LeverState.active
		anim.disconnect("animation_finished", _on_animated_sprite_2d_animation_finished)
