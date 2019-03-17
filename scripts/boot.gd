extends Node2D

func _ready() -> void:
	var sega_x:Vector2 = $sega.position
	var miga_x:Vector2 = $miga.position

	$boot.modulate = Color(1,1,1,0)
	$sega.modulate = Color(1,1,1,0)
	$sega.position.x = $sega.position.x - 50
	$miga.modulate = Color(1,1,1,0)
	$miga.position.x = $miga.position.x + 50

	$tween.interpolate_property($boot, "modulate", Color(1,1,1,0), Color(1,1,1,1), 1, Tween.TRANS_LINEAR, 0)
	$tween.start()
	yield($tween, "tween_completed")

	$boot_sfx.play()

	$tween.interpolate_property($mask, "position", $mask.position, Vector2(288, 0), 1.5, Tween.TRANS_SINE, Tween.EASE_OUT)
	$tween.start()
	yield(get_tree().create_timer(1.3), "timeout")

	$tween.interpolate_property($sega, "modulate", $sega.modulate, Color(1,1,1,1), 1, Tween.TRANS_LINEAR, 0)
	$tween.interpolate_property($sega, "position", $sega.position, sega_x, 1.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$tween.start()
	yield(get_tree().create_timer(.6), "timeout")

	$tween.interpolate_property($miga, "modulate", $miga.modulate, Color(1,1,1,1), 1, Tween.TRANS_LINEAR, 0)
	$tween.interpolate_property($miga, "position", $miga.position, miga_x, 1.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$tween.start()
	yield(get_tree().create_timer(1.6), "timeout")

	$wink.frame = 1
	$wink_sfx.play()

	yield(get_tree().create_timer(2), "timeout")
	GLOBAL.next_scene("intro")