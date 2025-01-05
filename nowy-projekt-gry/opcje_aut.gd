extends Control

# Tablica obrazków postaci
var character_images = []
var current_index = 0  # Indeks aktualnie wybranej postaci

# Referencje do węzłów
@onready var current_character = $CurrentCharacter
@onready var poprzedni_button = $PoprzedniButton
@onready var nastepny_button = $NastepnyButton

func _ready():
	# Wczytaj obrazki postaci
	character_images = [
		preload("res://auta/auto3.png"),
		preload("res://auta/car-4291153_640.png"),
		preload("res://auta/car-4450666_640.png"),
		preload("res://auta/samochod.png"),
	]


	# Ustaw domyślną grafikę
	update_character_display()

func update_character_display():
	# Sprawdzenie, czy current_character nie jest null
	if current_character != null:
		current_character.texture = character_images[current_index]
	else:
		print("BŁĄD: Nie znaleziono węzła CurrentCharacter!")

func _on_poprzedni_button_pressed():
	# Przełącz na poprzednią grafikę
	current_index -= 1
	if current_index < 0:
		current_index = character_images.size() - 1
	update_character_display()

func _on_nastepny_button_pressed():
	# Przełącz na następną grafikę
	current_index += 1
	if current_index >= character_images.size():
		current_index = 0
	update_character_display()

func _on_wybierz_pressed() -> void:
	get_tree().change_scene_to_file("res://wyborlvl.tscn")
