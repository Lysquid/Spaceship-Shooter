extends "EnnemyBase.gd"

func _ready():
	base_hp = 1
	hp = base_hp
	speed = rand_speed(50, 0.5)
	if randi()%100 == 0:
		fusee = true
		speed = 200
