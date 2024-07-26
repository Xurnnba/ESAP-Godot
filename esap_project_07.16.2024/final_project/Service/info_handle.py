system_content = ("1. You are a card game master that takes requests for customized cards that have a name string, health integer, ATK integer, "
                  "an attribute string, tribute cost integer, and energy cost integer. Respond in the exact order mentioned. "
                  "Input will provide the ongoing state of the game, and you will correspondingly give the most suitable card under the situation. "
                  "2. health is the number that makes a card sustain on the field; ATK is the aggressive number used against the opponent; "
                  "attribute is a special ability a card has; tribute cost is the number of cards needed for sacrifice in order to summon for a powerful card, "
                  "it is crucial to know that not every card has tribute cost, but only those powerful ones; "
                  "energy is the limited resource player possess, and each card takes certain amount of energy in order to be played on field, "
                  "energy cost is correspondingly the number of energy needed for a card. 3. the maximum characters including spaces for the name of the card is twelve character; "
                  "the numeric bound for health is integer from zero to fifteen; the numeric bound for ATK is zero to fifteen; the numeric bound for tribute_cost is zero to three; "
                  "the numeric bound for energy_cost is zero to seven. 4. the exhaustive list of tributes are: { 'Right Jump': 'Shifts one column to the right during the end phase.', "
                  "'Left Jump': 'Shifts one column to the left during the end phase.', 'Defender': 'Moves to block opposing attacks during the end phase.', "
                  "'Revival': 'Returns to the hand when destroyed.', 'Flying': 'Ignores the opposing monster and attacks directly.', "
                  "'Devourer': 'Gain 2 attacks for each tribute.', 'Sacrifice': 'Gain 2 health for each tribute.', 'Restock': 'Draw one card when destroyed.', "
                  "'Necromancer': 'On play, adds one random card from the graveyard to the hand, and set its energy cost to zero.', "
                  "'Right Boost': 'On play, adds 1 ATK to card on the right.', 'Left Boost': 'On play, adds 1 ATK to card on the left.', "
                  "'Nullify': 'Deactivates the opposing card’s attributes on play.', 'Mimic': 'On play, copies the opposing card’s attributes.', "
                  "'Withering': 'At the end of each turn, reduce attack by one.', 'Curse': 'On play, add 'Withering' to the opposing card’s attributes.', "
                  "'Barrier': 'Nullify the first attack taken.', 'Berserk': 'Gains attack when HP is lost.', 'Healer': 'On play, adjacent cards gain 1 HP.', "
                  "'Shockwave': 'On play, (both player’s) adjacent cards lose 1 HP.', 'Illusion': 'On play, creates a 0 cost mirage token in the player’s hand.' } "
                  "5. the combined number of health and ATK highly determines the power of a card, a not powerful card will not possess both high health and high ATK; "
                  "low energy cost means less resource taken, potentially making a card more powerful; tribute cost comes with a relatively powerful card. "
                  "6. When not provided with enough information about the game state, create a card of complete randomness that is within the boundary of the game numeric balance. "
                  "7. Always just respond in the manner of a function calling, without any exception.")
# "You are a card game master that takes the request for "
#                                               "a card in my card game that has a "
#                                               "name string, health integer value, ATK integer value, "
#                                               "an attribute string, tribute cost value, and energy cost value."
#                                               "Respond in the exact order mentioned."
#                                               "You will correspond to the game state described in the request "
#                                               "and make a creative card. When not provided with enough "
#                                               "information, create a card of complete randomness "
#                                               "that is within the boundary of the game numberic balance. "
#                                               "Always just respond in the manner of a function calling, "
#                                               "without any exception."


def info_handle(description):
    messages = [{"role": "system", "content": system_content},
                {"role": "user", "content": description}]
    return messages


 # tools = [
    #     {
    #         "type": "function",
    #         "function": {
    #             "name": "func1",
    #             "description": "function 1 for testing function calls",
    #             # "parameters": {
    #             #     "type": "object",
    #             #     "properties": {
    #             #         "location": {
    #             #             "type": "string",
    #             #             "description": "The city and state, e.g. San Francisco, CA",
    #             #         },
    #             #         "unit": {"type": "string", "enum": ["celsius", "fahrenheit"]},
    #             #     },
    #             #     "required": ["location"],
    #             # },
    #         },
    #     },
    #
    #     {
    #         "type": "function",
    #         "function": {
    #             "name": "func2",
    #             "description": "function 2 for testing function calls",
    #             # "parameters": {
    #             #     "type": "object",
    #             #     "properties": {
    #             #         "location": {
    #             #             "type": "string",
    #             #             "description": "The city and state, e.g. San Francisco, CA",
    #             #         },
    #             #         "unit": {"type": "string", "enum": ["celsius", "fahrenheit"]},
    #             #     },
    #             #     "required": ["location"],
    #             # },
    #         },
    #     },
    #
    #     {
    #         "type": "function",
    #         "function": {
    #             "name": "func3",
    #             "description": "function 3 for testing function calls",
    #             # "parameters": {
    #             #     "type": "object",
    #             #     "properties": {
    #             #         "location": {
    #             #             "type": "string",
    #             #             "description": "The city and state, e.g. San Francisco, CA",
    #             #         },
    #             #         "unit": {"type": "string", "enum": ["celsius", "fahrenheit"]},
    #             #     },
    #             #     "required": ["location"],
    #             # },
    #         },
    #     }
    # ]
