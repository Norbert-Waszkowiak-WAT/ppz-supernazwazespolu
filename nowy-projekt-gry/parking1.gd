extends Area2D

signal car_parked  # Sygnał do przejścia na kolejny poziom

func _on_body_entered(body):
	if body.is_in_group("car"):  # Sprawdza, czy to auto
		emit_signal("car_parked")  # Wysyła sygnał, że auto zaparkowało
		
func _on_ParkingSpot_body_entered(body):
	if body.is_in_group("car"):  # Sprawdza, czy obiekt to samochód
		print("Zaparkowano!")  
		get_tree().change_scene_to_file("res://sceny/nastepny_poziom.tscn")  # Przejście do nowego poziomu
