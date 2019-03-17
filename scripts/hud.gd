extends Node2D

var time:int = 10;

func _ready() -> void:
	get_tree().paused = false
	show_time()
	show_level()

	$hud/timer.connect("timeout", self, "_on_timer_timeout")

func _on_timer_timeout() -> void:
	if time == 0:
		get_tree().paused = true

		yield(get_tree().create_timer(1.0), "timeout")

		GLOBAL.player_dead()

		yield(get_tree().create_timer(2.0), "timeout")

		get_tree().reload_current_scene()

	time -= 1

	show_time()

func show_time() -> void:
	var time_txt

	$hud/background.modulate = Color(1, 1, 1, 1)
	match time:
		3: $hud/background.modulate = Color(1, 1, 0, 1) # jaune
		2: $hud/background.modulate = Color(1, .75, 0, 1) # orange clair
		1: $hud/background.modulate = Color(1, .50, 0, 1) # orange foncé
		0: $hud/background.modulate = Color(1, .30, 0, 1)  # rouge

	if time < 10:
		time_txt = "0" + str(time)
	else:
		time_txt = str(time)

	$hud/label.text = time_txt


func show_level() -> void:
	$level/label.text = str(GLOBAL.level_index)+"/"+str(GLOBAL.level_max)