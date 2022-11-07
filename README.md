# pokemon-manifests

## Rancher Desktop Example

This example works on Rancher Desktop with the Traefik ingress controller.

The `kustomization.yaml` file will expect a `dh-secret.yaml` in the following format:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: regcred
  namespace: pokemon
data:
  .dockerconfigjson: eyJhdXRoc...
type: kubernetes.io/dockerconfigjson

```
You'll need to replace the value of the `.dockerconfig.json` with your 64-bit encoded key from your Docker Hub account.

Before deploying you need to identify the IP address of the Rancher Desktop node where it is publishing the contents of the ingress controller:

```bash
IP=$(kubectl get node/lima-rancher-desktop -o json | jq -r '.status.addresses[] | select(.type=="InternalIP").address')
```

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