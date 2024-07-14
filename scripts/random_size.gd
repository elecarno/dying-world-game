extends Node3D

@export var min_scale: float = 1.0
@export var max_scale: float = 2.0
@export var randomise_rotation: bool = false

func _ready():
	scale = Vector3(randf_range(min_scale, max_scale), randf_range(min_scale, max_scale), randf_range(min_scale, max_scale))
	if randomise_rotation:
		rotation.y = randf_range(0, 2*PI)
