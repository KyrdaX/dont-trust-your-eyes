extends CharacterBody2D

@export var goals: Array[AnimatedSprite2D]

func _ready():
	var goal_id = GameManager.world - 1
	
	goals[goal_id].show()
	goals[goal_id].name = "ActiveGoal"
