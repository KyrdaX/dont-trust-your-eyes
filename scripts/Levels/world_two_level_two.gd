extends Node2D

func _on_spike_trigger_1_area_entered(area: Area2D):
	if not area.is_in_group("player"): return
	
	%FirstSpikeTrapAnim.play("start_trap")
	play_trap_audio()
	%SpikeTrigger1.set_deferred("monitoring", false)

func _on_spike_trigger_2_area_entered(area: Area2D):
	if not area.is_in_group("player"): return
	
	%SecondSpikeTrapAnim.play("start_trap")
	play_trap_audio()
	%SpikeTrigger2.set_deferred("monitoring", false)

func play_trap_audio():
	GameManager.play_trap_audio()
