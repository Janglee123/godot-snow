extends Node

onready var _blob_scene := preload("res://Blob.tscn") as PackedScene

func _process(delta):
	var pos = get_viewport().get_mouse_position()
	$Sprite.position = pos


func _create_blob(pos) -> void:
	var b: Blob = _blob_scene.instance()
	add_child(b)
	b.position = pos
