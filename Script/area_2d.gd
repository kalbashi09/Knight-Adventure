extends Area2D

# List to keep track of enemies in the attack zone
var enemies_in_zone = []

func _ready():
	connect("area_entered", Callable(Area2D, "_on_area_entered"))
	connect("area_exited", Callable(Area2D, "_on_area_exited"))
	monitoring = false 


# Called when an enemy enters the attack zone
func _on_area_entered(area):
	if area.is_in_group("Enemy"):  # Assuming enemies are in an "Enemy" group
		enemies_in_zone.append(area)

# Called when an enemy exits the attack zone
func _on_area_exited(area):
	if area in enemies_in_zone:
		enemies_in_zone.erase(area)

# Called every frame to check for input
func _process(_delta):
	
	var attacks = ["ui_attack","ui_attack2","ui_attack3"]
	
	for action in attacks:
		if Input.is_action_just_pressed(action): 
			monitoring = true # Replace "attack" with your actual action name
			if enemies_in_zone.size() > 0:
				print("Attacked an enemy!")
			else:
				print("No enemies to attack.")
		elif Input.is_action_just_released(action):
			monitoring = false
			

func _on_ready() -> void:
	pass # Replace with function body.
