extends Node3D

@export var the_last_copy : PackedScene
@export var biblio_dialogue : DialogueResource
var can_talk : bool = true

func _ready() -> void:
	# Connessione al segnale dialogue_ended
	DialogueManager.dialogue_ended.connect(func(_d):
		if _d == biblio_dialogue:
			# Chiamata differita per cambiare scena in sicurezza
			call_deferred("_start_minigame")
	)

	# Definizione della funzione di interazione con la bibliotecaria
	$BibliotecariaInteraction.interact = func():
		if not can_talk:
			return
		can_talk = false
		$CharacterBody3D.talk()
		SceneLoader.player.can_move = false
		SceneLoader.player.can_animate = false
		DialogueManager.show_dialogue_balloon(biblio_dialogue, "incontro_bibliotecaria")
		

# Funzione che cambia la scena
func _start_minigame():
	SceneLoader.player.can_move = false
	SceneLoader.player.can_animate = false
	UI.song.stop()
	UI.update_quest("")
	get_tree().change_scene_to_packed(the_last_copy)
