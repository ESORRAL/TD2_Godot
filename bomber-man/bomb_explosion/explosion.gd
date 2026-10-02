extends Area3D

@export var duration: float = 0.5

func _ready() -> void:
	body_entered.connect(_on_hit)
	area_entered.connect(_on_hit)
	await get_tree().create_timer(duration).timeout
	queue_free()

func _on_hit(node: Node) -> void:
	print("Explosion touche : ", node.name)   
	while node:
		if node.has_method("hit_by_explosion"):
			node.hit_by_explosion()
			return
		node = node.get_parent()
