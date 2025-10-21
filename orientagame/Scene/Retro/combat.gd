extends Node

#@export var playerActor : Actor
#@export var segretariaActor : Actor
#@export var playerBar : ProgressBar
#@export var segretariaBar : ProgressBar
#var dlog : Resource = load("res://Dialogues/Battle/battle.dialogue")
@export var combat_GUI : CanvasLayer
var can_act : bool = false
@export var combat_dialogue : DialogueResource
@export var post_combat_dialogue : DialogueResource
var timbro_inizio : Collectible = preload("res://Oggetti/Collezionabili/resources/TimbroInizio.tres")

@onready var interaction := $CameraInteraction
#@onready var player_sprite = $CanvasLayer/Control/HSplitContainer/Control/Player
@onready var segretaria = {
	"sprite" : $CanvasLayer/Control/HSplitContainer/Control/Segretaria,
	"bar" : $CanvasLayer/Control/HSplitContainer/Control/ProgressBarSegretaria,
	"actor" : $SegretariaActor,
	"heal" : $CanvasLayer/Control/HSplitContainer/Control/SegretariaHeal,
	"damage" : $CanvasLayer/Control/HSplitContainer/Control/SegretariaDamage
}

@onready var player = {
	"sprite" : $CanvasLayer/Control/HSplitContainer/Control/Player,
	"bar" : $CanvasLayer/Control/HSplitContainer/Control/ProgressBarPlayer,
	"actor" : $PlayerActor,
	"heal" : $CanvasLayer/Control/HSplitContainer/Control/PlayerHeal,
	"damage" : $CanvasLayer/Control/HSplitContainer/Control/PlayerDamage
}



	

func set_combat_GUI():
	var movepool := $CanvasLayer/Control/HSplitContainer/MovePool
	var i := 0
	for c in movepool.get_children():
		if c is Button:
			c.text = player['actor'].mosse[i].name
			c.button_up.connect(func():
				if can_act:
					can_act = false
					var winner: Actor = await turno(player['actor'].mosse[i])
					# nascondi i pulsanti
					if winner:
						print(winner.name, " ha vinto!")
					)
			i += 1


func turno(playerMossa : Mossa):
	var playerPriority : bool
	var segretariaMossa : Mossa = segretaria['actor'].mosse.pick_random()
	playerMossa.agent = player['actor']
	playerMossa.target = segretaria['actor']
	segretariaMossa.agent = segretaria['actor']
	segretariaMossa.target = player['actor']
	print("eseguo   pla:", playerMossa.name, "     seg:",segretariaMossa.name)

	if segretariaMossa.name == 'filecorrotto':
		playerPriority = false
	elif player['actor'].temp_priority:
		playerPriority = true
		player['actor'].temp_priority = false
	else:
		playerPriority = bool(randi_range(0,1))
	
	var iniziativa = [1,0] if playerPriority else [0,1]
	for i in iniziativa:
		var winner = await [segretariaMossa, playerMossa][i].do()
		if winner: 
			await end_combat(winner)
		#await get_tree().create_timer(3).timeout
	can_act = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("end_combat"):
		await end_combat(null)

func start_battle():
	SceneLoader.player.can_move = false
	await UI.show_black_screen(0.2)
	combat_GUI.show()
	set_combat_GUI()
	can_act = true


func end_combat(_winner) : 
	combat_GUI.hide()
	can_act = false
	$Antonio.show()
	await UI.hide_black_screen()
	
	DialogueManager.show_dialogue_balloon(combat_dialogue, "combat_end")
	await DialogueManager.dialogue_ended
	await get_tree().create_timer(1).timeout
	$TimbroInizio._on_interact()
	await get_tree().create_timer(2).timeout
	
	# sposta telecamera su Antonio
	interaction._on_body_entered(SceneLoader.player)
	DialogueManager.show_dialogue_balloon(post_combat_dialogue, "antonio_post_combat")
	await DialogueManager.dialogue_ended
	UI.update_quest("Raggiungi la Biblioteca")
	interaction._on_body_exited(SceneLoader.player)
	SceneLoader.player.can_move = true
	
	#$Antonio.interactionArea.interact = DialogueManager.show_dialogue_balloon(post_combat_dialogue, "antonio_repeat")
	

 
func _ready() -> void:
	### DEBUG
	#end_combat(null)
	#return
	player['actor'].real_name = SceneLoader.player.alias
	player['actor'].damaged.connect(displayDamage.bind(player))
	player['actor'].healed.connect(displayDamage.bind(player, 'heal'))
	segretaria['actor'].real_name = "Segretaria"
	segretaria['actor'].damaged.connect(displayDamage.bind(segretaria))
	segretaria['actor'].healed.connect(displayDamage.bind(segretaria,'heal'))
	#return
	combat_GUI.hide()


func displayDamage(damage, actor_dict, heal_or_damage:String="damage"):
	var actor = actor_dict["actor"]
	var damage_label : Label = actor_dict[heal_or_damage]
	var tween = create_tween()
	damage_label.text = str(damage)
	damage_label.show()
	if heal_or_damage == "damage":
		actor.blink_animation()
	else:
		actor.heal_animation()
	
	tween.tween_property(actor_dict['bar'], "value", actor.hp, 0.5)
	await tween.finished
	await get_tree().create_timer(0.5).timeout
	damage_label.hide()



#STUDENTE 
# mail confusa   : CONFUSIONE(segretaria) + 10 DANNI(segretaria)
  # confondi la segretaria con parole poco argute
# allega JPEG    : 15 DANNI(segretaria)
  # sai benissimo che devi mettere un pdf
# Bevi caffè     : -30 DANNI(player) & COLPISCI PER PRIMO
  # curati e affronta la giornata
# Compila modulo : MINIGIOCO [5-30] DANNI(segretaria)
  # prova a centrare ogni risposta

#SEGRETARIA
# modulo mancante : 15 DANNI(player) + 5 DANNI(player) DOPO
# indovinello : CONFUSIONE(segretaria) | 20 DANNI(player)
# file corrotto : PROTEZIONE(segretaria) + caratteri corrotti
# monologo incomprensibile : 20 DANNI(player) + CONFUSIONE(player)
