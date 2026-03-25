.PHONY: help deploy destroy clean check-deps

# Default target
help:
	@echo "Jalapeno BMP Demo - Single-Node Deployment"
	@echo ""
	@echo "Available targets:"
	@echo "  make deploy          - Deploy complete stack (MicroK8s, Jalapeno, Containerlab)"
	@echo "  make destroy         - Destroy Containerlab topology only"
	@echo "  make clean           - Clean up all deployments"
	@echo "  make check-deps      - Check required dependencies"
	@echo ""
	@echo "Configuration:"
	@echo "  Edit deploy/inventory.yaml to configure target host"
	@echo "  Default: deploys to localhost"
	@echo ""
	@echo "Docker Registry Credentials:"
	@echo "  Set environment variables DOCKER_USER and DOCKER_PASSWORD, or"
	@echo "  Pass via command line:"
	@echo "    make deploy DOCKER_USER=myuser DOCKER_PASSWORD=mypass"
	@echo ""

# Check dependencies
check-deps:
	@echo "Checking dependencies..."
	@command -v ansible-playbook >/dev/null 2>&1 || { echo "Error: ansible-playbook not found"; exit 1; }
	@command -v python3 >/dev/null 2>&1 || { echo "Error: python3 not found"; exit 1; }
	@echo "All dependencies satisfied."

# Deploy entire stack
deploy: check-deps
	@echo "Starting deployment of Jalapeno BMP Demo..."
	@if [ -n "$(DOCKER_USER)" ] && [ -n "$(DOCKER_PASSWORD)" ]; then \
		cd deploy && ansible-playbook site.yaml -e "docker_user=$(DOCKER_USER)" -e "docker_password=$(DOCKER_PASSWORD)"; \
	else \
		cd deploy && ansible-playbook site.yaml; \
	fi
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
	@sudo containerlab destroy --topo clab/bmp.clab.yaml || true
	@echo "Containerlab topology destroyed."

# Clean everything
clean: destroy
	@echo "Cleaning up deployments..."
	@echo "Note: MicroK8s and Jalapeno must be manually removed if needed."
	@echo "  - To remove Jalapeno: helm uninstall jalapeno -n jalapeno"
	@echo "  - To remove MicroK8s: sudo snap remove microk8s"
