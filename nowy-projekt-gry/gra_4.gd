extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://wyborlvl.tscn")
	
func _on_area_2d_4_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://gra_5.tscn")
