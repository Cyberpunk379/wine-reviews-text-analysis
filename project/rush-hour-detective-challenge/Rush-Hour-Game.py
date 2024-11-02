import random

def choose_character():
    print("🌟 Welcome to Rush Hour 2: Detective's Challenge! 🕵️‍♂️")
    print("In this adventure, you'll step into the shoes of a detective with unique skills and personality traits.")
    print("Choose your character to begin the investigation:\n")
    print("1: Jackie Chang - Known for his serious and proactive nature. Better at methodical investigation and direct action.")
    print("2: Chris Talker - A bit clumsy but lucky. Excels in social interactions and unconventional methods.\n")

    while True:
        choice = input("Enter 1 for Jackie or 2 for Chris: ").strip()
        if choice == "1":
            print("\nYou have chosen Jackie Chang. Time to be sharp and proactive!")
            return "Jackie"
        elif choice == "2":
            print("\nYou have chosen Chris Talker. Let's see how luck helps you in this adventure!")
            return "Chris"
        else:
            print("Invalid choice. Please enter 1 or 2.")

def stage_one(character):
    print("\n────────────────────────────────────────────────────")
    print("Stage 1: Embassy Party Investigation 🎉🔍")
    print("You are at a lavish embassy party. Something's amiss, and it's your job to find out what.")
    
    # Initialize list of clues
    clues_list = []

    if character == "Jackie":
        print("As Jackie, you decide to be methodical. Searching rooms or observing quietly could be more effective.")
    else:
        print("As Chris, your approach is less conventional. Mingling or causing a small distraction might work better.")

    choice = input("Do you want to 'mingle' with guests, 'search' the rooms, or 'observe' quietly? ").lower()

    if character == "Jackie":
        if choice == "search":
            clues_list.append("Hidden document")
            print("🔍 You meticulously search the rooms and find a hidden document.")
        elif choice == "observe":
            clues_list.append("Suspicious conversation")
            print("👀 From a distance, you observe a suspicious conversation.")
        else:
            print("🗣️ Mingling isn't Jackie's strength. You gather minimal information.")

    elif character == "Chris":
        if choice == "mingle":
            clues_list.append("Overheard secret")
            print("🗣️ You charm your way through the crowd and overhear a secret.")
        elif choice == "observe":
            clues_list.append("Unusual activity")
            print("👀 You try to observe, but you're better off in the crowd.")
        else:
            print("🔍 Searching isn't Chris's forte. You turn up little of value.")

    print(f"🔎 Clues found: {len(clues_list)}")
    print("Clues list:", clues_list)
    print("────────────────────────────────────────────────────\n")
    return clues_list

def stage_two(character, clues_list):
    print("\n────────────────────────────────────────────────────")
    print("Stage 2: The Chase through the Streets 🏙️🚔")
    print("After gathering clues at the party, you spot a suspicious figure hastily leaving the scene.")

    choice = input("Do you 'pursue' the suspect on foot or try a 'shortcut'? ").lower()

    if character == "Jackie":
        if choice == "pursue":
            clues_list.append("Fingerprint evidence")
            print("🏃‍♂️ With swift action, you catch up to the suspect and find fingerprint evidence.")
        else:
            clues_list.append("Lost item")
            print("🤔 The shortcut doesn't pay off, but you find a lost item left by the suspect.")

    elif character == "Chris":
        if choice == "shortcut":
            success = random.choice([True, False])  # 50-50 chance
            clue = "Stolen wallet" if success else "Discarded note"
            clues_list.append(clue)
            print(f"🚀 You take a risky shortcut and find a {clue}.")
        else:
            clues_list.append("Witness account")
            print("🏃‍♂️ Pursuing directly isn't Chris's strength, but you gather a witness account.")

    print(f"🔎 Total clues found: {len(clues_list)}")
    print("Clues list:", clues_list)
    print("────────────────────────────────────────────────────\n")
    return clues_list

