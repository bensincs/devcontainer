.PHONY: help bootstrap
help: ## show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%s\033[0m|%s\n", $$1, $$2}' \
        | column -t -s '|'

# VPN
vpn: ## Deploy a VPN Gateway
	@./scripts/vpn-create.sh
vpn-destroy: ## Deploy a VPN Gateway
	@./scripts/vpn-destroy.sh
vpn-client: ## **CAUTION** Setup a VPN Client
	@./scripts/vpn-client.sh
	@./scripts/dns-configure.sh
vpn-reset: ## **CAUTION** Reset the VPN and the DNS Name Resolution
	@./scripts/vpn-reset.sh