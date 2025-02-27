import json

class StudentDatabase:
    def __init__(self, filename="students.json"):
        self.filename = filename
        self.students = self.load_students()

    def load_students(self):
        try:
            with open(self.filename, "r") as file:
                return json.load(file)
        except FileNotFoundError:
            return {}
        except json.JSONDecodeError:
            print("Warning: JSON file is corrupt or invalid. Starting with an empty database.")
            return {}

    def save_students(self):
        with open(self.filename, "w") as file:
            json.dump(self.students, file, indent=4)

    def add_student(self):
        print("\nAdding a new student...")
        student_id = input("Enter student ID: ").upper()
        
        if student_id in self.students:
            print(f"Student with ID {student_id} already exists.")
            return

        name = input("Enter student name: ")
        age = input("Enter student age: ")
        grade = input("Enter student grade: ")

        self.students[student_id] = {
            "name": name,
            "age": age,
            "grade": grade
        }

        self.save_students()
        
        print(f"Student {name} added successfully.")

    def edit_student(self):
        print("\nEditing a student...")
        student_id = input("Enter student ID to edit: ").upper()

        if student_id not in self.students:
            print(f"Student with ID {student_id} does not exist.")
            return

        student = self.students[student_id]
        name = input(f"\nEnter new student name (current: {student['name']}): ")
        age = input(f"\nEnter new student age (current: {student['age']}): ")
        grade = input(f"\nEnter new student grade (current: {student['grade']}): ")

        if name:
            student["name"] = name
        if age:
            student["age"] = age
        if grade:
            student["grade"] = grade

        self.save_students()
        print(f"Student with ID {student_id} updated successfully.")

    def remove_student(self):
        print("\nRemoving a student...")
        student_id = input("Enter student ID to remove: ").upper()

        if student_id not in self.students:
            print(f"Student with ID {student_id} does not exist.")
            return

        del self.students[student_id]
        self.save_students()
        print(f"Student with ID {student_id} removed successfully.")

    def display_students(self):
        print("\nDisplaying all students...")
        if not self.students:
            print("No students in the database.")
        else:
            for student_id, student_info in self.students.items():
                print(f"ID: {student_id}")
                print(f"Name: {student_info['name']}")
                print(f"Age: {student_info['age']}")
                print(f"Grade: {student_info['grade']}\n")

    def search_student(self):
        print("\nSearching for students...")

        while True:
            print("\nWhat would you like to search by?\n")
            print("1. ID")
            print("2. Name")
            print("3. Age")
            print("4. Exit")

            choice = input("Enter your choice: ")

            if choice == "1":
                self.search_by_id()
            elif choice == "2":
                self.search_by_name()
            elif choice == "3":
                self.search_by_age()
            elif choice == "4":
                print("Exiting search...")
                break
            else:
                print("Invalid choice. Please try again.")

    def search_by_id(self):
        student_id = input("Enter student ID: ").upper()
        student = self.students.get(student_id)
        if student:
            print(f"ID: {student_id}")
            print(f"Name: {student['name']}")
            print(f"Age: {student['age']}")
            print(f"Grade: {student['grade']}\n")
        else:
            print("No student with that ID found.")

    def search_by_name(self):
        name = input("Enter student Name: ").upper()
        found = False
        for student_id, student_info in self.students.items():
            if name == student_info["name"].upper():
                print(f"\nID: {student_id}")
                print(f"Name: {student_info['name']}")
                print(f"Age: {student_info['age']}")
                print(f"Grade: {student_info['grade']}\n")
                found = True
        if not found:
            print("No student with that Name found.")

    def search_by_age(self):
        age = input("Enter student Age: ").upper()
        found = False
        for student_id, student_info in self.students.items():
            if age == student_info["age"].upper():
                print(f"\nID: {student_id}")
                print(f"Name: {student_info['name']}")
                print(f"Age: {student_info['age']}")
                print(f"Grade: {student_info['grade']}\n")
                found = True
        if not found:
            print("No student with that Age found.")

def main():
    database = StudentDatabase()
    print("-------- WELCOME TO THE STUDENT DATABASE --------")
    
    while True:
        print("\n1. Add Student")
        print("2. Edit Student")
        print("3. Remove Student")
        print("4. Display all Students")
        print("5. Search Students")
        print("6. Exit\n")
        
        choice = input("Enter your choice: ")

        if choice == "1":
            database.add_student()
        elif choice == "2":
            database.edit_student()
        elif choice == "3":
            database.remove_student()
        elif choice == "4":
            database.display_students()
        elif choice == "5":
            database.search_student()
        elif choice == "6":
            print("Exiting...")
            break
        else:
            print("Invalid choice. Please try again.")

if __name__ == "__main__":
    main()