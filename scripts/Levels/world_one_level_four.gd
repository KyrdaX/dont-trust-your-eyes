extends Node2D

func _on_area_2d_area_entered(area: Area2D):
	if area.is_in_group("player"):
		%MovingSpikes1Anim.play("start_trap")
		GameManager.play_trap_audio()
		%MovingSpikes1Trigger.queue_free()

func _on_moving_spikes_2_trigger_area_entered(area: Area2D):
	if area.is_in_group("player"):
		%MovingSpikes2Anim.play("start_trap")
		GameManager.play_trap_audio()
		%MovingSpikes2Trigger.queue_free()
		
		await get_tree().create_timer(1.6).timeout
		%HiddenSpike1.queue_free()
		%HiddenSpike2.queue_free()
		%HiddenSpike3.queue_free()

func _on_moving_spikes_3_trigger_area_entered(area: Area2D):
	if area.is_in_group("player"):
		%MovingSpikes3Anim.play("start_trap")
		play_trap_audio()
		%MovingSpikes3Trigger.queue_free()

func play_trap_audio() -> void:
	GameManager.play_trap_audio()
