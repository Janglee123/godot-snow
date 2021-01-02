class_name Player extends KinematicBody2D

const FLOOR_NORMAL = Vector2.UP
const SNAP_DIRECTION = Vector2.DOWN
const SNAP_LENGTH = 32

export(float) var speed = 250.0
export(float) var gravity = 1000.0

var direction = Vector2.ZERO
var velocity = Vector2.ZERO
var snap_vector = SNAP_DIRECTION * SNAP_LENGTH
var jump_strength = 500
var _gun_scene := preload("res://Gun.tscn")
var _flame_scene := preload("res://FlameGun.tscn") 
var _current_gun := 0

onready var sprite := $Sprite as Sprite
onready var _hands := $Sprite/Hands as Node2D
onready var _guns = [_gun_scene.instance(), _flame_scene.instance()]


func _physics_process(delta):
	velocity.y += gravity * delta
	velocity.y = move_and_slide_with_snap(velocity, snap_vector, FLOOR_NORMAL, true).y
	if is_on_floor() and snap_vector == Vector2.ZERO:
		reset_snap()
	
	update_face()
	
	sprite.scale.y +=  (1.0 + _sq(abs(velocity.y)/900.0) - sprite.scale.y)*0.5
	sprite.scale.x = sign(sprite.scale.x)*1.0/sqrt(sprite.scale.y)


func _sq(x):
	return x*x


func _unhandled_input(event):
	if event.is_action("left") or event.is_action("right"):
		update_direction()
	
	if event.is_action_pressed('jump'):
		jump()
	
	if event.is_action_pressed("mouse_wheel_up"):
		_change_gun()


func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		
		if event.button_index == BUTTON_WHEEL_UP:
			_current_gun += 1
			_current_gun = (_current_gun) % _guns.size()
		
		if event.button_index == BUTTON_WHEEL_DOWN:
			_current_gun -= 1
			if _current_gun < 0:
				_current_gun = _guns.size() - 1
		_change_gun()


func reset_snap():
	snap_vector = SNAP_DIRECTION * SNAP_LENGTH


func jump():
	if is_on_floor():
		snap_vector = Vector2.ZERO
		velocity.y = -jump_strength


func update_direction():
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	velocity.x = direction.x * speed


func update_face():
	var mouse_pos = get_viewport().get_mouse_position()
	sprite.scale.x = -1 if mouse_pos.x < global_position.x else 1
	$Sprite/Hands.look_at(mouse_pos)


func _change_gun():
	_hands.remove_child(_hands.get_child(0))
	_hands.add_child(_guns[_current_gun])
