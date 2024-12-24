extends Control

const SETTINGS_FILE_PATH: String = "user://settings.cfg"
var temp_volume: float = 0.5  # Default temporary volume value

func _ready() -> void:
	load_settings()
	$VBoxContainer/HSlider.connect("value_changed", Callable(self, "_on_volume_slider_changed"))

func _on_volume_slider_changed(value: float) -> void:
	temp_volume = value  # Store the slider value temporarily

func _on_save_pressed() -> void:
	save_settings()
	AudioManager.set_volume(temp_volume)  # Apply the saved volume to the background music

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/Start menu.tscn")

# Save settings to ConfigFile
func save_settings() -> void:
	var config = ConfigFile.new()
	var quality = $VBoxContainer/Quality.selected
	var difficulty = $VBoxContainer/Difficulty.selected

	config.set_value("settings", "quality", quality)
	config.set_value("settings", "difficulty", difficulty)
	config.set_value("settings", "volume", temp_volume)

	var error = config.save(SETTINGS_FILE_PATH)
	if error == OK:
		print("Settings saved successfully!")
	else:
		print("Failed to save settings: ", error)

# Load settings from ConfigFile
func load_settings() -> void:
	var config = ConfigFile.new()
	var error = config.load(SETTINGS_FILE_PATH)

	if error == OK:
		$VBoxContainer/Quality.selected = config.get_value("settings", "quality", 0)
		$VBoxContainer/Difficulty.selected = config.get_value("settings", "difficulty", 0)
		var volume = config.get_value("settings", "volume", 0.5)  # Default to 0.5
		$VBoxContainer/HSlider.value = volume
		temp_volume = volume  # Set the temporary volume to the loaded value
		AudioManager.set_volume(volume)  # Apply the loaded volume immediately
		print("Settings loaded successfully!")
	else:
		print("Failed to load settings: ", error)
