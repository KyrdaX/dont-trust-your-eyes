extends Node2D

func _ready():
	await get_tree().create_timer(2.5).timeout
	%FirstMovingWallAnim.play("start_trap")
	play_trap_audio()

func play_trap_audio():
	GameManager.play_trap_audio()

func disable_first_fall_trap():
	%FirstFall.queue_free()
	%FirstFallTrigger.queue_free()

func _on_first_fall_trigger_area_entered(area: Area2D):
	if not area.is_in_group("player"): return
	
	%FirstFallAnim.play("start_trap")
	play_trap_audio()
	%FirstFallTrigger.set_deferred("monitoring", false)


func _on_second_wall_trigger_area_entered(area: Area2D):
	if not area.is_in_group("player"): return
	
	%SecondMovingWallAnim.play("start_trap")
	play_trap_audio()
	%SecondWallTrigger.set_deferred("monitoring", false)
