class_name World
extends TileMapLayer

const SOURCE_ID = 0
const SCENERY_FREQUENCY = 0.1
const PREY_FREQUENCY = 0.025

# Tile Coords
const GRASS_TILE = Vector2i(6, 1)
const WATER_TILE = Vector2i(15, 11)
const SAND_TILE = Vector2i(1, 1)
const BORDER_TILE = Vector2i(15, 0)

# Scenery Coords
const GRASS_SCENERY = [
	Vector2i(8, 2),
	Vector2i(9, 2),
	Vector2i(8, 3),
	Vector2i(9, 3)
]

const Sand_SCENERY = [
	Vector2i(3, 2),
	Vector2i(4, 2),
	Vector2i(3, 3),
	Vector2i(4, 3)
]

@export var world_size: Vector2i
@export var prey_scene: PackedScene
@export var noise_texture: NoiseTexture2D

@onready var scenery_layer: TileMapLayer = $SceneryLayer
@onready var noise: Noise = noise_texture.noise

func _ready() -> void:
	noise_texture.noise.seed = randi()
	generate_world()

func generate_world() -> void:
	@warning_ignore("integer_division")
	var half_width: int = world_size.x / 2
	@warning_ignore("integer_division")
	var half_height: int = world_size.y / 2

	for x: int in range(-half_width, half_width):
		for y: int in range(-half_height, half_height):
			var tile_position = Vector2i(x, y)
			var noise_value = noise.get_noise_2d(x, y)

			if noise_value > 0.15:
				set_cell(tile_position, SOURCE_ID, GRASS_TILE)
				if randf() < SCENERY_FREQUENCY:
					scenery_layer.set_cell(tile_position, SOURCE_ID, GRASS_SCENERY.pick_random())

				# Rabbit Spawning
				if randf() < PREY_FREQUENCY:
					spawn_prey(map_to_local(Vector2i(x, y)))
			elif noise_value > 0.0:
				set_cell(tile_position, SOURCE_ID, SAND_TILE)
				if randf() < SCENERY_FREQUENCY:
					scenery_layer.set_cell(tile_position, SOURCE_ID, Sand_SCENERY.pick_random())
			else:
				set_cell(tile_position, SOURCE_ID, WATER_TILE)

	# build outer border
	for x: int in range(-half_width - 1, half_width + 1):
		set_cell(Vector2i(x, -half_height - 1), SOURCE_ID, BORDER_TILE)
		set_cell(Vector2i(x, half_height), SOURCE_ID, BORDER_TILE)

	for y: int in range(-half_height - 1, half_height + 1):
		set_cell(Vector2i(-half_width - 1, y), SOURCE_ID, BORDER_TILE)
		set_cell(Vector2i(half_width, y), SOURCE_ID, BORDER_TILE)

func spawn_prey(prey_position: Vector2):
	var prey_instance = prey_scene.instantiate() as Prey
	prey_instance.global_position = prey_position
	add_child(prey_instance)
