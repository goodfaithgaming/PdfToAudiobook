# Simple PDF to Audiobook

This project converts PDF books into **AI-narrated audiobooks** using [Coqui-TTS](https://github.com/idiap/coqui-ai-TTS) (fork), PyMuPDF and jenkspy. Everything is done
locally so there is no need for api keys, credits, etc.

The workflow is very simple but it will improve in the future — if you’re not afraid of tweaking a bit of code, you’ll have no problem.

For now only PDFs are accepted but I may implement support for EPUB.

---

## 🚀 How to use it

1. **Extract text from the PDF**
   ```bash
   python extract_text.py <input> <output>
   ```

- The script opens the file specified in the `input` argument (e.g. `book.pdf`)
- It generates a json file as specified in the `output` argument (e.g. `vision_output.json`)
1. **Classify text blocks**
    
    ```bash
    python classify.py
    ```
    
    - Uses **Jenks natural breaks** to classify text as:
        - `header` (titles),
        - `body` (main content),
        - `caption` (subtitles),
        - `other` (things to skip, e.g. page numbers).
    - Saves the result as `classified_text.json`.
2. **Generate audio with Coqui-TTS**
    
    ```bash
    python tts.py
    ```
    
    - Converts each block from `classified_text.json` into audio.
    - Produces **one WAV file per block** inside the `temp/` folder.
    
    👉 If you stop synthesis halfway through, it’s fine:
    
    all previously generated blocks remain in `temp/`, and you can continue from there.
    
3. **Join the audio files**
    
    ```bash
    python join_audios.py
    
    ```
    
    - Concatenates all `.wav` files from `temp/` into a single final `audiobook.mp3` using **FFmpeg**.

---

## 📦 Dependencies

You’ll need these libraries and tools installed:

- [**FFmpeg**](https://ffmpeg.org/) (make sure it’s in your PATH)
- [**Coqui-TTS (fork)**](https://coqui-tts.readthedocs.io/)
- [**PyMuPDF**](https://pymupdf.readthedocs.io/) (`pip install PyMuPDF`)
- [**jenkspy**](https://pypi.org/project/jenkspy/) (`pip install jenkspy`)
- [**Pydub**](https://pypi.org/project/pydub/)

---

## ⚠️ Notes

- The input PDF must be named **`book.pdf`** and placed in the project folder.
- For now the pipeline is very **basic and experimental**. If you don’t mind tweaking some code, you can adjust things like:
    - The page ranges to process.
    - The thresholds for text classification.
    - The voice or language in Coqui-TTS.
- If the book is long, the audio is split into small blocks (`temp/block_X.wav`) so you don’t lose progress. You can edit the `tts.py` file to skip blocks you have already processed.
