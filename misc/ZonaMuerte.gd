extends Area2D

signal jugador_muere()

func _on_ZonaMuerte_area_entered(area):
	print(area)
	if "Bomba" in area.name:
		emit_signal("jugador_muere")
