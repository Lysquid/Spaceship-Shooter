extends Node

export (PackedScene) var Game

func _ready():
	if OS.get_name() != "HTML5":
		load_game()

func _process(_delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT) or Input.is_mouse_button_pressed(BUTTON_RIGHT) or Input.is_mouse_button_pressed(BUTTON_MIDDLE):
		load_game()
		
func load_game():
	var _error = get_tree().change_scene_to(Game)
