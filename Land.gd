extends StaticBody2D
class_name Land

onready var _main_poly := $CollisionPolygon2D as CollisionPolygon2D

var _epsolin := 1

func _process(delta):
	if position.y > 5000: 
		queue_free()
	update()


func _draw():
	for child in get_children():
		draw_polygon(child.polygon, [Color.white])


func add(shape_id, points: PoolVector2Array):
	
	var col_poly := shape_owner_get_owner(shape_find_owner(shape_id)) as CollisionPolygon2D
	
	if not Geometry.intersect_polygons_2d(col_poly.polygon, points):
		return
	
	var merged_polys := Geometry.merge_polygons_2d(col_poly.polygon, points)
	
	col_poly.polygon = merged_polys[0]


func remove(shape_id, points):
	
	var col_poly := shape_owner_get_owner(shape_find_owner(shape_id)) as CollisionPolygon2D
	var merged_polys := Geometry.clip_polygons_2d(col_poly.polygon, points)
	
	if merged_polys.size() == 0:
		remove_child(col_poly)
		return
	
	col_poly.polygon = merged_polys.pop_front()
	
	for poly in merged_polys:
		if poly.size() > 0:
			add_shape(poly)


func _aabb_area(points) -> float:
	var min_x = points[0].x
	var min_y = points[0].y
	var max_x = points[0].x
	var max_y = points[0].y
	for p in points:
		min_x = min(p.x, min_x)
		min_y = min(p.x, min_y)
		max_x = max(p.x, max_x)
		max_y = max(p.x, max_y)
	
	return (max_x - min_x)*(max_y - min_y)


func add_shape(points):
	var v := CollisionPolygon2D.new()
	v.polygon = points
	call_deferred('add_child', v)


func _dist(p: Vector2, a: Vector2, b: Vector2) -> float:
	var closest_point := Geometry.get_closest_point_to_segment_uncapped_2d(p, a, b)
	return closest_point.distance_squared_to(p)


func simplify_poly_2d(points: PoolVector2Array) -> PoolVector2Array:
	
	var torlance := 20
	
	var i = 0
	while i < points.size() - 1:
		var p1 := points[i]
		var j = i + 1
		while p1.distance_squared_to(points[j]) < torlance*torlance: #change it to path sum if not working
			j += 1
		
		if j > i + 1:
			var new_points := _simplify(points, i, j)
			for k in range(i, j+1):
				points.remove(k)
			
			for k in range(new_points.size()):
				points.insert(i+k, new_points[k])
		
		i = j
	return points



func simplify(points: PoolVector2Array) -> PoolVector2Array:
	return _simplify(points, 0, points.size())


func _simplify(points: PoolVector2Array, start, end) -> PoolVector2Array:
	var dmax = 0
	var index = 0
	
	for i in range(start + 1, end - 1):
		var d = _dist(points[i], points[start], points[end - 1])
		if d > dmax:
			dmax = d
			index = i
	
	var result = PoolVector2Array()
	if dmax > _epsolin*_epsolin:
		var first = _simplify(points, start, index - 1)
		var sec = _simplify(points, index, end)
		result.append_array(first)
		result.append_array(sec)
	elif end - start > 1:
		result.append(points[start])
		result.append(points[end - 1])
	else:
		result.append(points[start])
	return result

