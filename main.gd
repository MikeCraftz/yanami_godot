extends Node2D
@onready var food_scene = preload("res://food.tscn")
@onready var food_spawn_timer = $SpawnTimer
@onready var score = $CanvasLayer/UI/CaloriesCounter
@onready var yanami = $Yanami/AnimatedSprite2D

var calories = 0
var failure_count = 0

func _ready():
	pass
	
func _process(delta):
	if failure_count > 10:
		Global.final_calories = calories
		get_tree().change_scene_to_file("res://fail_screen.tscn")

func _on_spawn_timer_timeout():
	spawn_food()
	
func spawn_food():
	var screen_size = get_viewport().get_visible_rect().size
	var random_spawn_position = randf_range(10, screen_size.x-10)
	var food_instance = food_scene.instantiate()
	food_instance.connect("food_ate", _on_food_ate)
	food_instance.position = Vector2(random_spawn_position, 0)
	add_child(food_instance)

func _on_spawn_rate_increase_timer_timeout():
	var new_timer = Timer.new()
	new_timer.wait_time = 2
	new_timer.one_shot = false  # Allow it to run repeatedly
	new_timer.connect("timeout", _on_spawn_timer_timeout)
	add_child(new_timer)
	new_timer.start()


func _on_failure_area_body_entered(body):
	failure_count += 1
	
func _on_food_ate(food_calories):
	yanami.play("eating")
	calories += food_calories
	score.text = "Calories Counter: " + str(calories) + " kcal"
