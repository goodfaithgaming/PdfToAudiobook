#!/bin/bash
python3 extract_text.py $1 vision_output.json
python3 classify.py vision_output.json classified_text.json
python3 tts.py
python3 join_audios.py
