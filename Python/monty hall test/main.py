import random

# Simulating the Monty Hall problem
def monty_hall_simulation(num_trials=10000):
    switch_wins = 0
    stay_wins = 0

    for _ in range(num_trials):
        # Randomly place the car behind one of three doors
        car_door = random.randint(1, 3)
        # Contestant makes an initial choice
        contestant_choice = random.randint(1, 3)

        # Host opens a door that is not the car door and not the contestant's choice
        host_options = [door for door in range(1, 4) if door != car_door and door != contestant_choice]
        host_open = random.choice(host_options)

        # Determine the door to switch to
        switch_choice = next(door for door in range(1, 4) if door != contestant_choice and door != host_open)

        # Count wins based on staying or switching
        if switch_choice == car_door:
            switch_wins += 1
        if contestant_choice == car_door:
            stay_wins += 1

    return switch_wins, stay_wins

# Run the simulation and output results
num_trials = 10000
switch_wins, stay_wins = monty_hall_simulation(num_trials)
switch_wins, stay_wins, (switch_wins / num_trials) * 100, (stay_wins / num_trials) * 100

print(switch_wins, " ", stay_wins)