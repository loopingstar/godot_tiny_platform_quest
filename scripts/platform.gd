extends Path2D

export (Array) var tween_values = [0, 1]
export (int) var speed = 3

func _ready() -> void:
	tween_start()

func tween_start() -> void:
	$tween.interpolate_property($follow, "unit_offset", tween_values[0], tween_values[1], speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$tween.start()