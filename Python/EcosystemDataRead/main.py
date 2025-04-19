import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv("ecosystem_data.csv")

plt.plot(df["time"], df["predator"], label="predator", color="red")
plt.plot(df["time"], df["prey"], label="prey", color="green")

plt.xlabel("time")
plt.ylabel("population")
plt.title("Predator-Prey Over Time (aka extinction speedrun)")
plt.legend()
plt.grid(True)
plt.show()
