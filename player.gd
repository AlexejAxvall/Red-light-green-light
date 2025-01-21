extends CharacterBody2D

@export var speed: float = 200.0
@onready var ray_cast_2D = $RayCast2D

var my_velocity

func _physics_process(delta: float) -> void:
	var direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down")).normalized()
	velocity = direction * speed
	my_velocity = velocity
	
	move_and_slide()
