extends Node2D

export var wait_time:float = 1
export var speed:float = 2
export var start_pos:int = -2
onready var tween_values:Array = [Vector2(0, start_pos * GLOBAL.tile_size), Vector2(0, 0)]

func _ready() -> void:
	$platform.position = tween_values[0]
	$tween.connect("tween_completed", self, "on_tween_complete")
	tween_start()

func tween_start() -> void:
	$tween.stop_all()
	$tween.interpolate_property($platform, "position", tween_values[0], tween_values[1], speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$tween.start()

func on_tween_complete(object, key) -> void:
	yield(get_tree().create_timer(wait_time), "timeout")
	tween_values.invert()
	tween_start()
