extends Area2D

@onready var collision_polygon_2d: CollisionPolygon2D = %CollisionPolygon2D
@onready var score_text: Label = %ScoreText
@onready var lives_text: Label = %LivesText
@onready var sfx: AudioStreamPlayer2D = %Sfx

@export var max_lives: int = 5
const hit_sfx = preload("uid://kje8rf4vuu8k")


signal dead
# --- Movement (ease-in/out "arrive") ---
var max_speed: float = 500.0
var acceleration: float = 2400.0
var slow_radius: float = 200.0
var arrive_radius: float = 8.0
var velocity: Vector2 = Vector2.ZERO
var target_position: Vector2
var current_lives: int =5

# --- Knockback (independent from movement) ---
var knockback_impulse: float = 60.0     # small one-shot impulse
var knockback_min_dv: float = 220.0     # ensure at least this Δv along push dir
var knockback_max_speed: float = 900.0  # cap so it doesn't rocket away

func _ready() -> void:
	# Make sure the Area2D will report overlaps
	monitoring = true
	monitorable = true

	# Connect collision signals ASAP
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	sfx.stream = hit_sfx

	# Force the physics broadphase to refresh after the scene is ready
	# (prevents missed enters if things were spawned overlapped)
	set_deferred("monitoring", false)
	set_deferred("monitoring", true)

	# After one frame, catch any bodies already overlapping so we don't miss the "enter" edge
	await get_tree().process_frame
	for b in get_overlapping_bodies():
		_on_body_entered(b)

	target_position = global_position

func _process(_delta: float) -> void:
		target_position = get_global_mouse_position()

func _physics_process(delta: float) -> void:
	if global_position.x < 20: 
		global_position.x= 20
	if global_position.x > 1135: 
		global_position.x= 1135
	if global_position.y > 620:
		global_position.y = 620
	if global_position.y < 100:
		global_position.y = 100
		
	var to_target: Vector2 = target_position - global_position
	var distance: float = to_target.length()
		
	# Arrive behavior: slow to a stop at the end
	if distance <= arrive_radius:
		velocity = velocity.move_toward(Vector2.ZERO, acceleration * delta)
		global_position += velocity * delta
		return

	# Ease-in/out: target speed scales down inside slow_radius
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


func update_lives(amount:int):
	current_lives = int(lives_text.text)
	current_lives = current_lives + amount
	lives_text.text = str(current_lives)

func _on_body_entered(body: Node) -> void:
	# Signal guard: ensure it's a physics body we can push
	if not (body is RigidBody2D):
		return
	var rb: RigidBody2D = body
	rb.sleeping = false  # wake so impulses/velocity apply immediately
	sfx.stream = hit_sfx
	modulate = Color.RED
	sfx.play()
	
	# Direction AWAY from this Area2D
	var dir: Vector2 = rb.global_position - global_position
	if dir == Vector2.ZERO:
		dir = Vector2.RIGHT
	dir = dir.normalized()

	# 1) Small instantaneous impulse (snappy feedback)
	rb.apply_impulse(dir * knockback_impulse)

	# 2) Guarantee minimum velocity along push direction (visible motion)
	var v_along: float = rb.linear_velocity.dot(dir)
	var needed_boost: float = knockback_min_dv - v_along
	if needed_boost > 0.0:
		rb.linear_velocity += dir * needed_boost

	# 3) Cap to avoid extreme speeds
	if rb.linear_velocity.length() > knockback_max_speed:
		rb.linear_velocity = rb.linear_velocity.normalized() * knockback_max_speed
	
	var score = int(score_text.text) -1000
	if score <0: 
		score  = 0
	score_text.text = str(score)
	

func _on_body_exited(body: Node) -> void:
	# Optional: keep for debugging or future logic
	if not (body is RigidBody2D):
		return
	modulate = Color.WHITE
	update_lives(-1)
	print(current_lives)
	if current_lives <= 0:
		end_game()
				
		# print("body_exited:", (body as RigidBody2D).name)


func end_game():
	visible = false
	dead.emit()
