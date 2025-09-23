# Dotfiles Setup

## Clone this repository:

- git clone https://github.com/yourusername/dotfiles.git
- cd dotfiles
- Either `pnpm i` to install and `pnpm run start` or;
- `chmod +x setup.sh` makes the setup.sh file executable so you can run it as a program and `./setup.sh` Run script

## Tips / Notes

### Brew

- `brew upgrade` Will ensure applications installed with brew are updated as one

### Bruno

- Use alongside https://github.com/domgaulton/bruno-api-collection

### GraphQl

- https://studio.apollographql.com/public/SpaceX-pxxbxen/variant/current/explorer
- https://studio.apollographql.com/sandbox/explorer/?referrer=docs-content

### zsh

- Run `source ~/.zshrc` to update zsh without resetting terminal

### Docker

Build and run the Docker container:

```bash
# Build the image
docker build -t dotfiles .

# Run the container
docker run dotfiles
```

Or run in interactive mode:

```bash
docker run -it dotfiles sh
```
