extends Node3D

@export var combat : Node
@export var combat_dialogue : DialogueResource
var has_fought : bool = false
var can_talk : bool = true


func _ready() -> void:
	DialogueManager.dialogue_ended.connect(func(_d):
		if not has_fought and _d == combat_dialogue:
			has_fought = true
			combat.start_battle()
			can_talk = true
	)
	$PortaSegreteria.interact = func():
		if not can_talk: return
		can_talk = false
		if not has_fought:
			DialogueManager.show_dialogue_balloon(combat_dialogue, "combat_start")
		else:
			DialogueManager.show_dialogue_balloon(combat_dialogue, "already_defeated")


			
		
		#var dial =  load("res://Dialogues/Battle/battle.dialogue") as  DialogueResource
		#print(dial.titles)
		#DialogueManager.show_dialogue_balloon(dial, "confused")
		#queue_free()
		#var line = await DialogueManager.get_next_dialogue_line(dial, "confused")
		#if line:
			#print("Testo linea:", line.text)
		#else:
			#print("Linea non trovata o vuota.")
		#DialogueManager.dialogue_ended.connect(func():
			#print("Dialogo finito!")
		#)
