extends Control
@onready var muzyka = $Muzyka  # Pobieramy węzeł AudioStreamPlayer

func _ready():
	if muzyka != null:
		muzyka.play()  # Odtwarza muzykę
