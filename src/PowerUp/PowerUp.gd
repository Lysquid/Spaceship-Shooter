extends Area2D

export var speed = 20
var type

func _ready():
	type = randi() % 2 + 1
	$Sprite.set_animation(str(type))
	$BlinkingTimer.start()

func _physics_process(delta: float) -> void:
	position.y += speed * delta


func _on_PowerUp_body_entered(body: Node) -> void:
	if body.is_in_group("Ship"):
		body.activate_power_up(type)
		queue_free()

func _on_BlinkingTimer_timeout() -> void:
	$Sprite.set_speed_scale(3)
	$DespawnTimer.start()


func _on_DespawnTimer_timeout() -> void:
	queue_free()
