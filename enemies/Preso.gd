extends Area2D

onready var ancho_ventana = get_viewport().size.x
onready var posicion_inicial = position.x
var juego_iniciado = false
var crear_nuevo_nivel = false
#Precargar bombas
const BOMB = preload("res://misc/Bomba.tscn")
var bomba_inicial = false
var bomba_lanzada = false
var maximo_bombas = 10
var bombas_lanzadas = 0
var bombas_atrapadas = 0
var bomba_velocidad = 150
#Variables Movimiento Preso
var movimiento = Vector2()
var rango = RandomNumberGenerator.new()
var posicion_final
var posicion_actual
var velocidad_movimiento = 160 
var juego_finalizado = false

signal juego_inicio(value)
signal jugador_revive()

func _ready():
	posicion_final = rango.randf_range(0, ancho_ventana)

func _input(event):
	if !juego_iniciado and !juego_finalizado:
		if event is InputEventMouseButton:
			juego_iniciado = true 
			emit_signal("juego_inicio",true)
	if juego_iniciado and juego_finalizado:
		if event is InputEventMouseButton:
			get_tree().reload_current_scene()
			
func _physics_process(delta):
	if !crear_nuevo_nivel:
		if juego_iniciado and bombas_lanzadas != maximo_bombas:
			movimiento_prisionero(delta)
			translate(movimiento)
		if bombas_atrapadas == maximo_bombas:
			crear_nuevo_nivel = true
			iniciar_nuevo_nivel()
	
func movimiento_prisionero(delta):
	if posicion_final < posicion_inicial:
		movimiento.x = -velocidad_movimiento * delta
		posicion_actual = position.x
		if !bomba_lanzada:
			lanzar_bomba()
		if posicion_actual < posicion_final:
			calcular_movimiento()
	elif posicion_final > posicion_inicial:
		movimiento.x = +velocidad_movimiento * delta
		posicion_actual = position.x
		if !bomba_lanzada:
			lanzar_bomba()
		if posicion_actual > posicion_final:
			calcular_movimiento()
			
func calcular_movimiento():
	posicion_final = rango.randf_range(0, ancho_ventana)
	posicion_inicial = posicion_actual

func lanzar_bomba():
	if bombas_lanzadas != maximo_bombas:
		var lanza_bomba = randi()%10
		if lanza_bomba == 0:
			var bomba= BOMB.instance()
			bomba.velocidad_bomba += bomba_velocidad 
			get_parent().add_child(bomba)
			bomba.position = $Position2D.global_position
			bombas_lanzadas += 1 
			bomba_lanzada = true
			if !bomba_inicial:
				bomba_inicial = true
				$Sprite.hide()
		
	
func iniciar_nuevo_nivel():
	yield(get_tree().create_timer(2), "timeout")
	asignar_nueva_velocidad_bombas()
	aumentar_cantidad_bombas()
	aumentar_velocidad_preso()
	calcular_movimiento()
	bombas_atrapadas = 0
	bombas_lanzadas = 0
	crear_nuevo_nivel = false
	
func asignar_nueva_velocidad_bombas():
	if bomba_velocidad == 900 or bomba_velocidad > 900:
		bomba_velocidad = 900
	else:
		bomba_velocidad += 100
	
func aumentar_cantidad_bombas():
	if maximo_bombas == 100 or maximo_bombas > 100:
		maximo_bombas = 100
	else:
		maximo_bombas = maximo_bombas + 20

func aumentar_velocidad_preso():
	if velocidad_movimiento == 1000 or velocidad_movimiento > 1000:
		velocidad_movimiento = 1000
	else: 
		velocidad_movimiento = velocidad_movimiento + 100

func _on_Preso_area_exited(area):
	if "Bomba" in area.name:
		bomba_lanzada = false

func _on_Player_bomba_en_cesta():
	bombas_atrapadas += 1

func _on_ZonaMuerte_jugador_muere():
	crear_nuevo_nivel = true
	get_tree().call_group("bombas", "detener_bombas")
	for bomba in get_tree().get_nodes_in_group("bombas"):
		yield(get_tree().create_timer(0.4), "timeout")
		bomba.destruir_bomba()
	if get_tree().get_nodes_in_group("bombas").size() == 1:
		if !juego_finalizado:
			yield(get_tree().create_timer(2), "timeout")
			bombas_atrapadas = 0
			bombas_lanzadas = 0
			calcular_movimiento()
			crear_nuevo_nivel = false
			emit_signal("jugador_revive")
			$Sprite.hide()

func _on_Player_juego_finalizado():
	juego_finalizado = true

