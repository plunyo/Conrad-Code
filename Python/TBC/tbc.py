import json
import os
import sys
import time
from datetime import datetime

# ANSI escape codes for colors (because plain text is for plebs)
RESET = "\033[0m"
BOLD = "\033[1m"
GREEN = "\033[32m"
RED = "\033[31m"
YELLOW = "\033[33m"
CYAN = "\033[36m"

# Get base path for script or executable (fancy stuff for PyInstaller wannabes)
if getattr(sys, "frozen", False):
    base_path = sys._MEIPASS
else:
    base_path = os.path.dirname(os.path.abspath(__file__))

# Setup local directory for tasks
local_directory = os.path.join(base_path, "local")
tasklist_path = os.path.join(local_directory, "tasklist.json")
os.makedirs(local_directory, exist_ok=True)


def ensure_tasklist_exists(path):
    if not os.path.exists(path):
        with open(path, "w") as file:
            json.dump([], file)  # Starting fresh with no lame tasks


ensure_tasklist_exists(tasklist_path)


def load_tasks():
    with open(tasklist_path, "r") as file:
        return json.load(file)


def save_tasks(tasks):
    with open(tasklist_path, "w") as file:
        json.dump(tasks, file, indent=4)


def adaptive_sleep(lines=1):
    # Because even the coolest need a break. Adjust pause based on output length.
    time.sleep(max(0.5, lines * 0.25))


def get_int_input(prompt):
    while True:
        user_input = input(prompt)
        if user_input.strip() == "":
            print(f"{RED}Dude, you gotta enter a number!{RESET}")
            continue
        try:
            return int(user_input)
        except ValueError:
            print(f"{RED}Not a number, genius. Try again.{RESET}")


def display_tasks(tasks):
    os.system("cls" if os.name == "nt" else "clear")
    print(f"{BOLD}{CYAN}Your Tasks:{RESET}")
    print("-" * 40)
    if not tasks:
        print(
            f"{YELLOW}Task list is empty. Chill, you're all caught up!{RESET}"
        )
        adaptive_sleep(1)
        return
    for index, task in enumerate(tasks, start=1):
        status = "✓" if task.get("completed") else "✗"
        due_date = task.get("due_date", "No due date")
        status_color = GREEN if task.get("completed") else RED
        print(
            f"{index}. [{status_color}{status}{RESET}] {task.get('description')} (Due: {due_date})"
        )
    print("-" * 40)
    adaptive_sleep(len(tasks) + 2)


def add_task(tasks):
    while True:
        description = input("Enter task description: ").strip()
        if description:
            break
        else:
            print(f"{RED}C'mon, write something cool!{RESET}")
    due_date_input = input(
        "Enter due date (YYYY-MM-DD) or leave blank: "
    ).strip()
    due_date = None
    if due_date_input:
        try:
            datetime.strptime(due_date_input, "%Y-%m-%d")
            due_date = due_date_input
        except ValueError:
            print(
                f"{YELLOW}That date ain't legit. No due date for this one.{RESET}"
            )
    new_task = {
        "description": description,
        "completed": False,
        "due_date": due_date if due_date else "N/A",
        "created_at": str(datetime.now()),
    }
    tasks.append(new_task)
    print(f"{GREEN}Task added: {description}{RESET}")
    adaptive_sleep(2)
    save_tasks(tasks)


def mark_task_completed(tasks):
    display_tasks(tasks)
    if not tasks:
        return
    task_number = get_int_input("Enter task number to mark as completed: ") - 1
    if 0 <= task_number < len(tasks):
        tasks[task_number]["completed"] = True
        print(
            f"{GREEN}Boom! '{tasks[task_number]['description']}' is done!{RESET}"
        )
        adaptive_sleep(2)
        save_tasks(tasks)
    else:
        print(f"{RED}Invalid task number, genius.{RESET}")
        adaptive_sleep(1)


def delete_task(tasks):
    display_tasks(tasks)
    if not tasks:
        return
    task_number = get_int_input("Enter task number to delete: ") - 1
    if 0 <= task_number < len(tasks):
        removed_task = tasks.pop(task_number)
        print(f"{GREEN}Task deleted: {removed_task['description']}{RESET}")
        adaptive_sleep(2)
        save_tasks(tasks)
    else:
        print(f"{RED}Nope, that's not a valid number.{RESET}")
        adaptive_sleep(1)


def search_tasks(tasks):
    keyword = input("Enter keyword to search: ").strip().lower()
    matching_tasks = [
        task for task in tasks if keyword in task.get("description", "").lower()
    ]
    os.system("cls" if os.name == "nt" else "clear")
    if not matching_tasks:
        print(f"{YELLOW}No tasks found with that keyword. Get creative!{RESET}")
        adaptive_sleep(1)
    else:
        print(f"{BOLD}{CYAN}Matching Tasks:{RESET}")
        print("-" * 40)
        for index, task in enumerate(matching_tasks, start=1):
            status = "✓" if task.get("completed") else "✗"
            due_date = task.get("due_date", "No due date")
            status_color = GREEN if task.get("completed") else RED
            print(
                f"{index}. [{status_color}{status}{RESET}] {task.get('description')} (Due: {due_date})"
            )
        print("-" * 40)
        adaptive_sleep(len(matching_tasks) + 2)


def print_banner():
    os.system("cls" if os.name == "nt" else "clear")
    banner = f"""
{BOLD}{CYAN}
            ████████╗██████╗  ██████╗
            ╚══██╔══╝██╔══██╗██╔════╝
               ██║   ██████╔╝██║     
               ██║   ██╔══██╗██║     
               ██║   ██████╔╝╚██████╗
               ╚═╝   ╚═════╝  ╚═════╝
       
     Welcome to Tasks By Conrad - Get Shit Done!
{RESET}
    """
    print(banner)
    adaptive_sleep(3)


def main():
    tasks = load_tasks()
    while True:
        print_banner()
        print("-" * 40)
        print("1. View Tasks")
        print("2. Add Task")
        print("3. Mark Task as Completed")
        print("4. Delete Task")
        print("5. Search Tasks")
        print("6. Exit")
        print("-" * 40)
        choice = input("Choose an option: ").strip()
        if choice == "":
            print(f"{RED}Really? Pick an option, dude!{RESET}")
            adaptive_sleep(1)
            continue
        if choice == "1":
            display_tasks(tasks)
        elif choice == "2":
            add_task(tasks)
        elif choice == "3":
            mark_task_completed(tasks)
        elif choice == "4":
            delete_task(tasks)
        elif choice == "5":
            search_tasks(tasks)
        elif choice == "6":
            print(f"{CYAN}Exiting... Later, loser!{RESET}")
            adaptive_sleep(2)
            break
        else:
            print(f"{RED}Invalid option, bro. Try again.{RESET}")
            adaptive_sleep(1)


if __name__ == "__main__":
    main()
