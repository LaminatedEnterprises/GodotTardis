extends MeshInstance3D
class_name Portal3D

@export
var player: Player3D
@export
var other_portal: Portal3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mesh.material.set_shader_parameter("camera_tex", $SubViewport.get_texture());
	
	if player.get_camera().environment != null:
		$SubViewport/Camera3D.environment = player.get_camera().environment.duplicate()
	elif get_tree().root.find_child("WorldEnvironment", true, false) != null:
		$SubViewport/Camera3D.environment = (get_tree().root.find_child("WorldEnvironment", true, false) as WorldEnvironment).environment.duplicate()
	
	$SubViewport/Camera3D.environment.tonemap_mode = Environment.TONE_MAPPER_LINEAR
	$SubViewport.size = get_tree().root.get_viewport().size
	
func _process(delta: float) -> void:
	$SubViewport/Camera3D.global_transform = other_portal.global_transform * (global_transform * Transform3D(Basis.from_euler(Vector3(0, PI, 0)), Vector3.ZERO)).affine_inverse() * player.get_camera().global_transform
