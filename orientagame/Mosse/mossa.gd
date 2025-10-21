@tool
extends Resource
class_name Mossa

@export var name : String
@export_multiline var expression:String = ""
var inputs:Array[String] = ["agent", "target"]
var agent : Actor
var target : Actor
var dlog : DialogueResource = preload("res://Dialogues/Battle/battle.dialogue")

const CONFUSION_DMG := 10
var _expr:Expression

func _ensure() -> bool:
	if _expr == null:
		_expr = Expression.new()
		var err := _expr.parse(expression, inputs)
		if err != OK:
			push_error("Expression parse error: %s" % _expr.get_error_text())
			return false
	return true



func do() -> Actor:
	#handle confusione
	if agent.is_confused :
		# uso savefile solo per avere una variabile d'ambiente
		SaveFile.combat_current_agent = agent.real_name
		DialogueManager.show_dialogue_balloon(dlog, "confused")
		await DialogueManager.dialogue_ended
		#(agent.real_name è confuso!)
		if  randi_range(0,1) == 0:
			agent.take_damage(CONFUSION_DMG)
			DialogueManager.show_dialogue_balloon(dlog, "confusion")
			await DialogueManager.dialogue_ended
			#(agent.real_name è così confuso da colpirsi da solo!)
			if agent.hp <= 0:
				return target
			return null
		agent.is_confused = false

	DialogueManager.show_dialogue_balloon(dlog, name.replace(" ", '_').to_lower())

	_exec([agent, target])
	await DialogueManager.dialogue_ended

	if agent.remaining_damage > 0:
		agent.take_damage(agent.remaining_damage)
		agent.remaining_damage = 0

	if target.hp <= 0:
		return agent

	return null

func _exec(args:Array, base:Variant = null) -> Variant:
  # NOTE: base permette di esporre funzioni helper all'espressione (vedi Mossa).
	if not _ensure():
		return null
	return _expr.execute(args, base, true)
