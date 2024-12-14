extends Control


func _on_graj_pressed() -> void:
	get_tree().change_scene_to_file("res://wyborlvl.tscn")


func _on_graj_2_pressed() -> void:
	get_tree().change_scene_to_file("res://opcje_ustawien.tscn")


func _on_graj_3_pressed() -> void:
	get_tree().quit()
