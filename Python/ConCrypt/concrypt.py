import base64
import os
import sys


def rot13(text):
    result = []
    for char in text:
        if "a" <= char <= "z":
            result.append(chr((ord(char) - ord("a") + 13) % 26 + ord("a")))
        elif "A" <= char <= "Z":
            result.append(chr((ord(char) - ord("A") + 13) % 26 + ord("A")))
        else:
            result.append(char)
    return "".join(result)


def encrypt_transform(input_string):
    base64_encoded = base64.b64encode(input_string.encode()).decode()
    rot13_encoded = rot13(base64_encoded)
    base32_encoded = base64.b32encode(rot13_encoded.encode()).decode()
    reversed_string = base32_encoded[::-1]
    return reversed_string


def decrypt_transform(input_string):
    reversed_string = input_string[::-1]

    # Fix the padding for Base32 decoding
    padding_needed = len(reversed_string) % 8
    if padding_needed:
        reversed_string += "=" * (8 - padding_needed)

    try:
        base32_decoded = base64.b32decode(
            reversed_string, casefold=True
        ).decode()
        rot13_decoded = rot13(base32_decoded)
        original_string = base64.b64decode(rot13_decoded).decode()
        return original_string
    except (base64.binascii.Error, UnicodeDecodeError) as e:
        print(
            f"Error during decryption: {e}. Please ensure the input is correctly formatted."
        )
        sys.exit(1)


def main():
    if len(sys.argv) < 3 or len(sys.argv) > 4:
        print(
            "Usage: python script.py <encrypt/decrypt> <input_file> [output_file]"
        )
        sys.exit(1)

    operation = sys.argv[1]
    input_file = sys.argv[2]
    output_file = sys.argv[3] if len(sys.argv) == 4 else input_file

    if not os.path.isfile(input_file):
        print(f"Error: The input file '{input_file}' does not exist.")
        sys.exit(1)

    try:
        with open(input_file, "r") as infile:
            input_data = infile.read()
    except Exception as e:
        print(f"Error reading the input file: {e}")
        sys.exit(1)

    if operation == "encrypt":
        result = encrypt_transform(input_data)
    elif operation == "decrypt":
        result = decrypt_transform(input_data)
    else:
        print("Invalid operation. Use 'encrypt' or 'decrypt'.")
        sys.exit(1)

    try:
        with open(output_file, "w") as outfile:
            outfile.write(result)
    except Exception as e:
        print(f"Error writing to the output file: {e}")
        sys.exit(1)

    print(
        f"{operation.capitalize()}ion completed successfully! Results saved to '{output_file}'."
    )


if __name__ == "__main__":
    main()
