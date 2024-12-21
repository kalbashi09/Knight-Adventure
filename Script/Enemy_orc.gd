extends CharacterBody2D  # For Godot 4.x

# Constants
const SPEED = 200.0  # Movement speed
const PATROL_DISTANCE = 150.0  # Distance to patrol from the starting position
const IDLE_TIME = 2.0  # Time to idle at each patrol point
const GRAVITY = 500.0  # Gravity strength
const JUMP_STRENGTH = -250.0  # Jump strength (negative because gravity pulls down)

# Variables
var start_position = Vector2.ZERO  # The starting position of the enemy
var patrol_direction = 1  # Direction of movement: 1 (right), -1 (left)
var is_idle = false  # Tracks whether the enemy is currently idling
var idle_timer = 0.0  # Timer for managing idle state
var damage = 10  # Amount of damage the enemy deals

# Enemy Health
var max_health = 100
var current_health = max_health
var damage_interval = 0.5  # Time in seconds between each damage tick
var damage_timer = 0.0      # Timer to track the damage interval

signal enemy_died
signal health_changed(current_health)

@onready var area1 = $Area2D

# Tracks if the player is in the area
var player_in_area = null

func _ready():
	add_to_group("Enemy")
	print("enemy is in 'Enemy' group")
	
	start_position = global_position  # Record the starting position
	$AnimatedSprite2D.play("run")  # Start with the run animation
	$AnimatedSprite2D.flip_h = true  # Initially flip the sprite to face left (since it's facing left by default)
	
	area1.connect("body_entered", Callable(self, "_on_body_entered"))
	area1.connect("body_exited", Callable(self, "_on_body_exited"))
	
func take_damage(amount: int) -> void:
	current_health -= amount
	current_health = max(current_health, 0)
	emit_signal("health_changed", current_health)
	if current_health <= 0:
		die()
		
func die() -> void:
	print("Enemy died")
	emit_signal("enemy_died")
	queue_free()  # Remove the enemy from the scene
	
func _on_body_entered(body: Node) -> void:
	# Check if the body is the player
	if body.is_in_group("Player"):
		player_in_area = body  # Track the player
		print("Player entered the enemy's area")

func _on_body_exited(body: Node) -> void:
	# Check if the body is the player
	if body == player_in_area:
		player_in_area = null  # Reset when the player leaves
		print("Player exited the enemy's area")

func _physics_process(delta):
	if is_idle:
		handle_idle(delta)
		return

	apply_gravity(delta)
	patrol_and_move()

	# Handle damage-over-time
	if player_in_area:
		damage_timer -= delta
		if damage_timer <= 0:
			if player_in_area.has_method("take_damage"):
				player_in_area.take_damage(damage)
				print("Player takes damage:", damage)
			damage_timer = damage_interval  # Reset the timer

# Applies gravity to the character
func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta  # Apply gravity force
	else:
		velocity.y = 0  # Reset vertical velocity when on the ground

# Handles the patrol logic and movement
func patrol_and_move():
	# Calculate patrol limits
	var left_limit = start_position.x - PATROL_DISTANCE
	var right_limit = start_position.x + PATROL_DISTANCE

	# Move the bot horizontally
	velocity.x = SPEED * patrol_direction
	move_and_slide()

	# Check if the bot has reached the patrol limits
	if global_position.x <= left_limit or global_position.x >= right_limit:
		patrol_direction *= -1  # Reverse the patrol direction
		$AnimatedSprite2D.flip_h = patrol_direction == 1  # Flip the sprite based on direction
		enter_idle_state()

# Handles the idle state logic
func handle_idle(delta):
	idle_timer -= delta
	if idle_timer <= 0:
		is_idle = false
		$AnimatedSprite2D.play("run")  # Resume the run animation

# Enters the idle state
func enter_idle_state():
	is_idle = true
	idle_timer = IDLE_TIME
	velocity.x = 0  # Stop horizontal movement
	$AnimatedSprite2D.play("idle")  # Play the idle animation
	print("Enemy is idling")
