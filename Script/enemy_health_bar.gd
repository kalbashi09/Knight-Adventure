extends ProgressBar

@onready var health_bar = self
@onready var enemy = get_tree().get_root().get_node("Main/Enemy1")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if enemy:
		enemy.connect("health_changed", Callable(self, "update_health_bar"))

	if health_bar:
		health_bar.max_value = enemy.max_health
		health_bar.value = enemy.current_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_health_bar(current_health: int) -> void:
	if health_bar:
		health_bar.value = current_health
