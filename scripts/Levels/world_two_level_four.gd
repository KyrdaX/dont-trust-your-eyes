extends Node2D

func _on_first_floor_trap_trigger_area_entered(area: Area2D):
	if not area.is_in_group("player"): return
	
	%FirstFloorTrapTrigger.set_deferred("monitoring", false)
	%FirstFloorTrapAnim.play("start_trap")
	play_trap_audio()

func _on_second_floor_trap_trigger_area_entered(area: Area2D):
	if not area.is_in_group("player"): return
	
	%SecondFloorTrapTrigger.set_deferred("monitoring", false)
	%SecondFloorTrapAnim.play("start_trap")
	play_trap_audio()

func play_trap_audio():
	GameManager.play_trap_audio()
