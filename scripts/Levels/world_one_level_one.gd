extends Node2D

func _on_moving_floor_1_trigger_area_entered(area: Area2D):
	if area.is_in_group("player"):
		GameManager.play_trap_audio()
		%MovingFloor1Anim.play("start_trap")
		%MovingFloor1Trigger.queue_free()
