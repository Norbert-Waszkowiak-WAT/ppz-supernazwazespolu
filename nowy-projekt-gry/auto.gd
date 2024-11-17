extends CharacterBody2D

@onready var player = $"../Player"

@export var steering_angle = 15  # Maksymalny kąt skrętu kół samochodu
@export var engine_power = 900  # Siła, jaką silnik może zastosować do przyspieszenia
@export var friction = -55  # Współczynnik tarcia spowalniający samochód
@export var drag = -0.06  # Współczynnik oporu powietrza, który także spowalnia samochód
@export var braking = -450  # Siła hamowania przy wciśnięciu hamulca
@export var max_speed_reverse = 250  # Maksymalna prędkość wsteczna
@export var slip_speed = 400  # Prędkość, powyżej której przyczepność samochodu maleje (do driftu)
@export var traction_fast = 2.5  # Współczynnik przyczepności przy dużej prędkości (wpływa na kontrolę)
@export var traction_slow = 10  # Współczynnik przyczepności przy małej prędkości (wpływa na kontrolę)

var wheel_base = 65  # Odległość między przednią a tylną osią samochodu
var acceleration = Vector2.ZERO  # Aktualny wektor przyspieszenia
var steer_direction  # Aktualny kierunek skrętu

@export var is_active = false

func _physics_process(delta: float) -> void:
	if is_active:
		$Camera2D.enabled = true
		acceleration = Vector2.ZERO
		get_input()  # Pobierz dane wejściowe od gracza
		calculate_steering(delta)  # Zastosuj logikę skrętu na podstawie sterowania
	else:
		$Camera2D.enabled = false

	velocity += acceleration * delta  # Zastosuj wynikowe przyspieszenie do prędkości
	apply_friction(delta)  # Zastosuj siły tarcia na samochód
	move_and_slide()  # Przesuń samochód i obsłuż kolizje

# Funkcja do obsługi wejścia od użytkownika i zastosowania efektów na ruch samochodu
func get_input():
	# Pobierz dane wejściowe dotyczące skrętu i przetłumacz je na kąt
	var turn = Input.get_axis("move_left", "move_right")
	steer_direction = turn * deg_to_rad(steering_angle)

	# Jeśli przycisk przyspieszenia jest wciśnięty, zastosuj moc silnika w kierunku jazdy
	if Input.is_action_pressed("move_up"):
		acceleration = transform.x * engine_power

	# Jeśli przycisk hamowania jest wciśnięty, zastosuj siłę hamowania
	if Input.is_action_pressed("move_down"):
		acceleration = transform.x * braking

# Funkcja do zastosowania sił tarcia na samochód, co powoduje jego „ślizganie się” do zatrzymania
func apply_friction(delta):
	# Jeśli brak jest wejścia i prędkość jest bardzo niska, zatrzymaj samochód, aby zapobiec nieskończonemu ślizganiu
	if acceleration == Vector2.ZERO and velocity.length() < 50:
		velocity = Vector2.ZERO
	# Oblicz siłę tarcia i oporu powietrza na podstawie aktualnej prędkości i zastosuj je
	var friction_force = velocity * friction * delta
	var drag_force = velocity * velocity.length() * drag * delta
	# Dodaj siły do przyspieszenia
	acceleration += drag_force + friction_force

# Funkcja do obliczenia efektu skrętu
func calculate_steering(delta):
	# Oblicz pozycje tylnych i przednich kół
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	# Przesuń pozycje kół na podstawie aktualnej prędkości, stosując rotację do przedniego koła
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	# Oblicz nowy kierunek na podstawie pozycji kół
	var new_heading = rear_wheel.direction_to(front_wheel)

	# Wybierz model trakcji na podstawie aktualnej prędkości
	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast

	# Iloczyn skalarny reprezentuje, jak bardzo nowy kierunek jest wyrównany z aktualnym kierunkiem prędkości
	var d = new_heading.dot(velocity.normalized())

	# Jeśli nie hamujemy (d > 0), dopasuj płynnie prędkość samochodu do nowego kierunku
	if d > 0:
		velocity = lerp(velocity, new_heading * velocity.length(), traction * delta)

	# Jeśli hamujemy (d < 0), odwróć kierunek i ogranicz prędkość
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)

	# Zaktualizuj obrót samochodu, aby skierować go w stronę nowego kierunku
	rotation = new_heading.angle()
