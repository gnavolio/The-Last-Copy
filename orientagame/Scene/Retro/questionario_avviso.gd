
extends CanvasLayer

func _ready() -> void:
	hide()
	
	$BaseGround/Resume.pressed.connect(func():
		queue_free()
	)
	
	$BaseGround/Button.pressed.connect(func():
		OS.shell_open(Settingss.survey_link)
	)


func make_visible():
	$"../Combat/CanvasLayer".hide()
	show()
	
	
