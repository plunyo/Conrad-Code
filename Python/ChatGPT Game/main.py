import random
import sys

import pygame

# --- Fullscreen Initialization ---
pygame.init()
infoObject = pygame.display.Info()
WIDTH, HEIGHT = infoObject.current_w, infoObject.current_h
screen = pygame.display.set_mode((WIDTH, HEIGHT), pygame.FULLSCREEN)
pygame.display.set_caption("Minecraft-like NO BS Pygame")
clock = pygame.time.Clock()
FPS = 60

# --- Colors ---
WHITE      = (255, 255, 255)
BLACK      = (0, 0, 0)
RED        = (255, 0, 0)
GREEN      = (0, 255, 0)
BLUE       = (0, 0, 255)
BROWN      = (139, 69, 19)
GRAY       = (128, 128, 128)
DARK_GREEN = (0, 100, 0)
YELLOW     = (255, 255, 0)
ORANGE     = (255, 165, 0)

# --- Block Colors ---
block_colors = {
    "grass": (34, 177, 76),
    "dirt": (185, 122, 87),
    "stone": (127, 127, 127),
    "wood": (136, 0, 21)
}

# --- Game States ---
STATE_MAIN_MENU = "main_menu"
STATE_STORY     = "story"
STATE_WORLD     = "world"
STATE_OPTIONS   = "options"
STATE_CREDITS   = "credits"
STATE_GAME_OVER = "game_over"

# --- Utility Functions ---
def draw_text(surface, text, size, color, x, y, center=True):
    font = pygame.font.SysFont("comicsansms", size)
    text_surface = font.render(text, True, color)
    text_rect = text_surface.get_rect()
    if center:
        text_rect.center = (x, y)
    else:
        text_rect.topleft = (x, y)
    surface.blit(text_surface, text_rect)

