# Open Data Hub Custom Notebook

Create a custom notebook available in the ODH JupyterHub spawner.

## Prerequisites

1. Install Open Data Hub
2. Install `oc` CLI tool
3. [Quay Registry](https://quay.io/)
4. Install `podman` or `docker` CLI tool. These instructions will use `podman`

## Steps

1. Login to OpenShift. Get command from `Copy login command` in the OpenShift web console.

    ```bash
    oc login --token=token --server=cluster_url
    ```

2. Login to Quay

    ```bash
    podman login quay.io
    ```

3. Build the notebook image

    ```bash
    podman build -t quay.io/nsayre/custom-notebook container/
    ```

4. Push the notebook image to Quay. Then, navigate to `quay.io` and make the image public.

    ```bash
    podman push quay.io/nsayre/custom-notebook
    ```

5. In the namespace with ODH deployed, create an `ImageStream`

    ```bash
    cd deploy
    ```

    ```bash
    oc apply -n opendatahub -f s2i-custom-notebook-image-stream.yaml
    ```

6. Navigate to your ODH deployed JupyterHub spawner. You will see the custom notebook in the list of available notebooks!
