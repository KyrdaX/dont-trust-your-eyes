extends Node2D

@onready var fade_anims: AnimationPlayer = $AnimationPlayer
@onready var shader_layer: ColorRect = %ShaderLayer

@onready var menu_scene := preload("res://scenes/menu.tscn")

var menu: Node
var level: Node

var next_level_exists: bool
var first_level := true

func _ready():
	menu = menu_scene.instantiate()
	call_deferred("add_sibling", menu)
	
	Signals.player_died.connect(func():
		fade_anims.play("death_screen_fade_in")
	)
	
	Signals.player_won.connect(func():
		%PixelateSFX.play()
		shader_layer.start_pixelate_effect(50, 1)
		next_level_exists = GameManager.level < GameManager.levels[GameManager.world - 1].size()
	)
	
	Signals.pixelate_ended.connect(func():
		if first_level:
			shader_layer.reset_pixelate_effect(0.3)
			return
		
		level.queue_free()
		shader_layer.reset_pixelate_effect(0.5)
		
		if next_level_exists:
			GameManager.level += 1
			_spawn_level()
		else:
			level.queue_free()
			
			menu = menu_scene.instantiate()
			call_deferred("add_child", menu)
			first_level = true
	)
	
	Signals.level_button_pressed.connect(func(menu_loop: AudioStreamPlayer):
		var tween := create_tween()
		tween.tween_property(menu_loop, "volume_db", -80, 0.5)
		
		shader_layer.start_pixelate_effect(50, 1)
		%PixelateSFX.play()
		
		await tween.finished
		menu.queue_free()
		_spawn_level()
		
		await get_tree().create_timer(2).timeout
		first_level = false
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
