extends Control

var previous_scene_path: String
var song

func set_previous_scene(path: String) -> void:
	previous_scene_path = path

func _ready() -> void:
	#pause(true)
	Engine.time_scale = 0
	for i in get_parent().get_children():
		if i.has_method("set_joystick"):
			i.set_joystick(false)
	
	for child in get_parent().get_children():
		if child.name == "Song":
			song = child
			song.stream_paused = true

func pause(enable: bool):
	Engine.time_scale = 0 if enable else 1
	if enable:
		self.show()
	else:
		self.hide()
	

func _on_resume_pressed() -> void:
	$ButtonClick.play()
	
	#for i in get_parent().get_children():
		#if i.has_method("set_joystick"):
			#i.set_joystick(true)
	
	await $ButtonClick.finished
	song.stream_paused = false
	Engine.time_scale = 1
	self.queue_free()

func _on_exit_pressed() -> void:
	$ButtonClick.play()
	await $ButtonClick.finished
	get_tree().quit()
	

func _on_gear_pressed() -> void:
	var option_scene = preload("res://UI/option_menu.tscn").instantiate()
	option_scene.set_previous_scene("res://Scene/BookMiniGame/UI/pause_menu_minigame.tscn")  # passiamo il menu di pausa
	get_parent().add_child(option_scene)
	self.hide()

# Hover effetti
func _on_resume_mouse_entered() -> void:
	$CanvasLayer/Scaler/BaseGround/Resume/ResumeLabel.hide()
	$CanvasLayer/Scaler/BaseGround/Resume/ResumeLabelPressed.show()
	$ButtonHover.play()

func _on_resume_mouse_exited() -> void:
	$CanvasLayer/Scaler/BaseGround/Resume/ResumeLabelPressed.hide()
	$CanvasLayer/Scaler/BaseGround/Resume/ResumeLabel.show()

func _on_exit_mouse_entered() -> void:
	$CanvasLayer/Scaler/BaseGround/Exit/ExitLabel.hide()
	$CanvasLayer/Scaler/BaseGround/Exit/ExitLabelPressed.show()
	$ButtonHover.play()

func _on_exit_mouse_exited() -> void:
	$CanvasLayer/Scaler/BaseGround/Exit/ExitLabelPressed.hide()
	$CanvasLayer/Scaler/BaseGround/Exit/ExitLabel.show()
