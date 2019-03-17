extends Node2D

var pause:bool = true

func _ready() -> void:
	yield(get_tree().create_timer(1.0), "timeout")
	pause = false

func _process(delta:float) -> void:
	if !pause:
		var up:bool = Input.is_action_just_pressed("ui_up")
		var down:bool = Input.is_action_just_pressed("ui_down")
		var left:bool = Input.is_action_just_pressed("ui_left")
		var right:bool = Input.is_action_just_pressed("ui_right")

		if up || down || left || right:
			GLOBAL.next_scene("title")