extends KinematicBody2D

export var speed = 95
onready var raycast = $RayCast2D

var velocity = Vector2.ZERO
var path = []
var threshold = 16
var player = null
var nav = null

func _ready():
	yield(owner, "ready")
	nav = owner.nav
	add_to_group("zombies")

# warning-ignore:unused_argument
func _physics_process(delta):
	if player == null:
		return
	if path.size() > 0:
		move_to_target()
	
	var vec_to_player = player.global_position - global_position
	vec_to_player = vec_to_player.normalized()
	global_rotation = atan2(vec_to_player.y, vec_to_player.x)
		
func move_to_target():
	if global_position.distance_to(path[0]) < threshold:
		path.remove(0)
	else:
		var direction = global_position.direction_to(path[0])
		velocity = direction * speed
		velocity = move_and_slide(velocity)
	
	if raycast.is_colliding():
		var coll = raycast.get_collider()
		if coll.name == "Player":
			coll.kill()

func get_target_path(target_pos):
	path = nav.get_simple_path(global_position, target_pos, false)

func kill():
	queue_free()

func set_player(p):
	player = p
