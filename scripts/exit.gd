extends Area2D

func _on_exit_body_entered(body) -> void:
	if body.name == "player":
		GLOBAL.next_scene("level", .5, .25)