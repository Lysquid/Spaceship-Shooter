extends Node


export (PackedScene) var Ship
export (Array, PackedScene) var ennemies

export var probaLerp = [0.018, 0.0012, 0.00011]
export var double_proba = 50		# score/time after witch proba are doubled

var proba = [0, 0, 0]
var ship
var score setget set_score
var time
var best_score = 0
var music_volume

enum {MENU, GAME}

var state = MENU

func _ready() -> void:
	init()
	music_volume = $Music.volume_db
	$Music.play()

func init() -> void:
	randomize()
	$Menu.popup()
	set_physics_process(false)
	

func _on_Menu_start_game() -> void:
	score = 0
	time = 0
	
	$Menu.hide() 
	ship = Ship.instance()	
	ship.position = $PlayerSpawn.position
	add_child(ship)
	
	$StartTimer.start()
	
	get_tree().call_group("GameElements", "queue_free")
	
	if not $Music.is_playing() or $Music/Tween.is_active():
		$Music/Tween.stop_all()
		$Music.volume_db = music_volume
		$Music.play()

func _physics_process(delta: float) -> void:
	for i in range(3):
		if randf() < proba[i]:
			var ennemy = ennemies[i].instance()
			$EnnemiesSpawn/PathFollow2D.offset = randi()
			ennemy.position = $EnnemiesSpawn/PathFollow2D.position
			add_child(ennemy)
			proba[i] = 0
		proba[i] = lerp(proba[i], 1, probaLerp[i] * delta * (1 + score/double_proba))

func _process(_delta: float):
	var offset = Vector2.DOWN * 0.3
	if state == GAME:
		offset -= Vector2.DOWN * 0.2 *  ship.velocity.y / ship.speed_y
	$Background.scroll_offset += offset
		
	if state == GAME and Input.is_action_pressed("ui_del"):
		ship.die()
	

func _on_StartDelay_timeout() -> void:
	set_physics_process(true)
	ship.gain_control()
	$HUD.update_score(score)
	$HUD.popup()
	$ScoreTimer.start()
	state = GAME

func game_over() -> void:
	$ScoreTimer.stop()
	if score > best_score:
		best_score = score
	state = MENU
	$Menu.show_game_over(score, best_score)
	init()
	$HUD.hide()
	get_tree().call_group("Ennemies", "ship_dead")
	$Music/Tween.interpolate_property($Music, "volume_db", null, -80, 3)
	$Music/Tween.start()

func _on_ScoreTimer_timeout() -> void:
	set_score(score + 1)
	time += 1


func set_score(value):
	score = value
	$HUD.update_score(score)


func _on_Tween_tween_completed(_object, _key) -> void:
	$Music.stop()
	$Music.volume_db = music_volume

