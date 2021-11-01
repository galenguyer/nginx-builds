variable "ALPINE_VER" {
    default = "latest"
}
variable "NGINX_MAINLINE" {
    default = "UNSET"
}
variable "NGINX_STABLE" {
    default = "UNSET"
}
variable "CORE_COUNT" {
    default = "1"
}
variable "REGISTRY" {
    default = "local"
}
variable "HUB_USERNAME" {
    default = "local"
}

group "default" {
    targets = ["alpine"]
}
group "alpine" {
    targets = ["alpine-mainline", "alpine-stable"]
}

target "alpine-mainline" {
    dockerfile = "Dockerfile.alpine"
    args = {
        ALPINE_VER="${ALPINE_VER}"
        NGINX_VER="${NGINX_MAINLINE}"
        CORE_COUNT="${CORE_COUNT}"
    }
    tags = [
        "nginx:latest",
        "nginx:mainline",
        "nginx:${NGINX_MAINLINE}",
        "nginx:alpine${ALPINE_VER}",
        "nginx:alpine${ALPINE_VER}-mainline",
        "nginx:alpine${ALPINE_VER}-${NGINX_MAINLINE}",
    ]
}

target "alpine-stable" {
    dockerfile = "Dockerfile.alpine"
    args = {
        ALPINE_VER="${ALPINE_VER}"
        NGINX_VER="${NGINX_STABLE}"
        CORE_COUNT="${CORE_COUNT}"
    }
    tags = [
        "nginx:stable",
        "nginx:${NGINX_STABLE}",
        "nginx:alpine${ALPINE_VER}-stable",
        "nginx:alpine${ALPINE_VER}-${NGINX_STABLE}",
    ]
}
