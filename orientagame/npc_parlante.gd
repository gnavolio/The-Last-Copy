extends CharacterBody3D

@export var animations : Array[SpriteFrames] = []
@onready var sprite = $AnimatedSprite3D

func _ready() -> void:
	sprite.sprite_frames = animations.pick_random()
	sprite.play("idle")
