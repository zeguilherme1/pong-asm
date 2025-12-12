CC := gcc

CCFLAGS := -w

SIM := sim

MON := montador

SIM_DIR := ./Simulador/simulador_fonte/

MON_DIR := ./Simulador/montador_fonte/



.PHONY: run build all clean



help: ## Mostra essa ajuda

	@awk 'BEGIN {FS = ":.*##"; printf "Usage:\n  make \033[36m\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)



all: clean build run ## Roda todas as rotinas



build: build_montador build_simulador ## Gera os arquivos montador e simulador



build_montador: ## Gera o arquivo montador 

	cd $(MON_DIR) && $(CC) *.c -o $(MON) $(CCFLAGS) && mv $(MON) ../../



build_simulador: ## Gera o arquivo simulador

	cd $(SIM_DIR) && sh compila.sh && mv $(SIM) ../../



run: *.asm ## Roda o programa .asm que está na pasta

	./$(MON) $^ main.mif

	./$(SIM) main.mif charmap.mif



clean: ## Limpa os arquivos gerados durante a build do programa

	rm -rf montador sim main.mif montador.exe
