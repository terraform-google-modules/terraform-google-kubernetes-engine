# GKE Inference Gateway Example

This example provisions a GKE Standard cluster and a node pool with H100 GPUs, suitable for deploying and serving Large Language Models (LLMs) using the GKE Inference Gateway.

The cluster is configured with:
- GKE Gateway API enabled.
- Managed Prometheus for monitoring.
- DCGM for GPU monitoring.
- A dedicated node pool with NVIDIA H100 80GB GPUs.

This Terraform script automates the deployment of all necessary Kubernetes resources, including:
- Authorization for metrics scraping.
- A vLLM model server for a Llama3.1 model.
- GKE Inference Gateway CRDs.
- GKE Inference Gateway resources (`InferencePool`, `InferenceObjective`, `Gateway`, `HTTPRoute`).

## Usage

1.  **Enable APIs**

    ```bash
    gcloud services enable container.googleapis.com
    ```

2.  **Set up your environment**

    You will need to set the following environment variables. You may also need to create a `terraform.tfvars` file to provide values for the variables in `variables.tf`.

    ```bash
    export PROJECT_ID="your-project-id"
    export REGION="us-central1"
    export CLUSTER_NAME="inference-gateway-cluster"
    export HF_TOKEN="your-hugging-face-token"
    ```

3.  **Run Terraform**

    The `terraform apply` command will provision the GKE cluster and deploy all the necessary Kubernetes resources.

    ```bash
    terraform init
    terraform apply
    ```

4.  **Configure kubectl**

    After the apply is complete, configure `kubectl` to communicate with your new cluster.

    ```bash
    gcloud container clusters get-credentials $(terraform output -raw cluster_name) --region $(terraform output -raw location)
    ```

5.  **Send an inference request**

    Get the Gateway IP address:
    ```bash
    IP=$(kubectl get gateway/inference-gateway -o jsonpath='{.status.addresses[0].value}')
    PORT=80
    ```

    Send a request:
    ```bash
    curl -i -X POST http://${IP}:${PORT}/v1/completions \
    -H "Content-Type: application/json" \
    -d 
    {
        "model": "food-review",
        "prompt": "What is a good recipe for a chicken curry?",
        "max_tokens": 100,
        "temperature": "0.7"
    }
    ```

## Cleanup

Running `terraform destroy` will deprovision the GKE cluster and all associated Kubernetes resources.

```bash
terraform destroy
```