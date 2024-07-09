# github-runner

## run

```sh
docker run \
  --detach \
  --env ORGANIZATION=<YOUR-GITHUB-ORGANIZATION> \
  --env ACCESS_TOKEN=<YOUR-GITHUB-ACCESS-TOKEN> \
  --name runner \
  runner-image
```

## base on

[https://testdriven.io/blog/github-actions-docker/](https://testdriven.io/blog/github-actions-docker/)
