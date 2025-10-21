#@tool
extends Resource
class_name Character
@export var dialogues : Array[DialogueResource]
@export_enum('sequence',  'random') var dialogue_cycle : int = 1
@export var name : String
#var _sprite : SpriteFrames
@export var sprite : SpriteFrames#:
	#get: return _sprite
	#set(v):
		#if _sprite == v: 
			#return
		#_sprite = v
		#emit_changed()
