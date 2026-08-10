extends Node2D

func _on_moving_floor_1_trigger_area_entered(area: Area2D):
	if area.is_in_group("player"):
		%MovingFloor1Anim.play("start_trap")
		GameManager.play_trap_audio()
		%MovingFloor1Trigger.queue_free()

func _on_moving_floor_2_trigger_area_entered(area: Area2D):
	if area.is_in_group("player"):
		%MovingFloor2Anim.play("start_trap")
		GameManager.play_trap_audio()
		%MovingFloor2Trigger.queue_free()

func _on_moving_floor_1_anim_animation_finished(anim_name):
	if anim_name == "start_trap":
		await get_tree().create_timer(1.0).timeout
		%MovingFloor1Anim.play("end_trap")

func _on_moving_floor_2_anim_animation_finished(anim_name):
	if anim_name == "start_trap":
		await get_tree().create_timer(1.0).timeout
		%MovingFloor2Anim.play("end_trap")

func play_trap_audio():
	GameManager.play_trap_audio()
