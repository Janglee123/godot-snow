class_name Blob extends RigidBody2D

var _local_collision_pos: Vector2
var _collision_normal: Vector2

func _ready():
	linear_velocity.x = rand_range(-200, 200)
	linear_velocity.y = rand_range(-980, -10)


func _physics_process(delta):
	
	var W = 1.0 + abs(linear_velocity.x)/750.0
	var H = 1.0/W
	H += abs(linear_velocity.y)/2000.0
	W = 1.0/ H
	
	$CollisionShape2D.scale = lerp($CollisionShape2D.scale, Vector2(W, H), 0.9)
	update()


func _integrate_forces( state ):
	if(state.get_contact_count() >= 1):  #this check is needed or it will throw errors 
		_local_collision_pos = state.get_contact_local_position(0)
		_collision_normal = state.get_contact_local_normal(0)


func _on_body_shape_entered(body_id, body, body_shape, local_shape):
	var s = $CollisionShape2D.scale
	var size = $CollisionShape2D.shape.radius*2
	var d = _local_collision_pos - global_position
	var c = Vector2(5, 2).normalized()
	body.add(body_shape, points(global_position + d*1.12 , size, Vector2(s.y, s.x)*c, _collision_normal.angle(), 6))
	queue_free()


func points(pos, size, sc, rot, n) -> PoolVector2Array:
	var thita = PI*2.0/n
	
	var point = PoolVector2Array()
	for i in range(n):
		var p = pos + size*Vector2(cos(i*thita + rot), sin(i*thita + rot))*sc
		point.append(p)
	
	return point


func _draw():
	if get_viewport().size.y > position.y:
		var size = $CollisionShape2D.shape.radius
		draw_polygon(points(Vector2.ZERO, size, $CollisionShape2D.scale, 0, 10), [Color.white])
