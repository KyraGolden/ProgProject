#!/bin/bash

# File containing the sentences
SENTENCES_FILE="help.txt"
# API endpoint
API_ENDPOINT="https://api.openai.com/v1/chat/completions"
# Output file
OUTPUT_FILE="outputAPI_TemperatureZeroPointTwo.txt"


sentence=''

while IFS=$'\n' read -r line || [[ -n "$line" ]]; do
    # If the line is blank, it's the end of a sentence
    if [[ -z "$line" ]]; then
        if [[ -n "$sentence" ]]; then
            sentence="${sentence%?}"  # remove trailing space

            # Write the sentence to the output file
            echo "{ \"original_sentence\": \"$sentence\" }" >> "$OUTPUT_FILE"

            # Execute the curl command
            curl "https://api.openai.com/v1/chat/completions" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer $TOKEN" \
            -d "{
                \"model\": \"gpt-3.5-turbo\",
                \"messages\": [{
                    \"role\": \"assistant\",
                    \"content\": \"Identify the nouns in this sentence: '$sentence' that denote a human. Return the noun and indicate if they are referring to a male or female person by writing the noun and gender as answer in the format: Noun, Gender. If there are none, write None. \"
                }],
                \"temperature\": 0.2
            }" >> "$OUTPUT_FILE"

            sentence=''  # reset sentence variable
        fi
    else
        word=$(echo "$line" | cut -f2)  # extract the word form
        sentence+="$word "  # add word to sentence
    fi
done < "$SENTENCES_FILE"

if [[ -n "$sentence" ]]; then
    sentence="${sentence%?}"  # remove trailing space
    # Write the sentence to the output file
    echo "Original sentence: $sentence" >> "$OUTPUT_FILE"
fi
