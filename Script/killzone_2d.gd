extends Area2D

# Signal to notify when the player enters the killzone
signal player_killed

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):  # Assuming the player node is in the "Player" group
		print("Player entered killzone")
		emit_signal("player_killed")  # Emit the signal
		call_deferred("reload_scene")  # Add a delay before reloading the scene

func reload_scene() -> void:
	await get_tree().create_timer(2.0).timeout  # Wait for 2 seconds
	get_tree().reload_current_scene()  # Reload the current scene
