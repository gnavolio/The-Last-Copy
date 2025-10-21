extends Node3D

@export var npc_dialogue : DialogueResource
@onready var npc = $NPCParlante
var can_talk : bool = true

func _ready() -> void:
	# Connessione al segnale dialogue_ended
	DialogueManager.dialogue_ended.connect(func(_d):
		if _d == npc_dialogue:
			SceneLoader.player.can_move = true
			SceneLoader.player.can_animate = true
			can_talk = true
	)
	
	$NPCInteraction.interact = func():
		if not can_talk:
			return
		can_talk = false
		SceneLoader.player.can_move = false
		SceneLoader.player.can_animate = false
		DialogueManager.show_dialogue_balloon(npc_dialogue, "studentLines")
