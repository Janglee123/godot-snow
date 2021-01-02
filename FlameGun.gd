extends Node2D

onready var _flame := $Flame as AnimatedSprite
onready var _area := $Area2D/CollisionShape2D as CollisionShape2D

var _cur_shape := -1
var _body: Land


func _ready():
	_flame.visible = false


func _process(delta):
	
	var c := Input.is_mouse_button_pressed(BUTTON_LEFT)
	_flame.visible = c
	if c and _body:
		var size = _area.shape.radius*1.5
		_body.remove(_cur_shape, points(_area.global_position, size, _area.scale, _area.global_rotation, 10))


func _on_Area2D_body_shape_entered(body_id, body, body_shape, area_shape):
	_cur_shape = body_shape
	_body = body


func points(pos, size, sc, rot, n) -> PoolVector2Array:
	var thita = PI*2.0/n
	
	var point = PoolVector2Array()
	for i in range(n):
		var p = pos + size*Vector2(cos(i*thita + rot), sin(i*thita + rot))*sc
		point.append(p)
	
	return point
