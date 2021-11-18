extends KinematicBody2D

export var jugador_vivo = true
export var juego_iniciado = false
var vidas = 3

signal juego_finalizado()
signal bomba_en_cesta()

func _ready():
	$vida1/AnimatedSprite.connect("animation_finished", self, "vidauno_finished")
	$vida2/AnimatedSprite.connect("animation_finished", self, "vidados_finished")
	$vida3/AnimatedSprite.connect("animation_finished", self, "vidatres_finished")
	
func _input(event):
	if jugador_vivo and juego_iniciado:
		if event is InputEventMouseMotion:
			position.x = event.position.x

func _on_Preso_juego_inicio(value):
	juego_iniciado = value;

func _on_vida1_area_entered(area):
	$vida1/AnimatedSprite.play("splash")
	if "Bomba" in area.name:
		emit_signal("bomba_en_cesta")
		area.queue_free()
	
func _on_vida2_area_entered(area):
	$vida2/AnimatedSprite.play("splash")
	if "Bomba" in area.name:
		emit_signal("bomba_en_cesta")
		area.queue_free()
		
func _on_vida3_area_entered(area):
	$vida3/AnimatedSprite.play("splash")
	if "Bomba" in area.name:
		emit_signal("bomba_en_cesta")
		area.queue_free()

func _on_ZonaMuerte_jugador_muere():
	jugador_vivo = false
	vidas = vidas - 1
	if vidas == 2:
		$vida3.queue_free()
	if vidas == 1:
		$vida2.queue_free()
	if vidas == 0:
		emit_signal("juego_finalizado")
		$vida1.queue_free()

func vidauno_finished():
	$vida1/AnimatedSprite.play("default")
	
func vidados_finished():
	$vida2/AnimatedSprite.play("default")

func vidatres_finished():
	$vida3/AnimatedSprite.play("default")

func _on_Preso_jugador_revive():
	jugador_vivo = true

