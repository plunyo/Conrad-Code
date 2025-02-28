class Complaint:
    def __init__(self, message: str, date: str) -> None:
        self.message: str = message
        self.date: str = date

    def __repr__(self):
        return f"{self.message} \n- {self.date}"
