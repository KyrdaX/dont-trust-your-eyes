extends Node2D

@onready var fade_anims: AnimationPlayer = $AnimationPlayer
@onready var shader_layer: ColorRect = %ShaderLayer

var level: Node

var next_level_exists: bool

func _ready():
	_spawn_level()
	
	Signals.player_died.connect(func():
		fade_anims.play("death_screen_fade_in")
	)
	
	Signals.player_won.connect(func():
		shader_layer.start_pixelate_effect(30, 1)
		next_level_exists = GameManager.level < GameManager.levels[GameManager.world - 1].size()
	)
	
	Signals.pixelate_ended.connect(func():
		level.queue_free()
		shader_layer.reset_pixelate_effect(0.5)
		
		if next_level_exists:
			GameManager.level += 1
		else:
			pass 
		
		_spawn_level()
	)
	
	fade_anims.animation_finished.connect(func(anim):
		if anim == "death_screen_fade_in":
			GameManager.player_dead = false
			
			level.queue_free()
			_spawn_level()
			
			fade_anims.play("death_screen_fade_out")
	)

func _spawn_level():
	level = GameManager.levels[GameManager.world - 1][GameManager.level - 1].instantiate()
	call_deferred("add_child", level)
