extends Path2D

export var speed:int = 2.5

func _ready() -> void:
	tween_start()

func tween_start() -> void:
	$tween.interpolate_property($follow, "unit_offset", 0, 1, speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$tween.start()

func _process(delta) -> void:
	$follow/platform/sprite.rotation_degrees -= 15

func _on_platform_body_entered(body) -> void:
	if body.name == "player":
		GLOBAL.player_dead()
		GLOBAL.restart_scene()