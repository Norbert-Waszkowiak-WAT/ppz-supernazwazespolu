extends Control

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://gra.tscn")

func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scena3d.tscn")
