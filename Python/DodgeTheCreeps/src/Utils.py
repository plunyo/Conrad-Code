import Inputs
import Vector2
import pygame


def get_axis(positive_key, negative_key):
    axis = 0

    if Inputs.keys[positive_key]:
        axis = 1

    if Inputs.keys[negative_key]:
        axis = -1

    return axis


def get_vector(up_key, down_key, left_key, right_key):
    return Vector2(

    )
