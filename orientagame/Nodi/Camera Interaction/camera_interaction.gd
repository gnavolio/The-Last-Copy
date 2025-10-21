extends Area3D

@export var target_rotation_degrees : Vector3
@export var target_position : Vector3
@export var duration_in: float = 0.5
@export var duration_out: float = 0.5
@onready var camera: Camera3D = SceneLoader.get_camera()
@export var disactivate_on_leave: bool = false
var enabled = true

func _on_body_entered(body: Node3D) -> void:
	if enabled and body is Player:
		camera.move_focus(target_position, target_rotation_degrees, duration_in)


func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		camera.move_focus(Vector3.ZERO, Vector3.ZERO, duration_out)
		if disactivate_on_leave:
			enabled = false
			
