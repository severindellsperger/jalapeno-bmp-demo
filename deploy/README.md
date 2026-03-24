# Ansible Deployment

Lab configuration using Ansible.
This lets us configure many lab environments at once, without relying on the LTB `cloud-init`.

## Deployment

The LTB lab is configured with two machines, `jagw-L` and `infrastructure-XL`, both connected to a gateway.

These two machines are still configured via `cloud-init`, found in `./cloud-config`.

## Configuration

1. Sync and activate the Python virtual environment:

   ```sh
   # Add --dev for additional tools
   uv sync
   source .venv/bin/activate
   ```

2. Update `./labs.yaml` with the current addresses of the gateways in the LTB labs, then run `ansible-playbook ./gen-inv.yaml` to generate `./inventory.yaml`.

   ONLY CONTINUE after manually verifying the generated `./inventory.yaml`!

3. Run the playbook: `ansible-playbook -u ins -k ./site.yaml`.

   _Be sure to only do this if you can grasp the possible severity of this action._
