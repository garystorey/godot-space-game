extends Node2D

@onready var score_timer: Timer = %ScoreTimer
@onready var round_timer: Timer = %RoundTimer
@onready var round_display_timer: Timer = %RoundDisplayTimer
@onready var sfx: AudioStreamPlayer2D = %Sfx

@onready var score_text: Label = %ScoreText
@onready var round_text: Label = %RoundText
@onready var round_display: Label = %RoundDisplay

@onready var player: Area2D = %Player

@export var max_scale: float = 0.2
@export var points_per_sec: int = 50
@export var max_asteroids: int = 5

var number_asteroids: int = 0

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

const ASTEROID_SCENE: PackedScene = preload("res://asteroid.tscn")
const LEVEL_SFX: AudioStream = preload("uid://c25wdaajvcfhs")

func _ready() -> void:
	rng.randomize()

	score_timer.timeout.connect(_on_score_timer_timeout)
	round_timer.timeout.connect(_on_round_timer_timeout)
	round_display_timer.timeout.connect(_on_display_timeout)
	player.dead.connect(_on_dead)
	print('firing sound in ready')
	sfx.stream = LEVEL_SFX
	round_text.text = str(0)
	score_text.text = str(0)

	_on_round_timer_timeout()

func _on_dead() -> void:
	round_timer.stop()
	score_timer.stop()

	for asteroid in get_tree().get_nodes_in_group("Asteroids"):
		asteroid.queue_free()

	get_tree().change_scene_to_file("res://start.tscn")
	queue_free()

func _physics_process(_delta: float) -> void:
	var should_spawn_asteroid := rng.randi_range(0, 100)
	if should_spawn_asteroid >= 80 and number_asteroids < max_asteroids:
		create_asteroid()

func create_asteroid() -> void:
	var new_asteroid: RigidBody2D = ASTEROID_SCENE.instantiate()
	var spawn_x := rng.randf_range(0.0, 1100.0)
	var new_scale := rng.randf_range(0.05, max_scale)

	new_asteroid.position = Vector2(spawn_x, -250.0)

	var sprite := new_asteroid.get_node("Sprite2D") as Sprite2D
	if sprite:
		sprite.scale = Vector2(new_scale, new_scale)

	var collision_shape := new_asteroid.get_node("CollisionShape2D") as CollisionShape2D
	if collision_shape and collision_shape.shape is CircleShape2D:
		var shape := (collision_shape.shape as CircleShape2D).duplicate() as CircleShape2D
		shape.radius *= new_scale
		collision_shape.shape = shape
	new_asteroid.mass = 200.0 * new_scale
	new_asteroid.gravity_scale = rng.randf_range(0.1, 1.3) * new_scale
	new_asteroid.linear_velocity.x = rng.randf_range(-180.0, 180.0)
	new_asteroid.add_to_group("Asteroids")
	new_asteroid.asteroid_removed.connect(_on_child_asteroid_removed)

	add_child(new_asteroid)
	number_asteroids += 1

func _on_child_asteroid_removed() -> void:
	number_asteroids = maxi(number_asteroids - 1, 0)

func _on_score_timer_timeout() -> void:
	var score := int(score_text.text)
	score += rng.randi_range(1, 20)
	score_text.text = str(score)

func _on_round_timer_timeout() -> void:
	max_asteroids += 5
	points_per_sec += 50
	max_scale += 0.05

	var level := int(round_text.text)
	print('firing sound in _on_round_timer_timoeout')
	sfx.play()

	level += 1
	round_text.text = str(level)

	round_display_timer.start()
	round_display.visible = true
	round_display.text = "Level " + str(level)

func _on_display_timeout() -> void:
	round_display.visible = false
	
