extends Node2D

func _ready():
	# pega a câmera sem precisa do caminho
	var camera = get_viewport().get_camera_2d()
	
	# aplica o zoom na câmera
	if camera and camera.has_method("intro_zoom"):
		camera.intro_zoom()
