extends Node2D

@onready var score_timer: Timer = %ScoreTimer
@onready var round_timer: Timer = %RoundTimer
@onready var round_display_timer: Timer = %RoundDisplayTimer
@onready var sfx: AudioStreamPlayer2D = %Sfx

@onready var score_text: Label = %ScoreText
@onready var round_text: Label = %RoundText
@onready var round_display: Label = %RoundDisplay

@onready var player: Area2D = %Player

@export var number_asteroids = 0
@export var max_scale = 0.2
@export var points_per_sec = 50

@export var MAX_ASTEROIDS = 5
@export var MAX_MASS = 250
@export var MIN_MASS = 50

var rng = RandomNumberGenerator.new()

var asteroid_scene = preload("res://asteroid.tscn")
const level_sfx = preload("uid://c25wdaajvcfhs")
var start = preload("uid://c7cdxgg7tixdy").instantiate()


func _ready() -> void:
	score_timer.timeout.connect(_on_score_timer_timeout)
	round_timer.timeout.connect(_on_round_timer_timeout)
	player.connect("dead", _on_dead)
	round_text.text = str(0)
	score_text.text = str(0)
	_on_round_timer_timeout()

func _on_dead():
	round_timer.stop()
	score_timer.stop()
	for asteroid in get_tree().get_nodes_in_group("Asteroids"):
		asteroid.queue_free()
	get_tree().root.add_child(start)
	queue_free()

func _physics_process(_delta: float) -> void:
	var should_spawn_asteroid = rng.randi_range(0, 100)
	if should_spawn_asteroid >=80 and number_asteroids< MAX_ASTEROIDS:
		number_asteroids +=1
		create_asteroid()
	
func create_asteroid():
		var new_asteroid = asteroid_scene.instantiate();
		var x = randf_range(0,1100)
		var new_scale = randf_range(0.05, max_scale)
		
		new_asteroid.position = Vector2(x,-250)
		new_asteroid.get_child(0).scale = Vector2(new_scale,new_scale)
		new_asteroid.scale =  Vector2(new_scale,new_scale)
		new_asteroid.mass = 200 * new_scale
		new_asteroid.gravity_scale = randf_range(0.1,1.3) * new_scale
		new_asteroid.linear_velocity.x = randf_range(-180, 180)
		new_asteroid.add_to_group("Asteroids")
		add_child(new_asteroid)
		new_asteroid.asteroid_removed.connect(_on_child_asteroid_removed)
	
func _on_child_asteroid_removed():
	number_asteroids -=1

func _on_score_timer_timeout():
	var score = int(score_text.text)
	score += randi_range(1,20)
	score_text.text = str(score)
	
func _on_round_timer_timeout():
	MAX_ASTEROIDS += 5
	points_per_sec += 50
	max_scale += 0.05
	var level = int(round_text.text)
	sfx.stream = level_sfx
	sfx.play()
	level += 1
	round_text.text = str(level)
	round_display_timer.start()
	round_display_timer.timeout.connect(_on_display_timeout)
	round_display.visible = true
	round_display.text = "Level "+str(level)
	

func _on_display_timeout():
	round_display.visible = false
	
