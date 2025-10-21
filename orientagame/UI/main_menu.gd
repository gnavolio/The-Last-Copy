extends Control

var button_type = null

func _ready() -> void:
	UI.hide()
	$CanvasLayer/Scaler/ButtonManager/Survey.pressed.connect(func():
		OS.shell_open(Settingss.survey_link)
	)


func _on_start_pressed():
	button_type = "start"
	$CanvasLayer/Fade_transition.show()
	$CanvasLayer/Fade_transition/Fade_timer.start()
	$CanvasLayer/Fade_transition/AnimationPlayer.play("fade_in")
	UI.show()


func _on_survey_pressed() -> void:
	button_type = "survey"
	#$CanvasLayer/Fade_transition.show()
	#$CanvasLayer/Fade_transition/Fade_timer.start()
	#$CanvasLayer/Fade_transition/AnimationPlayer.play("fade_in")

func _on_quit_pressed():
	get_tree().quit()


func _on_options_pressed():
	button_type = "options"
	var option_scene = preload("res://UI/option_menu.tscn").instantiate()
	option_scene.set_previous_scene("res://UI/main_menu.tscn")
	get_tree().current_scene.add_child(option_scene)


func _on_start_mouse_entered() -> void:
	$CanvasLayer/Scaler/ButtonManager/Start/StartLabel.hide()
	$CanvasLayer/Scaler/ButtonManager/Start/StartLabelPressed.show()
	$ButtonHover.play()

func _on_start_mouse_exited() -> void:
	$CanvasLayer/Scaler/ButtonManager/Start/StartLabelPressed.hide()
	$CanvasLayer/Scaler/ButtonManager/Start/StartLabel.show()


func _on_survey_mouse_entered() -> void:
	$CanvasLayer/Scaler/ButtonManager/Survey/SurveyLabel.hide()
	$CanvasLayer/Scaler/ButtonManager/Survey/SurveyLabelPressed.show()
	$ButtonHover.play()

func _on_survey_mouse_exited() -> void:
	$CanvasLayer/Scaler/ButtonManager/Survey/SurveyLabelPressed.hide()
	$CanvasLayer/Scaler/ButtonManager/Survey/SurveyLabel.show()


func _on_quit_mouse_entered() -> void:
	$CanvasLayer/Scaler/ButtonManager/Quit/QuitLabel.hide()
	$CanvasLayer/Scaler/ButtonManager/Quit/QuitLabelPressed.show()
	$ButtonHover.play()

func _on_quit_mouse_exited() -> void:
	$CanvasLayer/Scaler/ButtonManager/Quit/QuitLabelPressed.hide()
	$CanvasLayer/Scaler/ButtonManager/Quit/QuitLabel.show()


#Aggiungere i file dele scene corrette
func _on_fade_timer_timeout() -> void:
	if button_type == "start" :
		
		SceneLoader.swap(SceneLoader.first_scene, &"SpawnStart")
		queue_free()
	
	#elif button_type == "options" :
	#	get_tree().change_scene_to_file("res://UI/option_menu.tscn")
	
	elif button_type == "survey" :
		pass
