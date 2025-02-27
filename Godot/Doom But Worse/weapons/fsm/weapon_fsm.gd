extends Node
class_name WeaponStateMachine

@export var initial_state : BaseWeaponState

var current_state : BaseWeaponState
var states = {}

func _ready():
	for child in get_children():
		if child is BaseWeaponState:
			states[child.name.to_lower()] = child

	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta):
	if current_state:
		current_state.update(delta)

	if Input.is_action_just_pressed("switch_weapon"):
		var weapons: Array[Node] = get_children()
		current_state = weapons[(weapons.find(current_state) + 1) % weapons.size()]
		current_state.enter()

func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)

func change_state(state, new_state_name):
	if state != current_state:
		return

	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return

	if current_state:
		current_state.exit()

	new_state.enter()
	current_state = new_state
