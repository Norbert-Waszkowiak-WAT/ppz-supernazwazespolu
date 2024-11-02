extends Control


func _on_graj_pressed() -> void:
	get_tree().change_scene_to_file("res://gra.tscn")


func _on_opcje_pressed() -> void:
	get_tree().change_scene_to_file("res://opcje_menu.tscn")


func _on_wyjdź_pressed() -> void:
	get_tree().quit()
