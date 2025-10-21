extends Node3D

func _ready() -> void:
	$InteractionArea.interact = func():
		UI.item_preview.show_image(load("res://Oggetti/Alberto/foglia.png"))
