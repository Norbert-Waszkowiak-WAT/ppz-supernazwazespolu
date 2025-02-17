extends CharacterBody2D

# Parametry pojazdu
@export var steering_angle = 90  # Maksymalny kąt skrętu (w stopniach)
@export var engine_power = 700  # Moc silnika (przyspieszenie)
@export var max_speed = 400  # Maksymalna prędkość
@export var braking_power = 700  # Siła hamowania
@export var friction = 400  # Współczynnik tarcia (spowalnia pojazd)
@export var reverse_speed_limit = -400  # Maksymalna prędkość wsteczna

# Flaga określająca aktywność pojazdu
@export var is_active = true

var start_position: Vector2  # Pozycja startowa auta

# Zmienna dla prędkości i kierunku skrętu
var speed = 0
var steer_direction = 0

# Pozycja i rotacja początkowa
var spawn_position: Vector2
var spawn_rotation: float

func _ready() -> void:
	# Zapisanie początkowej pozycji i rotacji
	spawn_position = global_position
	spawn_rotation = rotation
func _on_body_entered(body):
	if body.is_in_group("Bariera"):# Jeśli auto uderzy w barierę
		global_position = start_position


func _physics_process(delta: float) -> void:
	if is_active:
		handle_input(delta)
		apply_friction(delta)
		move_vehicle(delta)

# Funkcja obsługująca wejście użytkownika
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

	# Ograniczenie prędkości
	speed = clamp(speed, reverse_speed_limit, max_speed)

# Zastosowanie tarcia do stopniowego zmniejszania prędkości
func apply_friction(delta: float) -> void:
	if speed > 0:
		speed -= friction * delta
		if speed < 0:
			speed = 0
	elif speed < 0:
		speed += friction * delta
		if speed > 0:
			speed = 0

# Ruch pojazdu na podstawie prędkości i kierunku
func move_vehicle(delta: float) -> void:
	if speed != 0:
		rotation += steer_direction * (speed / max_speed) * delta

	var direction = Vector2.RIGHT.rotated(rotation)
	var movement = direction * speed * delta
	move_and_collide(movement)

# Funkcja obsługująca kolizje
func _on_area_2d_body_entered(body: Node2D) -> void:
	is_active = false  # Dezaktywuj sterowanie
	$Sprite2D.visible = false  # Ukryj samochód

	# Tworzenie i czekanie na timer
	var timer = Timer.new()
	timer.wait_time = 1.0  # Czas odrodzenia: 1 sekunda
	timer.one_shot = true  # Timer działa tylko raz
	add_child(timer)
	timer.start()
	await timer.timeout  # Czekaj na zakończenie timera
	timer.queue_free()  # Usuń timer po użyciu

	reset_car()  # Zresetuj pozycję samochodu
	$Sprite2D.visible = true  # Pokaż samochód
	is_active = true  # Aktywuj sterowanie

# Funkcja resetowania pojazdu
func reset_car() -> void:
	global_position = spawn_position
	rotation = spawn_rotation
	speed = 0
	steer_direction = 0
	
