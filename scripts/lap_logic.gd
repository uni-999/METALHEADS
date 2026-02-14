extends Node2D

@onready var checkpoints_node = $Checkpoints
@onready var racers_node = $Racers
@onready var player = $"Racers/Test Player"
@onready var laptime = $"Lap time"
@onready var lapcount = $"Lap count"

var checkpoints: Array[Node] = []
var racers: Array[Node] = []
var tracking: Dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	checkpoints = checkpoints_node.get_children()
	racers = racers_node.get_children()

	for r in racers:
		tracking.get_or_add(r.name, [0, 0, 0])
	print('Level loaded')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lapcount.text = 'Lap count: ' + str(player.lap_count)


func _on_sector_1_body_entered(body: Node2D) -> void:
	print(body, ' has passed Sector 1')
	if body in racers:
		tracking[body.name][0] += 1
	print(tracking[body.name])

func _on_sector_2_body_entered(body: Node2D) -> void:
	print(body, ' has passed Sector 2')
	if body in racers:
		tracking[body.name][1] += 1
	print(tracking[body.name])

func _on_sector_3_body_entered(body: Node2D) -> void:
	print(body, ' has passed Sector 3')
	var checks = tracking[body.name]
	if body in racers:
		checks[2] += 1
	print(checks)
	if body.lap_count < checks.min():
		body.lap_count += 1
	print(body.lap_count)