# --- Main Menu State ---
class MainMenu:
    def __init__(self):
        self.options = ["New Game", "Options", "Credits", "Exit"]
        self.selected = 0

    def update(self, events):
        for event in events:
            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_UP:
                    self.selected = (self.selected - 1) % len(self.options)
                elif event.key == pygame.K_DOWN:
                    self.selected = (self.selected + 1) % len(self.options)
                elif event.key == pygame.K_RETURN:
                    option = self.options[self.selected]
                    if option == "New Game":
                        return STATE_STORY
                    elif option == "Options":
                        return STATE_OPTIONS
                    elif option == "Credits":
                        return STATE_CREDITS
                    elif option == "Exit":
                        pygame.quit()
                        sys.exit()
        return STATE_MAIN_MENU

    def render(self, surface):
        surface.fill(BLACK)
        draw_text(surface, "TRIPLE-A NO BS GAME", 64, WHITE, WIDTH//2, HEIGHT//4)
        for idx, option in enumerate(self.options):
            color = GREEN if idx == self.selected else WHITE
            draw_text(surface, option, 48, color, WIDTH//2, HEIGHT//2 + idx * 60)
        draw_text(surface, "Use UP/DOWN + ENTER", 32, ORANGE, WIDTH//2, HEIGHT - 100)

# --- Story / Lore State ---
class StoryState:
    def __init__(self):
        self.lines = [
            "In a world where blocks rule everything,",
            "a lone coder dares to defy the norms.",
            "With a pickaxe in hand and chaos in heart,",
            "you set out on an epic journey.",
            "Mine, build, and conquer the BS!",
            "Press SPACE to continue..."
        ]
        self.current_line = 0
        self.timer = 0
        self.delay = 2500  # milliseconds

    def update(self, events):
        self.timer += clock.get_time()
        if self.timer > self.delay and self.current_line < len(self.lines) - 1:
            self.current_line += 1
            self.timer = 0
        for event in events:
            if event.type == pygame.KEYDOWN and event.key == pygame.K_SPACE:
                if self.current_line >= len(self.lines) - 1:
                    return STATE_WORLD
                else:
                    self.current_line = len(self.lines) - 1
        return STATE_STORY

    def render(self, surface):
        surface.fill(BLACK)
        y = HEIGHT // 4
        for i in range(self.current_line + 1):
            draw_text(surface, self.lines[i], 36, WHITE, WIDTH // 2, y)
            y += 50
        draw_text(surface, "Press SPACE to advance", 28, ORANGE, WIDTH // 2, HEIGHT - 80)

# --- World & World Generation ---
TILE_SIZE = 32
WORLD_COLS = 100
WORLD_ROWS = 100

class World:
    def __init__(self):
        # Create a 2D array filled with "air"
        self.tiles = [[ "air" for _ in range(WORLD_COLS)] for _ in range(WORLD_ROWS)]
        self.generate_world()

    def generate_world(self):
        for x in range(WORLD_COLS):
            ground_level = random.randint(40, 60)
            for y in range(WORLD_ROWS):
                if y < ground_level:
                    self.tiles[y][x] = "air"
                elif y == ground_level:
                    self.tiles[y][x] = "grass"
                elif ground_level < y <= ground_level + 2:
                    self.tiles[y][x] = "dirt"
                else:
                    self.tiles[y][x] = "stone"
        # Scatter some wood (tree trunks) randomly on grass
        for _ in range(50):
            tx = random.randint(0, WORLD_COLS - 1)
            ty = random.randint(30, WORLD_ROWS - 10)
            if self.tiles[ty][tx] == "grass":
                height = random.randint(3, 6)
                for h in range(height):
                    if ty - h >= 0:
                        self.tiles[ty - h][tx] = "wood"

    def draw(self, surface, camera_x, camera_y):
        start_col = max(0, camera_x // TILE_SIZE)
        start_row = max(0, camera_y // TILE_SIZE)
        end_col = min(WORLD_COLS, (camera_x + WIDTH) // TILE_SIZE + 1)
        end_row = min(WORLD_ROWS, (camera_y + HEIGHT) // TILE_SIZE + 1)
        for y in range(start_row, end_row):
            for x in range(start_col, end_col):
                tile = self.tiles[y][x]
                if tile != "air":
                    color = block_colors.get(tile, WHITE)
                    rect = pygame.Rect(x * TILE_SIZE - camera_x, y * TILE_SIZE - camera_y, TILE_SIZE, TILE_SIZE)
                    pygame.draw.rect(surface, color, rect)

# --- World Player ---
class WorldPlayer(pygame.sprite.Sprite):
    def __init__(self, x, y):
        super().__init__()
        self.image = pygame.Surface((TILE_SIZE, TILE_SIZE))
        self.image.fill(YELLOW)
        self.rect = self.image.get_rect(center=(x, y))
        self.speed = 5
        self.health = 100
        self.inventory = {"grass": 0, "dirt": 0, "stone": 0, "wood": 0}
        self.selected_item = "grass"  # default inventory selection

    def update(self, keys_pressed):
        if keys_pressed[pygame.K_a] or keys_pressed[pygame.K_LEFT]:
            self.rect.x -= self.speed
        if keys_pressed[pygame.K_d] or keys_pressed[pygame.K_RIGHT]:
            self.rect.x += self.speed
        if keys_pressed[pygame.K_w] or keys_pressed[pygame.K_UP]:
            self.rect.y -= self.speed
        if keys_pressed[pygame.K_s] or keys_pressed[pygame.K_DOWN]:
            self.rect.y += self.speed

# --- World Enemy ---
class WorldEnemy(pygame.sprite.Sprite):
    def __init__(self, x, y):
        super().__init__()
        self.image = pygame.Surface((TILE_SIZE, TILE_SIZE))
        self.image.fill(RED)
        self.rect = self.image.get_rect(center=(x, y))
        self.speed = 2
        self.health = 50

    def update(self, player):
        if self.rect.x < player.rect.x:
            self.rect.x += self.speed
        elif self.rect.x > player.rect.x:
            self.rect.x -= self.speed
        if self.rect.y < player.rect.y:
            self.rect.y += self.speed
        elif self.rect.y > player.rect.y:
            self.rect.y -= self.speed

# --- World State (Main Game Play) ---
class WorldState:
    def __init__(self):
        self.world = World()
        self.player = WorldPlayer(WIDTH // 2, HEIGHT // 2)
        self.camera_x = 0
        self.camera_y = 0
        self.enemies = pygame.sprite.Group()
        self.all_sprites = pygame.sprite.Group()
        self.all_sprites.add(self.player)
        self.enemy_spawn_timer = 0
        self.enemy_spawn_delay = 5000  # spawn enemy every 5 seconds
        self.show_inventory = False

    def update(self, events):
        keys = pygame.key.get_pressed()
        self.player.update(keys)

        # Update camera to follow player
        self.camera_x = self.player.rect.x - WIDTH // 2
        self.camera_y = self.player.rect.y - HEIGHT // 2
        # Clamp camera to world boundaries
        self.camera_x = max(0, min(self.camera_x, WORLD_COLS * TILE_SIZE - WIDTH))
        self.camera_y = max(0, min(self.camera_y, WORLD_ROWS * TILE_SIZE - HEIGHT))

        # Handle events for inventory toggle and item selection
        for event in events:
            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_i:
                    self.show_inventory = not self.show_inventory
                if event.key == pygame.K_1:
                    self.player.selected_item = "grass"
                elif event.key == pygame.K_2:
                    self.player.selected_item = "dirt"
                elif event.key == pygame.K_3:
                    self.player.selected_item = "stone"
                elif event.key == pygame.K_4:
                    self.player.selected_item = "wood"
                if event.key == pygame.K_ESCAPE:
                    return STATE_MAIN_MENU  # ESC to exit to main menu
            # Handle mining (left mouse click)
            if event.type == pygame.MOUSEBUTTONDOWN and event.button == 1:
                mx, my = pygame.mouse.get_pos()
                world_x = (mx + self.camera_x) // TILE_SIZE
                world_y = (my + self.camera_y) // TILE_SIZE
                if 0 <= world_x < WORLD_COLS and 0 <= world_y < WORLD_ROWS:
                    tile = self.world.tiles[world_y][world_x]
                    if tile != "air":
                        self.player.inventory[tile] += 1
                        self.world.tiles[world_y][world_x] = "air"
            # Handle placing (right mouse click)
            if event.type == pygame.MOUSEBUTTONDOWN and event.button == 3:
                mx, my = pygame.mouse.get_pos()
                world_x = (mx + self.camera_x) // TILE_SIZE
                world_y = (my + self.camera_y) // TILE_SIZE
                if 0 <= world_x < WORLD_COLS and 0 <= world_y < WORLD_ROWS:
                    if self.world.tiles[world_y][world_x] == "air":
                        selected = self.player.selected_item
                        if self.player.inventory[selected] > 0:
                            self.world.tiles[world_y][world_x] = selected
                            self.player.inventory[selected] -= 1

        # Spawn enemies periodically
        self.enemy_spawn_timer += clock.get_time()
        if self.enemy_spawn_timer > self.enemy_spawn_delay:
            ex = random.randint(0, WORLD_COLS * TILE_SIZE)
            ey = random.randint(0, WORLD_ROWS * TILE_SIZE)
            enemy = WorldEnemy(ex, ey)
            self.enemies.add(enemy)
            self.all_sprites.add(enemy)
            self.enemy_spawn_timer = 0

        # Update enemies: chase player and deal damage
        for enemy in list(self.enemies):
            enemy.update(self.player)
            if enemy.rect.colliderect(self.player.rect):
                self.player.health -= 0.5  # gradual damage
                if self.player.health <= 0:
                    return STATE_GAME_OVER

        return STATE_WORLD

    def render(self, surface):
        # Draw world tiles with camera offset
        self.world.draw(surface, self.camera_x, self.camera_y)
        # Draw sprites (player and enemies)
        for sprite in self.all_sprites:
            offset_rect = sprite.rect.copy()
            offset_rect.x -= self.camera_x
            offset_rect.y -= self.camera_y
            surface.blit(sprite.image, offset_rect)
        # Draw UI: Health Bar
        pygame.draw.rect(surface, RED, (20, 20, 300, 30))
        health_width = int(300 * (self.player.health / 100))
        pygame.draw.rect(surface, GREEN, (20, 20, health_width, 30))
        draw_text(surface, f"Health: {int(self.player.health)}", 24, WHITE, 170, 35)
        # Draw Inventory UI if toggled
        if self.show_inventory:
            inv_rect = pygame.Rect(50, HEIGHT - 150, 400, 100)
            pygame.draw.rect(surface, BLACK, inv_rect)
            pygame.draw.rect(surface, WHITE, inv_rect, 2)
            x_offset = 60
            for item, count in self.player.inventory.items():
                draw_text(surface, f"{item}: {count}", 24, WHITE, x_offset, HEIGHT - 120, center=False)
                x_offset += 150
            draw_text(surface, f"Selected: {self.player.selected_item}", 24, YELLOW, 60, HEIGHT - 30, center=False)

# --- Options State ---
class OptionsState:
    def __init__(self):
        self.options = ["Sound: ON", "Back"]
        self.selected = 0

    def update(self, events):
        for event in events:
            if event.type == pygame.KEYDOWN:
                if event.key in [pygame.K_UP, pygame.K_DOWN]:
                    self.selected = (self.selected + 1) % len(self.options)
                elif event.key == pygame.K_RETURN:
                    if self.options[self.selected] == "Back":
                        return STATE_MAIN_MENU
                    # Dummy toggle for sound
                    if self.options[self.selected].startswith("Sound"):
                        if "ON" in self.options[self.selected]:
                            self.options[0] = "Sound: OFF"
                        else:
                            self.options[0] = "Sound: ON"
        return STATE_OPTIONS

    def render(self, surface):
        screen.fill((0, 0, 0, 0))
        draw_text(surface, "OPTIONS", 64, WHITE, WIDTH // 2, HEIGHT // 4)
        for idx, option in enumerate(self.options):
            color = GREEN if idx == self.selected else WHITE
            draw_text(surface, option, 48, color, WIDTH // 2, HEIGHT // 2 + idx * 60)
        draw_text(surface, "Use UP/DOWN + ENTER", 32, ORANGE, WIDTH // 2, HEIGHT - 100)

# --- Credits State ---
class CreditsState:
    def __init__(self):
        self.lines = [
            "Triple-A NO BS Game",
            "Developed by a Certified Dumbass",
            "Pygame powered madness",
            "Thanks for playing, you filthy beast!",
            "Press ENTER to return to Main Menu"
        ]

    def update(self, events):
        for event in events:
            if event.type == pygame.KEYDOWN and event.key == pygame.K_RETURN:
                return STATE_MAIN_MENU
        return STATE_CREDITS

    def render(self, surface):
        surface.fill(BLACK)
        y = HEIGHT // 4
        for line in self.lines:
            draw_text(surface, line, 36, WHITE, WIDTH // 2, y)
            y += 50

# --- Game Over State ---
class GameOverState:
    def __init__(self):
        self.message = "Game Over! You got wrecked!"

    def update(self, events):
        for event in events:
            if event.type == pygame.KEYDOWN and event.key == pygame.K_RETURN:
                return STATE_MAIN_MENU
        return STATE_GAME_OVER

    def render(self, surface):
        surface.fill(BLACK)
        draw_text(surface, self.message, 64, RED, WIDTH // 2, HEIGHT // 2)
        draw_text(surface, "Press ENTER to return to Main Menu", 32, ORANGE, WIDTH // 2, HEIGHT // 2 + 80)

# --- Main Game Class ---
class Game:
    def __init__(self):
        self.state = STATE_MAIN_MENU
        self.main_menu = MainMenu()
        self.story = StoryState()
        self.world_state = None
        self.options_state = OptionsState()
        self.credits_state = CreditsState()
        self.game_over_state = GameOverState()

    def run(self):
        while True:
            events = pygame.event.get()
            for event in events:
                if event.type == pygame.QUIT:
                    pygame.quit()
                    sys.exit()

            if self.state == STATE_MAIN_MENU:
                next_state = self.main_menu.update(events)
                self.main_menu.render(screen)
                if next_state != self.state:
                    self.state = next_state
                    if self.state == STATE_STORY:
                        self.story = StoryState()
                    elif self.state == STATE_OPTIONS:
                        self.options_state = OptionsState()
                    elif self.state == STATE_CREDITS:
                        self.credits_state = CreditsState()
            elif self.state == STATE_STORY:
                next_state = self.story.update(events)
                self.story.render(screen)
                if next_state != self.state:
                    self.state = next_state
                    if self.state == STATE_WORLD:
                        self.world_state = WorldState()
            elif self.state == STATE_WORLD:
                next_state = self.world_state.update(events)
                self.world_state.render(screen)
                if next_state != self.state:
                    self.state = next_state
                    if self.state == STATE_GAME_OVER:
                        self.game_over_state = GameOverState()
                    elif self.state == STATE_MAIN_MENU:
                        self.main_menu = MainMenu()
            elif self.state == STATE_OPTIONS:
                next_state = self.options_state.update(events)
                self.options_state.render(screen)
                if next_state != self.state:
                    self.state = next_state
            elif self.state == STATE_CREDITS:
                next_state = self.credits_state.update(events)
                self.credits_state.render(screen)
                if next_state != self.state:
                    self.state = next_state
            elif self.state == STATE_GAME_OVER:
                next_state = self.game_over_state.update(events)
                self.game_over_state.render(screen)
                if next_state != self.state:
                    self.state = next_state
                    self.main_menu = MainMenu()

            pygame.display.flip()
            clock.tick(FPS)

if __name__ == "__main__":
    game = Game()
    game.run()
