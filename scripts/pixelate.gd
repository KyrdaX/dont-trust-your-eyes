extends ColorRect

func start_pixelate_effect(max_pixel_size, duration):
	var tween = create_tween()
	tween.tween_property(material, "shader_parameter/pixel_size", max_pixel_size, duration)
	
	await tween.finished
	Signals.pixelate_ended.emit()

func reset_pixelate_effect(duration):
	var tween = create_tween()
	tween.tween_property(material, "shader_parameter/pixel_size", 1, duration)
