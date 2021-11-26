extends KinematicBody2D

var velocity = Vector2(0, 0)
var speed = 300
var bullet = bulletshit.get_global_mouse_position()

# warning-ignore:unused_argument
func _physics_process(delta):
	var _collision_info = move_and_collide(velocity.normalized() * delta * speed)
	 bullet.velocity = 300
