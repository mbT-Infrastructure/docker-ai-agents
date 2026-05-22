# openclaw-sandbox image

This image contains an openclaw install on top of the [development image]. By default openclaw runs
as user and not root and is not able to change the `openclaw.json` config file by its own.

The default config file uses signal as channel and contains some environment variables for
configuration. Alternatively a customized `openclaw.json` can be mounted in the container.

## Installation

1. Pull from [Docker Hub], download the package from [Releases] or build using `builder/build.sh`

## Usage

### Environment variables

- `AI_API_URL`
    - Url of the AI API server used by the default config file.
- `AI_API_KEY`
    - Key to use for authorization to the AI API server used by the default config file.
- `ALLOWED_ORIGIN`
    - Configure the allowed origin for the Control UI, default `http://127.0.0.1:18789`.
- `AI_MODEL`
    - The AI model used by the default config file, default: `default`.
- `AUTH_MODE`
    - The authentication mode for the gateway used by the default config file, default: `token`.
- `BASE_PATH`
    - The base path for the gateway used by the default config file, default: `/`.
- `BRAVE_API_KEY`
    - The API key for Brave Search used by the default config file.
- `OPENCLAW_HOME`
    - The OpenClaw home directory, default: `/media/openclaw`.
- `OPENCLAW_CONFIG_PATH`
    - The path to the OpenClaw configuration file, default: `/opt/openclaw/openclaw.json`. Set this to e. g. `~/.openclaw/openclaw.json` to make the config file changeable by openclaw.
- `OPENCLAW_STATE_DIR`
    - The path to the OpenClaw state directory, default: `/media/openclaw/.openclaw`.
- `PASSWORD`
    - The gateway password and token for OpenClaw used by the default config file.
- `SIGNAL_ACCOUNT`
    - The Signal account number used by the default config file.
- `SIGNAL_ALLOW_FROM`
    - Allow messages from this Signal number used by the default config file.
- `SIGNAL_SERVER_URL`
    - The URL of the Signal server used by the default config file, default: `http://signal-cli:8080`.
- `TRUSTED_PROXY`
    - The trusted proxy IP address or network in CIDR notation used by the default config file.
- `USER`
    - Allowed user for `trusted-proxy` auth mode.

### Volumes

- `/media/openclaw`
    - The default home folder of openclaw.
- `/media/user`
    - The home directory of the user used by openclaw.

## Development

To build and run the docker container for development execute:

```bash
docker compose --file docker-compose-dev.yaml up --build
```

[development image]: https://github.com/mbT-Infrastructure/docker-development
[Docker Hub]: https://hub.docker.com/r/madebytimo/openclaw-sandbox
[Releases]: https://github.com/mbT-Infrastructure/docker-openclaw-sandbox/releases
