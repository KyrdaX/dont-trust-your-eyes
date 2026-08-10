extends Node2D

func _on_falling_ceiling_1_trigger_area_entered(area: Area2D):
	if area.is_in_group("player"):
		%FallingCeiling1Trigger.queue_free()
		var tween = get_tree().create_tween()
		GameManager.play_trap_audio()
		tween.tween_property(%FallingCeiling1, "position", Vector2(0, 130.0), 1).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
		tween.tween_callback(func():
			await get_tree().create_timer(0.5).timeout
			
			%FallingCeiling1.set_deferred("freeze", false)
			GameManager.play_trap_audio()
			%MovingFloor1Anim.play("start_trap")
		)

func _on_moving_floor_1_trigger_area_entered(area: Area2D):
	if area.is_in_group("player"):
		%MovingFloor1Trigger.queue_free()
		GameManager.play_trap_audio()
		%MovingFloor2Anim.play("start_trap")

func play_trap_audio():
	GameManager.play_trap_audio()

func _on_moving_goal_1_trigger_area_entered(area: Area2D):
	if area.is_in_group("player"):
		%MovingGoal1Trigger.queue_free()
		GameManager.play_trap_audio()
		%MovingGoal1Anim.play("start_trap")
		%MovingGoal2Trigger.set_deferred("monitoring", true)

func _on_moving_goal_2_trigger_area_entered(area: Area2D):
	if area.is_in_group("player"):
		%MovingGoal2Trigger.queue_free()
		GameManager.play_trap_audio()
		%MovingGoal2Anim.play("start_trap")
