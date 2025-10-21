extends CharacterBody3D
var can_talk := true

func _ready() -> void:
	$AnimatedSprite3D.play("Idle")
	

func talk():
	if can_talk:
		$AnimatedSprite3D.play("Talk")
		can_talk = false
