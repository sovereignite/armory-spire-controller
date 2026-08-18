# spire-tpm-keymanager-controller

An in-cluster controller that reconciles `SPIRETPMKeyManager` custom
resources (`spire.sovereignite.io/v1alpha1`). On a poll loop it lists every
`spiretpmkeymanager` object through a minimal Kubernetes API client, validates
the spec (socket path, PKCS#11 module/token, user PIN secret ref, server CA
key), and merge-patches a `Ready` status condition back onto each object.

Extracted from the
[github.com/sovereignite/sovereignite](https://github.com/sovereignite/sovereignite)
monorepo. The Kubernetes API client comes from
[github.com/sovereignite/controller-libs](https://github.com/sovereignite/controller-libs)
(`kubeapi`), wired in via a local `replace` directive while controller-libs is
still unpublished.

## Build & test

```sh
go build ./...
go test ./...
```

## Container image

Build from the parent workspace so the replaced `controller-libs` sibling
module is inside the build context:

```sh
docker build -f spire-tpm-keymanager-controller/Dockerfile .
```

Or with ko, from this directory:

```sh
ko build .
```

## License

GPL-2.0-only. See [LICENSE.md](LICENSE.md).
