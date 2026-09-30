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
	var directions := DIRECTIONS.duplicate()
	directions.shuffle()
	for dir in directions:
		if not is_wall_ahead(dir):
			direction = dir
			target = global_position + dir
			return
	# Aucune direction libre : reste sur place
	target = global_position

func is_wall_ahead(dir: Vector3) -> bool:
	var space_state := get_world_3d().direct_space_state
	var from := global_position + Vector3.UP * 0.5
	var query := PhysicsRayQueryParameters3D.create(from, from + dir)
	query.exclude = [self]
	var result := space_state.intersect_ray(query)
	return not result.is_empty() and result.collider is StaticBody3D
