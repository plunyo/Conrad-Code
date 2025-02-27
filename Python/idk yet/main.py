import pygame

# define consts
MAX_FPS = 60

PADDLE_WIDTH = 50
PADDLE_HEIGHT = 200
PADDLE_SPEED = 200

clock = pygame.time.Clock()


class Paddle:
    def __init__(self, x, y = pygame.get, up_key, down_key):
        self.x = x
        self.y = y

        self.up_key = up_key
        self.down_key = down_key

    def handle_inputs(self):
        keys = pygame.key.get_pressed()

        if keys[self.up_key]:
            self.y -= PADDLE_SPEED * (clock.tick(MAX_FPS) / 1000)

        if keys[self.down_key]:
            self.y += PADDLE_SPEED * (clock.tick(MAX_FPS) / 1000)

    def draw
