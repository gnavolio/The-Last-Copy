extends Control

@onready var song = $Song

@onready var item_preview: ItemPreview = $Scaler/ItemPreview
@onready var joystick = $Scaler/Joystick
@onready var interaction_button = $Scaler/InteractionButton
@export var black_screen :Panel
var openmenu: bool = false

func _tween_black_screen(do_show, duration:float=1) -> void:
	#var duration :float = 1 
	var t:= create_tween()
	var target_modulate = Color(1,1,1,int(do_show))
	t.tween_property(black_screen, "modulate", target_modulate, duration)
	await  t.finished


func show_black_screen(duration:float=1) -> void:
	await _tween_black_screen(true, duration)


func hide_black_screen(duration:float=1) -> void:
	await _tween_black_screen(false, duration)
	

func update_quest(new_quest):
	$Scaler/CurrentQuest.text = new_quest


func _on_interaction_button_pressed() -> void:
	#Input.action_press("Interact")
	#get_tree().create_timer(0.2)
	#Input.action_release("Interact")
	InteractionManager.do_interact.call()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_menu"):
		_on_pause_button_pressed()
	#else:
		#print(event.as_text())


func _on_pause_button_pressed() -> void:
	if openmenu == false:
		var inst = preload("res://UI/pause_menu.tscn").instantiate()
		inst.name = "PauseMenu"
		if inst.has_method("set_previous_scene"):
			inst.set_previous_scene("res://UI/global_ui.gd")
		get_parent().add_child(inst)
		# NON nascondere il parent, altrimenti si nasconde anche il menu
		# get_parent().hide()
		hide()                     # nascondi solo questa UI, non il parent
		pause(true)                # metti in pausa (senza queue_free)
		openmenu = true
	else:
		var inst = get_parent().get_node_or_null("PauseMenu")
		if inst:
			inst.queue_free()      # chiude il menu
		show()                     # ri-mostra questa UI
		pause(false)               # togli la pausa
		openmenu = false


func pause(enable : bool):
	Engine.time_scale = 0 if enable else 1
	
	#get_parent().add_child(pause_scene)
	#get_parent().hide()
	
func _ready() -> void:
	set_joystick(false)
	song.play()


func set_joystick (enabled : bool) :
	enabled = false
	joystick.visible = enabled
	joystick.mouse_filter = MouseFilter.MOUSE_FILTER_STOP if enabled else MouseFilter.MOUSE_FILTER_IGNORE 
