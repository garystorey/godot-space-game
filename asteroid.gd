extends RigidBody2D

signal asteroid_removed()

func _physics_process(delta: float) -> void:
	get_child(0).rotate(.5 * delta)
	if position.y >= 600: 
		emit_signal("asteroid_removed")
		queue_free()
