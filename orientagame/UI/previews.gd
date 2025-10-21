extends Control


@export var rotate_speed := 10
@onready var previews := {
	"Gameboy" : $Gameboy,
	"ComputerVecchio" : $OldPC,
	"Timbro dell'inizio" : $Timbro,
	"Appunti del mentore" : $Appunti,
}
@onready var mesh_istances = [
	$Gameboy/SubViewport/Node3D/MeshInstance3D,
	$Appunti/SubViewport/Node3D/MeshInstance3D,
	$OldPC/SubViewport/Node3D/MeshInstance3D,
	$Timbro/SubViewport/Node3D/MeshInstance3D
]

@export var silhouette : StandardMaterial3D

func _ready() -> void:
	print(Savefile.collectibles_discovered)

func update_visibilities() -> void:
	#for preview in get_children():
	for item in previews:
		var node = previews[item]
		get_mesh_instance(node).material_override = null if SaveFile.collectibles_discovered[item] else silhouette


func _process(_delta):
	# ruota intorno all'asse Y
	update_visibilities()
	for mesh in mesh_istances:
		mesh.rotation_degrees.y += 0.01 * rotate_speed * TAU

func get_mesh_instance(node:Node) -> MeshInstance3D:
	return node.get_child(0).get_child(0).get_child(0)
		
