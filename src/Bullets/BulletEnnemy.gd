extends "BulletBase.gd"

func _ready():
	speed = 100

func _on_Bullet_body_entered(body: Node) -> void:
	if body.is_in_group("Ship"):
		explode()
		body.hit(1)
