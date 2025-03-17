# Telegram Uploader Script for TDL

This repository contains a Bash script that creates a multi-part split ZIP archive and uploads the files to Telegram using [TDL](https://github.com/tdlib/tdl). 

## Features

- Splits large files into smaller 2GB ZIP parts.
- Uploads files to a designated Telegram channel.
- Automatically generates a link for the first uploaded file.
- Sends an index message to another Telegram channel.

## Requirements

Before using this script, ensure that you have the following:

1. **Ubuntu User**: The script must be executed as an Ubuntu user or modify the script accordingly.
2. **TDL (Telegram Database Library CLI)**: This script relies on `tdl` for file uploads.
3. **TDL Login Token**: Generate a `token.json` using TDL and store it at `/home/ubuntu/tdl-token/token.json`.
4. **Telegram Channels**: You need:
   - A **files channel** (`TG_FILES_CHANNEL_ID`) to upload the split files.
   - An **index channel** (`TG_INDEX_CHANNEL_ID`) to post the file links.

## Installation

1. Install `tdl` if you haven't already:

   ```bash
   npm install -g tdl
   ```

2. Clone this repository:

   ```bash
   git clone https://github.com/YOUR_USERNAME/Telegram_Uploader_Script_For_TDL.git
   cd Telegram_Uploader_Script_For_TDL
   ```

3. Update the script with your **Telegram Channel IDs** and **TDL token path**.

## Usage

Run the script by passing the file or directory name as an argument:

```bash
./tdl-upload.sh myfile.txt
```

### Example:

```bash
./tdl-upload.sh myfolder
```

### How It Works:

1. The script creates a temporary directory.
2. It compresses the file/folder into multiple 2GB ZIP parts.
3. Each ZIP part is uploaded to the **files channel**.
4. A link to the first uploaded file is generated.
5. An index message is forwarded to the **index channel**.

## Notes

- Ensure that `tdl` is configured and authenticated.
- Modify the script to set your `TG_FILES_CHANNEL_ID` and `TG_INDEX_CHANNEL_ID`.
- The first uploaded file's URL is extracted from `tdl-export.json`.
- The index message requires manual modification (`--from "with-any-message-url-of-index-channel"`).

## License

This project is open-source and available under the MIT License.

---

### ⚠ Disclaimer

Use this script responsibly. The repository owner is not responsible for any misuse.

Let me know if you need any modifications! 🚀