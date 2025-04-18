class_name World
extends TileMapLayer

signal update

const SOURCE_ID: int = 0

const PREDATOR_FREQUENCY: float = 0.0025
const PREY_FREQUENCY: float = 0.025
const SCENERY_FREQUENCY: float = 0.1
const FOOD_FREQUENCY: float = 0.015

# Tile Coords
const GRASS_TILE: Vector2i = Vector2i(6, 1)
const WATER_TILE: Vector2i = Vector2i(15, 11)
const SAND_TILE: Vector2i = Vector2i(1, 1)
const BORDER_TILE: Vector2i = Vector2i(15, 0)

# Scenery Coords
const GRASS_SCENERY: Array[Vector2i] = [
	Vector2i(8, 2),
	Vector2i(9, 2),
	Vector2i(9, 3)
]

const SAND_SCENERY: Array[Vector2i] = [
	Vector2i(3, 2),
	Vector2i(4, 2),
	Vector2i(3, 3),
	Vector2i(4, 3)
]

@export var world_size: Vector2i
@export var prey_scene: PackedScene
@export var predator_scene: PackedScene
@export var food_scene: PackedScene
@export var noise_texture: NoiseTexture2D

@onready var scenery_layer: TileMapLayer = $SceneryLayer
@onready var noise: Noise = noise_texture.noise

@onready var prey_container: Node2D = $PreyContainer
@onready var predator_container: Node2D = $PredatorContainer
@onready var food_container: Node2D = $FoodContainer

@onready var update_timer: Timer = $UpdateTimer

var starting_time: int = Time.get_ticks_msec()

var empty_grass_tiles: Array[Vector2i]
var food_registry: Array[Food]

var prey_count: int
var predator_count: int

func _ready() -> void:
	#print("time,prey,predator")
	update_timer.timeout.connect(func() -> void: update.emit())
	Engine.time_scale = 1
	noise_texture.noise.seed = randi()
	generate_world()

func generate_world() -> void:
	# clear old elements, food, prey, predator e.g
	prey_count = 0
	predator_count = 0
	empty_grass_tiles.clear()
	food_registry.clear()
	scenery_layer.clear()
	for container in [food_container, prey_container, predator_container]:
		for node in container.get_children():
			node.queue_free()


	@warning_ignore("integer_division")
	var half_width: int = world_size.x / 2
	@warning_ignore("integer_division")
	var half_height: int = world_size.y / 2

	for x: int in range(-half_width, half_width):
		for y: int in range(-half_height, half_height):
			var tile_position = Vector2i(x, y)
			var noise_value = noise.get_noise_2d(x, y)

			if noise_value > -0.2:
				empty_grass_tiles.append(Vector2i(x, y))
				set_cell(tile_position, SOURCE_ID, GRASS_TILE)

				# food and scenery
				if randf() < SCENERY_FREQUENCY:
					scenery_layer.set_cell(tile_position, SOURCE_ID, GRASS_SCENERY.pick_random())
					empty_grass_tiles.erase(Vector2i(x, y))
				if randf() < FOOD_FREQUENCY:
					food_registry.append(spawn_food(Vector2i(x, y)))

				# prey Spawning
				if randf() < PREY_FREQUENCY:
					spawn_prey(Vector2i(x, y))
				# Predator spawing
				elif randf() < PREDATOR_FREQUENCY:
					spawn_predator(Vector2i(x, y))

			elif noise_value > -0.3:
				set_cell(tile_position, SOURCE_ID, SAND_TILE)
				if randf() < SCENERY_FREQUENCY:
					scenery_layer.set_cell(tile_position, SOURCE_ID, SAND_SCENERY.pick_random())

			else:
				set_cell(tile_position, SOURCE_ID, WATER_TILE)

	# build outer border
	for x: int in range(-half_width - 1, half_width + 1):
		set_cell(Vector2i(x, -half_height - 1), SOURCE_ID, BORDER_TILE)
		set_cell(Vector2i(x, half_height), SOURCE_ID, BORDER_TILE)

	for y: int in range(-half_height - 1, half_height + 1):
		set_cell(Vector2i(-half_width - 1, y), SOURCE_ID, BORDER_TILE)
		set_cell(Vector2i(half_width, y), SOURCE_ID, BORDER_TILE)

	# make food regrow when eaten
	for food: Food in food_container.get_children():
		food.consumed.connect(func() -> void:
			food.global_position = map_to_local(empty_grass_tiles.pick_random())
		)

func spawn_prey(prey_position: Vector2i) -> void:
	var prey_instance = prey_scene.instantiate() as Prey
	prey_instance.global_position = map_to_local(prey_position)
	prey_container.add_child(prey_instance)

	prey_count += 1
	prey_instance.died.connect(func() -> void:
		prey_count -= 1
	)


func spawn_predator(predator_position: Vector2i) -> void:
	var predator_instance = predator_scene.instantiate() as Predator
	predator_instance.global_position = map_to_local(predator_position)
	predator_container.add_child(predator_instance)

	predator_count += 1
	predator_instance.died.connect(func() -> void:
		predator_count -= 1
	)

func spawn_food(food_position: Vector2i) -> Food:
	var food_instance = food_scene.instantiate() as Food
	food_instance.global_position = map_to_local(food_position)
	food_container.add_child(food_instance)
	return food_instance

func _on_print_population_timer_timeout() -> void:
	@warning_ignore("integer_division")
	print("Population = " + str(predator_count + prey_count) + " ( Prey: " + str(prey_count) + ", " + "Predator: " + str(predator_count) + " )\n" + "Time: " + str((Time.get_ticks_msec() - starting_time) / 1000))
	#print(str((Time.get_ticks_msec() - starting_time) / 1000)  + "," + str(prey_count) + "," + str(predator_count))
