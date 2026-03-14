# Wyoming OpenAI - Umbrel App

OpenAI-Compatible Proxy Middleware for the Wyoming Protocol

## Overview

This app provides a Wyoming protocol server that connects to OpenAI-compatible endpoints of your choice. It enables Wyoming clients such as the [Home Assistant Wyoming Integration](https://www.home-assistant.io/integrations/wyoming/) to use the transcription (ASR) and text-to-speech (TTS) capabilities of various OpenAI-compatible projects.

## Features

- **File-Based Configuration**: Easily switch models and backends by editing a single configuration file
- **Multiple Backend Support**: Compatible with LocalAI, OpenAI, Groq, Microsoft Edge TTS, and more
- **Privacy-Focused**: Default LocalAI backend runs completely offline
- **Streaming Support**: Supports streaming for compatible STT/TTS models
- **Service Consolidation**: Share TTS/STT services between multiple applications

## Installation

1. Install this app from your community app store in Umbrel
2. Install a backend service (e.g., LocalAI from the Umbrel App Store)
3. Configure the backend URL in `~/umbrel/app-data/kegesch-wyoming-openai/settings.env`
4. Restart the app
5. Add to Home Assistant via the Wyoming Protocol integration

## Configuration

The configuration is managed through a single file: `~/umbrel/app-data/kegesch-wyoming-openai/settings.env`

### Default Configuration

The app ships with LocalAI as the default backend:

```bash
STT_OPENAI_URL=http://localai:8080/v1
STT_MODELS=whisper-base
STT_BACKEND=LOCALAI

TTS_OPENAI_URL=http://localai:8080/v1
TTS_MODELS=en-us-amy-low.onnx
TTS_BACKEND=LOCALAI
```

### Switching Backends

To switch to a different backend, edit the configuration file and update the relevant settings:

#### OpenAI (Cloud)

```bash
STT_OPENAI_KEY=sk-your-openai-key
TTS_OPENAI_KEY=sk-your-openai-key
STT_OPENAI_URL=https://api.openai.com/v1
TTS_OPENAI_URL=https://api.openai.com/v1
STT_MODELS=whisper-1 gpt-4o-transcribe
TTS_MODELS=gpt-4o-mini-tts tts-1-hd
STT_BACKEND=OPENAI
TTS_BACKEND=OPENAI
```

#### Groq (Fast Cloud Inference)

```bash
STT_OPENAI_KEY=gsk-your-groq-key
TTS_OPENAI_KEY=gsk-your-groq-key
STT_OPENAI_URL=https://api.groq.com/openai/v1
TTS_OPENAI_URL=https://api.groq.com/openai/v1
STT_MODELS=whisper-large-v3
TTS_MODELS=orpheus-2b
STT_BACKEND=GROQ
TTS_BACKEND=GROQ
```

#### Microsoft Edge TTS (Free, No API Key)

```bash
STT_OPENAI_URL=http://openai-edge-tts:8000/v1
TTS_OPENAI_URL=http://openai-edge-tts:8000/v1
STT_MODELS=en-US-JennyNeural
TTS_MODELS=en-US-JennyNeural
STT_BACKEND=EDGE_TTS
TTS_BACKEND=EDGE_TTS
```

After making changes, restart the app:

```bash
sudo ~/umbrel/scripts/app restart kegesch-wyoming-openai
```

## Available Backends

| Backend | Type | API Key Required | Privacy | Speed |
|---------|------|------------------|----------|-------|
| LocalAI | Local | No | ✅ High | ⚠️ Medium |
| OpenAI | Cloud | Yes | ❌ Low | ✅ Fast |
| Groq | Cloud | Yes | ❌ Low | ⚡ Very Fast |
| Edge TTS | Cloud | No | ❌ Low | ✅ Fast |
| Speaches | Local | No | ✅ High | ✅ Fast |
| Kokoro | Local | No | ✅ High | ✅ Fast |
| Mistral | Cloud | Yes | ❌ Low | ✅ Fast |
| Chatterbox | Local | No | ✅ High | ✅ Fast |

## Usage in Home Assistant

1. Install and configure this app in Umbrel
2. In Home Assistant, go to **Settings** > **Devices & Services**
3. Click **Add Integration** > Search for **Wyoming Protocol**
4. Enter: `tcp://umbrel.local:10300`
5. Configure your voice assistant pipeline to use the new STT/TTS services

### Reloading Configuration

When you make changes to the configuration (models, voices, URLs), reload the Wyoming OpenAI integration in Home Assistant:

1. Go to **Settings** > **Devices & Services**
2. Find and select your **Wyoming OpenAI** integration
3. Click on **Reload**

## Troubleshooting

### App won't start

- Check that the backend URL is correct
- Verify the backend service is running
- Check app logs: `docker logs kegesch-wyoming-openai_wyoming_openai_1`

### Home Assistant can't connect

- Verify the URL: `tcp://umbrel.local:10300`
- If using IP address instead of umbrel.local, use: `tcp://192.168.1.X:10300`
- Check firewall settings

### Models not available

- Verify the backend has the specified models installed
- Check backend logs for model loading errors
- Try a different model from the backend's available models

## Project Links

- **Upstream Project**: https://github.com/roryeckel/wyoming_openai
- **Documentation**: https://github.com/roryeckel/wyoming_openai#readme
- **Docker Image**: ghcr.io/roryeckel/wyoming_openai

## License

This app is distributed under the same license as the upstream Wyoming OpenAI project (Apache-2.0).

## Submitting Issues

For issues specific to this Umbrel app, please report them in the umbrel-apps repository. For issues with the Wyoming OpenAI proxy itself, please report them in the upstream repository.
