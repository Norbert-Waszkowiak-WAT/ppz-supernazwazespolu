extends Control



func _on_powrót_pressed() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")
@onready var auto_sprite = $AutoSprite
var obrazki_aut = []
var indeks = 0

func _ready():
	obrazki_aut = [
		preload("res://auta/auto3.png"),
		preload("res://auta/car-4291153_640.png"),
		preload("res://auta/car-4450666_640.png")
	]

	# Ustaw pierwszą grafikę
	auto_sprite.texture = obrazki_aut[indeks]

func _on_zmien_auto_pressed():
	# Zmień teksturę na kolejną
	indeks += 1
	if indeks >= obrazki_aut.size():
		indeks = 0
	auto_sprite.texture = obrazki_aut[indeks]
