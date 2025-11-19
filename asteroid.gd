extends RigidBody2D

signal asteroid_removed

@onready var sprite: Node2D = $Sprite2D

func _physics_process(delta: float) -> void:
	sprite.rotate(0.5 * delta)
	if global_position.y >= 600.0:
		asteroid_removed.emit()
		queue_free()
