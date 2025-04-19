class_name MatingRange
extends Area2D

@onready var mate_cooldown_timer: Timer = $MateCooldownTimer
@onready var mate_timer: Timer = $MateTimer
@onready var animal: Animal = get_parent()

@export var mate_cooldown: int = 90

func _ready() -> void:
	mate_cooldown_timer.wait_time = mate_cooldown

func _on_body_entered(body: Node2D) -> void:
	if body is Animal and body == animal.mate:
		mate_timer.start()

func _on_body_exited(body: Node2D) -> void:
	if body is Animal and body == animal.mate:
		mate_timer.stop()

func _on_mate_timer_timeout() -> void:
	if not animal.mate: return

	if animal.get_instance_id() > animal.mate.get_instance_id():
		if animal is Prey:
			animal.world.spawn_prey(animal.world.local_to_map(animal.global_position))
		elif animal is Predator:
			animal.world.spawn_predator(animal.world.local_to_map(animal.global_position))
		
		#after it mates
		animal.reproductive_urge = 0
		animal.hunger = max(animal.hunger - 35.0, 0.0)
		animal.mate.reproductive_urge = 0
		mate_cooldown_timer.start()
		animal.change_state_to(Animal.AnimalState.WANDERING)
