extends StaticBody3D

signal exploded

const EXPLOSION_SCENE := preload("res://bomb_explosion/Explosion.tscn")
const DIRECTIONS := [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]

@export var fuse_time := 2.5
var bomb_range := 1
var cell: Vector2i
var owner_player: PhysicsBody3D
var has_exploded := false

func _ready() -> void:
	add_to_group("bomb")
	$Timer.wait_time = fuse_time
	$Timer.one_shot = true
	$Timer.timeout.connect(explode)
	$Timer.start()

func _physics_process(_delta: float) -> void:
	if owner_player and Grid.world_to_cell(owner_player.global_position) != cell:
		remove_collision_exception_with(owner_player)
		owner_player.remove_collision_exception_with(self)
		owner_player = null

func explode() -> void:
	if has_exploded:
		return
	has_exploded = true

	_spawn_explosion(cell)

	for dir in DIRECTIONS:
		for i in range(1, bomb_range + 1):
			var target: Vector2i = cell + dir * i
			var wall := _get_wall_at(target)
			if wall and wall.is_in_group("wall_solid"):
				break                 
			_spawn_explosion(target)
			if wall and wall.is_in_group("wall_breakable"):
				wall.queue_free()     
				break                 

	exploded.emit()
	queue_free()

func hit_by_explosion() -> void:
	call_deferred("explode")

func _spawn_explosion(c: Vector2i) -> void:
	var fx := EXPLOSION_SCENE.instantiate()
	get_parent().add_child(fx)
	fx.global_position = Grid.cell_to_world(c)
	
func _get_wall_at(c: Vector2i) -> Node:
	var params := PhysicsPointQueryParameters3D.new()
	params.position = Grid.cell_to_world(c) + Vector3(0, 0.5, 0)
	for result in get_world_3d().direct_space_state.intersect_point(params):
		var node: Node = result.collider
		while node and node != get_parent():
			if node.is_in_group("wall_solid") or node.is_in_group("wall_breakable"):
				return node
			node = node.get_parent()
	return null
