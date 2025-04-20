#!/bin/bash

if [ ! $UID -eq 1001 ];
then
	echo "Please Execute as Ubuntu User."
	exit 1
fi

if [ ! -z "$1"  ];
then
	# Iterating Through All The Positional Arguments
	for x in "$@";
	do
    		# ENV VARIABLES
		TG_INDEX_CHANNEL_ID="YOUR_INDEX_CHANNEL_ID"
        	TG_FILES_CHANNEL_ID="YOUR_FILES_CHANNEL_ID"
		# Login Token Path (generate using tdl)
		TDL_CONFIG_PATH="/home/ubuntu/tdl-token/token.json"

		echo -e "\e[36m=====================================\e[0m"
	    	echo -e "\e[33m          Telegram Uploader          \e[0m"
	    	echo -e "\e[36m=====================================\e[0m\n"


		# Creating Temp Dir For Storing Zip Split Parts
		temp_dir=$(mktemp -d tempdir.XXXXXX)
		echo -e "\e[36m[CREATING]\e[0m \e[38;5;218mTemporary Directory: $temp_dir \e[0m"
		echo -e "\e[92mSuccess\e[0m\n"

		# Zipping Process
		echo -e "\e[36m[ZIPPING]\e[0m \e[38;5;218mCreating a Split Zip Archive\e[0m"
		zip -r -0 -s2000M "./${temp_dir}/${x}.zip" "${x}" > /dev/null
		echo -e "\e[92mSuccess\e[0m"

		# LOOPING THROUGH EACH ZIP PART
		count=0
	        num_of_files=$(find "$temp_dir" -maxdepth 1 -type f | wc -l)
	        uploaded_file_link=""

		for file in "$temp_dir"/*;
		do
	        ((count++))
			echo -e "\n\e[36m[UPLOADING]\e[0m \e[38;5;214m(${count}/${num_of_files})\e[0m \e[38;5;218m${file##*/}\e[0m"
	                # checking file exist before uploading to telegram file channel
					[ -f "$file" ] && tdl upload \
					--limit 1 \
					--path "$(realpath "$file")" \
					--chat $TG_FILES_CHANNEL_ID \
					--storage "path=${TDL_CONFIG_PATH},type=file" \
					--rm

			if [ $count == 1 ]; then
				# Generating tdl-export.json for the first uploaded file
	                        tdl chat export \
				--chat $TG_FILES_CHANNEL_ID \
				-T last \
				-i 1 \
				--with-content \
				--limit 1 \
				--storage "path=${TDL_CONFIG_PATH},type=file" > /dev/null

				# Reading TG_URL of first uploaded file From tdl-export.json
				uploaded_file_link="https://t.me/c/$(jq '.id' tdl-export.json)/$(jq '.messages[0].id' tdl-export.json)"
				rm "tdl-export.json"
			fi
			
			# when uploading is completed
			# please replace the tdl forward command's flag --from "with-any-message-url-of-index-channel"
			# please do the above step, in order to make forward command work.
			if [ $count == $num_of_files ]; then
				# Send Link To Telegram Index Channel
	                        tdl forward \
				--from "https://t.me/c/${TG_INDEX_CHANNEL_ID}/1" \
				--edit "\`<a href=\"${uploaded_file_link}\">${file##*/}</a> [${num_of_files} Parts]\`" \
				--to $TG_INDEX_CHANNEL_ID \
				--storage "path=${TDL_CONFIG_PATH},type=file" > /dev/null
			fi
		done
		
		# Cleaning Process (Removes Zip Files)
		echo -e "\n\e[36m[CLEANING]\e[0m \e[38;5;218mRemoving Temporary Directory and Zip Files\e[0m"
		rm -r "./${temp_dir}"

		echo -e "\e[36m=============================\e[0m"
	    echo -e "\e[33m          COMPLETED          \e[0m"
	    echo -e "\e[36m===========================\e[0m\n"
	done
else
	echo -e  "\e[36mPlease Provide Folder_Name or File_Name\e[0m"
fi
