extends CharacterBody2D

@export var SPEED: float = 300.00
@export var JUMP_FORCE: float = -500.00
@export var GRAVITY: float = 30

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
	if GameManager.player_dead: return
	
	if !is_on_floor():
		is_jumping = true
		player_sprite.play("jumping")
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
	hide()
	area.get_parent().get_node("AnimatedSprite2D").play("disappearing")
	
	await get_tree().create_timer(0.5).timeout
	Signals.player_won.emit()
	
	queue_free()
