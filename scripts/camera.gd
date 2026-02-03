extends Camera2D

var target: Node2D

func _ready() -> void:
	get_target() # procura o player

func _process(_delta: float) -> void:
	position = target.position # ajusta a câmera baseando no player

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
