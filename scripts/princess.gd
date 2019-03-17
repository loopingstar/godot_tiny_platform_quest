extends KinematicBody2D

func _ready() -> void:
	$hit.connect("body_entered", self, "on_body_entered")

func on_body_entered(body) -> void:
	if body.name == "player":
		GLOBAL.next_scene("outro", .5, .25)