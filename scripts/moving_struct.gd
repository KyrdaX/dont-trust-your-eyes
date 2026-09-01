@tool
extends StaticBody2D

enum Direction {Up, Down, Left, Right}

@export var triggers: Array[Area2D]

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

@onready var structure_anchors: Dictionary = {
	top = %TopAnchor,
	left = %LeftAnchor,
	right = %RightAnchor,
	bottom = %BottomAnchor
}

var starting_pos: Vector2

func _ready():
	starting_pos = global_position
	color_rect.color = struct_color
	
	if spikes: _place_spikes()
	_connect_trigger()

func _connect_trigger() -> void:
	for trigger: Area2D in triggers:
		trigger.area_entered.connect(func(area: Area2D):
			if area.is_in_group("player"):
				if oneshot: for t: Area2D in triggers: t.set_deferred("monitoring", false)
				
				var tween: Tween = create_tween()
				tween.tween_property(self, "global_position", end_pos, travel)
				
				await get_tree().create_timer(await_time + travel).timeout
				
				if returns:
					tween = create_tween()
					tween.tween_property(self, "global_position", starting_pos, travel)
		)

func _place_spikes():
	var spike := spike_scene.instantiate()
	var spike_anchors = spike.get_anchors()
	var original_spike_scale: Vector2 = spike.scale
	var step = spike_anchors.left.global_position.distance_to(spike_anchors.right.global_position)
	
	add_child(spike)
	spike.global_scale = original_spike_scale
	
	var center_anchor: Node2D
	var boundary_a: Node2D
	var boundary_b: Node2D
	
	match direction:
		Direction.Up:
			center_anchor = structure_anchors.top
			boundary_a = structure_anchors.left
			boundary_b = structure_anchors.right
		Direction.Down:
			center_anchor = structure_anchors.bottom
			boundary_a = structure_anchors.left
			boundary_b = structure_anchors.right
		Direction.Left:
			center_anchor = structure_anchors.left
			boundary_a = structure_anchors.top
			boundary_b = structure_anchors.bottom
		Direction.Right:
			center_anchor = structure_anchors.right
			boundary_a = structure_anchors.top
			boundary_b = structure_anchors.bottom
	
	spike_anchors.main.global_rotation = center_anchor.global_rotation
	spike_anchors.main.global_position = center_anchor.global_position
	
	var axis: Vector2 = Vector2.RIGHT.rotated(center_anchor.global_rotation)
	var origin: Vector2 = center_anchor.global_position
	
	var limit_a: float = (boundary_a.global_position - origin).dot(axis)
	var limit_b: float = (boundary_b.global_position - origin).dot(axis)
	
	var limit_pos: float = max(limit_a, limit_b)
	var limit_neg: float = min(limit_a, limit_b)
	
	var offset_pos: float = step
	var offset_neg: float = -step
	
	var pos_done := false
	var neg_done := false
	
	while not (pos_done and neg_done):
		if not pos_done:
			if offset_pos + step > limit_pos:
				pos_done = true
			else:
				var new_spike := spike_scene.instantiate()
				var new_anchors = new_spike.get_anchors()
				
				add_child(new_spike)
				new_spike.global_scale = original_spike_scale
				
				new_anchors.main.global_rotation = center_anchor.global_rotation
				new_anchors.main.global_position = origin + axis * offset_pos
				
				offset_pos += step
		
		if not neg_done:
			if offset_neg - step < limit_neg:
				neg_done = true
			else:
				var new_spike := spike_scene.instantiate()
				var new_anchors = new_spike.get_anchors()
				
				add_child(new_spike)
				new_spike.global_scale = original_spike_scale
				
				new_anchors.main.global_rotation = center_anchor.global_rotation
				new_anchors.main.global_position = origin + axis * offset_neg
				
				offset_neg -= step

func _validate_property(property: Dictionary):
	if property.name == "direction" and !spikes:
		property.usage &= ~PROPERTY_USAGE_EDITOR
