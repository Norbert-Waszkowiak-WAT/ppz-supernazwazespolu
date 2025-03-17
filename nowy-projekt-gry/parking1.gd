extends Area2D

@export var next_level_scene: String = "res://sceny/parking3.tscn"

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
