## Deployment

Create/apply resources in this order:

1. kaggle-secret.yaml
2. trtllm_checkpoint_pv.yaml
3. job-download-gemma-7b.yaml (wait for job to complete sucessfully, may take a few minutes)
4. deploy-triton-server.yaml  (wait for sucessful completion, may take a few minutes)


*TODO: How to orchestrate this deployment using Terraform?*