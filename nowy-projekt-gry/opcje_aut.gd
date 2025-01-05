extends Control

# Tablica obrazków postaci
var character_images = []
var current_index = 0  # Indeks aktualnie wybranej postaci

# Referencje do węzłów
@onready var current_character = $CurrentCharacter
var poprzedni_button
var nastepny_button

func _ready():
	# Wczytaj obrazki postaci
	poprzedni_button = $PoprzedniButton
	nastepny_button = $NastepnyButton
	character_images = [
		preload("res://auta/auto3.png"),
		preload("res://auta/car-4291153_640.png"),
		preload("res://auta/car-4450666_640.png"),
		preload("res://auta/samochod.png"),
	]
	poprzedni_button.connect("pressed", Callable(self, "_on_poprzedni_button_pressed"))
	nastepny_button.connect("pressed", Callable(self, "_on_nastepny_button_pressed"))
	# Ustaw domyślną grafikę
	update_character_display()

	# Podłącz przyciski
	
func _on_wybierz_pressed() -> void:
	get_tree().change_scene_to_file("res://wyborlvl.tscn")

func update_character_display():
	# Sprawdzenie, czy current_character nie jest null
	if current_character != null:
		current_character.texture = character_images[current_index]

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


func _on_poprzedni_pressed() -> void:
	pass # Replace with function body.


func _on_nastepny_pressed() -> void:
	pass # Replace with function body.
