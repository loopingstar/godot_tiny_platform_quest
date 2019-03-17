extends Node2D

func _ready() -> void:
	GLOBAL.change_music("music_title", .1)

	# show continue ?
	if GLOBAL.file.file_exists(GLOBAL.savePath):
		$continue_zone.position.x = 0

	GLOBAL.get_node("color").modulate = Color(0,0,0,1)
	GLOBAL.get_node("color").show()
	GLOBAL.get_node("tween").stop_all()
	GLOBAL.get_node("tween").interpolate_property(GLOBAL.get_node("color"), "modulate", Color(0,0,0,1), Color(0,0,0,0), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	GLOBAL.get_node("tween").start()

	$new_zone.connect("body_entered", self, "_on_new_zone")
	$continue_zone.connect("body_entered", self, "_on_continue_zone")

	var	level_index = 1
	if GLOBAL.file.file_exists(GLOBAL.savePath):
		GLOBAL.file.open_encrypted_with_pass(GLOBAL.savePath, File.READ, GLOBAL.passPhrase)
		var datas = parse_json(GLOBAL.file.get_as_text())
		GLOBAL.file.close()
		level_index = datas.level

	$continue_zone/label.text = "GO TO\r\nLEVEL "+str(level_index)

func _on_new_zone(body) -> void:
	if body.name == "player":
		get_tree().paused = true

		GLOBAL.get_node("sfx/sfx_walk_sand").stop()
		GLOBAL.get_node("sfx/sfx_walk_stone").stop()

		GLOBAL.next_scene("title_desc")

func _on_continue_zone(body) -> void:
	if body.name == "player":
		get_tree().paused = true

		GLOBAL.get_node("sfx/sfx_walk_sand").stop()
		GLOBAL.get_node("sfx/sfx_walk_stone").stop()

		GLOBAL.load_game()
