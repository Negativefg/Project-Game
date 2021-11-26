extends KinematicBody2D
export var speed = 80
onready var raycast = $RayCast2D

func _ready():
	yield(get_tree(), "idle_frame")
	get_tree().call_group("zombies", "set_player", self)

func _physics_process(delta):
	var move_vec = Vector2()
	if Input.is_action_pressed("move_up"):
		move_vec.y -= 1
	if Input.is_action_pressed("move_down"):
		move_vec.y += 1
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
	if Input.is_action_just_pressed("run"):
		speed = 130
	if Input.is_action_just_released("run"):
		speed = 80
	move_vec = move_vec.normalized()
# warning-ignore:return_value_discarded
	move_and_collide(move_vec * speed * delta)
	
	var look_vec = get_global_mouse_position() - global_position
	global_rotation = atan2(look_vec.y, look_vec.x)
	
	if Input.is_action_just_pressed("shoot"):
		var coll = raycast.get_collider()
		if raycast.is_colliding() and coll.has_method("kill"):
			coll.kill()

func kill():
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
	
	
