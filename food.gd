extends CharacterBody2D

var food_types = [
	{"name": "onigiri", "speed": 200, "clicks_to_consume": 2, "image": "onigiri", "calories": 100},
	{"name": "hotcake", "speed": 180, "clicks_to_consume": 3, "image": "hotcake", "calories": 200},
	{"name": "baumkuchen", "speed": 150, "clicks_to_consume": 4, "image": "baumkuchen", "calories": 300},
	{"name": "taiyaki", "speed": 160, "clicks_to_consume": 2, "image": "taiyaki", "calories": 150},
	{"name": "inari", "speed": 170, "clicks_to_consume": 3, "image": "inari", "calories": 250}
]

var speed = 0
var clicks_to_consume = 0
var calories = 0
@onready var food_sprite = $Sprite2D
@onready var food_consume_particle = $FoodConsumeParticle
#var ground_position = 350
signal food_ate(calories)

func _ready():
	var random_food = food_types[randi() % food_types.size()]
	speed = random_food["speed"]
	clicks_to_consume = random_food["clicks_to_consume"]
	calories = random_food["calories"]
	var image_path = "res://assests/" + random_food["image"] + ".png"
	food_sprite.texture = load(image_path)

func _physics_process(delta):
#	Was being an idiot here, i set the ground as area2D and was wondering why all the food
#	are falling through it, forgotting area2d only really detect collision
#	I forced a checking of ground here to stop it, but actually staticbody do the trick.
#	Leaving the code here as proof of shame.
	velocity.y += speed * delta
	move_and_slide()
	#if position.y >= ground_position:
		#position.y = ground_position
		#velocity.y = 0

func enable_food_consume_particle_effect():
	food_consume_particle.emitting = true

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		enable_food_consume_particle_effect()
		clicks_to_consume -= 1
		if clicks_to_consume <= 0:
			emit_signal("food_ate", calories)
			queue_free()
