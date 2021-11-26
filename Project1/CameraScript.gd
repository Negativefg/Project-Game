extends Camera2D

func _physics_process(delta):
	var Cam = Vector2()
	if Input.is_action_just_pressed("run"):
		Cam.y = 1
