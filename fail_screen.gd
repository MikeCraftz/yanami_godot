extends Control
@onready var click_label = $ClickLabel
@onready var fail_screen = $FailScreen
@onready var final_calories_counter = $CaloriesCounter
var flash_timer = 0.0
var flash_interval = 0.5

func _ready():
	final_calories_counter.text = "Calories Counter: " + str(Global.final_calories) + " kcal"
	
func _process(delta):
	flash_timer += delta
	if flash_timer >= flash_interval:
		click_label.visible = !click_label.visible
		flash_timer = 0.0

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			get_tree().change_scene_to_file("res://start_screen.tscn")
