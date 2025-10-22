extends Area2D

signal dead

@onready var score_text: Label = %ScoreText
@onready var lives_text: Label = %LivesText
@onready var sfx: AudioStreamPlayer2D = %Sfx
@onready var animate_node: AnimateNode = %AnimateNode

@export var max_lives: int = 5

const HIT_SFX: AudioStream = preload("uid://kje8rf4vuu8k")

# --- Movement (ease-in/out "arrive") ---
var max_speed: float = 500.0
var acceleration: float = 2400.0
var slow_radius: float = 200.0
var arrive_radius: float = 8.0
var velocity: Vector2 = Vector2.ZERO
var target_position: Vector2
var current_lives: int = 0

# --- Knockback (independent from movement) ---
var knockback_impulse: float = 60.0     # small one-shot impulse
var knockback_min_dv: float = 220.0     # ensure at least this Δv along push dir
var knockback_max_speed: float = 900.0  # cap so it doesn't rocket away

func _ready() -> void:
	monitoring = true
	monitorable = true

	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	sfx.stream = HIT_SFX
	current_lives = max_lives
	lives_text.text = str(current_lives)

	set_deferred("monitoring", false)
	set_deferred("monitoring", true)

	await get_tree().process_frame
	for body in get_overlapping_bodies():
		_on_body_entered(body)

	target_position = global_position

func _process(_delta: float) -> void:
	target_position = get_global_mouse_position()

func _physics_process(delta: float) -> void:
	global_position.x = clampf(global_position.x, 20.0, 1135.0)
	global_position.y = clampf(global_position.y, 100.0, 620.0)

	var to_target: Vector2 = target_position - global_position
	var distance: float = to_target.length()

	if distance <= arrive_radius:
		velocity = velocity.move_toward(Vector2.ZERO, acceleration * delta)
		global_position += velocity * delta
		return

	var desired_speed: float = max_speed
	if distance < slow_radius:
		desired_speed = max_speed * (distance / slow_radius)

	var desired_velocity: Vector2 = to_target.normalized() * desired_speed
	var steering: Vector2 = desired_velocity - velocity
	var max_change: float = acceleration * delta
	if steering.length() > max_change:
		steering = steering.normalized() * max_change

	velocity += steering
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed

	global_position += velocity * delta

func update_lives(amount: int) -> void:
	current_lives += amount
	current_lives = clampi(current_lives, 0, max_lives)
	lives_text.text = str(current_lives)

func _on_body_entered(body: Node) -> void:
	if not (body is RigidBody2D):
		return

	var rb := body as RigidBody2D
	rb.sleeping = false
	animate_node.play_enabled()
	sfx.play()

	var dir: Vector2 = rb.global_position - global_position
	if dir == Vector2.ZERO:
		dir = Vector2.RIGHT
	dir = dir.normalized()

	rb.apply_impulse(dir * knockback_impulse)

	var v_along: float = rb.linear_velocity.dot(dir)
	var needed_boost: float = knockback_min_dv - v_along
	if needed_boost > 0.0:
		rb.linear_velocity += dir * needed_boost

	if rb.linear_velocity.length() > knockback_max_speed:
		rb.linear_velocity = rb.linear_velocity.normalized() * knockback_max_speed

	var score := maxi(int(score_text.text) - 1000, 0)
	score_text.text = str(score)

func _on_body_exited(body: Node) -> void:
	if not (body is RigidBody2D):
		return

	modulate = Color.WHITE
	update_lives(-1)
	if current_lives <= 0:
		end_game()

func end_game() -> void:
	visible = false
	dead.emit()
