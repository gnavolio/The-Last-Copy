extends Control

func _ready() -> void:
	Engine.time_scale = 0
	var minigame_node = get_parent().get_children()
	minigame_node[0].queue_free()
	minigame_node[1].queue_free()


func _on_continua_pressed() -> void:
	Engine.time_scale = 1
	$ButtonClick.play()
	await $ButtonClick.finished
	
	# Carica la scena come PackedScene
	var scena_collezionabile : PackedScene = preload("res://Scene/BookMiniGame/raccolta_libro.tscn")
	
	# Cambia scena
	get_tree().change_scene_to_packed(scena_collezionabile)
	
	# Rimuovi il menu corrente in sicurezza (opzionale, di solito non serve perché la scena viene cambiata)
	call_deferred("queue_free")

	
	

func _on_continua_mouse_entered() -> void:
	$CanvasLayer/Scaler/BaseGround/Continua/ContinuaLabel.hide()
	$CanvasLayer/Scaler/BaseGround/Continua/ContinuaLabelPressed.show()
	$ButtonHover.play()


func _on_continua_mouse_exited() -> void:
	$CanvasLayer/Scaler/BaseGround/Continua/ContinuaLabelPressed.hide()
	$CanvasLayer/Scaler/BaseGround/Continua/ContinuaLabel.show()
