extends KinematicBody2D

export var speed_x = 120
export var speed_y = 80
export var friction = 0.04
export var acceleration = 0.1
export var hp = 3

export (PackedScene) var Bullet

var velocity = Vector2.ZERO
var transparent = false
var time_since_last_shot = 0
var power_up = Power_ups.NORMAL

# Shoot modes specifics
var tmp_time_storage

enum Power_ups {NORMAL, PENTA, INFINITE}

func _ready() -> void:
	set_process_input(false)
	get_parent().get_node("HUD").update_hp(hp)

func get_input():
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return input

func _physics_process(_delta):
	
	var direction = Vector2()
	
	if is_processing_input():
		direction = get_input()
	else:
		if not $StartAnimationTimer.is_stopped():
			direction = Vector2.UP
		else:
			direction = Vector2.ZERO
		
	direction = direction.normalized()
	direction.x *= speed_x
	direction.y *= speed_y
	
	# code found here : http://kidscancode.org/godot_recipes/2d/topdown_movement/
	if direction.length() > 0:
		velocity = lerp(velocity, direction, acceleration)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)
	velocity = move_and_slide(velocity)
	
	if Input.is_action_pressed("ui_select") and $ShootCooldown.is_stopped():
		shoot()
		
	for i in get_slide_count():
		var collider = get_slide_collision(i).collider
		if collider.is_in_group("Ennemies") and $InvincibilityTimer.is_stopped():
			collider.hit(1)
			self.hit(1)
	
	time_since_last_shot += _delta

func _process(_delta: float) -> void:
	animate()

func animate():
	var tilte = velocity.x / speed_x
	var animation
	if abs(tilte) > 0.7:
		if tilte > 0:
			animation = "right"
		else:
			animation = "left"
	elif abs(tilte) > 0.1:
		if tilte > 0:
			animation = "right_tilte"
		else:
			animation = "left_tilte"
	else:
		animation = "straight"
	$Sprite.animation = animation
		
func shoot():
	match power_up:
		Power_ups.NORMAL:
			spawn_bullet(Vector2.ZERO)
		Power_ups.PENTA:
			for i in range(-1, 2):
				spawn_bullet(Vector2.ZERO + Vector2(i*6, abs(i)*4))
		Power_ups.INFINITE:
			spawn_bullet(Vector2.ZERO)
	time_since_last_shot = 0
	$ShootCooldown.start()

func spawn_bullet(offset: Vector2):
	var bullet = Bullet.instance()
	bullet.init(self, $ShootPosition.position + offset, Vector2.UP)
	bullet.set_desintegration_time(time_since_last_shot)
	if power_up == Power_ups.INFINITE:
		bullet.set_desintegration_time(time_since_last_shot*2)

func _on_Sprite_animation_finished() -> void:
	if $Sprite.animation == "death":
		get_parent().game_over()
		queue_free()

func hit(damage: int):
	hp -= damage
	get_parent().get_node("HUD").update_hp(hp)
	
	if damage > 0:
		$InvincibilityTimer.start()
		$InvincibilityAnimationTimer.start()
		_on_InvincibilityAnimationTimer_timeout()
		set_collision_layer_bit(0, false)
		set_collision_mask_bit(0, false)
	
	if hp <= 0:
		die()

func die():
	hp = 0
	$Sprite.animation = "death"
	$CollisionShape2D.set_deferred("disabled", true)
	set_physics_process(false)
	set_process(false)
	set_process_input(false)

func gain_control() -> void:
	set_process_input(true)
	$CollisionShape2D.disabled = false


func _on_InvincibilityTimer_timeout() -> void:
	set_modulate(Color(1, 1, 1, 1))
	transparent = false
	$InvincibilityAnimationTimer.stop()
	set_collision_layer_bit(0, true)
	set_collision_mask_bit(0, true)
	

func _on_InvincibilityAnimationTimer_timeout() -> void:
	if transparent:
		set_modulate(Color(1, 1, 1, 1))
	else:
		set_modulate(Color(1, 1, 1, 0.3))
	transparent = not transparent

func activate_power_up(type):
	disable_power_up()
	match type:
		1:
			power_up = Power_ups.PENTA
		2:
			power_up = Power_ups.INFINITE
			tmp_time_storage = $ShootCooldown.get_wait_time()
			$ShootCooldown.set_wait_time($ShootCooldown/InfiniteMode.wait_time)
	$PowerUpTimer.start()

func disable_power_up() -> void:
	match power_up:
		Power_ups.INFINITE:
			$ShootCooldown.set_wait_time(tmp_time_storage)
	power_up = Power_ups.NORMAL
