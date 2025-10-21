@tool
extends AnimatedSprite3D
class_name NPC

@export var character : Character
var interactionArea: InteractionArea
var current_dialogue_line := 0
#var sprite : AnimatedSprite3D

#var prova = load("res://Dialogues/main.dialogue")
@export var is_walking = false
@export var dialogue_active = false
@export var backwards  : bool = false

#@export var sprite : AnimatedSprite3D
@export_tool_button("update sprite") var uf = _update_frames
func _update_frames():
	if character:
		sprite_frames = character.sprite.duplicate()
	

func _ready():
	var ia := InteractionArea.new()
	interactionArea = ia
	add_child(ia)
	_update_frames()
	if Engine.is_editor_hint():
		return
	DialogueManager.dialogue_started.connect(
		func(_any): 
			interactionArea.monitoring = false 
	)
	DialogueManager.dialogue_ended.connect(
		func(_any): 
			if character.dialogue_cycle == 0 or character.dialogues.size() > current_dialogue_line:
				interactionArea.monitoring = true
	)


func _on_interact():
	var dialogue = _next_dialogue()
	if dialogue:
		DialogueManager.show_dialogue_balloon(dialogue, "start")


func _next_dialogue() -> DialogueResource:
	var d = null
	if character.dialogue_cycle == 0:
		d = character.dialogues.pick_random()
	elif character.dialogues.size() > current_dialogue_line:
		d = character.dialogues[current_dialogue_line]
		current_dialogue_line +=1
	return d


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if not is_walking and animation != 'idle':
		play(&"idle")
		return
	if get_parent() is not PathFollow3D:
		return
	var curr_animation : String = "move_"
	var thresholds = [45,135,225,315]
	#var directions = {45:'down', 135:'left', 225:'up', 315:'right'}
	var directions = ['down', 'left', 'up', 'right']
	var backwards_directions = ['up', 'right', 'down', 'left']

	for i in range(4):
		if abs(get_parent().rotation_degrees.y) <= thresholds[i]:
			curr_animation += backwards_directions[i] if backwards else directions[i]
			#print(get_parent().rotation_degrees.y)
			break
	if animation != curr_animation:
		play(curr_animation)


static func create(_character : Character) -> NPC:
	#npc.sprite.sprite_frames.resource_local_to_scene = true

	var npc = NPC.new()
	npc.character = _character.duplicate()	
	#npc.sprite_frames = _character.sprite
	npc.pixel_size = 0.034
	npc.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	npc.shaded = true
	npc.alpha_scissor_threshold = 0
	npc.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	return npc

#static func build_animated_sprite(_character : Character) -> AnimatedSprite3D:
	#var s = AnimatedSprite3D.new()
	#s.sprite_frames = _character.sprite
	#s.pixel_size = 0.05
	#s.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	#s.shaded = true
	#s.alpha_scissor_threshold = 0
	#s.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	#return s
