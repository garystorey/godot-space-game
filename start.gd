extends Control

@onready var start_button: Button = %Button

const GAME_SCENE: PackedScene = preload("uid://b3vu7mn112co7")

func _ready() -> void:
    start_button.button_up.connect(_start_game)

func _start_game() -> void:
    var game: Node = GAME_SCENE.instantiate()
    get_tree().root.add_child(game)
    queue_free()

	
