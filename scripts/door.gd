extends Area2D

enum DoorState {
	closed,
	opened,
	opening,
	closing,
	locked,
	finished
}

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

@export var door_id: String = ""
@export var next_level = ""

var status: DoorState
var can_interact = false

func _ready():
	if GameState.is_door_open(door_id):
		GameState.close_door(door_id)
		status = DoorState.closing
		anim.play("closing")
		await anim.animation_finished
		if anim.animation == "closing":
			anim.play("locked")
			status = DoorState.locked
	elif GameState.is_door_locked(door_id):
		status = DoorState.locked
		anim.play("locked")
	elif GameState.is_door_finished(door_id):
		status = DoorState.finished
		anim.play("finished")
	else:
		status = DoorState.closed
		anim.play("closed")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") && can_interact == true:
		if status == DoorState.closing or status == DoorState.locked:
			print("Clique ignorado: A porta está ocupada ou trancada.")
			return
		match status:
			DoorState.closed:
				status = DoorState.opening
				anim.play("opening")
				await anim.animation_finished
				if anim.animation == "opening":
					status = DoorState.opened
			DoorState.opened:
				GameState.open_door(door_id)
				call_deferred("load_next_scene")
			_:
				pass

func load_next_scene():
	get_tree().change_scene_to_file("res://scenes/" + next_level + ".tscn")


func _on_body_entered(_body: Node2D) -> void:
	if status == DoorState.closed or status == DoorState.opened or status == DoorState.opening:
		print("Pode interagir", door_id)
		can_interact = true

func _on_body_exited(_body: Node2D) -> void:
	can_interact = false
