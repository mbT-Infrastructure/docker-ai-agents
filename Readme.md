# AI-Agents image

This image contains [Hermes] and [Open Terminal] installed on top of the [development image].

Some configuration options are exposed as environment variables as listed below.

## Installation

1. Pull from [Docker Hub], download the package from [Releases] or build using `builder/build.sh`

## Usage

### Environment variables

- `AI_API_URL`
    - URL of the AI API server used by the default configuration.
- `AI_API_KEY`
    - API key for the AI server.
- `AI_CONTEXT_LENGTH`
    - Maximum context length used by the agents (default: `512000`).
- `AI_MODEL`
    - The AI model to use (default: `default`).
- `BRAVE_API_KEY`
    - API key for Brave Search used by the default configuration.
- `OPEN_TERMINAL_API_KEY`
    - API key for `open-terminal`.
- `SIGNAL_ACCOUNT`
    - The Signal account used by the default configuration.
- `SIGNAL_ALLOWED_USERS`
    - Comma-separated Signal numbers allowed to interact with the agents.
- `SIGNAL_GROUP_ALLOWED_USERS`
    - Comma-separated Signal group IDs allowed to interact with the agents.
- `SIGNAL_SERVER_URL`
    - URL of the Signal server (default: `http://signal-cli:8080`).

### Volumes

- `/media/user`
    - The home directory of the user used by the agents.

## Development

To build and run the docker container for development execute:

```bash
docker compose --file docker-compose-dev.yaml up --build
```

[development image]: https://github.com/mbT-Infrastructure/docker-development
[Docker Hub]: https://hub.docker.com/r/madebytimo/ai-agents
[Releases]: https://github.com/mbT-Infrastructure/docker-ai-agents/releases
[Hermes]: https://hermes-agent.nousresearch.com/
[Open Terminal]: https://openterminal.sh/
