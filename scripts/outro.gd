extends Node2D

var pause:bool = true

func _ready() -> void:
	#musique
	GLOBAL.change_music("music_title_desc", .1)

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
			GLOBAL.change_music("music_title")
			GLOBAL.next_scene("title", .5, .25)