# pokemon-manifests

## Sealed Secrets

To apply this, [bitnami/sealed-secrets](https://github.com/bitnami-labs/sealed-secrets#installation) should be installed in your K8s cluster.

Create a json/yaml-encoded Secret somehow:
(note use of `--dry-run` - this is just a local file!)

```sh
kubectl create secret docker-registry regcred --namespace pokemon --docker-username=$DH_USERNAME --docker-password=$DH_PASSWD --docker-email=$DH_EMAIL --dry-run=client -o json > regcred.json
```

This is the important bit:
(note default format is json!)

```sh
kubeseal < regcred.json > sealed-secret.yaml
```

At this point `sealed-secret.json` is safe to upload to Github, post on Twitter, etc.

### Eventually:

```sh
kubectl create -f sealed-secret.yaml -n pokemon
```

### Profit!

```sh
kubectl get secret regcred -n pokemon
```

## Rancher Desktop Example

This example works on Rancher Desktop with the Traefik ingress controller.

The `kustomization.yaml` file will expect a `sealed-secret.yaml` in the same directory.

Before deploying you need to identify the IP address of the Rancher Desktop node where it is publishing the contents of the ingress controller:

```bash
IP=$(kubectl get node/lima-rancher-desktop -o json | jq -r '.status.addresses[] | select(.type=="InternalIP").address')
```

Note: By default the `kustomization.yaml` file uses the NGinx controller, assuming that this is the controller installed in RD, if you are using Traefik edit the `kustomization.yaml` replace the ingress by `pokemon-ingress-traefik.yaml` or simply:

```sh
sed -i "s/nginx/traefik/" kustomization.yaml
```
Finally make sure the `host` is the right one in the ingress file.

To deploy the application manually you need to execute in command line:

```bash
kubectl -n pokemon apply -k ./
```

To test you can invoke curl:

```bash
curl pokemon.$IP.nip.io/trainers
```

To delete all:

```bash
kubectl delete all,ingress --all -n pokemon
```
