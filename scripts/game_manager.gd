extends Node

var player_dead = false
var player_winning = false

var world = 1
var level = 1

@export var levels: Array = [
	[
		preload("res://scenes/test_level.tscn"),
		preload("res://scenes/test_level.tscn")
	]
]
