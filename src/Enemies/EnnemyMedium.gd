extends "EnnemyBase.gd"

func _ready():
	base_hp = 2
	hp = base_hp
	speed = rand_speed(30, 0.5)


func _on_ShotTimer_timeout() -> void:
	var bullet = Bullet.instance()
	bullet.init(self, $ShootPosition.position, Vector2.DOWN)


func _on_EnnemyMedium_died() -> void:
	if randi() % 8 == 0:
		drop_power_up()

