extends CharacterBody2D

@export var spikes: Array[Sprite2D]

func _ready():
	spikes[GameManager.world - 1].show()

func get_anchors() -> Dictionary:
	return {
		main = %AnchorPoint,
		left = %LeftAnchor, 
		right = %RightAnchor
		}
