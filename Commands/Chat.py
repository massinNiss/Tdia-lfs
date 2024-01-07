#voice.py
import pyttsx3
import openai

openai.api_key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" //Votre API ici

engine = pyttsx3.init()

user_name = "USER"
bot_name = "TDIA"

while True:
    # Get user input
    user_input = input(f"{user_name}: ")

    # Send user input to the ChatGPT API
    response = openai.Completion.create(
        engine="text-davinci-003", 
        prompt=f"{user_name}: {user_input}\n{bot_name}:",
        temperature=0.7,
        max_tokens=100,
        top_p=1,
        frequency_penalty=0,  #using frequent tokens 
        presence_penalty=0
    )

    # Extract the bot's response from the API result
    response_str = response["choices"][0]["text"].replace(f"{bot_name}:", "").strip()
    print(response_str)

    # Speak the response
     engine.say(response_str)
     engine.runAndWait()
