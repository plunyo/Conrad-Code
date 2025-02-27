# OLD BAD BAD COODE DO NOT LOOK UNLESS U WANT ANYURESM CANCER AND MORE

bag = ["Hammer", "Chips", "Flashlight"]
hp = 100

while hp < 0:
    print("you died lmao")
    input("")

print("you have " + str(bag))
chainq = input("you go camping, and then you wake in a strange room with your leg chained up, what do you do/use? ")
if chainq == ("Hammer"):
    print("you hammer away but ultimately the Hammer breaks")
    bag.remove("Hammer")
    print(bag)
    input("")
    hammer = input("what next? ")
    if hammer == ("Chips"):
        print("the chips satisfy your hunger but nothing else happens")
        bag.remove("Chips")
        print(bag)
        input("")
        hammercf = input("whats next? ")
        if hammercf == ("Flashlight"):
            print("the Flashlight temporarily satisfy your boredom but nothing else happens")
            bag.remove("Flashlight")
            print(bag)
            input("")
    elif hammer == ("Flashlight"):
        print("the Flashlight temporarily satisfy your boredom but nothing else happens")
        bag.remove("Flashlight")
        print(bag)
        input("")
        hammerfc = input("what next? ")
        if hammerfc == ("Chips"):
            print("the chips satisfy your hunger but nothing else happens")
            bag.remove("Chips")
            print(bag)
            input("")
    
elif chainq == ("Chips"):
    print("the chips satisfy your hunger but nothing else happens")
    bag.remove("Chips")
    print(bag)
    input("")
    chips = input("whats next? ")
    if chips == ("Hammer"):
        print("you hammer away but ultimately the Hammer breaks")
        bag.remove("Hammer")
        print(bag)
        input("")
        chipshf = input("whats next? ")
        if chipshf == ("Flashlight"):
            print("the Flashlight temporarily satisfy your boredom but nothing else happens")
            bag.remove("Flashlight")
            print(bag)
            input("")
    if chips == ("Flashlight"):
        print("the Flashlight temporarily satisfy your boredom but nothing else happens")
        bag.remove("Flashlight")
        print(bag)
        input("")
        chipsfh = input("whats next? ")
        if chipsfh == ("Hammer"):
            print("you hammer away but ultimately the Hammer breaks")
            bag.remove("Hammer")
            print(bag)
            input("")
    elif chips == ("Flashlight"):
        print("the Flashlight temporarily satisfy your boredom but nothing else happens")
        bag.remove("Flashlight")
        print(bag)
        input("")
        
elif chainq == ("Flashlight"):
    print("the Flashlight temporarily satisfy your boredom but nothing else happens")
    bag.remove("Flashlight")
    print(bag)
    flash = input("what next? ")
    if flash == ("Hammer"):
        print("you hammer away but ultimately the Hammer breaks")
        bag.remove("Hammer")
        print(bag)
        flashh = input("what next? ")
        if flashh == ("Chips"):
            print("the cthips satisfy your hunger but nothing else happens")
            bag.remove("Chips")
            print(bag)
    elif flash == ("Chips"):
        print("the chips satisfy your hunger but nothing else happens")
        bag.remove("Chips")
        print(bag)
        flashc = input("what next? ")
        if flashc == ("Hammer"):
            print("you hammer away but ultimately the hammer breaks")
            bag.remove("Hammer")
            print(bag)
        
print("you used ALL of your resources? Loser")
input("")
ege = input("the man walks in wearing all black, keeping his face concealed behind a mask, DO YOU TAKE A SWING? Y or N :")
if ege == ("Y"):
    print("you took a swing you hit and you dented their mask, you got tased and lost 20hp")
    hp -= 20
    print("you now have " + str(hp) + ("/100hp"))
elif ege == ("N"):
    print("he gives you a lil kissy")
print("he gives you a lil napkin for your tears")
bag.append("Napkin")
input("")
napuse = input("do you use the napkin? Y or N :")
if napuse == ("Y"):
    print("you use the napkin but now its wet and broken")
    bag.remove("Napkin")
elif napuse == ("N"):
    print("it stays in your bag")