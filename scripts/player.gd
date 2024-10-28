extends RigidBody3D

var speed: float = 1200.0

var mouse_sensitivity: float = 0.001
var twist_input: float = 0.0
var pitch_input: float = 0.0

@onready var twist_pivot: Node3D = $twist_pivot
@onready var pitch_pivot: Node3D = $twist_pivot/pitch_pivot

func _process(delta: float) -> void:
	_handle_movement(delta)
	_handle_mouse()

func _handle_movement(delta: float):
	var input_directions = Vector3(Input.get_axis("move_left", "move_right"), 0, Input.get_axis("move_forward", "move_back"))
	apply_central_force((twist_pivot.basis * input_directions).normalized() * speed * delta)

func _handle_mouse():
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif Input.is_action_just_pressed("ui_end"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	twist_pivot.rotate_y(twist_input)
	var pitch_angle: float = pitch_pivot.rotation.x + pitch_input
	pitch_pivot.rotation.x = clamp(pitch_angle, deg_to_rad(-16.0), deg_to_rad(18.0))
	twist_input = 0.0
	pitch_input = 0.0

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = -event.relative.x * mouse_sensitivity
			pitch_input = -event.relative.y * mouse_sensitivity
