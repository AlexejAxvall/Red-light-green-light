extends Area2D

@export var segments: int = 16
@onready var npc = get_parent()
@export var fov = 160

func initialize(radius: float) -> void:
	var collision_polygon = $CollisionPolygon2D
	collision_polygon.polygon = generate_quarter_circle(radius, segments)

func generate_quarter_circle(radius: float, segments: int) -> PackedVector2Array:
	var points = PackedVector2Array()
	points.append(position)

	for i in range(segments + 1):
		var angle = deg_to_rad((180 - fov) / 2 + fov * i / segments)
		var x = cos(angle) * radius
		var y = sin(angle) * radius
		points.append(Vector2(x, y))
	npc.initialize_polygon_2D(points)
	return points
