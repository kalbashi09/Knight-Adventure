extends Control

# Path for saving settings
const SETTINGS_FILE_PATH: String = "user://settings.cfg"

func _on_back_pressed() -> void:
	# Navigate back to the main menu
	get_tree().change_scene_to_file("res://Scene/Start menu.tscn")

func _on_save_pressed() -> void:
	save_settings()

func _ready() -> void:
	load_settings()
	
# Save settings to ConfigFile
func save_settings() -> void:
	var config = ConfigFile.new()
	
	# Access nodes and save their values
	var quality = $VBoxContainer/Quality.selected
	var difficulty = $VBoxContainer/Difficulty.selected
	var volume = $VBoxContainer/HSlider.value
	
	# Write values to ConfigFile
	config.set_value("settings", "quality", quality)
	config.set_value("settings", "difficulty", difficulty)
	config.set_value("settings", "volume", volume)
	
	# Save to file
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
		# Load values from file and apply them to nodes
		$VBoxContainer/Quality.selected = config.get_value("settings", "quality", 0)  # Default to index 0
		$VBoxContainer/Difficulty.selected = config.get_value("settings", "difficulty", 0)
		$VBoxContainer/HSlider.value = config.get_value("settings", "volume", 50)  # Default to 50
		print("Settings loaded successfully!")
	else:
		print("Failed to load settings: ", error)
