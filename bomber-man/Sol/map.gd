@tool
extends Node3D

const WIDTH := 15
const HEIGHT := 11
const GRASS := preload("uid://d0clw3txbfsva")

func _ready() -> void:
	for child in get_children():
		child.free()
	build_floor()
	build_walls()

# Sol : un seul gros cube dont le dessus est à y = 0
func build_floor() -> void:
	var mat := StandardMaterial3D.new()
	mat.albedo_texture = GRASS
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	mat.uv1_scale = Vector3(WIDTH, HEIGHT, 1)

	var mesh := BoxMesh.new()
	mesh.size = Vector3(WIDTH, 1, HEIGHT)
	mesh.material = mat

	var floor_node := MeshInstance3D.new()
	floor_node.mesh = mesh
	floor_node.position.y = -0.5
	add_child(floor_node)

# Murs : bordure + un pilier une case sur deux (grille classique de Bomberman)
func build_walls() -> void:
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.5, 0.5, 0.55)

	var mesh := BoxMesh.new()
	mesh.material = mat

	var shape := BoxShape3D.new()

	for x in WIDTH:
		for z in HEIGHT:
			var border := x == 0 or z == 0 or x == WIDTH - 1 or z == HEIGHT - 1
			var pillar := x % 2 == 0 and z % 2 == 0
			if border or pillar:
				add_wall(mesh, shape, Vector3(x - (WIDTH - 1) * 0.5, 0.5, z - (HEIGHT - 1) * 0.5))

func add_wall(mesh: Mesh, shape: Shape3D, pos: Vector3) -> void:
	var body := StaticBody3D.new()
	body.position = pos

	var visual := MeshInstance3D.new()
	visual.mesh = mesh
	body.add_child(visual)

	var collision := CollisionShape3D.new()
	collision.shape = shape
	body.add_child(collision)

	add_child(body)
