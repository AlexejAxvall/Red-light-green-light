extends CharacterBody2D

@onready var ray_cast_2D = $RayCast2D
@onready var detection_cone = $Detection_cone
@onready var collision_polygon_2D = $Detection_cone/CollisionPolygon2D
@onready var polygon_2D = $Detection_cone/Polygon2D

var for_radius: float = 0.0
var is_in_cone = false
var player_body

var cycle_time: float = 4.0
@export var cycle_time_min: float = 2.0
@export var cycle_time_max: float = 6.0
@export var rotation_segments: int = 16
@export var rotation_time = 2

var green_light = false
var turn_green = false
var turn_red = false

var target_rotation: float = 0.0
var lerp_factor: float = 0.0

func _ready() -> void:
	for_radius = ray_cast_2D.target_position.y
	print("Parent's for_radius: ", for_radius)

	if detection_cone:
		detection_cone.initialize(for_radius)
	
	polygon_2D.color = Color(1, 0, 0, 0.1)
	
	traffic()

func _on_detection_cone_body_entered(body):
	if body.is_in_group("Player"):
		player_body = body
		is_in_cone = true

func _on_detection_cone_body_exited(body):
	if body.is_in_group("Player"):
		is_in_cone = false

func _process(delta):
	if rotation != target_rotation:
		lerp_factor += delta / (rotation_time)
		lerp_factor = clamp(lerp_factor, 0.0, 1.0)
		rotation = lerp_angle(rotation, target_rotation, lerp_factor)

	if is_in_cone and not green_light:
		var direction_to_body = (player_body.global_position - global_position).normalized()
		var angle_to_body = direction_to_body.angle()
		ray_cast_2D.rotation = angle_to_body - rotation - PI / 2

		if ray_cast_2D.is_colliding():
			var collider = ray_cast_2D.get_collider()
			if collider.is_in_group("Player"):
				if player_body.my_velocity != Vector2.ZERO:
					player_body.queue_free()

func traffic():
	while true:
		await get_tree().create_timer(cycle_time).timeout
		cycle_time = randf_range(cycle_time_min, cycle_time_max)
		green_light = true
		polygon_2D.color = Color(0, 1, 0)
		turn_green = true
		turn_red = false
		target_rotation = PI
		lerp_factor = 0.0

		await get_tree().create_timer(cycle_time).timeout
		cycle_time = randf_range(cycle_time_min, cycle_time_max)
		green_light = false
		polygon_2D.color = Color(1, 0, 0, 0.1)
		turn_green = false
		turn_red = true
		target_rotation = 0.0
		lerp_factor = 0.0

func initialize_polygon_2D(points: PackedVector2Array):
		polygon_2D.polygon = points
