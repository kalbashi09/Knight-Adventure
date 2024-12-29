extends Control

const SETTINGS_FILE_PATH: String = "user://settings.cfg"
var temp_music_volume : float = 0.5  # Default temporary volume value
var temp_sfx_volume : float = 0.5

func _ready() -> void:
	load_settings()
	$VBoxContainer/Music_slider.connect("value_changed", Callable(self, "_on_music_volume_slider_changed"))
	$VBoxContainer/Sfx_slider.connect("value_changed", Callable(self, "_on_sfx_volume_slider_changed"))

func _on_music_volume_slider_changed(value: float) -> void:
	temp_music_volume  = value  # Store the slider value temporarily
	
func _on_sfx_volume_slider_changed(value:float)-> void:
	temp_sfx_volume = value


func _on_save_pressed() -> void:
	save_settings()
	AudioManager.BG_value_changed(temp_music_volume) # Apply the saved volume to the background music
	AudioManager.SFX_value_changed(temp_sfx_volume)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/Startmenu.tscn")

# Save settings to ConfigFile
func save_settings() -> void:
	var config = ConfigFile.new()
	var quality = $VBoxContainer/Quality.selected
	var difficulty = $VBoxContainer/Difficulty.selected

	config.set_value("settings", "quality", quality)
	config.set_value("settings", "difficulty", difficulty)
	config.set_value("settings", "music_volume", temp_music_volume)
	config.set_value("settings", "sfx_volume", temp_sfx_volume)

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
		var music_volume = config.get_value("settings", "music_volume", 0.5)  # Default to 0.5
		var sfx_volume = config.get_value("settings", "sfx_volume", 0.5) 
		$VBoxContainer/Music_slider.value = music_volume
		$VBoxContainer/Sfx_slider.value = sfx_volume
		temp_music_volume  = music_volume  # Set the temporary volume to the loaded value
		AudioManager.BG_value_changed(music_volume)  # Apply the loaded volume immediately
		temp_sfx_volume = sfx_volume
		AudioManager.SFX_value_changed(sfx_volume)
		print("Settings loaded successfully!")
	else:
		print("Failed to load settings: ", error)
