extends Node2D

@onready var checkpoints_node = $Checkpoints
@onready var racers_node = $Racers
@onready var player = $"Racers/Test Player"
@onready var laptime = $"Racers/Test Player/Camera2D/Lap time"
@onready var lapcount = $"Racers/Test Player/Camera2D/Lap count"
@onready var bestlap = $"Racers/Test Player/Camera2D/Best lap"
@onready var speed_label = $"Racers/Test Player/Camera2D/Label"

var checkpoints: Array[Node] = []
var racers: Array[Node] = []
var tracking: Dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	checkpoints = checkpoints_node.get_children()
	racers = racers_node.get_children()

	for r in racers:
		tracking.get_or_add(r.name, {"sectors": [0, 0, 0], "laptimes": [], "lapstart": Time.get_ticks_msec()})
	print('Level loaded')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lapcount.text = 'Круги: ' + str(max(0, player.lap_count))
	laptime.text = 'Время круга: ' + str((Time.get_ticks_msec() - tracking[player.name]["lapstart"]) / 1000.0)
	if player.lap_count < 1:
		bestlap.text = 'Лучший круг: N/A'
	else:
		bestlap.text = 'Лучший круг: ' + str(tracking[player.name]["laptimes"].min() / 1000.0)
	speed_label.text = str(int(player.speed)) + ' см/с'


func _on_sector_1_body_entered(body: Node2D) -> void:
	print(body, ' has passed Sector 1')
	var racer = tracking[body.name]
	var checks = racer["sectors"]
	if body in racers and checks[0] == checks[1] and checks[0] == checks[2]:
		checks[0] += 1
		body.lap_count += 1
		if body.lap_count != 0:
			racer["laptimes"].append(Time.get_ticks_msec() - racer["lapstart"])
			racer["lapstart"] = Time.get_ticks_msec()
			print("Lap time for ", body.name, " - ", racer["laptimes"][-1] / 1000.0, " seconds")
	print(checks)

func _on_sector_2_body_entered(body: Node2D) -> void:
	print(body, ' has passed Sector 2')
	var racer = tracking[body.name]
	var checks = racer["sectors"]
	if body in racers and checks[0] > checks[1]:
		checks[1] += 1
	print(checks)

func _on_sector_3_body_entered(body: Node2D) -> void:
	print(body, ' has passed Sector 3')
	var racer = tracking[body.name]
	var checks = racer["sectors"]
	if body in racers and checks[1] > checks[2] and checks[0] > checks[2]:
		checks[2] += 1
	print(checks)


func _on_slowdown_area_body_entered(body: Node2D) -> void:
	body.speed_modifier = body.dirt_speed_modifier


func _on_slowdown_area_body_exited(body: Node2D) -> void:
	body.speed_modifier = 1


func _on_slowdown_area_2_body_entered(body: Node2D) -> void:
	body.speed_modifier = body.dirt_speed_modifier


func _on_slowdown_area_2_body_exited(body: Node2D) -> void:
	body.speed_modifier = 1
