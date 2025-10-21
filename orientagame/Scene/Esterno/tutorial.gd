extends Node


@onready var mentore : NPC = $"Antonio"
@onready var verso_inizio : Path3D = $PercorsoMentore
@onready var verso_dib : Path3D = $Percorso101
#@onready var player : Player = SceneLoader.player

var player
var dialogo =load("res://Dialogues/tuttorial.dialogue")
var ended_correctly := false

func _on_tutorial_end_enters(body):
	if body is Player:
		ended_correctly = true

func _ready() -> void:
	return
	await get_tree().process_frame
	if SaveFile.tutorial_done:
		return
	#print("dada")
	UI.update_quest("Raggiungi il campus")
	player = SceneLoader.player
	player.can_move = false
	player.can_animate = false
	DialogueManager.dialogue_ended.connect(func(dialogue):
		if dialogue == dialogo:
			player.can_move = true
			player.can_animate = true
			player.reparent(SceneLoader)
			#if not ended_correctly:
				#DialogueManager.show_dialogue_balloon(dialogo, "scacciato")
				#ended_correctly = true
			UI.update_quest("Trova la bibliotecaria")
			player.camera_reset()
			player.rotation.y=0
			Savefile.tutorial_done = true
		)
	# aspetta che finisca di percorrere
	mentore.is_walking = true
	#await walk_path(mentore, verso_inizio, 3)
	await walk_path(mentore, verso_inizio, 3)
	mentore.is_walking = false
	#avvia dialogo
	DialogueManager.show_dialogue_balloon(dialogo, "start")
	# aspetta che il mentore pronunzi le prime frasi
	await get_tree().create_timer(5).timeout
	
	# partite entrambi verso il dib
	mentore.is_walking = true
	mentore.backwards = true
	#walk_path(mentore, verso_dib, 15)
	walk_path(mentore, verso_dib, 15)

	
	await get_tree().create_timer(0.5).timeout #tu con un poco di ritardo
	player.last_action = 'move'
	player.last_direction = 'up'
	player.sprite.play("move_up") #e con l'animazione della camminata
	await walk_path(player,  verso_dib, 15)
	var t := create_tween()
	t.tween_property(player, "rotation_degrees/y", 0, 0.5)
	#await DialogueManager.show_dialogue_balloon(dialogo, "parte2")
	player.last_action = 'idle'
	#player.camera_reset()
	Savefile.tutorial_done = true
	

	
#func walk_path(character:Node, path : Path3D, duration=5):
	#var follow = PathFollow3D.new()
	#path.add_child(follow)
	#character.reparent(follow)
	#var tween := get_tree().create_tween()
	#tween.tween_property(follow, "progress_ratio", 1, duration)
#
	#await tween.finished
	#print("ho spostato ", character.name)
	#if character is Player:
		#character.reparent(SceneLoader)
		#follow.rotation_mode = PathFollow3D.ROTATION_NONE
	#else:
		#character.reparent(get_parent())

func walk_path(character: Node, path: Path3D, duration := 5) -> void:
	var follow := PathFollow3D.new()
	path.add_child(follow)
	character.reparent(follow)

	var tween := get_tree().create_tween()
	tween.tween_property(follow, "progress_ratio", 1, duration)

	await tween.finished

	# QUI: camminata finita → resetta flag
	if "is_walking" in character:
		character.is_walking = false

	print("ho spostato ", character.name)
	if character is Player:
		character.reparent(SceneLoader)
		follow.rotation_mode = PathFollow3D.ROTATION_NONE
	else:
		character.reparent(get_parent())
		
