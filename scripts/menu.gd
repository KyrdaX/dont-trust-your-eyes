extends Control

func _ready() -> void:
	_connect_hover_signals()
	_connect_world_buttons()
	_connect_level_buttons()
	_animate_all_labels()

#region Connections and label animations
func _connect_hover_signals() -> void:
	for button: Button in get_tree().get_nodes_in_group("green_hover"):
		button.connect("mouse_entered", func():
			button.get_parent().get_children()[1].label_settings.font_color = Color.GREEN
		)
		
		button.connect("mouse_exited", func():
			button.get_parent().get_children()[1].label_settings.font_color = Color.WHITE
		)
	
	for button: Button in get_tree().get_nodes_in_group("red_hover"):
		button.connect("mouse_entered", func():
			button.get_parent().get_children()[1].label_settings.font_color = Color.RED
		)
		
		button.connect("mouse_exited", func():
			button.get_parent().get_children()[1].label_settings.font_color = Color.WHITE
		)

func _connect_level_buttons() -> void:
	var level_buttons: Array[Button]
	
	for button in get_tree().get_nodes_in_group("level_button"):
		level_buttons.append(button)
		
		button.connect("pressed", func():
			for btn: Button in level_buttons:
				btn.disabled = true
			
			GameManager.level = button.get_meta("level")
			
			Signals.level_button_pressed.emit(%MenuLoop)
		)

func _connect_world_buttons() -> void:
	for button: Button in get_tree().get_nodes_in_group("world_button"):
		button.connect("pressed", func():
			if button.has_meta("world"): 
				var tween := create_tween()
				tween.set_parallel(true)
				
				tween.tween_property(%WorldSelection, "global_position", %AllRightWorldPos.global_position, 1).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
				tween.tween_property(%LevelSelection, "global_position", %FinalLevelPos.global_position, 1).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
				
				GameManager.world = button.get_meta("world")
		)

func _animate_all_labels() -> void:
	for label in get_tree().get_nodes_in_group("title_labels"):
		animate_label(label)
		await get_tree().create_timer(0.25).timeout

func animate_label(label: Label) -> void:
	var tween: Tween = create_tween()
	tween.set_loops()
	
	tween.tween_property(label, "position", Vector2(label.global_position.x, (label.global_position.y - 14)), 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(label, "position", Vector2(label.global_position.x, (label.global_position.y + 14)), 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
#endregion

#region Buttons clicked functions
func _on_play_button_pressed() -> void:
	var tween := create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(%WorldSelection, "global_position", %FinalWorldPos.global_position, 1).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(%MenuButtons, "global_position", %FinalMenuPos.global_position, 1).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

func _on_back_button_pressed() -> void:
	var tween := create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(%MenuButtons, "global_position", %StartingMenuPos.global_position, 1).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(%WorldSelection, "global_position", %StartingWorldPos.global_position, 1).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_back_lvl_button_pressed():
	var tween := create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(%WorldSelection, "global_position", %FinalWorldPos.global_position, 1).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(%LevelSelection, "global_position", %StartingLevelPos.global_position, 1).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

func _on_mute_music_button_pressed():
	if GameManager.music_muted:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), false)
		GameManager.music_muted = false
		%MuteMusicLabel.label_settings.font_color = Color.WHITE
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)
		GameManager.music_muted = true
		%MuteMusicLabel.label_settings.font_color = Color.RED

func _on_mute_sfx_button_pressed():
	if GameManager.sfx_muted:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), false)
		GameManager.sfx_muted = false
		%MuteSFXLabel.label_settings.font_color = Color.WHITE
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), true)
		GameManager.sfx_muted = true
		%MuteSFXLabel.label_settings.font_color = Color.RED
#endregion
