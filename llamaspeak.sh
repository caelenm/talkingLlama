#!/bin/bash

# install ollama with: curl -fsSL https://ollama.com/install.sh | sh
# install espeak with: sudo apt install espeak

# Get input from the terminal
read -p "Enter a question: " input

# Run the ollama model and capture the output
output=$(expect -c "
spawn ollama run llama3
expect >>>
send \"$input\r\"
expect >>> 
")

# Remove the ">>>" prompt from the output
output=${output#>>> }

# Remove ANSI escape codes from the output
output=$(echo "$output" | perl -pe 's/\e\[?.*?[\@-~]//g')

# Remove non-ASCII characters from the output
output=$(echo "$output" | tr -cd '\11\12\15\40-\176')

# Remove lines containing specific prompts
output=$(echo "$output" | grep -v -e "spawn ollama run llama3" -e ">>> Send a message (/? for help)")

# Save the output to a file
echo "$output" > output.txt

# Convert the output to a string
output_string=$(cat output.txt)

# Speak the output as a string using espeak
espeak -v en-us+m3 -s 150 -p 50 -a 200 "$output_string"
