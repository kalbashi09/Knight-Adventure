extends Node

var bg_music_player = AudioStreamPlayer.new()
var bus_BGindex = AudioServer.get_bus_index("Music")
var bus_SFXindex = AudioServer.get_bus_index("SFX")

func _ready() -> void:
	add_child(bg_music_player)
	bg_music_player.stream = preload("res://Sounds/Music/BGmusic.mp3")
	bg_music_player.set_bus("Music")
	bg_music_player.play()

	# Load saved volume levels
	var config = ConfigFile.new()
	var error = config.load("user://settings.cfg")
	if error == OK:
		var music_volume = config.get_value("settings", "music_volume", 0.5)  # Default to 0.5
		var sfx_volume = config.get_value("settings", "sfx_volume", 0.5)      # Default to 1.0
		BG_value_changed(music_volume)
		SFX_value_changed(sfx_volume)
		print("Audio settings loaded successfully!")
	else:
		print("No audio settings found, using default values.")

func BG_value_changed(value: float) -> void:
	var music_db_volume = linear_to_db(value / 100)  # Value is already 0-1
	AudioServer.set_bus_volume_db(bus_BGindex, music_db_volume)
	print("Music bus volume set to: ", music_db_volume, " dB")

func SFX_value_changed(value: float) -> void:
	var sfx_db_volume = linear_to_db(value / 20)  # Value is already 0-1
	AudioServer.set_bus_volume_db(bus_SFXindex, sfx_db_volume)
	print("SFX bus volume set to: ", sfx_db_volume, " dB")
