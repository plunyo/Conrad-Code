#!/usr/bin/env python3
import json
import os
import sys
from datetime import datetime

# set up the appdata directory in Linux
APP_DIR = os.path.join(os.path.expanduser("~"), ".local", "share", "clipped!")
os.makedirs(APP_DIR, exist_ok=True)
FILENAME = os.path.join(APP_DIR, "quotes.json")


# ----- utilities -----
def load_quotes():
    # if file doesn't exist, create an empty JSON file
    if not os.path.exists(FILENAME):
        with open(FILENAME, "w") as file:
            json.dump([], file)
        return []
    with open(FILENAME, "r") as file:
        try:
            return json.load(file)
        except json.JSONDecodeError:
            print(
                "\033[91m"
                + "damn, your quotes file is as jacked as your taste. starting fresh."
                + "\033[0m"
            )
            return []


def save_quotes(quotes):
    with open(FILENAME, "w") as file:
        json.dump(quotes, file, indent=4)


def print_header():
    header_art = r"""
 ░▒▓██████▓▒░░▒▓█▓▒░      ░▒▓█▓▒░▒▓███████▓▒░░▒▓███████▓▒░░▒▓████████▓▒░▒▓███████▓▒░░▒▓█▓▒░
░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░
░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░
░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░▒▓███████▓▒░░▒▓███████▓▒░░▒▓██████▓▒░ ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░
░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░
░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░
 ░▒▓██████▓▒░░▒▓████████▓▒░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓████████▓▒░▒▓███████▓▒░░▒▓█▓▒░
    """
    # using ANSI escape codes for colored output
    print("\033[95m" + header_art + "\033[0m")
    print("\033[96mwelcome to clipped! -- your terminal quote archive.\033[0m")
    print("\033[93mts pmo vibes only. holla holla get dolla.\033[0m\n")


def current_date():
    return datetime.now().strftime("%d-%m-%y")


# ----- core functions -----
def add_quote(quotes, quote_text, person):
    date = current_date()  # auto timestamp in dd-mm-yy
    quotes.append({"quote": quote_text, "person": person, "date": date})
    save_quotes(quotes)
    print(
        "\033[92m"
        + "added that mess. ts pmo, right? holla holla get dolla."
        + "\033[0m\n"
    )


def add_quote_interactive(quotes):
    quote = input("\033[94menter your dumb-ass quote: \033[0m").strip()
    person = input("\033[94mwho said this garbage? \033[0m").strip()
    add_quote(quotes, quote, person)


def view_quotes(quotes):
    if not quotes:
        print(
            "\033[91myour collection's emptier than your excuses. add some quotes, genius.\033[0m"
        )
        return
    print("\n\033[93m--- all your clipped quotes ---\033[0m")
    for index, entry in enumerate(quotes):
        print(
            f"\033[90m[{index}]\033[0m \033[97m{entry['quote']}\033[0m - \033[95m{entry['person']}\033[0m (\033[92m{entry['date']}\033[0m)\n"
        )


def edit_quote(quotes):
    view_quotes(quotes)
    try:
        idx = int(input("\n\033[94menter the number of the quote to edit: \033[0m"))
        if 0 <= idx < len(quotes):
            entry = quotes[idx]
            print(
                f"\033[93mediting: \033[97m{entry['quote']}\033[0m - \033[95m{entry['person']}\033[0m"
            )
            new_quote = input(
                "\033[94mnew quote text (or press enter to keep): \033[0m"
            ).strip()
            new_person = input(
                "\033[94mnew person field (or press enter to keep): \033[0m"
            ).strip()
            if new_quote:
                entry["quote"] = new_quote
            if new_person:
                entry["person"] = new_person
            entry["date"] = current_date()  # update timestamp on edit
            quotes[idx] = entry
            save_quotes(quotes)
            print("\033[92medited that bland take. ts pmo, right?\033[0m\n")
        else:
            print("\033[91minvalid index, genius.\033[0m")
    except ValueError:
        print("\033[91mnumbers only, buster.\033[0m")


def delete_quote(quotes):
    view_quotes(quotes)
    try:
        idx = int(input("\n\033[94menter the number of the quote to delete: \033[0m"))
        if 0 <= idx < len(quotes):
            removed = quotes.pop(idx)
            save_quotes(quotes)
            print(
                f"\033[92mdeleted: \033[97m{removed['quote']}\033[0m - \033[95m{removed['person']}\033[0m. lucky you.\033[0m\n"
            )
        else:
            print("\033[91minvalid index, you dummy.\033[0m")
    except ValueError:
        print("\033[91mnumbers only, chill out and try again.\033[0m")


# ----- menu & cli -----
def interactive_menu():
    quotes = load_quotes()
    print_header()
    while True:
        print("\033[93m--- clipped! menu ---\033[0m")
        print("\033[90m1.\033[0m add quote")
        print("\033[90m2.\033[0m view quotes")
        print("\033[90m3.\033[0m edit quote")
        print("\033[90m4.\033[0m delete quote")
        print("\033[90m5.\033[0m exit")
        choice = input("\033[94mchoose an option, a genius: \033[0m").strip()
        print("")
        if choice == "1":
            add_quote_interactive(quotes)
        elif choice == "2":
            view_quotes(quotes)
        elif choice == "3":
            edit_quote(quotes)
        elif choice == "4":
            delete_quote(quotes)
        elif choice == "5":
            print("\033[91mbye bye, scrap heap!\033[0m")
            break
        else:
            print("\033[91minvalid option. get your act together and try again.\033[0m")


def cli_add_quote(args):
    if len(args) < 3:
        print('\033[91musage: clipped! "your quote here" speaker\033[0m')
        sys.exit(1)
    # command-line args: sys.argv[0] is the script name
    quote_text = args[1]
    person = args[2]
    quotes = load_quotes()
    add_quote(quotes, quote_text, person)


if __name__ == "__main__":
    # if there are command-line arguments provided for adding a quote, use them
    if len(sys.argv) > 1:
        cli_add_quote(sys.argv)
    else:
        interactive_menu()
