extends CharacterBody2D

@onready var anim = $AnimationPlayer
@export var MAX_SPEED = 300.0
@export var acceleration = 10.0
@export var deceleration = 5.0
@export var braking_deceleration = 15.0
@export var rotation_speed = 3.0
var lap_count = 0
var speed = 0
var movement_vector = Vector2(0, 0)


func _ready() -> void:
	anim.play("Crawl")


func _physics_process(delta: float) -> void:
	var left_and_right := Input.get_axis("move_left", "move_right")
	var throttle = Input.get_axis("move_down", "move_up")
	
	if throttle > 0:
		speed = move_toward(speed, MAX_SPEED, acceleration)
	elif throttle < 0:
		speed = move_toward(speed, 0, braking_deceleration)
	else:
		speed = move_toward(speed, 0, deceleration)
	
	if left_and_right:
		rotate(rotation_speed * left_and_right * delta)
	
	movement_vector = Vector2(sin(rotation), -cos(rotation)).normalized()
	velocity = movement_vector * speed
	print(speed)
	move_and_slide()
