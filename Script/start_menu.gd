extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/main.tscn")


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/settings.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
