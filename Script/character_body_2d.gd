extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -450.0
const ATTACK_TIME = 0.5
const ATTACK3_TIME = 0.9
const ROLL_SPEED = 200.0
const ROLL_TIME = 0.8

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping = false
var is_attacking = false
var is_attacking2 = false
var is_attacking3 = false
var attack_timer = 0.0
var attack3_timer = 0.0
var is_crouching = false
var is_rolling = false
var roll_timer = 0.0
var max_health = 100
var current_health = max_health
var damage = 30 # Amount of damage the enemy deals

signal player_died
signal health_changed(current_health)

@onready var health_bar = $"../CanvasLayer/HealthBar"
@onready var area2 = $AnimatedSprite2D/AttackArea

func _ready():
	add_to_group("Player")
	area2.connect("body_entered", Callable(self, "_on_body_entered"))

func take_damage(amount: int) -> void:
	current_health -= amount
	current_health = max(current_health, 0)
	emit_signal("health_changed", current_health)
	if current_health <= 0:
		die()
		
func _on_body_entered(body: Node) -> void:
# Check if the body is the player
	if body.is_in_group("Enemy"):
		if body.has_method("take_damage"):
			body.take_damage(damage)

func heal(amount: int) -> void:
	current_health += amount
	current_health = min(current_health, max_health)
	emit_signal("health_changed", current_health)

func die() -> void:
	print("Player is dead")
	# Emit the signal before reloading the scene
	emit_signal("player_died")
	# Add a small delay before reloading the scene so players can see the death message
	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()

func _physics_process(delta: float) -> void:
	var direction = Input.get_axis("ui_left", "ui_right")

	if Input.is_action_pressed("ui_crouch") and not is_rolling and not is_attacking and not is_attacking2 and not is_attacking3 and is_on_floor():
		if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			is_rolling = true
			roll_timer = ROLL_TIME
			velocity.x = ROLL_SPEED if Input.is_action_pressed("ui_right") else -ROLL_SPEED
			$AnimatedSprite2D.flip_h = velocity.x < 0
			$AnimatedSprite2D.play("roll")
			return
		else:
			is_crouching = true
			$AnimatedSprite2D.play("crouch")
			velocity.x = 0
	else:
		is_crouching = false

	if is_rolling:
		roll_timer -= delta
		if roll_timer <= 0.0:
			is_rolling = false

	if is_rolling:
		move_and_slide()
		return

	if not is_crouching:
		if direction != 0 and not is_attacking and not is_attacking2 and not is_attacking3 and is_on_floor():
			velocity.x = direction * SPEED
			if is_on_floor():
				$AnimatedSprite2D.play("run")
			$AnimatedSprite2D.flip_h = direction < 0
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if is_on_floor() and not is_attacking and not is_attacking2 and not is_attacking3:
				$AnimatedSprite2D.play("idle")

	if not is_on_floor():
		velocity.y += gravity * delta
		if not is_jumping:
			$AnimatedSprite2D.play("jump")
			is_jumping = true
		if velocity.y > 0:
			$AnimatedSprite2D.play("fall")

	if Input.is_action_just_pressed("ui_select") and is_on_floor() and not is_attacking and not is_attacking2 and not is_attacking3:
		velocity.y = JUMP_VELOCITY
		is_jumping = true
		if direction != 0:
			velocity.x = direction * SPEED
		$AnimatedSprite2D.play("jump")

	if not is_on_floor() and direction != 0:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.flip_h = direction < 0

	if Input.is_action_just_pressed("ui_attack") and not is_attacking and not is_attacking2 and not is_attacking3:
		is_attacking = true
		$AnimatedSprite2D.play("attack")
		$AudioStreamPlayer_Attack.play()  # Play attack sound
		attack_timer = ATTACK_TIME

	if Input.is_action_just_pressed("ui_attack2") and not is_attacking and not is_attacking2 and not is_attacking3:
		is_attacking2 = true
		$AnimatedSprite2D.play("attack2")
		$AudioStreamPlayer_Attack.play()  # Play attack2 sound
		attack_timer = ATTACK_TIME

	if Input.is_action_just_pressed("ui_attack3") and not is_attacking and not is_attacking2 and not is_attacking3:
		is_attacking3 = true
		$AnimatedSprite2D.play("attack3")
		$AudioStreamPlayer_Attack.play()  # Play attack3 sound
		attack3_timer = ATTACK3_TIME

	if is_attacking or is_attacking2:
		attack_timer -= delta
		if attack_timer <= 0.0:
			is_attacking = false
			is_attacking2 = false

	if is_attacking3:
		attack3_timer -= delta
		if attack3_timer <= 0.0:
			is_attacking3 = false

	if is_on_floor() and is_jumping:
		is_jumping = false
		$AnimatedSprite2D.play("idle")

	move_and_slide()