def stage_three(character, clues_list):
    print("\n────────────────────────────────────────────────────")
    print("Stage 3: Undercover in the Casino 🎰🕶️")
    print("The clues lead you to a bustling casino, a potential hub for criminal activity.")

    choice = input("Do you 'observe' the casino, 'investigate' discreetly, or 'gamble'? ").lower()

    if character == "Jackie":
        if choice == "gamble":
            print("🎲 Jackie decides to gamble, but his serious demeanor gives him away! You're exposed!")
            fail()  # Ends the game if Jackie gambles
            return clues_list, True  # Indicate failure
        elif choice in ["observe", "investigate"]:
            clue = "Security footage" if choice == "observe" else "Confidential ledger"
            clues_list.append(clue)
            print(f"🔍 Jackie successfully {choice} and finds a {clue}.")
    elif character == "Chris":
        if choice == "gamble":
            clues_list.append("Dealer's whisper")
            print("🎲 Chris hits the tables and a dealer whispers crucial information to him.")
        else:
            clue = "Eavesdropped plan" if choice == "observe" else "Forgotten phone"
            clues_list.append(clue)
            print(f"👀 Chris's attempts at {choice} yield a {clue}.")

    print(f"📈 Total clues found: {len(clues_list)}")
    print("Clues list:", clues_list)
    print("────────────────────────────────────────────────────\n")
    return clues_list, False  # No failure

def stage_four():
    print("\nStage 4: The Showdown 🏢💣")
    print("────────────────────────────────────────────────────")
    print("🕵️‍♂️ You've gathered enough clues and it's time for the final confrontation.")
    print("💼 The situation is critical: a hostage situation with a bomb threat and a ransom demand.")
    print("You must decide: save the hostage, secure the ransom money, or try to do both.\n")

    girl_saved = False
    money_recovered = False

    choice = input("What will you do first? Type 'save' to rescue the hostage or 'secure' to recover the ransom: ").lower()
    print("────────────────────────────────────────────────────")

    if choice == "save":
        girl_saved = True  # Assume success in saving
        print("👧 You bravely disarm the bomb and save the hostage!")
        second_choice = input("Do you attempt to recover the ransom as well? (yes/no): ").lower()
        money_recovered = second_choice == "yes" and bool(random.getrandbits(1))
    elif choice == "secure":
        money_recovered = True  # Assume success in securing the ransom
        print("💰 You successfully secure the ransom money!")
        second_choice = input("Do you attempt to save the hostage as well? (yes/no): ").lower()
        girl_saved = second_choice == "yes" and bool(random.getrandbits(1))
    else:
        print("😖 Inaction leads to the worst outcome. The mission fails.")

    print(f"🔚 Stage 4 Complete. Hostage saved: {'Yes' if girl_saved else 'No'}. Ransom recovered: {'Yes' if money_recovered else 'No'}\n")
    print("────────────────────────────────────────────────────")
    return girl_saved, money_recovered

def win(girl_saved, money_recovered):
    print("\n🎉 Congratulations! 🎉")
    print("Mission Outcome:")
    print("👧 Hostage Status: " + ("Saved!" if girl_saved else "Not Saved."))
    print("💰 Ransom Status: " + ("Recovered!" if money_recovered else "Not Recovered."))
    print("\n🏆 You've shown great skill and determination. The city is safe, thanks to you!")
    exit()

def fail():
    print("\n🚨 Mission Failed! 🚨")
    print("Despite your best efforts, the mission ends in tragedy.")
    exit()  # Terminates the game
    
def run_game():
    character = choose_character()
    clues_list = stage_one(character)  # Collect clues from stage one
    clues_list = stage_two(character, clues_list)  # Pass and update clues in stage two
    clues_list, failed = stage_three(character, clues_list)  # Pass and update clues in stage three

    if failed:
        return  # If fail condition is met in stage_three, end the game

    girl_saved, money_recovered = stage_four()  # Stage four does not need clues_list

    if girl_saved or money_recovered:
        win(girl_saved, money_recovered)
    else:
        fail()

run_game()