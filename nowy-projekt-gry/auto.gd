extends CharacterBody2D

@export var steering_angle = 90  # Maksymalny kąt skrętu (w stopniach)
@export var engine_power = 700  # Moc silnika (przyspieszenie)
@export var max_speed = 400  # Maksymalna prędkość
@export var braking_power = 700  # Siła hamowania
@export var friction = 400  # Współczynnik tarcia (spowalnia pojazd)
@export var reverse_speed_limit = -400  # Maksymalna prędkość wsteczna

var speed = 0  # Aktualna prędkość pojazdu
var steer_direction = 0  # Kierunek skrętu (w radianach)

@export var is_active = true  # Czy pojazd jest aktywny?

func _physics_process(delta: float) -> void:
	if is_active:
		$Camera2D.enabled = true
		handle_input(delta)
		apply_friction(delta)
		move_vehicle(delta)
	else:
		$Camera2D.enabled = false

# Obsługa wejścia użytkownika
func handle_input(delta):
	# Obsługa skrętu
	if Input.is_action_pressed("ui_left"):
		steer_direction = -deg_to_rad(steering_angle)
	elif Input.is_action_pressed("ui_right"):
		steer_direction = deg_to_rad(steering_angle)
	else:
		steer_direction = 0  # Brak skrętu

	# Obsługa przyspieszania i hamowania
	if Input.is_action_pressed("ui_up"):
		speed += engine_power * delta
	elif Input.is_action_pressed("ui_down"):
		speed -= braking_power * delta

	# Ograniczenie prędkości maksymalnej
	speed = clamp(speed, reverse_speed_limit, max_speed)

# Zastosowanie tarcia w celu stopniowego zmniejszania prędkości
func apply_friction(delta):
	if speed > 0:
		speed -= friction * delta
		if speed < 0:  # Zatrzymaj pojazd, jeśli prędkość jest minimalna
			speed = 0
	elif speed < 0:
		speed += friction * delta
		if speed > 0:  # Zatrzymaj pojazd, jeśli prędkość jest minimalna
			speed = 0

# Ruch pojazdu na podstawie prędkości i kierunku
func move_vehicle(delta):
	# Zastosowanie skrętu
	if speed != 0:  # Skręcanie tylko przy ruchu pojazdu
		rotation += steer_direction * (speed / max_speed) * delta

	# Oblicz przesunięcie na podstawie prędkości
	var direction = Vector2.RIGHT.rotated(rotation)  # Kierunek pojazdu
	var movement = direction * speed * delta

	# Przesunięcie pojazdu
	move_and_collide(movement)
