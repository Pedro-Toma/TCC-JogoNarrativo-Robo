extends AudioStreamPlayer


func _ready() -> void:
	play_music("main")

var playlists = {
	"main": preload("res://sounds/game_music.mp3"),
	"final": preload("res://sounds/final_music.mp3")
}

func play_music(music_name: String):
	if stream == playlists[music_name] and playing:
		return
	if music_name == "main":
		volume_db = -15.0
	else:
		volume_db = -30.0
	stream = playlists[music_name]
	play()

func stop_music():
	stop()

func stop_music_fade_out(duration: float = 2.0):
	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self, "volume_db", -80.0, duration)
	await tween.finished
	stop()
	
func switch_music(music_name: String, duration: float = 1.5):
	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self, "volume_db", -80.0, duration)	
	await tween.finished
	stop()
	if music_name == "main":
		volume_db = -15.0
	else:
		volume_db = -20.0
	stream = playlists[music_name]
	play()
