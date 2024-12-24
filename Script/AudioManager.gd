extends Node

@onready var bg_music_player = AudioStreamPlayer.new()

func _ready() -> void:
	add_child(bg_music_player)
	bg_music_player.stream = preload("res://Sounds/Music/BGmusic.mp3")
	bg_music_player.autoplay = true
	bg_music_player.play()

# This function adjusts the volume in decibels
func set_volume(value: float) -> void:
	# Convert linear volume (0-100) to decibels
	bg_music_player.volume_db = linear_to_db(value / 100.0)
	print("Volume set to: ", value)

# Helper function to convert linear volume to decibels
func linear_to_db(value: float) -> float:
	if value > 0:
		return 20 * log(value) / log(10)
	else:
		return -80  # -80 dB is effectively silent

# Check if the current scene is the settings scene
func _process(_delta) -> void:
	var current_scene = get_tree().current_scene
	if current_scene:
		var scene_name = current_scene.name
		if scene_name == "res://Scene/settings.tscn":  # Replace with your settings scene name
			bg_music_player.stop()  # Stop music if in settings scene
		else:
			if not bg_music_player.playing:
				bg_music_player.play()  # Resume playing music if not in settings scene
