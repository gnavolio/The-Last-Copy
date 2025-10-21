extends Control

var minigame_scene = preload("res://Scene/BookMiniGame/book_mini_game.tscn").instantiate()
var song 


func _ready() -> void:
	for i in get_parent().get_children():
		if i.name == "BookMiniGame":
			for child in i.get_children():
				if child.name == "Song":
					song = child
					song.stream_paused = true


func _on_riprova_pressed() -> void:
	song.stream_paused = false
	
	for i in get_parent().get_children():
		if i.has_method("restore"):
			i.restore()
	
	Engine.time_scale = 1
	$ButtonClick.play()
	await $ButtonClick.finished
	
	self.queue_free()


func _on_riprova_mouse_entered() -> void:
	$CanvasLayer/Scaler/BaseGround/Riprova/RiprovaLabel.hide()
	$CanvasLayer/Scaler/BaseGround/Riprova/RiprovaLabelPressed.show()
	$ButtonHover.play()


func _on_riprova_mouse_exited() -> void:
	$CanvasLayer/Scaler/BaseGround/Riprova/RiprovaLabelPressed.hide()
	$CanvasLayer/Scaler/BaseGround/Riprova/RiprovaLabel.show()
