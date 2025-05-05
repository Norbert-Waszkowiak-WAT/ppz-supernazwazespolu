extends CharacterBody2D

# Parametry pojazdu
@export var steering_angle = 90
@export var engine_power = 700
@export var max_speed = 400
@export var braking_power = 700
@export var friction = 400
@export var reverse_speed_limit = -400

@export var is_active = true

var speed = 0
var steer_direction = 0
var spawn_position: Vector2
var spawn_rotation: float

func _ready() -> void:
	spawn_position = global_position
	spawn_rotation = rotation

func _physics_process(delta: float) -> void:
	if is_active:
		handle_input(delta)
		apply_friction(delta)
		move_vehicle(delta)

func handle_input(delta: float) -> void:
	if Input.is_action_pressed("ui_left"):
		steer_direction = -deg_to_rad(steering_angle)
	elif Input.is_action_pressed("ui_right"):
		steer_direction = deg_to_rad(steering_angle)
	else:
		steer_direction = 0

	if Input.is_action_pressed("ui_up"):
		speed += engine_power * delta
	elif Input.is_action_pressed("ui_down"):
		speed -= braking_power * delta

	speed = clamp(speed, reverse_speed_limit, max_speed)

func apply_friction(delta: float) -> void:
	if speed > 0:
		speed -= friction * delta
		if speed < 0:
			speed = 0
	elif speed < 0:
		speed += friction * delta
		if speed > 0:
			speed = 0

func move_vehicle(delta: float) -> void:
	if speed != 0:
		rotation += steer_direction * (speed / max_speed) * delta

	var direction = Vector2.RIGHT.rotated(rotation)
	var movement = direction * speed * delta
	move_and_collide(movement)

# 🚗 Kolizja z przeszkodą
func _on_area_2d_body_entered(body: Node2D) -> void:
	# Odtwarzanie dźwięku kolizji
	if $CollisionSound:
		$CollisionSound.play()

	is_active = false
	$Sprite2D.visible = false

	var timer = Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await timer.timeout
	timer.queue_free()

	reset_car()
	$Sprite2D.visible = true
	is_active = true

func reset_car() -> void:
	global_position = spawn_position
	rotation = spawn_rotation
	speed = 0
	steer_direction = 0
