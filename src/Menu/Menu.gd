extends Popup

signal start_game

var transparent_text = true

func _ready() -> void:
	$GameOver.hide()
	$Score.hide()
	$Best.hide()
	$StartButton/BlinkingTimer.start()

func _on_StartButton_pressed() -> void:
	$StartButton.disabled = true
	emit_signal("start_game")
	$StartButton/BlinkingTimer.start()


func show_game_over(score, best_score) -> void:
	$GameOver.show()
	$Score.show()
	$Score.text = "Score: " + str(score)
	$Best.show()
	$Best.text = "Best: " + str(best_score)
	$StartButton.hide()
	transparent_text = true
	$StartButton.disabled = false
	$StartButton.show()
	$StartButton/BlinkingTimer.start()


func _on_BlinkingTextTimer_timeout() -> void:	
	if transparent_text:
		$StartButton.set_modulate(Color(1, 1, 1, 1))
	else:
		$StartButton.set_modulate(Color(1, 1, 1, 0.5))
	transparent_text = not transparent_text

