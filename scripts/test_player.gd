extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@export var MAX_SPEED = 500.0
@export var acceleration = 3.0
@export var deceleration = 1.0
@export var braking_deceleration = 2.0
@export var rotation_speed = 2.0
var lap_count = -1
var speed = 0
var movement_vector = Vector2(0, 0)
var animation_speed = 0.0
var dirt_speed_modifier = 0.2
var speed_modifier = 1


func _ready() -> void:
	anim.play("crawl")


func _physics_process(delta: float) -> void:
	handle_throttle()
	handle_turning(delta)
	handle_velocity()
	handle_animation()
	
	move_and_slide()


func handle_throttle():
	var throttle = Input.get_axis("move_down", "move_up")
	if throttle > 0:
		speed = move_toward(speed, MAX_SPEED * speed_modifier, acceleration)
	elif throttle < 0:
		speed = move_toward(speed, 0, braking_deceleration)
	else:
		if speed > MAX_SPEED * speed_modifier:
			speed = move_toward(speed, 0, braking_deceleration)
		speed = move_toward(speed, 0, deceleration)
	

func handle_turning(delta: float):
	var left_and_right := Input.get_axis("move_left", "move_right")
	
	if left_and_right:
		rotate(rotation_speed * left_and_right * delta)

func handle_velocity():
	movement_vector = Vector2(sin(rotation), -cos(rotation)).normalized()
	velocity = movement_vector * speed

func handle_animation():
	const top_speed_scale = 3.0
	animation_speed = speed * top_speed_scale / MAX_SPEED
	anim.speed_scale = animation_speed
