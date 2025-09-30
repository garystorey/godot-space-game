extends Node2D

@onready var score_timer: Timer = %ScoreTimer
@onready var round_timer: Timer = %RoundTimer
@onready var score_text: Label = %ScoreText
@onready var round_text: Label = %RoundText


@export var number_asteroids = 0
@export var max_scale = 0.2
@export var points_per_sec =100

@export var MAX_ASTEROIDS = 10
@export var MAX_MASS = 300
@export var MIN_MASS = 25

var rng = RandomNumberGenerator.new()

var asteroid_scene = preload("res://asteroid.tscn")

func _ready() -> void:
	score_timer.timeout.connect(_on_score_timer_timeout)
	round_timer.timeout.connect(_on_round_timer_timeout)
	round_text.text = str(1)
	score_text.text = str(0)


func _physics_process(_delta: float) -> void:
	var should_spawn_asteroid = rng.randi_range(0, 100)
	if should_spawn_asteroid >=99 and number_asteroids< MAX_ASTEROIDS:
		number_asteroids +=1
		create_asteroid()
	
func create_asteroid():
		var new_asteroid = asteroid_scene.instantiate();
		var x = randf_range(80,980)
		var new_scale = randf_range(0.05, max_scale)
		
		new_asteroid.position = Vector2(x,-50)
		#new_asteroid.position.y = -50
		new_asteroid.get_child(0).scale = Vector2(new_scale,new_scale)
		#new_asteroid.get_child(0).scale.y = new_scale
		new_asteroid.scale =  Vector2(new_scale,new_scale)
		#new_asteroid.scale.y = new_scale
		new_asteroid.mass = 200 * new_scale
		new_asteroid.gravity_scale = randf_range(0.1,1.3) * new_scale
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
	level += 1
	round_text.text = str(level)
	
