# Browsers with fake DNS

Doing a migration? Testing a new version of your infrastructure? Want to make sure your new infra _works_ after you switch over your DNS records?
Look no further!


## Usage

```
docker build -t browsers .

docker run  --rm --name browsers -p 8080:8080 -v $PWD/data:/data -v $PWD/example.zone.conf:/data/zone.conf:ro browsers
# this starts the container and stores the home dir of the user on your system, so that you'll have a browser history, cookies, shell history etc.
```

## Tip:
Build an image with a zone configured, and ship it to a technical client via a docker repository. See the last lines of the Dockerfile.
