extends Control

@onready var start = %Button
var game = preload("uid://b3vu7mn112co7").instantiate()

func _ready():
	start.connect("button_up", _start_game)
	
func _start_game():
	get_tree().root.add_child(game)
	queue_free()

	
