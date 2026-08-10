extends Area2D

@export var reference_object: Node2D

func get_coordenates():
	return reference_object.global_position
