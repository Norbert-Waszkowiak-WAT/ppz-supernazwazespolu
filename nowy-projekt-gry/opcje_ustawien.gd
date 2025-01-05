extends Control

func _on_graj_1_pressed() -> void:
	get_tree().change_scene_to_file("res://opcje_aut.tscn")

func _on_graj_2_pressed() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")
