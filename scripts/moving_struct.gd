extends StaticBody2D

enum Direction {Up, Down, Left, Right}

@export var trigger: Area2D

@export var struct_color: Color

@export var end_pos: Vector2

@export var travel: float
@export var await_time: float

@export var oneshot: bool = true
@export var returns: bool
@export var spikes: bool:
	set(value):
		spikes = value
		notify_property_list_changed()

@export var direction: Direction = Direction.Up

@export var color_rect: ColorRect

@onready var spike_scene = preload("res://components/spike.tscn")

var starting_pos: Vector2

func _ready():
	starting_pos = global_position
	color_rect.color = struct_color
	
	if spikes: _place_spikes()
	_connect_trigger()

func _connect_trigger() -> void:
	#TODO: Implement that various triggers can be connected to the same signal in case a trap can be activated from both different sides (Area2D Array implementation)
	trigger.area_entered.connect(func(area: Area2D):
		if area.is_in_group("player"):
			if oneshot: trigger.set_deferred("monitoring", false)
			
			var tween: Tween = create_tween()
			tween.tween_property(self, "global_position", end_pos, travel)
			
			await get_tree().create_timer(await_time + travel).timeout
			
			if returns:
				tween = create_tween()
				tween.tween_property(self, "global_position", starting_pos, travel)
	)

func _place_spikes():
	#TODO: Dynamic spike placing system
	match direction:
		pass

func _validate_property(property: Dictionary):
	if property.name == "direction" and !spikes:
		property.usage &= ~PROPERTY_USAGE_EDITOR
