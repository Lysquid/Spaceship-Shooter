extends Area2D

export (int) var speed

var direction = Vector2()

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
	

func _physics_process(delta: float) -> void:
	if $Sprite.animation == "default":
		position += direction * speed * delta

func _on_Sprite_animation_finished() -> void:
	if $Sprite.animation == "explosion" or $Sprite.animation == "desintegration":
		queue_free()


func init(emittingBody, pos, _direction):
	position = emittingBody.position + pos
	direction = _direction.normalized()
	emittingBody.get_parent().add_child(self)

func explode():
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite.animation = "explosion"
