extends CanvasLayer

@onready var health_bar = $HealthBar
@onready var player = get_tree().get_root().get_node("Main/Player")
@onready var death_label = $DeathLabel
@onready var killzone = get_tree().get_root().get_node("Main/Killzone")  # Reference the Killzone node

func _ready() -> void:

	if player:
		player.connect("health_changed", Callable(self, "update_health_bar"))

	if health_bar:
		health_bar.max_value = player.max_health
		health_bar.value = player.current_health

	# Set up DeathLabel properties
	death_label.anchor_left = 0.5
	death_label.anchor_top = 0.5
	death_label.anchor_right = 0.5
	death_label.anchor_bottom = 0.5
	death_label.custom_minimum_size = Vector2(400, 100)
	death_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	death_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	death_label.position = Vector2.ZERO
	death_label.offset_left = -death_label.size.x / 2
	death_label.offset_top = -death_label.size.y / 2
	death_label.visible = false

	# Connect Killzone signal
	if killzone:
		killzone.connect("player_killed", Callable(self, "_on_player_killed"))

	# Connect to player's death
	if player:
		player.connect("player_died", Callable(self, "_on_player_died"))

func update_health_bar(current_health: int) -> void:
	if health_bar:
		health_bar.value = current_health

func _on_player_died() -> void:
	death_label.visible = true
	death_label.text = "YOU DIED"

func _on_player_killed() -> void:
	death_label.visible = true
	death_label.text = "YOU DIED"  # Or customize the text for the killzone

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/Start menu.tscn")
