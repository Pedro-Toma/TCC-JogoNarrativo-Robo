extends Camera2D

var target: Node2D
var shake_strength: float = 0.0
@onready var shake_sound: AudioStreamPlayer = $ShakeSound

func _ready() -> void:
	shake_sound.volume_db = -2.0
	get_target() # procura o player

func _process(delta: float) -> void:
	position = target.position # ajusta a câmera baseando no player
	if shake_strength > 0:
		offset = Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))
		shake_strength = lerp(shake_strength, 0.0, delta * 5.0)
	else:
		offset = Vector2.ZERO

func apply_shake(strength: float, duration: float):
	shake_sound.play()
	shake_sound.volume_db += 2.0
	shake_strength = strength
	await get_tree().create_timer(duration).timeout

func get_target():
	# procura nõs do grupo "Player"
	var nodes = get_tree().get_nodes_in_group("Player")
	if nodes.size() == 0:
		push_error("Player not found")
		return
		
	target = nodes[0] # transforma o player no target da câmera

# aplicar zoom após a introdução da história
func intro_zoom(initial_zoom: Vector2 = Vector2(8.0, 8.0), duration: float = 2.0):
	
	zoom = initial_zoom # zoom 8x inicial
	var tween = create_tween()
	tween.tween_interval(1.5) # espera 1 segundo
	
	# aplica o zoom out 
	tween.tween_property(self, "zoom", Vector2(1.0, 1.0), duration)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN)
	
	tween.tween_interval(1)
	await tween.finished

func zoom_in(duration: float = 3.0):
	
	var tween = create_tween()
	tween.tween_interval(1) # espera 1 segundo
	
	# aplica o zoom out 
	tween.tween_property(self, "zoom", Vector2(6.0, 6.0), duration)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.set_ease(Tween.EASE_IN)
	
	tween.tween_interval(1)
	await tween.finished
