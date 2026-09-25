extends CharacterBody3D

@export var speed: float = 5.0

@onready var skin = $Sketchfab_Scene 

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
