extends KinematicBody2D

signal died

export (int) var base_hp
export (PackedScene) var Bullet
export (PackedScene) var PowerUp

export (int) var speed

var hp

# Easter egg
var fusee = false

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
	
func _physics_process(delta: float) -> void:
	position.y += speed * delta

func hit(damage: int):
	hp -= damage
	if hp <= 0:
		$CollisionShape2D.set_deferred("disabled", true)
		$Sprite.animation = "death"
		$ShotTimer.stop()
		get_parent().score += base_hp
		emit_signal("died")

func _on_Sprite_animation_finished() -> void:
	if $Sprite.animation == "death":
		queue_free()

func _on_VisibilityNotifier2D_screen_entered() -> void:
	var wait_time = $ShotTimer.wait_time
	$ShotTimer.start(randf() * wait_time)
	$ShotTimer.wait_time = wait_time
	$CollisionShape2D.set_deferred("disabled", false)

func rand_speed(base_speed, speed_randomness):
	return rand_range(base_speed * (1 - speed_randomness), base_speed * (1 + speed_randomness))

func ship_dead():
	$ShotTimer.stop()

func drop_power_up():
	var power_up = PowerUp.instance()
	power_up.position = position
	get_parent().call_deferred("add_child", power_up)
