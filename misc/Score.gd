extends Node2D

var score = 0
onready var score_txt = get_node("Label")

func _ready():
	score_txt.text = str(score)

func _on_Player_bomba_en_cesta():
	score += 5
	score_txt.text = str(score)
