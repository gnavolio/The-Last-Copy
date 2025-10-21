extends Node

@export var first_scene : PackedScene
@onready var current_scene = $CurrentScene
@onready var player : Player= $Player


func _ready() -> void:
	# Se esiste già un'altra istanza attiva (cioè non sono "me stesso" nel singleton)
	if SceneLoader != self:
		print("⚠️ Duplicate. destroying this one:", self.name)
		queue_free()
	#await get_tree().process_frame
	#swap(first_scene, &"SpawnStart")


func swap(destination: PackedScene, spawner_name:StringName) -> void:
	if not destination:
		push_error("Scena inesistente")
		return
	#player.can_move = false
	UI.show_black_screen()
	# elimina scena vecchia
	for c in current_scene.get_children():
		c.queue_free()
	
	# piazza scena nuova
	var new_scene = destination.instantiate()
	current_scene.add_child(new_scene)
	player.camera_reset()
	
	# Spawna
	var spawner = get_spawn(spawner_name)
	if spawner: 
		player.position = spawner.global_position
	else:
		push_error("Spawner non trovato in ", current_scene.name) 
	print("swap to ", destination)
	
	await UI.hide_black_screen()
	#player.can_move = true


func get_spawn(spawner_name:StringName) -> Marker3D:
	for d in get_tree().get_nodes_in_group("spawn"):
		if d.name == spawner_name:
			return d
	return null


func get_camera() -> Camera3D:
	for c in player.get_children():
		if c is Camera3D:
			return c
	push_error("Camera not found in scene")
	return null
