extends Node2D

var pause:bool = true

func _ready() -> void:
	#musique
	GLOBAL.change_music("music_title_desc", .1)

	# scroll
	$tween_scroll.interpolate_property($scrolling, "position", Vector2(0, 320), Vector2(0, -288), 30, Tween.TRANS_LINEAR, 0)
	$tween_scroll.start()

	$player.freeze()
	yield(get_tree().create_timer(2.0), "timeout")
	pause = false

func _process(delta:float) -> void:
	if !pause:
		var up:bool = Input.is_action_just_pressed("ui_up")
		var down:bool = Input.is_action_just_pressed("ui_down")
		var left:bool = Input.is_action_just_pressed("ui_left")
		var right:bool = Input.is_action_just_pressed("ui_right")

		if up || down || left || right:
			GLOBAL.change_music("music_level")
			GLOBAL.next_scene("level", .5, .25)