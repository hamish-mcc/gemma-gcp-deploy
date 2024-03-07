## Resources

Google Cloud [Serve Gemma open models using GPUs on GKE with Triton and TensorRT-LLM ](https://cloud.google.com/kubernetes-engine/docs/tutorials/serve-gemma-gpu-tensortllm)

## Setup

### CLI Tools

[Install OpenTofu](https://opentofu.org/docs/intro/install/)

[Install `gcloud` CLI](https://cloud.google.com/sdk/docs/install)

[Install `kubectl`](https://kubernetes.io/docs/tasks/tools/)

### Google Cloud


### Kaggle

## Deploy Infrastructure

Using [OpenTofu CLI](https://opentofu.org/docs/cli/commands/)

```bash
tofu plan
tofu apply
```

## Deploy Kubernetes Resources

Configure kubectl to communicate with your cluster:

```bash
gcloud components install gke-gcloud-auth-plugin

gcloud container clusters get-credentials ${CLUSTER_NAME} --location=${REGION}
```

Then, deploy resources:

```bash
kubectl create namespace triton

# Create a Secret to store the Kaggle credentials:
kubectl -n triton create secret generic kaggle-secret --from-file=../credentials/kaggle.json

# Create a PersistentVolume backed by a persistent disk to store the model checkpoints
kubectl -n triton apply -f trtllm_checkpoint_pv.yaml

# Download the TensorRT-LLM engine files for Gemma
kubectl -n triton apply -f job-download-gemma-7b.yaml

kubectl -n triton wait --for=condition=complete --timeout=1500s job/data-loader-gemma-7b

kubectl -n triton get job/data-loader-gemma-7b # Verify job is complete

# Deploy Triton
kubectl -n triton apply -f deploy-triton-server.yaml

kubectl -n triton wait --for=condition=Available --timeout=900s deployment/triton-gemma-deployment

kubectl -n triton logs -f -l app=gemma-server # Verify logs

# Deploy Ingress
kubectl -n apply -f triton-server-ingress.yaml
```