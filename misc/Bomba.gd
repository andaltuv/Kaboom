extends Area2D

var movimiento_bomba = Vector2()
var velocidad_bomba = 0
var jugador_murio = false

func _physics_process(delta):
	if !jugador_murio:
		movimiento_bomba.y = velocidad_bomba * delta
		$AnimatedSprite.play("falling")
		translate(movimiento_bomba)
	else:
		movimiento_bomba.y = 0

func detener_bombas():
	jugador_murio = true

func destruir_bomba():
	queue_free()
