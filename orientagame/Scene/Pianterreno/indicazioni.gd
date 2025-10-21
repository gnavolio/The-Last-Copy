extends Node3D

@export var image: CompressedTexture2D

func _ready() -> void:
	$InteractionArea.interact = func():
		UI.item_preview.show_image(image, 3)
