@tool
extends Node3D

const WIDTH := 15
const HEIGHT := 11
const SOL := preload("res://Sol/sol.tscn")
const MUR := preload("res://Sol/mur.tscn")

func _ready() -> void:
	for child in get_children():
		child.free()
	build_map()

# Une case de sol partout, plus un mur sur la bordure et un pilier une case sur deux
func build_map() -> void:
	for x in WIDTH:
		for z in HEIGHT:
			var pos := Vector3(x - (WIDTH - 1) * 0.5, 0, z - (HEIGHT - 1) * 0.5)
			add_tile(SOL, pos + Vector3.DOWN * 0.5)

			var border := x == 0 or z == 0 or x == WIDTH - 1 or z == HEIGHT - 1
			var pillar := x % 2 == 0 and z % 2 == 0
			if border or pillar:
				add_tile(MUR, pos + Vector3.UP * 0.5)

func add_tile(scene: PackedScene, pos: Vector3) -> void:
	var tile := scene.instantiate()
	tile.position = pos
	add_child(tile)
