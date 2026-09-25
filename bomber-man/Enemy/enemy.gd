extends Area3D

@export var speed: float = 2.0

const DIRECTIONS: Array[Vector3] = [Vector3.FORWARD, Vector3.BACK, Vector3.LEFT, Vector3.RIGHT]

var target: Vector3
var direction: Vector3

func _ready() -> void:
	target = global_position
	direction = DIRECTIONS.pick_random()

func _physics_process(delta: float) -> void:
	global_position = global_position.move_toward(target, speed * delta)
	if global_position.is_equal_approx(target):
		choose_next_cell()

func choose_next_cell() -> void:
	direction = DIRECTIONS.pick_random()
	target += direction
