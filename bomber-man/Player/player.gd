extends CharacterBody3D

# bomb
const BOMB_SCENE := preload("res://bombe/bomb.tscn")
@export var max_bombs: int = 1
@export var bomb_range: int = 1
var active_bombs: int = 0
# fin de la partie bomb

@export var speed: float = 5.0

@onready var skin = $Sketchfab_Scene 

@export var vies: int = 3
var position_depart: Vector3 

@onready var conteneur_coeurs = $HUD/Node2D

func _ready() -> void:
	position_depart = global_position
	actualiser_affichage_vies()

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("p_left", "p_right", "p_up", "p_down")
	var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		
		var look_target = global_position + direction
		skin.look_at(look_target, Vector3.UP)
		
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

func actualiser_affichage_vies() -> void:
	var images_coeurs = conteneur_coeurs.get_children()
	for i in range(images_coeurs.size()):
		if i < vies:
			images_coeurs[i].visible = true
		else:
			images_coeurs[i].visible = false

func prendre_degat() -> void:
	vies -= 1
	actualiser_affichage_vies()
	
	if vies > 0:
		global_position = position_depart
	else:
		get_tree().change_scene_to_file("res://Death/death.tscn")
		
# Début deuxième partie du script pour la bombe du player
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("place_bomb"):
		place_bomb()

func place_bomb() -> void:
	if active_bombs >= max_bombs:
		return
	var cell := Grid.world_to_cell(global_position)
	for b in get_tree().get_nodes_in_group("bomb"):
		if b.cell == cell:
			return

	var bomb := BOMB_SCENE.instantiate()
	bomb.cell = cell
	bomb.bomb_range = bomb_range
	bomb.owner_player = self
	get_parent().add_child(bomb)
	bomb.global_position = Grid.cell_to_world(cell)

	add_collision_exception_with(bomb)
	bomb.add_collision_exception_with(self)

	active_bombs += 1
	bomb.exploded.connect(func(): active_bombs -= 1)

func hit_by_explosion() -> void:
	prendre_degat()
# fin deuxième partie du script bomb pour le player
