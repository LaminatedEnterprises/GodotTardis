extends MeshInstance3D

@export
var player: Player3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mesh.material.set_shader_parameter("camera_tex", $SubViewport.get_texture());
	
	if player.get_camera().environment != null:
		$SubViewport/Camera3D.environment = player.get_camera().environment.duplicate()
	elif get_tree().root.find_child("WorldEnvironment", true, false) != null:
		$SubViewport/Camera3D.environment = get_tree().root.find_child("WorldEnvironment", true).environment.duplicate()
	
	$SubViewport/Camera3D.environment.tonemap_mode = Environment.TONE_MAPPER_LINEAR
