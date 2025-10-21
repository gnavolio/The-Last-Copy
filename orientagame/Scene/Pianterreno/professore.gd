extends Node3D

@export var prof_dialogue : DialogueResource
var can_talk : bool = true

func _ready() -> void:
	# Connessione al segnale dialogue_ended
	DialogueManager.dialogue_ended.connect(func(_d):
		if _d == prof_dialogue:
			SceneLoader.player.can_move = true
			SceneLoader.player.can_animate = true
			can_talk = true
	)
	
	$ProfessoreInteraction.interact = func():
		if not can_talk:
			return
		can_talk = false
		SceneLoader.player.can_move = false
		SceneLoader.player.can_animate = false
		DialogueManager.show_dialogue_balloon(prof_dialogue, "professorLine")
