.PHONY: help deploy destroy setup-inventory clean check-deps

# Default target
help:
	@echo "Jalapeno BMP Demo - Single-Node Deployment"
	@echo ""
	@echo "Available targets:"
	@echo "  make deploy          - Deploy complete stack (MicroK8s, Jalapeno, Containerlab)"
	@echo "  make destroy         - Destroy Containerlab topology only"
	@echo "  make setup-inventory - Generate Ansible inventory from labs.yaml"
	@echo "  make clean           - Clean up all deployments"
	@echo "  make check-deps      - Check required dependencies"
	@echo ""
	@echo "Configuration:"
	@echo "  Edit deploy/labs.yaml to specify target host(s)"
	@echo ""

# Check dependencies
check-deps:
	@echo "Checking dependencies..."
	@command -v ansible-playbook >/dev/null 2>&1 || { echo "Error: ansible-playbook not found"; exit 1; }
	@command -v python3 >/dev/null 2>&1 || { echo "Error: python3 not found"; exit 1; }
	@echo "All dependencies satisfied."

# Setup inventory
setup-inventory:
	@echo "Generating inventory from labs.yaml..."
	@cd deploy && ansible-playbook gen-inv.yaml
	@echo "Inventory generated at deploy/inventory.yaml"
	@echo ""
	@echo "IMPORTANT: Please review deploy/inventory.yaml before proceeding!"

# Deploy entire stack
deploy: check-deps setup-inventory
	@echo "Starting deployment of Jalapeno BMP Demo..."
	@cd deploy && ansible-playbook -u ins -k site.yaml
	@echo ""
	@echo "Deployment complete!"
	@echo ""
	@echo "Access points:"
	@echo "  - Grafana: http://<host-ip>:30333"
	@echo "  - ArangoDB: http://<host-ip>:30852"
	@echo "  - Kafka UI: http://<host-ip>:30777"
	@echo "  - InfluxDB: http://<host-ip>:30308"
	@echo "  - BMP Server: <host-ip>:30511"
	@echo "  - Telegraf: <host-ip>:32400"

# Destroy only Containerlab topology
destroy:
	@echo "Destroying Containerlab topology..."
	@cd deploy && sudo containerlab destroy --topo closing.clab.yaml || true
	@echo "Containerlab topology destroyed."

# Clean everything
clean: destroy
	@echo "Cleaning up deployments..."
	@echo "Note: MicroK8s and Jalapeno must be manually removed if needed."
	@echo "  - To remove Jalapeno: helm uninstall jalapeno -n jalapeno"
	@echo "  - To remove MicroK8s: sudo snap remove microk8s"
