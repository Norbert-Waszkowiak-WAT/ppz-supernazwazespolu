extends Control


func _on_graj_pressed() -> void:
	get_tree().change_scene_to_file("res://wyborlvl.tscn")


func _on_opcje_pressed() -> void:
	get_tree().change_scene_to_file("res://opcje_ustawien.tscn")


func _on_wyjdź_pressed() -> void:
	get_tree().quit()
