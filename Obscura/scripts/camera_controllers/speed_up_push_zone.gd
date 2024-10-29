class_name SpeedUpPushZone
extends CameraControllerBase


@export var push_ratio:float
@export var pushbox_top_left:Vector2
@export var pushbox_bottom_right:Vector2
@export var speedup_zone_top_left:Vector2
@export var speedup_zone_bottom_right:Vector2

var pushbox_width:float
var pushbox_height:float
var speedup_width:float
var speedup_height:float

var diff_between_left_edges:float
var diff_between_right_edges:float
var diff_between_top_edges:float
var diff_between_bottom_edges:float

func _ready() -> void:
	super()
	position = target.position
	pushbox_width = abs(pushbox_bottom_right.x - pushbox_top_left.x)
	pushbox_height = abs(pushbox_top_left.y - pushbox_bottom_right.y)
	speedup_width = abs(speedup_zone_bottom_right.x - speedup_zone_top_left.x)
	speedup_height = abs(speedup_zone_bottom_right.y - speedup_zone_top_left.y)

func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	var tpos = target.global_position
	var cpos = global_position
	
	# diff between the target's edges and pushbox edges
	diff_between_left_edges = (tpos.x - target.WIDTH / 2.0) - (cpos.x - pushbox_width / 2.0)
	diff_between_right_edges = (tpos.x + target.WIDTH / 2.0) - (cpos.x + pushbox_width / 2.0)
	diff_between_top_edges = (tpos.z - target.HEIGHT / 2.0) - (cpos.z - pushbox_height / 2.0)
	diff_between_bottom_edges = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + pushbox_height / 2.0)

	var velocity = Vector3(target.velocity.x, 0, target.velocity.z)
	#boundary checks
	if is_touching_pushbox():
		print("case 1")
		#left
		if diff_between_left_edges < 0:
			global_position.x += diff_between_left_edges
		#right
		if diff_between_right_edges > 0:
			global_position.x += diff_between_right_edges
		#top
		if diff_between_top_edges < 0:
			global_position.z += diff_between_top_edges
		#bottom
		if diff_between_bottom_edges > 0:
			global_position.z += diff_between_bottom_edges
	elif is_inside_speedup_zone():
		print("case 2")
		if tpos.x > speedup_width / 2 and velocity.x > 0: 
			velocity.x = velocity.x * push_ratio
		elif tpos.x < -speedup_width / 2 and velocity.x < 0:
			velocity.x = velocity.x * push_ratio
		
		if tpos.z > speedup_height / 2 and velocity.z > 0:
			velocity.z = velocity.z * push_ratio
		elif tpos.z < -speedup_height / 2 and velocity.z < 0:
			velocity.z = velocity.z * push_ratio
	else:
		print("Case 3")
		velocity = Vector3.ZERO

	global_transform.origin += velocity * delta
	
	super(delta)
	
func is_touching_pushbox() -> bool:
	var left = diff_between_left_edges <= 0
	var right = diff_between_right_edges >= 0
	var bottom = diff_between_bottom_edges >= 0
	var top = diff_between_top_edges <= 0
	if left or right or bottom or top:
		true
	return false
	
func is_inside_speedup_zone() -> bool:
	print (target.position)
	var left = (target.position.x - target.WIDTH) <= speedup_zone_top_left.x
	var right = (target.position.x + target.WIDTH) >= speedup_zone_bottom_right.x
	var top = (target.position.z + target.HEIGHT) >= speedup_zone_top_left.y
	var bottom = (target.position.z - target.HEIGHT) <= speedup_zone_bottom_right.y
	
	print(left)
	print(right)
	print(top)
	print(bottom)
	if left or right or top or bottom:
		return true
		
	return false

func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var pushbox_left:float = -pushbox_width / 2
	var pushbox_right:float = pushbox_width / 2
	var pushbox_top:float = -pushbox_height / 2
	var pushbox_bottom:float = pushbox_height / 2
	
	var speedup_left:float = -speedup_width / 2
	var speedup_right:float = speedup_width / 2
	var speedup_top:float = -speedup_height / 2
	var speedup_bottom:float = speedup_height / 2
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)

	immediate_mesh.surface_add_vertex(Vector3(pushbox_right, 0, pushbox_top))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_right, 0, pushbox_bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(pushbox_right, 0, pushbox_bottom))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_left, 0, pushbox_bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(pushbox_left, 0, pushbox_bottom))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_left, 0, pushbox_top))
	
	immediate_mesh.surface_add_vertex(Vector3(pushbox_left, 0, pushbox_top))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_right, 0, pushbox_top))
	
	immediate_mesh.surface_add_vertex(Vector3(speedup_right, 0, speedup_top))
	immediate_mesh.surface_add_vertex(Vector3(speedup_right, 0, speedup_bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(speedup_right, 0, speedup_bottom))
	immediate_mesh.surface_add_vertex(Vector3(speedup_left, 0, speedup_bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(speedup_left, 0, speedup_bottom))
	immediate_mesh.surface_add_vertex(Vector3(speedup_left, 0, speedup_top))
	
	immediate_mesh.surface_add_vertex(Vector3(speedup_left, 0, speedup_top))
	immediate_mesh.surface_add_vertex(Vector3(speedup_right, 0, speedup_top))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
