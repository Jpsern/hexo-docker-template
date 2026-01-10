.DEFAULT_GOAL := help

COMPOSE_CMD := docker compose

help: ## このヘルプメッセージを出力
	@echo
	@printf "\033[1;4mUSAGE\033[0m\n"
	@printf "  \033[1mmake \033[36m[TARGET] \033[32m([ARGS])\033[0m\n"
	@echo
	@printf "\033[1;4mTARGETS\033[0m\n"
	@grep -E '^[/a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | perl -pe 's%^([/a-zA-Z0-9_-]+):.*?(##)%$$1 $$2%' | awk -F " *?## *?" '{printf "  \033[1;36m%-20s\033[0m %s\n", $$1, $$2}'
.PHONY: help

build: ## コンテナ初期化
	$(COMPOSE_CMD) build --no-cache
	make gen
.PHONY: build

up: ## コンテナ起動
	$(COMPOSE_CMD) up -d
.PHONY: up

down: ## コンテナ停止
	$(COMPOSE_CMD) down
.PHONY: down

down-all: ## コンテナ掃除
	$(COMPOSE_CMD) down --rmi all --volumes --remove-orphans
.PHONY: down-all

restart: ## コンテナ再起動
	$(COMPOSE_CMD) restart apache
	$(COMPOSE_CMD) restart https-portal
.PHONY: restart

clean: ## hexo generate の成果物を掃除
	$(COMPOSE_CMD) run --rm node hexo clean
.PHONY: clean

gen: ## hexo generate 実行
	$(COMPOSE_CMD) run --rm node npm install
	$(COMPOSE_CMD) run --rm node hexo generate
.PHONY: gen
