class_name SpeedUpPushZone
extends CameraControllerBase


@export var push_ratio:float
@export var pushbox_top_left:Vector2
@export var pushbox_bottom_right:Vector2
@export var speedup_zone_top_left:Vector2
@export var speedup_zone_bottom_right:Vector2

func _ready() -> void:
	super()
	position = target.position

func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	var tpos = target.global_position
	var cpos = global_position
	
	var pushbox_width = abs(pushbox_bottom_right.x - pushbox_top_left.x)
	var pushbox_height = abs(pushbox_top_left.y - pushbox_bottom_right.y)
	
	# diff between the target's edges and pushbox edges
	var diff_between_left_edges = (tpos.x - target.WIDTH / 2.0) - (cpos.x - pushbox_width / 2.0)
	var diff_between_right_edges = (tpos.x + target.WIDTH / 2.0) - (cpos.x + pushbox_width / 2.0)
	var diff_between_top_edges = (tpos.z - target.HEIGHT / 2.0) - (cpos.z - pushbox_height / 2.0)
	var diff_between_bottom_edges = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + pushbox_height / 2.0)
	
	var touching_left = diff_between_left_edges <= 0
	var touching_right = diff_between_right_edges >= 0
	var touching_top = diff_between_top_edges <= 0
	var touching_bottom = diff_between_bottom_edges >= 0
		
	var velocity = target.velocity
	velocity.y = 0
	
	#boundary checks
	if touching_left or touching_right or touching_top or touching_bottom:
		velocity = Vector3.ZERO
		if touching_left:
			global_position.x += diff_between_left_edges
			if !touching_top and !touching_bottom:
				velocity = Vector3(0,0, target.velocity.z * push_ratio)
		#right
		if touching_right:
			global_position.x += diff_between_right_edges
			if !touching_top and !touching_bottom:
				velocity = Vector3(0,0, target.velocity.z * push_ratio)
		#top
		if touching_top:
			global_position.z += diff_between_top_edges
			if !touching_left and !touching_right:
				velocity = Vector3(target.velocity.x * push_ratio,0,0)
		#bottom
		if touching_bottom:
			global_position.z += diff_between_bottom_edges
			if !touching_left and !touching_right:
				velocity = Vector3(target.velocity.x * push_ratio,0,0)
	elif _is_inside_speedup_zone():
		velocity = target.velocity * push_ratio
	else:
		velocity = Vector3.ZERO

	global_transform.origin += velocity * delta
	
	super(delta)
	
func _is_inside_speedup_zone() -> bool:
	var tpos = target.position
	var cpos = position
	
	var left = (tpos.x - target.WIDTH / 2.0) - (cpos.x + speedup_zone_top_left.x) < 0
	var right = (tpos.x + target.WIDTH / 2.0) - (cpos.x + speedup_zone_bottom_right.x) > 0 
	var top = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + speedup_zone_top_left.y) > 0
	var bottom = (tpos.z - target.HEIGHT / 2.0) - (cpos.z + speedup_zone_bottom_right.y) < 0 
	
	if left or right or top or bottom:
		return true
		
	return false

func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)

	immediate_mesh.surface_add_vertex(Vector3(pushbox_top_left.x, 0, pushbox_top_left.y))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_top_left.x, 0,pushbox_bottom_right.y))
	
	# bottom
	immediate_mesh.surface_add_vertex(Vector3(pushbox_top_left.x, 0, pushbox_bottom_right.y))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_bottom_right.x, 0, pushbox_bottom_right.y))

	# right
	immediate_mesh.surface_add_vertex(Vector3(pushbox_bottom_right.x, 0, pushbox_bottom_right.y))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_bottom_right.x, 0, pushbox_top_left.y))
	
	# top
	immediate_mesh.surface_add_vertex(Vector3(pushbox_bottom_right.x, 0, pushbox_top_left.y))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_top_left.x, 0, pushbox_top_left.y))
	
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_top_left.x, 0, speedup_zone_top_left.y))
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_top_left.x, 0,speedup_zone_bottom_right.y))
	
	# bottom
	immediate_mesh.surface_add_vertex(
			Vector3(speedup_zone_top_left.x, 0, speedup_zone_bottom_right.y))
	immediate_mesh.surface_add_vertex(
			Vector3(speedup_zone_bottom_right.x, 0, speedup_zone_bottom_right.y))

	# right
	immediate_mesh.surface_add_vertex(
				Vector3(speedup_zone_bottom_right.x, 0, speedup_zone_bottom_right.y))
	immediate_mesh.surface_add_vertex(
				Vector3(speedup_zone_bottom_right.x, 0, speedup_zone_top_left.y))
	
	# top
	immediate_mesh.surface_add_vertex(
				Vector3(speedup_zone_bottom_right.x, 0, speedup_zone_top_left.y))
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_top_left.x, 0, speedup_zone_top_left.y))
	
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, 
			target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
