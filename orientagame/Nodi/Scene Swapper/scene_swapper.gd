#@tool
extends Node3D
class_name SceneSwapper

@export_enum("DIB", "giardini", "retro" ) var target_scene_name : String
@export var target_spawner : StringName
var target_scene : PackedScene
@onready var freccia := $Freccia
@export_enum("up:110", "down:70") var direzione: 
	set(v):
		direzione = v
		if freccia:
			freccia.rotation_degrees.x = direzione
var teleporting = false
#todo animare sprite freccina

func _ready() -> void:
	if target_scene_name:
		target_scene = Settingss.collegamenti[target_scene_name]
	freccia.rotation_degrees.x = direzione
	if not Engine.is_editor_hint():
		freccia.hide()

func _on_area_freccia_body_entered(body: Node3D) -> void:
	if body is Player:
		freccia.visible = true


func _on_area_freccia_body_exited(body: Node3D) -> void:
	if body is Player:
		freccia.visible = false


func _on_area_teletrasporto_body_entered(body: Node3D) -> void:
	if body is Player and not teleporting:
		teleporting = true
		if target_scene:
			SceneLoader.swap(target_scene, target_spawner)
