extends CharacterBody2D

@export var SPEED: float = 300.00
@export var JUMP_FORCE: float = -500.00
@export var GRAVITY: float = 30.0
@export var MAX_FALLING_VEL: float = 800

@onready var player_sprite = %AnimatedSprite2D
@onready var death_particles: PackedScene = preload("res://components/explosion_particles.tscn")

enum States {
	IDLE,
	WALKING,
	JUMPING
}
var current_state = States.IDLE

var is_jumping = false
var direction

func _physics_process(_delta):
	if (
		GameManager.player_dead
		or GameManager.player_winning
	): return
	
	if !is_on_floor():
		is_jumping = true
		player_sprite.play("jumping")
		
		if velocity.y < MAX_FALLING_VEL:
			velocity.y += GRAVITY
	else:
		is_jumping = false
	
	direction = Input.get_axis("left", "right")
	
	match current_state:
		States.IDLE:
			if !is_jumping:
				player_sprite.play("idle")
			
			if direction != 0:
				current_state = States.WALKING
			elif Input.is_action_just_pressed("jump") and is_on_floor():
				current_state = States.JUMPING
		
		States.WALKING:
			if !is_jumping:
				player_sprite.play("walking")
			
			velocity.x = direction * SPEED
			
			if direction == 0:
				current_state = States.IDLE
			elif direction == 1:
				player_sprite.flip_h = false
			else:
				player_sprite.flip_h = true
			
			if Input.is_action_just_pressed("jump") and is_on_floor():
				current_state = States.JUMPING
		
		States.JUMPING:
			player_sprite.play("jumping")
			
			velocity.y = JUMP_FORCE
			
			if direction == 0:
				current_state = States.IDLE
			else:
				current_state = States.WALKING
	
	move_and_slide()

func _on_area_2d_area_entered(area: Area2D):
	if area.is_in_group("hazard") and !GameManager.player_dead:
		GameManager.player_dead = true
		_die()
	elif area.is_in_group("goal"):
		if GameManager.player_winning: return
		_win(area)
	elif area.is_in_group("teleport") and area.has_method("get_coordenates") and area.has_meta("axis"):
		_teleport(area)

func _die():
	var explosion = death_particles.instantiate()
	explosion.global_position = global_position
	get_tree().current_scene.add_child(explosion)
	explosion.emitting = true
	
	hide()
	
	await get_tree().create_timer(1).timeout
	Signals.player_died.emit()
	
	queue_free()

func _win(area: Area2D):
	GameManager.player_winning = true
	
	%GoalSFX.play()
	hide()
	area.get_parent().get_node("ActiveGoal").play("disappearing")
	
	await get_tree().create_timer(0.5).timeout
	Signals.player_won.emit()
	
	GameManager.player_winning = false
	queue_free()

func _teleport(area: Area2D):
	if !area.has_meta("axis"): return
	var tp_axis = area.get_meta("axis")
	
	if tp_axis == "horizontal":
		global_position.x = area.get_coordenates().x
	elif tp_axis == "vertical":
		global_position.y = area.get_coordenates().y
