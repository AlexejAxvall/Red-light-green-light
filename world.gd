extends Node2D

@onready var label = $Label
@export var player_scene : PackedScene = preload("res://player.tscn")

@export var player_count = 1
@export var npc_count = 1

@export var timer = 60
# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().get_nodes_in_group("Players").size() < player_count:
		var player_instance = player_scene.instantiate()
		player_instance.add_to_group("Player")
		
		var spawn_locations = []
		
		for i in range(0, player_count):
			spawn_locations.append(Vector2(1,2))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var factor = pow(10, 2)
	label.text = str(round(timer * factor) / factor)
	timer -= delta
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		get_tree().change_scene_to_file("res://victory.tscn")
