extends "EnnemyBase.gd"

var path_points = 10
var path_length = 0.5
var path_point = 0
var path_dir = 1
var path_initial_y

func _ready() -> void:
	base_hp = 5
	hp = base_hp
	speed = rand_speed(10, 0.5)

	if randi() % 2 == 0:
		path_point = path_points
	path_initial_y = $ShootPath/PathFollow.position.y + $ShootPath.position.y

func _on_ShotTimer_timeout() -> void:   
	var bullet = Bullet.instance()    
	$ShootPath/PathFollow.unit_offset = path_length * (float(path_point) / path_points) 
	bullet.init(self, $ShootPath/PathFollow.position, $ShootPath/PathFollow.position + Vector2.UP * path_initial_y)
	path_point += path_dir
	if path_point < 0 or path_point > path_points:
		path_dir *= -1
		path_point += path_dir * 2

func _on_EnnemyBig_died() -> void:
	if randi()%2 == 0:
		drop_power_up()
