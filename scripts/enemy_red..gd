extends KinematicBody2D

var speed:int = 100
var gravity:int = 10
var vel = Vector2()
var dirx:int = 1
var up:Vector2 = Vector2(0, -1)
enum sens {WALK_LEFT, WALK_RIGHT}
var state:int = sens.WALK_RIGHT
export (sens) var start_direction

func _ready() -> void:
	if start_direction == sens.WALK_LEFT:
		dirx = -1
	elif start_direction == sens.WALK_RIGHT:
		dirx = 1
	change_state(start_direction)

	$hit.connect("body_entered", self, "on_body_entered")

func _physics_process(delta) -> void:
	vel.y += gravity

	if is_on_wall():
		dirx = dirx * -1

		if dirx == 1:
			change_state(sens.WALK_RIGHT)
		elif dirx == -1:
			change_state(sens.WALK_LEFT)

	vel.x = dirx * speed
	vel = move_and_slide(vel, up)

func change_state(new_state:int) -> void:
	state = new_state

	if state == sens.WALK_LEFT:
		anim_play("walk_left")
	else:
		anim_play("walk_right")

func anim_play(new_animation) -> void:
	if $anim.current_animation != new_animation:
		$anim.play(new_animation)

func on_body_entered(body) -> void:
	if body.name == "player":
		GLOBAL.player_dead()
		GLOBAL.restart_scene()