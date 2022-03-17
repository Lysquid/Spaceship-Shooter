extends "BulletBase.gd"

func _ready() -> void:
	speed = 180

func _on_Bullet_body_entered(body: Node) -> void:
	if body.is_in_group("Ennemies"):
		explode()
		body.hit(1)
		if body.fusee:
			get_parent().ship.hit(-1)

func set_desintegration_time(time):
	$DesintegrationTimer.wait_time += time + rand_range(-0.08, 0.08)
	$DesintegrationTimer.start()
	
func _on_ExplodeTimer_timeout() -> void:
	$Sprite.animation = "desintegration"
