import sys

def get_sentences_with_female_subject(file_path):
    sentences = []
    current_sentence = []

    with open(file_path, 'r') as file:
        lines = file.readlines()

        for i, line in enumerate(lines):
            # Skip empty lines
            if not line.strip():
                if current_sentence:
                    sentences.append(current_sentence)
                    current_sentence = []
                continue

            # Split the line by tabs to extract fields
            fields = line.strip().split('\t')

            # Get the subject field (index 6 in CoNLL format)
            isnomen = fields[4]
            isfemale = fields[5]
            issubject = fields[7]

            # Check if the subject is female (by CoNLL notation)
            if ("masc" in isfemale.lower() in isfemale.lower()) and isnomen in ['NN', 'NE'] and issubject == 'subj':
                # Capture lines backward until the previous occurrence of the index
                prev_lines = []
                for j in range(i - 1, -1, -1):
                    if lines[j].strip():
                        prev_lines.insert(0, lines[j])
                    else:
                        break

                # Append the current line
                current_sentence.extend(prev_lines)
                current_sentence.append(line)

                # Capture lines forward until the next occurrence of the index
                next_lines = []
                for k in range(i + 1, len(lines)):
                    if lines[k].strip():
                        next_lines.append(lines[k])
                    else:
                        break

                current_sentence.extend(next_lines)

    if current_sentence:
        sentences.append(current_sentence)

    return sentences

# Usage example
if __name__ == "__main__":
    file_path = sys.argv[1]
    sentences = get_sentences_with_female_subject(file_path)
    for sentence in sentences:
        print("".join(sentence))
