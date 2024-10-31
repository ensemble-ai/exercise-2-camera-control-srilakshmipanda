class_name LerpSmoothing
extends CameraControllerBase

@export var lead_speed:float
@export var catchup_delay_duration:float
@export var catchup_speed:float
@export var leash_distance:float

var _speed:float
var _direction:Vector3
var _elapsed_time:float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	_elapsed_time = 0.0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !current:
		return
		
	if draw_camera_logic:
		draw_logic()
	
	var tpos = target.position
	var pos_diff = (Vector3(tpos.x, 0, tpos.z) - Vector3(position.x, 0, position.z))
	
	if pos_diff.length() < 0.1:
		_speed = 0
	elif target.velocity.x == 0 && target.velocity.z == 0:
		if _elapsed_time < catchup_delay_duration:
			_elapsed_time += delta 
			_speed = 0
		else:
			_speed = catchup_speed
			_direction = pos_diff.normalized()
	else:
		_elapsed_time = 0.0
		var new_position = target.velocity * leash_distance + target.position - position
		_direction = (new_position).normalized()
		if pos_diff.length() > leash_distance:
			_speed = target.velocity.length()
		else:
			_speed = lead_speed

	var velocity = _speed * _direction
	#print(pos_diff.length())
	#print(direction)
	global_transform.origin += velocity * delta

	#print("t: ", target.velocity)
	#print("c: " , velocity)
	
	super(delta)


	
func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	# Draw the vertical line (5 units long)
	immediate_mesh.surface_add_vertex(Vector3(0, 0, 2.5))
	immediate_mesh.surface_add_vertex(Vector3(0, 0, -2.5))
	
	# Draw the horizontal line (5 units long)
	immediate_mesh.surface_add_vertex(Vector3(2.5, 0, 0))
	immediate_mesh.surface_add_vertex(Vector3(-2.5, 0, 0))
	
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
