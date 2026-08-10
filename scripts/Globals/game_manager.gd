extends Node

var player_dead := false
var player_winning := false

var music_muted: bool
var sfx_muted: bool

var world: int = 2
var level: int

var trap_swoosh: AudioStreamPlayer = AudioStreamPlayer.new()

func _ready():
	trap_swoosh.stream = preload("res://assets/sounds/585256__lesaucisson__swoosh-2.mp3")
	trap_swoosh.bus = "SFX"
	add_child(trap_swoosh)

var levels: Array = [
	[
		preload("res://scenes/worlds/world_1/levels/world_one_level_one.tscn"),
		preload("res://scenes/worlds/world_1/levels/world_one_level_two.tscn"),
		preload("res://scenes/worlds/world_1/levels/world_one_level_three.tscn"),
		preload("res://scenes/worlds/world_1/levels/world_one_level_four.tscn"),
		preload("res://scenes/worlds/world_1/levels/world_one_level_five.tscn")
	],
	[
		preload("res://scenes/worlds/world_2/levels/world_two_level_one.tscn"),
		preload("res://scenes/worlds/world_2/levels/world_two_level_two.tscn"),
		preload("res://scenes/worlds/world_2/levels/world_two_level_three.tscn"),
		preload("res://scenes/worlds/world_2/levels/world_two_level_four.tscn")
	]
]

func play_trap_audio():
	trap_swoosh.pitch_scale = randf_range(1.8, 2.2)
	trap_swoosh.play()
