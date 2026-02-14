extends Node2D

@onready var checkpoints_node = $Checkpoints
@onready var racers_node = $Racers
var checkpoints: Array[Node] = []
var racers: Array[Node] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	checkpoints = checkpoints_node.get_children()
	racers = racers_node.get_children()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
