# Easy k8s secrets

This is a kubectl shim to help you manage secrets in kubernetes, the easy way.
It will, locally, decode and reencode your secrets, so you can edit/view them in plain text.

## Installation
Installation is as easy as running the following command:
```bash
git clone git@github.com:Apollorion/easy-k8s-secrets.git
cd easy-k8s-secrets
source k8s_shim.sh
```

to persist the changes, add the following line to your .bashrc or .zshrc:
```bash
source /path/to/easy-k8s-secrets/k8s_shim.sh
```

Now whenever you run `kubectl` or `k` you will run the shim instead.

## Usage
The shim is designed to be as easy to use as possible, if youre familiar with `kubectl` then using this is easy as pie.

### Creating a secret
```bash
kubectl create secret {secret_name}
```

### Editing a secret
```bash
kubectl edit secret {secret_name}
```

### Getting a secret
```bash
kubectl get secret {secret_name}
```

Optionally you can set the output format to json:
```bash
kubectl get secret {secret_name} --json
kubectl get secret {secret_name} -j
```

You can also get/edit/or delete secrets in a different namespace:
```bash
kubectl get secret {secret_name} --namespace {namespace}
kubectl get secret {secret_name} -n {namespace}
```

### Skipping Easy K8s Secrets Shim
If you need to use kubectl directly, for whatever reason, you can skip the shim by using `--no-easy-k8s-secrets`. This will pass the command directly to kubectl.
```bash
kubectl --no-easy-k8s-secrets get secret {secret_name} --namespace {namespace}
kubectl --no-easy-k8s-secrets get secret {secret_name} -n {namespace}
```

## Considerations

The shim uses simple string matching to determine when to use either easy-k8s-secrets or kubectl.
If any part of your command uses the word "secrets" (note the ending *s* in secrets), it will be passed to kubectl directly.
This is to support "kubectl get secrets" with native kubectl.  

This means that if you have a secret named "my-awesome-secrets", it will _not_ use the shim.
```bash
kubectl get secret my-awesome-secrets # Not supported
kubectl get secret my-awesome-secret # Supported
```
