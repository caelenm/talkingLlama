#!/bin/bash

# Get input from the terminal
read -p "Enter a question: " input

# Run the ollama model and capture the output
output=$(expect -c "
spawn ollama run tinyllama
expect >>>
send \"$input\r\"
expect >>> 
")

# Remove the ">>>" prompt from the output
output=${output#>>> }

# Remove ANSI escape codes from the output
output=$(echo "$output" | perl -pe 's/\e\[?.*?[\@-~]//g')

# Remove lines containing specific prompts
output=$(echo "$output" | grep -v -e "spawn ollama run tinyllama" -e ">>> Send a message (/? for help)")

# Save the output to a file
echo "$output" > output.txt

# Speak the output using espeak
espeak -f output.txt
