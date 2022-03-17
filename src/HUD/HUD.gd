extends Popup

func update_score(score):
	$Score.text = str(score)

func update_hp(hp):
	var text = ""
	for _i in range(hp):
		text += "♥"
	$Hp.text = text

