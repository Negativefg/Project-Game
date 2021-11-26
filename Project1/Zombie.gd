extends KinematicBody2D

export var speed = 85
onready var raycast = $RayCast2D
onready var line2d = $Line2D
onready var los = $LineOfSight

var velocity = Vector2.ZERO
var path = []
var threshold = 16
var player = null
var levelNavigation: Navigation2D = null
var player_spotted: bool = false

func _ready():
	add_to_group("zombies")
	yield(get_tree(), "idle_frame")
	var tree = get_tree()
	if tree.has_group("LevelNavigation"):
		levelNavigation = tree.get_nodes_in_group("LevelNavigation")[0]
	if tree.has_group("Player"):
		player = tree.get_nodes_in_group("Player")[0]

# warning-ignore:unused_argument
func _physics_process(delta):
	if player == null:
		return
	line2d.global_position = Vector2.ZERO
	if player:
		los.look_at(player.global_position)
		check_player_in_detection()
		if player_spotted:
			generate_path()
			navigate()
	move()

	var vec_to_player = player.global_position - global_position
	vec_to_player = vec_to_player.normalized()
	global_rotation = atan2(vec_to_player.y, vec_to_player.x)
	
	if raycast.is_colliding():
		var coll = raycast.get_collider()
		if coll.name == "Player":
			coll.kill()

func check_player_in_detection() -> bool:
	var collider = los.get_collider()
	if collider and collider.is_in_group("Player"):
		player_spotted = true
		print("raycast collided")	# Debug purposes
		return true
	return false

func navigate():	# Define the next position to go to
	if path.size() > 0:
		velocity = global_position.direction_to(path[1]) * speed
		
		# If reached the destination, remove this point from path array
		if global_position == path[0]:
			path.pop_front()

func generate_path():	# It's obvious
	if levelNavigation != null and player != null:
		path = levelNavigation.get_simple_path(global_position, player.global_position, false)
		line2d.points = path

func move():
	velocity = move_and_slide(velocity)

func kill():
	queue_free()

func set_player(p):
	player = p
