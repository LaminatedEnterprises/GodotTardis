extends Node3D
class_name Portal3D

@export
var other_portal: Portal3D
@export
var mesh_instance: MeshInstance3D

var player: Player3D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#find the player from the root. prevents the need for an editor-filled reference
	player = get_tree().root.find_child("Player", true, false)
	#setting the texture in editor results in it being pink. no clue why. doesn't happen if we do it at runtime
	mesh_instance.mesh.surface_get_material(0).set_shader_parameter("camera_tex", $SubViewport.get_texture());
	
	#copy the environment used by the player camera, or the WorldEnvironment failing that
	if player.get_camera().environment != null:
		$SubViewport/Camera3D.environment = player.get_camera().environment.duplicate()
	elif get_tree().root.find_child("WorldEnvironment", true, false) != null:
		$SubViewport/Camera3D.environment = (get_tree().root.find_child("WorldEnvironment", true, false) as WorldEnvironment).environment.duplicate()
	
	#turn off tone mapping so it looks *pretty much* as it should
	$SubViewport/Camera3D.environment.tonemap_mode = Environment.TONE_MAPPER_LINEAR
	$SubViewport.size = get_tree().root.get_viewport().size
	
	RenderingServer.frame_pre_draw.connect(update_portal)
	
func _exit_tree() -> void:
	RenderingServer.frame_pre_draw.disconnect(update_portal)
	
func update_portal() -> void:
	$SubViewport/Camera3D.global_transform = portal_offset_transform() * player.get_camera().global_transform
	
	if player_detected:
		check_player_for_teleport()

func portal_offset_transform() -> Transform3D:
	return other_portal.global_transform * (global_transform * Transform3D(Basis.from_euler(Vector3(0, PI, 0)), Vector3.ZERO)).affine_inverse()

func check_player_for_teleport() -> void:
	var player_local_position = global_transform.affine_inverse() * player.global_position
	if player_local_position.z < 0:
		player.global_transform = portal_offset_transform() * player.global_transform
	

var player_detected: bool = false
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == player:
		player_enter()

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body == player:
		player_exit()
		
func player_enter() -> void:
	player_detected = true
		
func player_exit() -> void:
	player_detected = false
