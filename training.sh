#!/bin/bash

# Create a new virtual environment for Python3
python3 -m venv myenv
source myenv/bin/activate

# Install chatterbot and other required packages
pip3 install https://github.com/RaSan147/ChatterBot_update/archive/refs/heads/master.zip
python3 -m spacy download en_core_web_sm
pip3 install chatterbot_corpus
python3 -m chatterbot_corpus.download
pip3 install --upgrade PyYAML
pip3 uninstall pyyaml -y
pip3 install PyYAML>=4.2b1

# Create a new Python file for your ChatterBot instance
touch chatbot.py

# Add the following code to chatbot.py
echo 'from chatterbot import ChatBot
from chatterbot.trainers import ChatterBotCorpusTrainer
from chatterbot.trainers import ListTrainer
import yaml

chatbot = ChatBot(
    "MyChatBot",
    storage_adapter="chatterbot.storage.SQLStorageAdapter",
    database_uri="sqlite:///database.sqlite3"
)

# Start by training our bot with the twilio dataset
trainer = ChatterBotCorpusTrainer(chatbot)
trainer.train("chatterbot.corpus.english")

# Train the bot with your own dataset
with open("path/to/your_dataset.yml", 'r') as file:
    conversations = yaml.safe_load(file)

trainer = ListTrainer(chatbot)
for conversation in conversations['conversations']:
    trainer.train(conversation)

# Start interacting with the bot
while True:
    try:
        user_input = input()
        bot_response = chatbot.get_response(user_input)
        print(bot_response)

    except (KeyboardInterrupt, EOFError, SystemExit):
        break' >> chatbot.py

# Replace "path/to/your_dataset.yml" with the actual path and name of your YAML file containing your own training data

# Run the Python file to start training the bot
python3 chatbot.py
