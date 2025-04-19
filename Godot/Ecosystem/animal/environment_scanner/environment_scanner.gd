class_name EnvironmentScanner extends Area2D


func find_nearest_prey() -> Prey:
	for body: Node2D in get_overlapping_bodies():
		if body is Prey and body != get_parent():
			return body

	return null

func find_nearest_predator() -> Predator:
	for body: Node2D in get_overlapping_bodies():
		if body is Predator and body != get_parent():
			return body

	return null

func find_nearest_food() -> Food:
	for body: Node2D in get_overlapping_areas():
		if body is Food and body != get_parent():
			return body

	return null
