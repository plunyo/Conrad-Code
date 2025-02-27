import pygame
import random

# Initialize Pygame
pygame.init()

# Set up display
width, height = 800, 600
win = pygame.display.set_mode((width, height))
pygame.display.set_caption("Bubble Sort Visualization")

# Colors
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)
RED = (255, 0, 0)
GREEN = (0, 255, 0)

# Parameters
n = 50  # Number of elements
arr = [random.randint(1, height - 20) for _ in range(n)]
bar_width = width // n

# Function to draw array
def draw_array(arr, color_position=None):
    win.fill(WHITE)
    for i in range(len(arr)):
        color = GREEN if color_position and i in color_position else BLACK
        pygame.draw.rect(win, color, (i * bar_width, height - arr[i], bar_width, arr[i]))
    pygame.display.update()

# Bubble Sort Algorithm
def bubble_sort(arr):
    n = len(arr)
    for i in range(n):
        for j in range(0, n - i - 1):
            draw_array(arr, [j, j + 1])
            pygame.time.delay(50)
            if arr[j] > arr[j + 1]:
                arr[j], arr[j + 1] = arr[j + 1], arr[j]
                draw_array(arr, [j, j + 1])
                pygame.time.delay(50)

# Main loop
run = True
sorting = False
while run:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            run = False
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_SPACE and not sorting:
                sorting = True
                bubble_sort(arr)

    if not sorting:
        draw_array(arr)

pygame.quit()
