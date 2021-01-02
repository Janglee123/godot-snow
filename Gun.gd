extends Sprite

onready var _blob_scene := preload("res://Blob.tscn") as PackedScene

func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		shoot()


func shoot():
	
	if not $Timer.is_stopped():
		return
	
	$Timer.start()
	var pos = $Position2D.global_position
	var dir = $Position2D.global_rotation + rand_range(-0.2, 0.2)
	var b: Blob = _blob_scene.instance()
	get_parent().get_parent().add_child(b)
	b.global_position = pos
	b.linear_velocity = rand_range(500, 700)*Vector2.RIGHT.rotated(dir)
