extends CharacterBody2D

enum PlayerState {
	idle,
	walk,
	jump,
	fall,
	wall,
	dead
}

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var reload_timer: Timer = $ReloadTimer
@onready var right_wall_detector: RayCast2D = $RightWallDetector
@onready var left_wall_detector: RayCast2D = $LeftWallDetector

const JUMP_VELOCITY = -300.0

var has_wall_jump = false
var jump_count = 0
@export var max_jump_count = 1
@export var max_speed = 120.0
@export var acceleration = 800
@export var air_acceleration = 200
@export var deceleration = 800
@export var air_deceleration = 100
@export var wall_acceleration = 200
@export var wall_jump_velocity = 100
var direction = 0
var status: PlayerState

func _ready() -> void:
	go_to_idle_state()
	if GameState.has_double_jump:
		max_jump_count = 2
	if GameState.has_wall_jump:
		has_wall_jump = true

# verificar estado do player
func _physics_process(delta: float) -> void:
	
	match status:
		PlayerState.idle:
			idle_state(delta)
		PlayerState.walk:
			walk_state(delta)
		PlayerState.jump:
			jump_state(delta)
		PlayerState.fall:
			fall_state(delta)
		PlayerState.wall:
			wall_state(delta)
		PlayerState.dead:
			dead_state(delta)
	move_and_slide()
	
# transição de estados
func go_to_idle_state():
	status = PlayerState.idle
	anim.play("idle")

func go_to_walk_state():
	status = PlayerState.walk
	anim.play("walk")
	
func go_to_jump_state():
	status = PlayerState.jump
	anim.play("jump")
	velocity.y = JUMP_VELOCITY
	jump_count += 1

func go_to_fall_state():
	status = PlayerState.fall
	anim.play("fall")

func go_to_wall_state():
	status = PlayerState.wall
	anim.play("jump")
	velocity = Vector2.ZERO

func go_to_dead_state():
	status = PlayerState.dead
	anim.play("dead")
	velocity.y = 50
	velocity.x = 0
	reload_timer.start()
	
# estados do player
func idle_state(delta):
	apply_gravity(delta)
	move(delta)
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		return
		
	if velocity.x != 0:
		go_to_walk_state()
		return
		
func walk_state(delta):
	apply_gravity(delta)
	move(delta)
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		return
		
	if velocity.x == 0:
		go_to_idle_state()
		return
	
	if !is_on_floor():
		jump_count += 1
		go_to_fall_state()
		return
		
func jump_state(delta):
	apply_gravity(delta)
	move(delta)
	
	if Input.is_action_just_pressed("jump") && can_jump():
		go_to_jump_state()
		return
	
	if velocity.y > 0:
		go_to_fall_state()

func wall_state(delta):
	
	velocity.y += wall_acceleration * delta
	
	if left_wall_detector.is_colliding():
		anim.flip_h = true
		direction = 1
		if Input.is_action_just_pressed("right"):
			go_to_fall_state()
			return
	elif right_wall_detector.is_colliding():
		anim.flip_h = false
		direction = -1
		if Input.is_action_just_pressed("left"):
			go_to_fall_state()
			return
	else:
		go_to_fall_state()
		return
	
	if is_on_floor():
		go_to_idle_state()
		return
	
	if Input.is_action_just_pressed("jump"):
		velocity.x = wall_jump_velocity * direction
		go_to_jump_state()
		return
	
func fall_state(delta):
	apply_gravity(delta)
	move(delta)
	
	if Input.is_action_just_pressed("jump") && can_jump():
		go_to_jump_state()
		return
	
	if is_on_floor():
		jump_count = 0
		if velocity.x == 0:
			go_to_idle_state()
		else:
			go_to_walk_state()
		return
	
	if !GameState.has_wall_jump:
		return
		
	var is_pushing_away = false
	
	if right_wall_detector.is_colliding() and Input.is_action_pressed("left"):
		is_pushing_away = true
	
	if left_wall_detector.is_colliding() and Input.is_action_pressed("right"):
		is_pushing_away = true
		
	if not is_pushing_away:
		if (right_wall_detector.is_colliding() or left_wall_detector.is_colliding()) and is_on_wall():
			go_to_wall_state()
			return

func dead_state(delta):
	apply_gravity(delta)

func move(delta):
	
	var current_accel
	var current_decel
	
	if is_on_floor():
		current_accel = acceleration
		current_decel = deceleration
	else:
		current_accel = air_acceleration
		current_decel = air_deceleration
		
	update_direction()
	
	if direction:
		velocity.x = move_toward(velocity.x, direction * max_speed, current_accel * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, current_decel * delta)

func apply_gravity(delta):
	if not is_on_floor() && status != PlayerState.dead:
		velocity += get_gravity() * delta

func update_direction():
	direction = Input.get_axis("left", "right")
	if direction < 0:
		anim.flip_h = true
	elif direction > 0:
		anim.flip_h = false

func can_jump() -> bool:
	return jump_count < max_jump_count
	
func _on_hitbox_area_entered(area: Area2D) -> void:
	if status == PlayerState.dead:
		return
		
	if area.is_in_group("LethalArea"):
		hit_lethal_area()

func hit_lethal_area():
	go_to_dead_state()
	
func _on_reload_timer_timeout() -> void:
	get_tree().reload_current_scene()

func enable_double_jump():
	max_jump_count = 2

func enable_wall_jump():
	has_wall_jump = true
