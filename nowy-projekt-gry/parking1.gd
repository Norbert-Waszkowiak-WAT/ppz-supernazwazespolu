extends Area2D

@export var next_level_scene: String = "res://sceny/parking3.tscn"

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("car"):
		print("Poziom 2 ukończony! Przechodzę do:", next_level_scene)
		await get_tree().create_timer(0.5).timeout  # Krótkie opóźnienie
		get_tree().change_scene_to_file(next_level_scene)
