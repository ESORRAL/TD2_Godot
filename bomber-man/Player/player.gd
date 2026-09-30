extends CharacterBody3D

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
