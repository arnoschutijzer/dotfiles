---
name: effective-python
description: Idiomatic Python patterns. Use when writing any Python code.
---

# Effective Python

Idiomatic Python patterns for clean, maintainable code.

## Type Hints

```python
# Always type-hint public function signatures
def filter_segments(segments: list[dict]) -> list[dict]:
    ...

def clean_transcription(result: dict) -> str:
    ...

def resample(audio: np.ndarray, orig_sr: int, target_sr: int) -> np.ndarray:
    ...

# Use Optional for nullable
from typing import Optional
def find_user(user_id: str) -> Optional[User]:
    ...

# Use Protocol for dependency injection
from typing import Protocol

class Transcriber(Protocol):
    def transcribe(self, audio: np.ndarray, language: str) -> str: ...
```

## Dataclasses

```python
from dataclasses import dataclass

# Prefer frozen=True for immutable data
@dataclass(frozen=True)
class TranscriptionResult:
    text: str
    duration_seconds: float
    language: str
    model: str

# Use field defaults
@dataclass
class ServerConfig:
    model: str = "mlx-community/whisper-large-v3-turbo"
    language: str = "nl"
    port: int = 8765
    silence_threshold: float = 0.01
```

## Guard Clauses (Early Returns)

```python
# GOOD - Early returns, flat structure
def process_chunk(audio, state):
    if state is None:
        state = {"text": "", "last_hash": ""}
    if audio is None:
        return state["text"], state

    sr, y = audio
    if y.ndim > 1:
        y = y.mean(axis=1)

    rms = np.sqrt(np.mean(y**2))
    if rms < SILENCE_THRESHOLD:
        return state["text"], state

    # Happy path - main logic here
    result = transcribe(y)
    state["text"] += result
    return state["text"], state

# BAD - Nested conditionals
def process_chunk(audio, state):
    if audio is not None:
        sr, y = audio
        if y.ndim == 1:
            rms = np.sqrt(np.mean(y**2))
            if rms >= SILENCE_THRESHOLD:
                # deeply nested logic
                pass
```

## Exception Handling

```python
# GOOD - Specific exceptions
try:
    result = mlx_whisper.transcribe(audio, path_or_hf_repo=model)
except FileNotFoundError:
    logging.error("Model not found: %s", model)
    raise
except RuntimeError as e:
    logging.warning("Transcription failed: %s", e)
    return ""

# BAD - Bare except
try:
    result = transcribe(audio)
except:
    pass

# BAD - Too broad
try:
    result = transcribe(audio)
except Exception:
    return ""
```

## String Formatting

```python
# GOOD - f-strings
logging.info("Transcribing %.2f seconds of audio", len(y) / WHISPER_SAMPLE_RATE)
message = f"Model: {model}, Language: {language}"

# BAD - String concatenation
message = "Model: " + model + ", Language: " + language

# BAD - Old-style formatting
message = "Model: %s, Language: %s" % (model, language)
```

## Comprehensions

```python
# List comprehension - clear and readable
kept = [seg for seg in segments if seg.get("compression_ratio", 0.0) <= MAX_COMPRESSION_RATIO]

# Dict comprehension
config = {k: v for k, v in defaults.items() if v is not None}

# Generator for large sequences (memory efficient)
total = sum(len(chunk) for chunk in audio_chunks)

# DON'T over-nest comprehensions
# BAD - Hard to read
result = [f(x) for x in [g(y) for y in items if h(y)] if p(x)]

# GOOD - Use intermediate variable or loop
filtered = [g(y) for y in items if h(y)]
result = [f(x) for x in filtered if p(x)]
```

## Path Handling

```python
from pathlib import Path

# GOOD - pathlib
model_path = Path.home() / ".cache" / "torch" / "hub" / "model.jit"
index_html = Path(__file__).parent / "index.html"

# BAD - string manipulation
model_path = os.path.join(os.path.expanduser("~"), ".cache", "torch", "hub", "model.jit")
```

## Context Managers

```python
# File I/O
with open("data.json") as f:
    data = json.load(f)

# Multiple resources
with open("input.txt") as fin, open("output.txt", "w") as fout:
    fout.write(fin.read())
```

## Constants

```python
# Module-level constants in UPPER_CASE
WHISPER_SAMPLE_RATE = 16000
VAD_FRAME_SAMPLES = 512
MAX_SPEECH_SECONDS = 15
MIN_SILENCE_DURATION_MS = 300

# BAD - Magic numbers
if len(y) / 16000 > 15:  # What are these numbers?
```

## Async Patterns

```python
import asyncio

# Offload CPU-bound work to thread pool
async def transcribe_async(audio: np.ndarray) -> str:
    result = await asyncio.to_thread(
        mlx_whisper.transcribe,
        audio,
        path_or_hf_repo=MODEL,
        language=LANGUAGE,
    )
    return clean_transcription(result)

# Never block the event loop
# BAD
async def handle(ws):
    result = mlx_whisper.transcribe(audio)  # Blocks!

# GOOD
async def handle(ws):
    result = await asyncio.to_thread(mlx_whisper.transcribe, audio)
```

## Logging

```python
import logging

# GOOD - Use logging, not print
logging.info("Transcribing %.2f seconds", duration)
logging.warning("Hallucination detected: %r", text)
logging.error("Model load failed: %s", e)

# BAD - Print statements in production code
print(f"Transcribing {duration} seconds")

# Use lazy formatting (don't format unless logged)
logging.debug("Audio shape: %s, dtype: %s", audio.shape, audio.dtype)
```

## Mutable Default Arguments

```python
# BAD - Shared mutable state
def process(items=[]):
    items.append("new")
    return items

# GOOD - None sentinel
def process(items=None):
    if items is None:
        items = []
    items.append("new")
    return items
```

## Enums for Fixed Choices

```python
from enum import Enum

class TranscriptionStatus(Enum):
    PENDING = "pending"
    PROCESSING = "processing"
    COMPLETED = "completed"
    FAILED = "failed"
```
