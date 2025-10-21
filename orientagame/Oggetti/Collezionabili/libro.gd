extends Node3D

@export var schermata_conclusiva : PackedScene

var interacted : bool = false

func _process(delta: float) -> void:
	rotation.y -= delta



func _on_timer_timeout() -> void:
	if schermata_conclusiva != null:
		get_tree().change_scene_to_packed(schermata_conclusiva)
	else:
		push_error("Errore: la scena 'schermata_conclusiva' non è assegnata!")
