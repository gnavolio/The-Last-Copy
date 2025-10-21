# res://ui/ItemPreview.gd
extends Control
class_name  ItemPreview

@export var rotate_speed := 0.15  # radianti al secondo

#@onready var _subvp     = $SubViewportContainer/SubViewport
@onready var _mesh_inst = $SubViewportContainer/SubViewport/Node3D/MeshInstance3D

@export var material_silhouette : StandardMaterial3D
#@onready var _tex_rect  = $TextureRect

func show_item(res : Collectible, silhouette:bool=false):
	_mesh_inst.mesh = res.mesh
	_mesh_inst.material_override = material_silhouette if silhouette else null

	show()
	SceneLoader.player.can_move = false
	await get_tree().create_timer(5).timeout
	SceneLoader.player.can_move = true
	hide()

func show_image(texture, duration=3.0):
	var image : TextureRect = $Image
	show()
	image.show()
	image.texture = texture
	await get_tree().create_timer(duration).timeout
	image.hide()
	hide()


	
func _process(delta):
	# ruota intorno all'asse Y
	_mesh_inst.rotate_y(delta * rotate_speed * TAU)

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(func(_any):
		hide()
		SceneLoader.player.can_move = true
	)
