# My Fedora toolbox [![Docker Repository on Quay](https://quay.io/repository/rbo/fedora-toolbox/status "Docker Repository on Quay")](https://quay.io/repository/rbo/fedora-toolbox)

My personal toolbox for Fedora Silverblue

```
toolbox create -i quay.io/rbo/fedora-toolbox:latest fedora-toolbox-$(rpm -E %fedora)
```


## Build


```
podman build -t quay.io/rbo/fedora-toolbox:latest \
    --build-arg FEDORA_VERSION=$(rpm -E %fedora)

```

