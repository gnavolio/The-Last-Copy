extends Node

#@export var npc_scene: PackedScene
@export var speed: float = 2
#@export var sprites: Array[SpriteFrames]
@export var characters: Array[Character]
#var _sprites : Array[SpriteFrames]
var _characters : Array[Character]
var selected = true
@export var repeat_characters:=false

func _ready() -> void:
	#return
	_characters = characters.duplicate()
	await get_tree().process_frame
	for p in get_children():
		if p is not Path3D: continue
		if _characters.size() == 0:
			if repeat_characters:
				_characters = characters.duplicate()
			else:
				push_warning("Tutti gli sprite sono stati usati, fermo la generazione")
				return
		
		var character = _characters.pop_at(randi_range(0, _characters.size()-1))
		var npc := NPC.create(character) 
		var follow := PathFollow3D.new()
		follow.use_model_front = true
		follow.tilt_enabled = false
		follow.rotation_mode = PathFollow3D.ROTATION_ORIENTED
		p.add_child(follow)
		follow.add_child(npc)
		follow.progress_ratio = randf()
		npc.is_walking = true
		#npc.sprite.frame = randi() % 4 

		var duration = p.curve.get_baked_length() / speed
		start_walking(follow, duration, npc)


func start_walking(path: PathFollow3D, duration: float, npc:NPC):
	var tween := get_tree().create_tween().set_loops()
	tween.step_finished.connect(func(_count):
		if npc:
			npc.backwards = !npc.backwards
	)
	tween.tween_property(path, "progress_ratio", 1, duration)
	tween.tween_property(path, "progress_ratio", 0, duration)
	child_exiting_tree.connect(tween.stop)
