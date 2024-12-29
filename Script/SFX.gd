extends Node

var bg_music_player = AudioStreamPlayer.new()


func _ready() -> void:
	add_child(bg_music_player)
	bg_music_player.set_bus("SFX")
