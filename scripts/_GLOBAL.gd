extends CanvasLayer

var tile_size:int = 32
var file:File = File.new()
var file_path:String
var level_index:int = 0
var level_max:int = 10
var scene_name:String = "boot"
var dead_scene:PackedScene = preload("res://scenes/dead.tscn")
var esc_scene:PackedScene = preload("res://scenes/esc.tscn")
var scene_fade:Node
var savePath:String = "user://savedata.bin"
var passPhrase:String = "OkdfPooie0029?/dll"
var current_music:String = ""

# for debug only
#func _ready():
#	print("[Screen Metrics]")
#	print("Display size: ", OS.get_screen_size())
#	print("Decorated Window size: ", OS.get_real_window_size())
#	print("Window size: ", OS.get_window_size())
#	print("Project Settings: Width=", ProjectSettings.get_setting("display/window/size/width"), " Height=", ProjectSettings.get_setting("display/window/size/height"))
#	print(OS.get_window_size().x)
#	print(OS.get_window_size().y)

func _process(delta) -> void:
	# MENU ESC
	if not GLOBAL.scene_name in ["intro"]: # , "title"
		var esc:bool = Input.is_action_just_pressed("ui_cancel")

		if esc && !get_tree().paused:
			get_tree().paused = true
			var e = esc_scene.instance()
			get_node("/root").add_child(e)

		elif esc && get_tree().paused:
			get_tree().paused = false
			if has_node("/root/esc_scene"):
				get_node("/root/esc_scene").queue_free()

func restart_scene() -> void:
	yield(get_tree().create_timer(1), "timeout")

	scene_fade = scene_fade_out(.5)
	yield(scene_fade, "tween_completed")

	file_path = "res://scenes/level"+str(level_index)+".tscn"
	if file.file_exists(file_path):
		get_tree().change_scene(file_path)

	scene_fade = scene_fade_in(.5)
	yield(scene_fade, "tween_completed")
	$color.hide()
	get_tree().paused = false

func next_scene(scene:String = "", fade_out:float = 1, fade_in:float = .5) -> void:
	scene_name = scene

	scene_fade = scene_fade_out(fade_out)
	yield(scene_fade, "tween_completed")

	if scene == "" || scene == "level":
		level_index += 1

		file_path = "res://scenes/level"+str(level_index)+".tscn"
		if file.file_exists(file_path):
			save_game()
			get_tree().change_scene(file_path)

		else:
			get_tree().change_scene("res://scenes/title.tscn")

	else:
		file_path = "res://scenes/"+scene+".tscn"
		if file.file_exists(file_path):
			get_tree().change_scene(file_path)

	scene_fade = scene_fade_in(fade_in)
	yield(scene_fade, "tween_completed")
	$color.hide()
	get_tree().paused = false

func scene_fade_out(time:float) -> Node:
	get_tree().paused = true
	return scene_fade(0, 1, time)

func scene_fade_in(time:float) -> Node:
	return scene_fade(1, 0, time)

func scene_fade(start:int, end:int, time:float) -> Node:
	$color.modulate = Color(0,0,0,start)
	$color.show()

	$tween.stop_all()
	$tween.interpolate_property($color, "modulate", Color(0,0,0,start), Color(0,0,0,end), time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$tween.start()

	return $tween

func player_dead() -> void:
	var player = get_node("/root/scene/player")

	if player:
		var d = dead_scene.instance()
		d.position = player.position
		get_node("/root/scene").add_child(d)

		player.queue_free()

		$sfx/sfx_dead.play()

func save_game() -> void:
	file.open_encrypted_with_pass(savePath, File.WRITE, passPhrase)

	var datas:Dictionary = {}
	datas.level = level_index

	file.store_string(JSON.print(datas))
	file.close()

func load_game() -> void:
	if !file.file_exists(savePath):
		level_index = 1

	else:
		file.open_encrypted_with_pass(savePath, File.READ, passPhrase)
		var datas = parse_json(file.get_as_text())
		file.close()

		level_index = datas.level

		GLOBAL.scene_name = "level"

		GLOBAL.change_music("music_level")

		restart_scene()

# https://docs.godotengine.org/en/3.0/tutorials/misc/handling_quit_requests.html
func _notification(what) -> void:
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
			get_tree().quit() # default behavior

func change_music(node_name:String, delay:float = 1) -> void:
	if !GLOBAL.get_node("sfx/"+node_name).is_playing():
		GLOBAL.get_node("sfx/"+node_name).play()

	if current_music != "" && current_music != node_name:
		$tween_music.interpolate_property(GLOBAL.get_node("sfx/"+current_music), "volume_db", GLOBAL.get_node("sfx/"+current_music).volume_db, -80, 1, Tween.TRANS_LINEAR, 0)
		$tween_music.interpolate_property(GLOBAL.get_node("sfx/"+node_name), "volume_db", GLOBAL.get_node("sfx/"+node_name).volume_db, 0, delay, Tween.TRANS_LINEAR, 0)

	$tween_music.start()
	current_music = node_name


