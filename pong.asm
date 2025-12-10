	; - - - - - - - TABELA DE CORES - - - - - - - 
	; adicione ao caracter para Selecionar a cor correspondente
	
	; 0 branco 0000 0000
	; 256 marrom 0001 0000
	; 512 verde 0010 0000
	; 768 oliva 0011 0000
	; 1024 azul marinho 0100 0000
	; 1280 roxo 0101 0000
	; 1536 teal 0110 0000
	; 1792 prata 0111 0000
	; 2048 cinza 1000 0000
	; 2304 vermelho 1001 0000
	; 2560 lima 1010 0000
	; 2816 amarelo 1011 0000
	; 3072 azul 1100 0000
	; 3328 rosa 1101 0000
	; 3584 aqua 1110 0000
	; 3840 branco 1111 0000




reset:
	
	
limpa: string " "
inicio: string "X - Pong aperte espaco para comecar"
cenario: string " 							Bob Esponja 									Plankton"
bob_vit: string "VITORIA DO BOB ESPONJA!"
plank_vit: string "VITORIA DO PLANKTON!"
	
vbola: var #1
	
dbh: var #1
	static dbh + #0, #0
dbv: var #1
	static dbv + #0, #0
	
pbola: var #1
	static pbola + #0, #619
	
pbob: var #1
	static pbob + #0, #0
	
pplank: var #1
	static pplank + #0, #0
	
	; - - - - Inicio do Programa Principal - - - - - 
	
	;VARIAVEIS SALVAS:
	;r3 = tamanho da linha
	;r6 = posicao da barra 1
	;r7 = posicao da barra 2
	
main:
	loadn r3, #40                ; Tamanho da linha
	
	call Delay
	call Delay
	call Delay
	call Delay
	
	call printtelaInicialScreen           ; Printa a tela de inicio
	
	call InputLoopIni            ; Loop esperando input para sair da tela inicial
	
		
	call LimpaTela
	
	call Delay
	call Delay
	call Delay
	call Delay
	
	call PrintCena               ; Printa o cenario
	
	loadn r6, #481               ; Posicao inicial da barra 1 na tela
	loadn r1, #0             ; Unidade da barra
	loadn r2, #2816              ; Cor = amarelo
	
	mov r0, r6                   ; Copia o valor de r6 para r0
	call PrintBarra              ; Printa a barra 1
	
	loadn r7, #518               ; Posicao inicial da barra 2 na tela
	loadn r1, #0              ; Unidade da barra
	loadn r2, #0                 ; Cor branca
	
	mov r0, r7                   ; Copia o valor de r7 para r0
	call PrintBarra              ; Printa a barra 2
	call PrintBola               ; Printa a bola
	
	
move:
	call MoveLoop                ; Chama o loop de movimento
	jmp move                     ; LOOP DE TESTE, TROCAR POR PULO CONDICIONAL
	
	jmp Fim                      ; Finaliza o programa
	
InputLoopIni:
	loadn r5, #32                ; Carrega r5 com o valor de input nulo
	inchar r2                    ; Salva o valor do input recebido em r2
	
	cmp r2, r5                   ; Verifica se o input foi nulo
	jne InputLoopIni             ; Se for nulo continua no loop
	
	rts
	
LimpaTela:
	push r0
	push r1
	push r2
	push r3                      ; empilha nesta ordem
	
	loadn r0, #0
	loadn r1, #' '
	loadn r2, #1200
	
LimpaLoop:
	outchar r1, r0
	inc r0
	dec r2
	loadn r3, #0
	cmp r2, r3
	jne LimpaLoop
	
	pop r3                       ; deve desempilhar na ordem INVERSA
	pop r2
	pop r1
	pop r0
	rts
	
PrintStr:                     ; Rotina de Impresao de Mensagens: r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso; r1 = endereco onde comeca a mensagem; r2 = cor da mensagem. Obs: a mensagem sera' impressa ate' encontrar " / 0"
	push r0                      ; protege o r0 na pilha para preservar seu valor
	push r1                      ; protege o r1 na pilha para preservar seu valor
	push r2                      ; protege o r1 na pilha para preservar seu valor
	push r3                      ; protege o r3 na pilha para ser usado na subrotina
	push r4                      ; protege o r4 na pilha para ser usado na subrotina
	
	loadn r3, #'\0'              ; Criterio de parada
	
PrintStrLoop:
	loadi r4, r1
	cmp r4, r3
	jeq PrintStrSai
	add r4, r2, r4
	outchar r4, r0
	inc r0
	inc r1
	jmp PrintStrLoop
	
PrintStrSai:
	pop r4                       ; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	
PrintPlacar:
	loadn r0, #pbob              ; Posicao da bola na tela
	loadi r0, r0
	
	loadn r1, #'0'
	add r1, r1, r0
	
	loadn r0, #53
	outchar r1, r0               ; Printa a bola
	
	loadn r0, #pplank            ; Posicao da bola na tela
	loadi r0, r0
	
	loadn r1, #'0'
	add r1, r1, r0
	
	loadn r0, #74
	outchar r1, r0               ; Printa a bola
	
	rts
	
PrintInicio:
	loadn r0, #374               ; Posicao na tela onde a mensagem sera escrita
	loadn r1, #inicio            ; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #0                 ; Cor = branco
	
	call PrintStr
	rts
	
PrintCena:
	loadn r0, #0                 ; Posicao na tela onde a mensagem sera escrita
	loadn r1, #cenario           ; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #0                 ; Cor = branco
	
	call PrintStr
	rts
	
PrintBarra:
	add r1, r1, r2               ; Define a cor da barra
	outchar r1, r0               ; Printa o primeiro caractere da barra
	
	add r0, r0, r3               ; Passa pra prox pos da barra (prox linha)
	outchar r1, r0
	add r0, r0, r3
	outchar r1, r0
	add r0, r0, r3
	outchar r1, r0
	add r0, r0, r3
	outchar r1, r0
	add r0, r0, r3
	outchar r1, r0
	add r0, r0, r3
	outchar r1, r0
	add r0, r0, r3
	outchar r1, r0
	
	rts
	
ColisaoBaixo:
	rts
	
ColisaoTopo:
	rts
	
PrintBola:
	loadn r0, #pbola             ; Posicao da bola na tela
	loadi r0, r0
	loadn r1, #19          ; Define a bola com o modelo 1 do charmap
	outchar r1, r0               ; Printa a bola
	rts

InputLoop:
	inchar r2                    ; Salva o valor do input recebido em r2
	rts
	
MoveLoop:
	call InputLoop               ; Espera um input nao nulo
	
	call MoveBola
	call PrintBola
	call PrintPlacar
	
	loadn r4, #'s'
	loadn r5, #'w'
	loadn r0, #'j'
	loadn r1, #'i'
	
	cmp r2, r5
	jeq MoveUp1                  ; Se o input for 'w' move pra cima
	
	cmp r2, r4
	jeq MoveD1                   ; Se o input for 's' move pra baixo
	
ret_move1:
	
	cmp r2, r1
	jeq MoveUp2
	
	cmp r2, r0
	jeq MoveD2
	
ret_move2:
	
	call Delay
	call Delay
	
	jmp MoveLoop                 ; Se nao for nenhum dos dois espera novo input
	
	
MoveUp1:
	mov r0, r6                   ; Copia o valor de r6(Pos barra 1) para r0
	sub r0, r0, r3               ; Subtrai uma linha da posicao da barra 1
	
	loadn r1, #121
	cmp r1, r0
	jgr ColisaoTopo
	
	loadn r2, #2816
	loadn r1, #0
	add r1, r1, r2
	outchar r1, r0               ; Printa um caractere de barra na nova posicao da barra 1
	
	loadn r5, #320
	add r0, r0, r5               ; Passa para o endereco do caractere mais baixo da barra
	
	loadn r1, #' '
	outchar r1, r0               ; Apaga esse caractere
	
	sub r6, r6, r3               ; Coloca a posicao da barra 1 uma linha pra cima
	
	jmp ret_move1
	
MoveD1:
	mov r0, r6                   ; Copia o valor de r6(Pos barra 1) para r0
	
	loadn r1, #840
	cmp r1, r6
	jle ColisaoBaixo
	
	loadn r1, #' '
	outchar r1, r0               ; Apaga o caractere mais alto da barra 1
	
	loadn r2, #2816
	loadn r1, #0
	add r1, r1, r2
	
	loadn r5, #320
	add r0, r0, r5               ; Passa para o endereco abaixo do caractere mais baixo da barra
	
	outchar r1, r0               ; Printa um caractere de barra na nova posicao da barra 1
	
	add r6, r6, r3               ; Coloca a barra 1 uma linha pra baixo
	
	jmp ret_move1
	
MoveUp2:
	mov r0, r7                   ; Copia o valor de r6(Pos barra 1) para r0
	sub r0, r0, r3               ; Subtrai uma linha da posicao da barra 1
	
	loadn r1, #158
	cmp r1, r0
	jgr ColisaoTopo
	
	loadn r2, #0
	loadn r1, #0
	add r1, r1, r2
	outchar r1, r0               ; Printa um caractere de barra na nova posicao da barra 1
	
	loadn r5, #320
	add r0, r0, r5               ; Passa para o endereco do caractere mais baixo da barra
	
	loadn r1, #' '
	outchar r1, r0               ; Apaga esse caractere
	
	sub r7, r7, r3               ; Coloca a posicao da barra 1 uma linha pra cima
	
	jmp ret_move2
	
MoveD2:
	mov r0, r7                   ; Copia o valor de r6(Pos barra 1) para r0
	
	loadn r1, #877
	cmp r1, r0
	jle ColisaoBaixo
	
	loadn r1, #' '
	outchar r1, r0               ; Apaga o caractere mais alto da barra 1
	
	loadn r2, #0
	loadn r1, #0
	add r1, r1, r2
	
	loadn r5, #320
	add r0, r0, r5               ; Passa para o endereco abaixo do caractere mais baixo da barra
	
	outchar r1, r0               ; Printa um caractere de barra na nova posicao da barra 1
	
	add r7, r7, r3               ; Coloca a barra 1 uma linha pra baixo
	
	jmp ret_move2
	
Delay:
	push r0
	push r1
	
	loadn r0, #0
	loadn r1, #6000
	
loopdelay:
	inc r0
	cmp r0, r1
	jne loopdelay
	
	pop r1
	pop r0
	
	rts
	
MoveBola:
	loadn r0, #pbola             ; Posicao da bola na tela
	loadi r0, r0
	loadn r1, #' '               ; Define a bola como 'O'
	outchar r1, r0               ; Printa a bola
	
	loadn r1, #dbv
	loadi r1, r1
	loadn r0, #0
	cmp r0, r1
	
	jeq mbd
	jmp mbu
	
ret_b1:
	loadn r0, #pbola             ; Posicao da bola na tela
	loadi r0, r0
	loadn r1, #' '               ; Define a bola como 'O'
	outchar r1, r0               ; Printa a bola
	
	loadn r1, #dbh
	loadi r1, r1
	loadn r0, #0
	cmp r0, r1
	
	jeq mbl
	jmp mbr
	
ret_b2:
	rts
	
mbd:
	loadn r0, #pbola
	loadi r0, r0
	
	loadn r1, #1120
	cmp r1, r0
	jle ColBolaBaixo
	
	loadn r1, #40
	loadn r0, #pbola
	loadi r0, r0
	add r0, r0, r1
	
	store pbola, r0
	jmp ret_b1
	
ColBolaBaixo:
	loadn r0, #1
	store dbv, r0
	jmp MoveBola
	
mbu:
	loadn r0, #pbola
	loadi r0, r0
	
	loadn r1, #160
	cmp r1, r0
	jgr ColBolaCima
	
	loadn r1, #40
	loadn r0, #pbola
	loadi r0, r0
	sub r0, r0, r1
	
	store pbola, r0
	jmp ret_b1
	
ColBolaCima:
	loadn r0, #0
	store dbv, r0
	jmp MoveBola
	
mbl:
	loadn r0, #pbola
	loadn r1, #40
	loadi r0, r0
	mod r0, r0, r1
	
	loadn r1, #2
	cmp r1, r0
	jeg ColBolaEsq
	
	loadn r1, #1
	loadn r0, #pbola
	loadi r0, r0
	sub r0, r0, r1
	
	store pbola, r0
	jmp ret_b2
	
ColBolaEsq:
	loadn r1, #40
	loadn r0, #pbola
	loadi r0, r0
	div r0, r0, r1
	div r1, r6, r1
	loadn r2, #8
	add r2, r1, r2
	
	cmp r0, r1
	
	jle nao_colidiu_plank
	
	cmp r0, r2
	
	jgr nao_colidiu_plank
	
ret_plank:
	loadn r0, #1
	store dbh, r0
	jmp MoveBola
	
nao_colidiu_plank:
	loadn r0, #pplank
	loadi r0, r0
	inc r0
	store pplank, r0
	
	call ResetBall
	call ChecarVitoria
	jmp ret_plank
	
mbr:
	loadn r0, #pbola
	loadn r1, #40
	loadi r0, r0
	mod r0, r0, r1
	
	loadn r1, #36
	cmp r1, r0
	jle ColBolaDir
	
	loadn r1, #1
	loadn r0, #pbola
	loadi r0, r0
	add r0, r0, r1
	
	store pbola, r0
	jmp ret_b2
	
ColBolaDir:
	loadn r1, #40
	loadn r0, #pbola
	loadi r0, r0
	div r0, r0, r1
	div r1, r7, r1
	loadn r2, #8
	add r2, r1, r2
	
	cmp r0, r1
	
	jle nao_colidiu
	
	cmp r0, r2
	
	jgr nao_colidiu
	
col_retorno:
	loadn r0, #0
	store dbh, r0
	jmp MoveBola
	rts
	
	
nao_colidiu:
	loadn r0, #pbob
	loadi r0, r0
	inc r0
	store pbob, r0
	
	call ResetBall
	call ChecarVitoria
	jmp col_retorno
	
	
	
ChecarVitoria:
	loadn r2, #5
	loadn r0, #pbob
	loadi r0, r0
	
	cmp r2, r0
	
	jeq VitoriaBob
	
	loadn r0, #pplank
	loadi r0, r0
	
	cmp r2, r0
	
	jeq VitoriaPlankton
	rts
	
	
VitoriaBob:
	call PrintPlacar
	loadn r0, #611               ; Posicao na tela onde a mensagem sera escrita
	loadn r1, #bob_vit           ; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #2816              ; Cor = branco
	call PrintStr
	
	jmp Fim
	
VitoriaPlankton:
	call PrintPlacar
	loadn r0, #613               ; Posicao na tela onde a mensagem sera escrita
	loadn r1, #plank_vit         ; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #0                 ; Cor = branco
	call PrintStr
	jmp Fim
	
ResetBall:
	loadn r0, #619
	store pbola, r0
	
delay:
	push r0
	push r1
	
	loadn r0, #0
	loadn r1, #65000
	
init_delay:
	inc r0
	nop
	nop
	nop
	nop
	cmp r0, r1
	jne init_delay
	
	pop r1
	pop r0
	rts
	
Fim:
	loadn r5, #32                ; Carrega r5 com o valor de input nulo
	inchar r2                    ; Salva o valor do input recebido em r2
	
	cmp r2, r5                   ; Verifica se o input foi nulo
	jne Fim                      ; Se for nulo continua no loop
	
	loadn r0, #0
	store pbob, r0
	store pplank, r0
	
	loadn r0, #0                 ; Posicao na tela onde a mensagem sera escrita
	loadn r1, #limpa             ; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #0                 ; Cor = branco
	
	call PrintStr
	
	jmp reset
	halt                         ; Encerra o programa

; -------------- Tela Inicial ----------------
telaInicial : var #1200
  ;Linha 0
  static telaInicial + #0, #3922
  static telaInicial + #1, #3922
  static telaInicial + #2, #3922
  static telaInicial + #3, #3922
  static telaInicial + #4, #3922
  static telaInicial + #5, #3922
  static telaInicial + #6, #3922
  static telaInicial + #7, #3922
  static telaInicial + #8, #3922
  static telaInicial + #9, #3922
  static telaInicial + #10, #3922
  static telaInicial + #11, #3922
  static telaInicial + #12, #3922
  static telaInicial + #13, #3922
  static telaInicial + #14, #3922
  static telaInicial + #15, #3922
  static telaInicial + #16, #3922
  static telaInicial + #17, #3922
  static telaInicial + #18, #3922
  static telaInicial + #19, #3922
  static telaInicial + #20, #3922
  static telaInicial + #21, #3922
  static telaInicial + #22, #3922
  static telaInicial + #23, #3922
  static telaInicial + #24, #3922
  static telaInicial + #25, #3922
  static telaInicial + #26, #3922
  static telaInicial + #27, #3922
  static telaInicial + #28, #3840
  static telaInicial + #29, #3922
  static telaInicial + #30, #3840
  static telaInicial + #31, #3922
  static telaInicial + #32, #3840
  static telaInicial + #33, #3966
  static telaInicial + #34, #3922
  static telaInicial + #35, #3966
  static telaInicial + #36, #3922
  static telaInicial + #37, #3922
  static telaInicial + #38, #3922
  static telaInicial + #39, #3922

  ;Linha 1
  static telaInicial + #40, #3922
  static telaInicial + #41, #3922
  static telaInicial + #42, #3922
  static telaInicial + #43, #3922
  static telaInicial + #44, #3922
  static telaInicial + #45, #3922
  static telaInicial + #46, #3922
  static telaInicial + #47, #3922
  static telaInicial + #48, #3922
  static telaInicial + #49, #3922
  static telaInicial + #50, #3922
  static telaInicial + #51, #3922
  static telaInicial + #52, #3922
  static telaInicial + #53, #3922
  static telaInicial + #54, #3922
  static telaInicial + #55, #3922
  static telaInicial + #56, #3922
  static telaInicial + #57, #3922
  static telaInicial + #58, #3922
  static telaInicial + #59, #3922
  static telaInicial + #60, #3922
  static telaInicial + #61, #3922
  static telaInicial + #62, #3922
  static telaInicial + #63, #3922
  static telaInicial + #64, #3922
  static telaInicial + #65, #3922
  static telaInicial + #66, #3922
  static telaInicial + #67, #3922
  static telaInicial + #68, #3922
  static telaInicial + #69, #3922
  static telaInicial + #70, #3922
  static telaInicial + #71, #3922
  static telaInicial + #72, #3922
  static telaInicial + #73, #3922
  static telaInicial + #74, #3922
  static telaInicial + #75, #3922
  static telaInicial + #76, #3922
  static telaInicial + #77, #3922
  static telaInicial + #78, #3922
  static telaInicial + #79, #3922

  ;Linha 2
  static telaInicial + #80, #3922
  static telaInicial + #81, #3922
  static telaInicial + #82, #3922
  static telaInicial + #83, #3922
  static telaInicial + #84, #3922
  static telaInicial + #85, #3922
  static telaInicial + #86, #3922
  static telaInicial + #87, #3922
  static telaInicial + #88, #3922
  static telaInicial + #89, #3922
  static telaInicial + #90, #3922
  static telaInicial + #91, #3922
  static telaInicial + #92, #3922
  static telaInicial + #93, #3922
  static telaInicial + #94, #3922
  static telaInicial + #95, #3922
  static telaInicial + #96, #3922
  static telaInicial + #97, #3922
  static telaInicial + #98, #3922
  static telaInicial + #99, #3922
  static telaInicial + #100, #3922
  static telaInicial + #101, #3922
  static telaInicial + #102, #3922
  static telaInicial + #103, #3922
  static telaInicial + #104, #3922
  static telaInicial + #105, #3922
  static telaInicial + #106, #3922
  static telaInicial + #107, #3922
  static telaInicial + #108, #3922
  static telaInicial + #109, #3922
  static telaInicial + #110, #3922
  static telaInicial + #111, #3922
  static telaInicial + #112, #3922
  static telaInicial + #113, #3922
  static telaInicial + #114, #3922
  static telaInicial + #115, #3922
  static telaInicial + #116, #3922
  static telaInicial + #117, #3922
  static telaInicial + #118, #3922
  static telaInicial + #119, #3922

  ;Linha 3
  static telaInicial + #120, #3922
  static telaInicial + #121, #3922
  static telaInicial + #122, #3922
  static telaInicial + #123, #3922
  static telaInicial + #124, #3922
  static telaInicial + #125, #1024
  static telaInicial + #126, #1024
  static telaInicial + #127, #1024
  static telaInicial + #128, #1024
  static telaInicial + #129, #1024
  static telaInicial + #130, #1024
  static telaInicial + #131, #1024
  static telaInicial + #132, #1024
  static telaInicial + #133, #1024
  static telaInicial + #134, #1024
  static telaInicial + #135, #1024
  static telaInicial + #136, #1024
  static telaInicial + #137, #1024
  static telaInicial + #138, #1024
  static telaInicial + #139, #1024
  static telaInicial + #140, #1024
  static telaInicial + #141, #1024
  static telaInicial + #142, #1024
  static telaInicial + #143, #1024
  static telaInicial + #144, #1024
  static telaInicial + #145, #1024
  static telaInicial + #146, #1024
  static telaInicial + #147, #1024
  static telaInicial + #148, #1024
  static telaInicial + #149, #1024
  static telaInicial + #150, #1024
  static telaInicial + #151, #1024
  static telaInicial + #152, #1024
  static telaInicial + #153, #1024
  static telaInicial + #154, #1024
  static telaInicial + #155, #3922
  static telaInicial + #156, #3922
  static telaInicial + #157, #3922
  static telaInicial + #158, #3922
  static telaInicial + #159, #3922

  ;Linha 4
  static telaInicial + #160, #3922
  static telaInicial + #161, #3922
  static telaInicial + #162, #3922
  static telaInicial + #163, #3922
  static telaInicial + #164, #1024
  static telaInicial + #165, #0
  static telaInicial + #166, #0
  static telaInicial + #167, #0
  static telaInicial + #168, #0
  static telaInicial + #169, #0
  static telaInicial + #170, #0
  static telaInicial + #171, #0
  static telaInicial + #172, #0
  static telaInicial + #173, #0
  static telaInicial + #174, #0
  static telaInicial + #175, #0
  static telaInicial + #176, #0
  static telaInicial + #177, #0
  static telaInicial + #178, #0
  static telaInicial + #179, #0
  static telaInicial + #180, #0
  static telaInicial + #181, #0
  static telaInicial + #182, #0
  static telaInicial + #183, #0
  static telaInicial + #184, #0
  static telaInicial + #185, #0
  static telaInicial + #186, #0
  static telaInicial + #187, #0
  static telaInicial + #188, #0
  static telaInicial + #189, #0
  static telaInicial + #190, #0
  static telaInicial + #191, #0
  static telaInicial + #192, #0
  static telaInicial + #193, #0
  static telaInicial + #194, #0
  static telaInicial + #195, #1024
  static telaInicial + #196, #3922
  static telaInicial + #197, #3922
  static telaInicial + #198, #3922
  static telaInicial + #199, #3922

  ;Linha 5
  static telaInicial + #200, #3922
  static telaInicial + #201, #3922
  static telaInicial + #202, #3922
  static telaInicial + #203, #1024
  static telaInicial + #204, #0
  static telaInicial + #205, #0
  static telaInicial + #206, #3584
  static telaInicial + #207, #3584
  static telaInicial + #208, #3584
  static telaInicial + #209, #3584
  static telaInicial + #210, #3584
  static telaInicial + #211, #3584
  static telaInicial + #212, #3584
  static telaInicial + #213, #3584
  static telaInicial + #214, #3584
  static telaInicial + #215, #3584
  static telaInicial + #216, #3584
  static telaInicial + #217, #3584
  static telaInicial + #218, #3584
  static telaInicial + #219, #3584
  static telaInicial + #220, #3584
  static telaInicial + #221, #3584
  static telaInicial + #222, #3584
  static telaInicial + #223, #3584
  static telaInicial + #224, #3584
  static telaInicial + #225, #3584
  static telaInicial + #226, #3584
  static telaInicial + #227, #3584
  static telaInicial + #228, #3584
  static telaInicial + #229, #3584
  static telaInicial + #230, #3584
  static telaInicial + #231, #3584
  static telaInicial + #232, #3584
  static telaInicial + #233, #3584
  static telaInicial + #234, #0
  static telaInicial + #235, #0
  static telaInicial + #236, #1024
  static telaInicial + #237, #3922
  static telaInicial + #238, #3922
  static telaInicial + #239, #3922

  ;Linha 6
  static telaInicial + #240, #3922
  static telaInicial + #241, #3922
  static telaInicial + #242, #1024
  static telaInicial + #243, #0
  static telaInicial + #244, #0
  static telaInicial + #245, #3584
  static telaInicial + #246, #1024
  static telaInicial + #247, #3584
  static telaInicial + #248, #3584
  static telaInicial + #249, #3584
  static telaInicial + #250, #1024
  static telaInicial + #251, #3584
  static telaInicial + #252, #3584
  static telaInicial + #253, #3584
  static telaInicial + #254, #1024
  static telaInicial + #255, #1024
  static telaInicial + #256, #1024
  static telaInicial + #257, #1024
  static telaInicial + #258, #3584
  static telaInicial + #259, #3584
  static telaInicial + #260, #1024
  static telaInicial + #261, #1024
  static telaInicial + #262, #3584
  static telaInicial + #263, #3584
  static telaInicial + #264, #1024
  static telaInicial + #265, #3584
  static telaInicial + #266, #3584
  static telaInicial + #267, #1024
  static telaInicial + #268, #3584
  static telaInicial + #269, #3584
  static telaInicial + #270, #1024
  static telaInicial + #271, #1024
  static telaInicial + #272, #1024
  static telaInicial + #273, #3584
  static telaInicial + #274, #3584
  static telaInicial + #275, #0
  static telaInicial + #276, #0
  static telaInicial + #277, #1024
  static telaInicial + #278, #3922
  static telaInicial + #279, #3922

  ;Linha 7
  static telaInicial + #280, #3922
  static telaInicial + #281, #3922
  static telaInicial + #282, #1024
  static telaInicial + #283, #3584
  static telaInicial + #284, #3584
  static telaInicial + #285, #3584
  static telaInicial + #286, #3584
  static telaInicial + #287, #1024
  static telaInicial + #288, #3584
  static telaInicial + #289, #1024
  static telaInicial + #290, #3584
  static telaInicial + #291, #3584
  static telaInicial + #292, #3584
  static telaInicial + #293, #3584
  static telaInicial + #294, #1024
  static telaInicial + #295, #3584
  static telaInicial + #296, #3584
  static telaInicial + #297, #1024
  static telaInicial + #298, #3584
  static telaInicial + #299, #1024
  static telaInicial + #300, #3584
  static telaInicial + #301, #3584
  static telaInicial + #302, #1024
  static telaInicial + #303, #3584
  static telaInicial + #304, #1024
  static telaInicial + #305, #1024
  static telaInicial + #306, #3584
  static telaInicial + #307, #1024
  static telaInicial + #308, #3584
  static telaInicial + #309, #1024
  static telaInicial + #310, #3584
  static telaInicial + #311, #3584
  static telaInicial + #312, #3584
  static telaInicial + #313, #3584
  static telaInicial + #314, #3584
  static telaInicial + #315, #3584
  static telaInicial + #316, #3584
  static telaInicial + #317, #1024
  static telaInicial + #318, #3922
  static telaInicial + #319, #3922

  ;Linha 8
  static telaInicial + #320, #3922
  static telaInicial + #321, #3922
  static telaInicial + #322, #1024
  static telaInicial + #323, #3584
  static telaInicial + #324, #3584
  static telaInicial + #325, #3584
  static telaInicial + #326, #3584
  static telaInicial + #327, #3584
  static telaInicial + #328, #1024
  static telaInicial + #329, #3584
  static telaInicial + #330, #3584
  static telaInicial + #331, #1024
  static telaInicial + #332, #1024
  static telaInicial + #333, #3584
  static telaInicial + #334, #1024
  static telaInicial + #335, #1024
  static telaInicial + #336, #1024
  static telaInicial + #337, #3584
  static telaInicial + #338, #3584
  static telaInicial + #339, #1024
  static telaInicial + #340, #3584
  static telaInicial + #341, #3584
  static telaInicial + #342, #1024
  static telaInicial + #343, #3584
  static telaInicial + #344, #1024
  static telaInicial + #345, #3584
  static telaInicial + #346, #1024
  static telaInicial + #347, #1024
  static telaInicial + #348, #3584
  static telaInicial + #349, #1024
  static telaInicial + #350, #3584
  static telaInicial + #351, #3584
  static telaInicial + #352, #1024
  static telaInicial + #353, #3584
  static telaInicial + #354, #3584
  static telaInicial + #355, #3584
  static telaInicial + #356, #3584
  static telaInicial + #357, #1024
  static telaInicial + #358, #3922
  static telaInicial + #359, #3922

  ;Linha 9
  static telaInicial + #360, #3922
  static telaInicial + #361, #3922
  static telaInicial + #362, #1024
  static telaInicial + #363, #3584
  static telaInicial + #364, #3584
  static telaInicial + #365, #3584
  static telaInicial + #366, #3584
  static telaInicial + #367, #1024
  static telaInicial + #368, #3584
  static telaInicial + #369, #1024
  static telaInicial + #370, #3584
  static telaInicial + #371, #3584
  static telaInicial + #372, #3584
  static telaInicial + #373, #3584
  static telaInicial + #374, #1024
  static telaInicial + #375, #3584
  static telaInicial + #376, #3584
  static telaInicial + #377, #3584
  static telaInicial + #378, #3584
  static telaInicial + #379, #1024
  static telaInicial + #380, #3584
  static telaInicial + #381, #3584
  static telaInicial + #382, #1024
  static telaInicial + #383, #3584
  static telaInicial + #384, #1024
  static telaInicial + #385, #3584
  static telaInicial + #386, #3584
  static telaInicial + #387, #1024
  static telaInicial + #388, #3584
  static telaInicial + #389, #1024
  static telaInicial + #390, #3584
  static telaInicial + #391, #3584
  static telaInicial + #392, #3584
  static telaInicial + #393, #1024
  static telaInicial + #394, #3584
  static telaInicial + #395, #3584
  static telaInicial + #396, #3584
  static telaInicial + #397, #1024
  static telaInicial + #398, #3922
  static telaInicial + #399, #3922

  ;Linha 10
  static telaInicial + #400, #3922
  static telaInicial + #401, #3922
  static telaInicial + #402, #1024
  static telaInicial + #403, #1536
  static telaInicial + #404, #1536
  static telaInicial + #405, #3584
  static telaInicial + #406, #1024
  static telaInicial + #407, #3584
  static telaInicial + #408, #3584
  static telaInicial + #409, #3584
  static telaInicial + #410, #1024
  static telaInicial + #411, #3584
  static telaInicial + #412, #3584
  static telaInicial + #413, #3584
  static telaInicial + #414, #1024
  static telaInicial + #415, #3584
  static telaInicial + #416, #3584
  static telaInicial + #417, #3584
  static telaInicial + #418, #3584
  static telaInicial + #419, #3584
  static telaInicial + #420, #1024
  static telaInicial + #421, #1024
  static telaInicial + #422, #3584
  static telaInicial + #423, #3584
  static telaInicial + #424, #1024
  static telaInicial + #425, #3584
  static telaInicial + #426, #3584
  static telaInicial + #427, #1024
  static telaInicial + #428, #3584
  static telaInicial + #429, #3584
  static telaInicial + #430, #1024
  static telaInicial + #431, #1024
  static telaInicial + #432, #1024
  static telaInicial + #433, #3584
  static telaInicial + #434, #3584
  static telaInicial + #435, #1536
  static telaInicial + #436, #1536
  static telaInicial + #437, #1024
  static telaInicial + #438, #3922
  static telaInicial + #439, #3922

  ;Linha 11
  static telaInicial + #440, #3922
  static telaInicial + #441, #3922
  static telaInicial + #442, #3922
  static telaInicial + #443, #1024
  static telaInicial + #444, #1536
  static telaInicial + #445, #1536
  static telaInicial + #446, #3584
  static telaInicial + #447, #3584
  static telaInicial + #448, #3584
  static telaInicial + #449, #3584
  static telaInicial + #450, #3584
  static telaInicial + #451, #3584
  static telaInicial + #452, #3584
  static telaInicial + #453, #3584
  static telaInicial + #454, #3584
  static telaInicial + #455, #3584
  static telaInicial + #456, #3584
  static telaInicial + #457, #3584
  static telaInicial + #458, #3584
  static telaInicial + #459, #3584
  static telaInicial + #460, #3584
  static telaInicial + #461, #3584
  static telaInicial + #462, #3584
  static telaInicial + #463, #3584
  static telaInicial + #464, #3584
  static telaInicial + #465, #3584
  static telaInicial + #466, #3584
  static telaInicial + #467, #3584
  static telaInicial + #468, #3584
  static telaInicial + #469, #3584
  static telaInicial + #470, #3584
  static telaInicial + #471, #3584
  static telaInicial + #472, #3584
  static telaInicial + #473, #3584
  static telaInicial + #474, #1536
  static telaInicial + #475, #1536
  static telaInicial + #476, #1024
  static telaInicial + #477, #3922
  static telaInicial + #478, #3922
  static telaInicial + #479, #3922

  ;Linha 12
  static telaInicial + #480, #3922
  static telaInicial + #481, #3922
  static telaInicial + #482, #3922
  static telaInicial + #483, #3922
  static telaInicial + #484, #1024
  static telaInicial + #485, #1536
  static telaInicial + #486, #1536
  static telaInicial + #487, #1536
  static telaInicial + #488, #1536
  static telaInicial + #489, #1536
  static telaInicial + #490, #1536
  static telaInicial + #491, #1536
  static telaInicial + #492, #1536
  static telaInicial + #493, #1536
  static telaInicial + #494, #1536
  static telaInicial + #495, #1536
  static telaInicial + #496, #1536
  static telaInicial + #497, #1536
  static telaInicial + #498, #1536
  static telaInicial + #499, #1536
  static telaInicial + #500, #1536
  static telaInicial + #501, #1536
  static telaInicial + #502, #1536
  static telaInicial + #503, #1536
  static telaInicial + #504, #1536
  static telaInicial + #505, #1536
  static telaInicial + #506, #1536
  static telaInicial + #507, #1536
  static telaInicial + #508, #1536
  static telaInicial + #509, #1536
  static telaInicial + #510, #1536
  static telaInicial + #511, #1536
  static telaInicial + #512, #1536
  static telaInicial + #513, #1536
  static telaInicial + #514, #1536
  static telaInicial + #515, #1024
  static telaInicial + #516, #3922
  static telaInicial + #517, #3922
  static telaInicial + #518, #3922
  static telaInicial + #519, #3922

  ;Linha 13
  static telaInicial + #520, #3922
  static telaInicial + #521, #3922
  static telaInicial + #522, #3922
  static telaInicial + #523, #3922
  static telaInicial + #524, #3922
  static telaInicial + #525, #1024
  static telaInicial + #526, #1024
  static telaInicial + #527, #1024
  static telaInicial + #528, #1024
  static telaInicial + #529, #1024
  static telaInicial + #530, #1024
  static telaInicial + #531, #1024
  static telaInicial + #532, #1024
  static telaInicial + #533, #1024
  static telaInicial + #534, #1024
  static telaInicial + #535, #1024
  static telaInicial + #536, #1024
  static telaInicial + #537, #1024
  static telaInicial + #538, #1024
  static telaInicial + #539, #1024
  static telaInicial + #540, #1024
  static telaInicial + #541, #1024
  static telaInicial + #542, #1024
  static telaInicial + #543, #1024
  static telaInicial + #544, #1024
  static telaInicial + #545, #1024
  static telaInicial + #546, #1024
  static telaInicial + #547, #1024
  static telaInicial + #548, #1024
  static telaInicial + #549, #1024
  static telaInicial + #550, #1024
  static telaInicial + #551, #1024
  static telaInicial + #552, #1024
  static telaInicial + #553, #1024
  static telaInicial + #554, #1024
  static telaInicial + #555, #3922
  static telaInicial + #556, #3922
  static telaInicial + #557, #3922
  static telaInicial + #558, #3922
  static telaInicial + #559, #3922

  ;Linha 14
  static telaInicial + #560, #3922
  static telaInicial + #561, #3922
  static telaInicial + #562, #3922
  static telaInicial + #563, #3922
  static telaInicial + #564, #3922
  static telaInicial + #565, #3922
  static telaInicial + #566, #3922
  static telaInicial + #567, #3922
  static telaInicial + #568, #3922
  static telaInicial + #569, #3922
  static telaInicial + #570, #3922
  static telaInicial + #571, #3922
  static telaInicial + #572, #3922
  static telaInicial + #573, #3922
  static telaInicial + #574, #3922
  static telaInicial + #575, #3922
  static telaInicial + #576, #3922
  static telaInicial + #577, #3922
  static telaInicial + #578, #3922
  static telaInicial + #579, #3922
  static telaInicial + #580, #3922
  static telaInicial + #581, #3922
  static telaInicial + #582, #3922
  static telaInicial + #583, #3922
  static telaInicial + #584, #3922
  static telaInicial + #585, #3922
  static telaInicial + #586, #3922
  static telaInicial + #587, #3922
  static telaInicial + #588, #3922
  static telaInicial + #589, #3922
  static telaInicial + #590, #3922
  static telaInicial + #591, #3922
  static telaInicial + #592, #3922
  static telaInicial + #593, #3922
  static telaInicial + #594, #3922
  static telaInicial + #595, #3922
  static telaInicial + #596, #3922
  static telaInicial + #597, #3922
  static telaInicial + #598, #3922
  static telaInicial + #599, #3922

  ;Linha 15
  static telaInicial + #600, #3922
  static telaInicial + #601, #3922
  static telaInicial + #602, #3922
  static telaInicial + #603, #3922
  static telaInicial + #604, #3922
  static telaInicial + #605, #3922
  static telaInicial + #606, #3922
  static telaInicial + #607, #3922
  static telaInicial + #608, #65
  static telaInicial + #609, #80
  static telaInicial + #610, #69
  static telaInicial + #611, #82
  static telaInicial + #612, #84
  static telaInicial + #613, #69
  static telaInicial + #614, #3922
  static telaInicial + #615, #69
  static telaInicial + #616, #83
  static telaInicial + #617, #80
  static telaInicial + #618, #65
  static telaInicial + #619, #67
  static telaInicial + #620, #79
  static telaInicial + #621, #3922
  static telaInicial + #622, #80
  static telaInicial + #623, #65
  static telaInicial + #624, #82
  static telaInicial + #625, #65
  static telaInicial + #626, #3922
  static telaInicial + #627, #73
  static telaInicial + #628, #78
  static telaInicial + #629, #73
  static telaInicial + #630, #67
  static telaInicial + #631, #73
  static telaInicial + #632, #65
  static telaInicial + #633, #82
  static telaInicial + #634, #3922
  static telaInicial + #635, #3922
  static telaInicial + #636, #3922
  static telaInicial + #637, #3922
  static telaInicial + #638, #3922
  static telaInicial + #639, #3922

  ;Linha 16
  static telaInicial + #640, #3922
  static telaInicial + #641, #3922
  static telaInicial + #642, #3922
  static telaInicial + #643, #3922
  static telaInicial + #644, #3922
  static telaInicial + #645, #3922
  static telaInicial + #646, #3922
  static telaInicial + #647, #3922
  static telaInicial + #648, #3922
  static telaInicial + #649, #3922
  static telaInicial + #650, #3922
  static telaInicial + #651, #3922
  static telaInicial + #652, #3922
  static telaInicial + #653, #3922
  static telaInicial + #654, #3922
  static telaInicial + #655, #3922
  static telaInicial + #656, #3922
  static telaInicial + #657, #3922
  static telaInicial + #658, #3922
  static telaInicial + #659, #39
  static telaInicial + #660, #3922
  static telaInicial + #661, #3922
  static telaInicial + #662, #3922
  static telaInicial + #663, #3922
  static telaInicial + #664, #3922
  static telaInicial + #665, #3922
  static telaInicial + #666, #3922
  static telaInicial + #667, #3922
  static telaInicial + #668, #3922
  static telaInicial + #669, #3922
  static telaInicial + #670, #3922
  static telaInicial + #671, #3922
  static telaInicial + #672, #3922
  static telaInicial + #673, #3922
  static telaInicial + #674, #3922
  static telaInicial + #675, #3922
  static telaInicial + #676, #3922
  static telaInicial + #677, #3922
  static telaInicial + #678, #3922
  static telaInicial + #679, #3922

  ;Linha 17
  static telaInicial + #680, #3922
  static telaInicial + #681, #3922
  static telaInicial + #682, #3922
  static telaInicial + #683, #3922
  static telaInicial + #684, #2816
  static telaInicial + #685, #2816
  static telaInicial + #686, #2816
  static telaInicial + #687, #2816
  static telaInicial + #688, #2816
  static telaInicial + #689, #2816
  static telaInicial + #690, #2816
  static telaInicial + #691, #2816
  static telaInicial + #692, #2816
  static telaInicial + #693, #3922
  static telaInicial + #694, #3922
  static telaInicial + #695, #3922
  static telaInicial + #696, #3922
  static telaInicial + #697, #3922
  static telaInicial + #698, #3922
  static telaInicial + #699, #3922
  static telaInicial + #700, #3922
  static telaInicial + #701, #3922
  static telaInicial + #702, #3922
  static telaInicial + #703, #3922
  static telaInicial + #704, #3922
  static telaInicial + #705, #3922
  static telaInicial + #706, #3922
  static telaInicial + #707, #3922
  static telaInicial + #708, #3922
  static telaInicial + #709, #3922
  static telaInicial + #710, #3922
  static telaInicial + #711, #3922
  static telaInicial + #712, #3922
  static telaInicial + #713, #3922
  static telaInicial + #714, #3922
  static telaInicial + #715, #3922
  static telaInicial + #716, #3922
  static telaInicial + #717, #3922
  static telaInicial + #718, #3922
  static telaInicial + #719, #3922

  ;Linha 18
  static telaInicial + #720, #3922
  static telaInicial + #721, #3922
  static telaInicial + #722, #3922
  static telaInicial + #723, #3922
  static telaInicial + #724, #2816
  static telaInicial + #725, #2816
  static telaInicial + #726, #2816
  static telaInicial + #727, #2816
  static telaInicial + #728, #2816
  static telaInicial + #729, #2816
  static telaInicial + #730, #2816
  static telaInicial + #731, #2816
  static telaInicial + #732, #2816
  static telaInicial + #733, #3922
  static telaInicial + #734, #3922
  static telaInicial + #735, #3922
  static telaInicial + #736, #3922
  static telaInicial + #737, #3922
  static telaInicial + #738, #3922
  static telaInicial + #739, #3922
  static telaInicial + #740, #3922
  static telaInicial + #741, #3922
  static telaInicial + #742, #3922
  static telaInicial + #743, #3922
  static telaInicial + #744, #3922
  static telaInicial + #745, #3922
  static telaInicial + #746, #3922
  static telaInicial + #747, #3922
  static telaInicial + #748, #1536
  static telaInicial + #749, #3922
  static telaInicial + #750, #3922
  static telaInicial + #751, #3922
  static telaInicial + #752, #1536
  static telaInicial + #753, #3922
  static telaInicial + #754, #3922
  static telaInicial + #755, #3922
  static telaInicial + #756, #3922
  static telaInicial + #757, #3922
  static telaInicial + #758, #3922
  static telaInicial + #759, #3922

  ;Linha 19
  static telaInicial + #760, #3922
  static telaInicial + #761, #3922
  static telaInicial + #762, #3922
  static telaInicial + #763, #3922
  static telaInicial + #764, #2816
  static telaInicial + #765, #0
  static telaInicial + #766, #0
  static telaInicial + #767, #0
  static telaInicial + #768, #2816
  static telaInicial + #769, #0
  static telaInicial + #770, #0
  static telaInicial + #771, #0
  static telaInicial + #772, #2816
  static telaInicial + #773, #3922
  static telaInicial + #774, #3922
  static telaInicial + #775, #3922
  static telaInicial + #776, #3922
  static telaInicial + #777, #3922
  static telaInicial + #778, #3922
  static telaInicial + #779, #3922
  static telaInicial + #780, #3922
  static telaInicial + #781, #3922
  static telaInicial + #782, #3922
  static telaInicial + #783, #3922
  static telaInicial + #784, #3922
  static telaInicial + #785, #3922
  static telaInicial + #786, #3922
  static telaInicial + #787, #3922
  static telaInicial + #788, #3922
  static telaInicial + #789, #1536
  static telaInicial + #790, #3840
  static telaInicial + #791, #1536
  static telaInicial + #792, #3922
  static telaInicial + #793, #3922
  static telaInicial + #794, #3922
  static telaInicial + #795, #3922
  static telaInicial + #796, #3922
  static telaInicial + #797, #3922
  static telaInicial + #798, #3922
  static telaInicial + #799, #3922

  ;Linha 20
  static telaInicial + #800, #3922
  static telaInicial + #801, #3922
  static telaInicial + #802, #3922
  static telaInicial + #803, #3922
  static telaInicial + #804, #2816
  static telaInicial + #805, #0
  static telaInicial + #806, #0
  static telaInicial + #807, #1536
  static telaInicial + #808, #2816
  static telaInicial + #809, #1536
  static telaInicial + #810, #0
  static telaInicial + #811, #0
  static telaInicial + #812, #2816
  static telaInicial + #813, #3922
  static telaInicial + #814, #3922
  static telaInicial + #815, #3922
  static telaInicial + #816, #3840
  static telaInicial + #817, #3922
  static telaInicial + #818, #3922
  static telaInicial + #819, #3840
  static telaInicial + #820, #3922
  static telaInicial + #821, #3840
  static telaInicial + #822, #3840
  static telaInicial + #823, #3840
  static telaInicial + #824, #3840
  static telaInicial + #825, #3922
  static telaInicial + #826, #3922
  static telaInicial + #827, #3922
  static telaInicial + #828, #3922
  static telaInicial + #829, #1536
  static telaInicial + #830, #1536
  static telaInicial + #831, #1536
  static telaInicial + #832, #3922
  static telaInicial + #833, #3922
  static telaInicial + #834, #3922
  static telaInicial + #835, #3922
  static telaInicial + #836, #3922
  static telaInicial + #837, #3922
  static telaInicial + #838, #3922
  static telaInicial + #839, #3922

  ;Linha 21
  static telaInicial + #840, #3922
  static telaInicial + #841, #3922
  static telaInicial + #842, #3922
  static telaInicial + #843, #3922
  static telaInicial + #844, #2816
  static telaInicial + #845, #3328
  static telaInicial + #846, #0
  static telaInicial + #847, #0
  static telaInicial + #848, #2816
  static telaInicial + #849, #0
  static telaInicial + #850, #0
  static telaInicial + #851, #3328
  static telaInicial + #852, #2816
  static telaInicial + #853, #3922
  static telaInicial + #854, #3922
  static telaInicial + #855, #3922
  static telaInicial + #856, #3840
  static telaInicial + #857, #3840
  static telaInicial + #858, #3840
  static telaInicial + #859, #3840
  static telaInicial + #860, #3840
  static telaInicial + #861, #3840
  static telaInicial + #862, #3840
  static telaInicial + #863, #3840
  static telaInicial + #864, #3840
  static telaInicial + #865, #3922
  static telaInicial + #866, #3922
  static telaInicial + #867, #3922
  static telaInicial + #868, #1536
  static telaInicial + #869, #3840
  static telaInicial + #870, #3840
  static telaInicial + #871, #3840
  static telaInicial + #872, #1536
  static telaInicial + #873, #3922
  static telaInicial + #874, #3922
  static telaInicial + #875, #3922
  static telaInicial + #876, #3922
  static telaInicial + #877, #3922
  static telaInicial + #878, #3922
  static telaInicial + #879, #3922

  ;Linha 22
  static telaInicial + #880, #3922
  static telaInicial + #881, #3922
  static telaInicial + #882, #3922
  static telaInicial + #883, #3922
  static telaInicial + #884, #2816
  static telaInicial + #885, #2816
  static telaInicial + #886, #2816
  static telaInicial + #887, #2816
  static telaInicial + #888, #2816
  static telaInicial + #889, #2816
  static telaInicial + #890, #2816
  static telaInicial + #891, #2816
  static telaInicial + #892, #2816
  static telaInicial + #893, #3922
  static telaInicial + #894, #3922
  static telaInicial + #895, #3922
  static telaInicial + #896, #3840
  static telaInicial + #897, #3840
  static telaInicial + #898, #3840
  static telaInicial + #899, #3840
  static telaInicial + #900, #3840
  static telaInicial + #901, #3840
  static telaInicial + #902, #3840
  static telaInicial + #903, #3840
  static telaInicial + #904, #3840
  static telaInicial + #905, #3922
  static telaInicial + #906, #3922
  static telaInicial + #907, #3840
  static telaInicial + #908, #1536
  static telaInicial + #909, #1792
  static telaInicial + #910, #256
  static telaInicial + #911, #1792
  static telaInicial + #912, #1536
  static telaInicial + #913, #3840
  static telaInicial + #914, #3840
  static telaInicial + #915, #3840
  static telaInicial + #916, #3840
  static telaInicial + #917, #3840
  static telaInicial + #918, #3840
  static telaInicial + #919, #3840

  ;Linha 23
  static telaInicial + #920, #3922
  static telaInicial + #921, #3922
  static telaInicial + #922, #3922
  static telaInicial + #923, #3922
  static telaInicial + #924, #2816
  static telaInicial + #925, #2816
  static telaInicial + #926, #2816
  static telaInicial + #927, #2816
  static telaInicial + #928, #2816
  static telaInicial + #929, #2816
  static telaInicial + #930, #2816
  static telaInicial + #931, #2816
  static telaInicial + #932, #2816
  static telaInicial + #933, #3922
  static telaInicial + #934, #3922
  static telaInicial + #935, #3840
  static telaInicial + #936, #3840
  static telaInicial + #937, #3840
  static telaInicial + #938, #3840
  static telaInicial + #939, #3840
  static telaInicial + #940, #3840
  static telaInicial + #941, #3840
  static telaInicial + #942, #3840
  static telaInicial + #943, #3840
  static telaInicial + #944, #3840
  static telaInicial + #945, #3922
  static telaInicial + #946, #3922
  static telaInicial + #947, #3840
  static telaInicial + #948, #1536
  static telaInicial + #949, #0
  static telaInicial + #950, #256
  static telaInicial + #951, #0
  static telaInicial + #952, #1536
  static telaInicial + #953, #3922
  static telaInicial + #954, #3922
  static telaInicial + #955, #3922
  static telaInicial + #956, #3922
  static telaInicial + #957, #3922
  static telaInicial + #958, #3922
  static telaInicial + #959, #3922

  ;Linha 24
  static telaInicial + #960, #3922
  static telaInicial + #961, #3922
  static telaInicial + #962, #3922
  static telaInicial + #963, #0
  static telaInicial + #964, #0
  static telaInicial + #965, #0
  static telaInicial + #966, #0
  static telaInicial + #967, #1792
  static telaInicial + #968, #2304
  static telaInicial + #969, #1792
  static telaInicial + #970, #0
  static telaInicial + #971, #0
  static telaInicial + #972, #0
  static telaInicial + #973, #0
  static telaInicial + #974, #3922
  static telaInicial + #975, #3922
  static telaInicial + #976, #3840
  static telaInicial + #977, #3840
  static telaInicial + #978, #3840
  static telaInicial + #979, #3840
  static telaInicial + #980, #3840
  static telaInicial + #981, #3840
  static telaInicial + #982, #3840
  static telaInicial + #983, #3840
  static telaInicial + #984, #3840
  static telaInicial + #985, #3840
  static telaInicial + #986, #3840
  static telaInicial + #987, #3840
  static telaInicial + #988, #1536
  static telaInicial + #989, #0
  static telaInicial + #990, #0
  static telaInicial + #991, #0
  static telaInicial + #992, #1536
  static telaInicial + #993, #3922
  static telaInicial + #994, #3922
  static telaInicial + #995, #3922
  static telaInicial + #996, #3922
  static telaInicial + #997, #3922
  static telaInicial + #998, #3922
  static telaInicial + #999, #3922

  ;Linha 25
  static telaInicial + #1000, #3922
  static telaInicial + #1001, #3922
  static telaInicial + #1002, #3922
  static telaInicial + #1003, #2816
  static telaInicial + #1004, #256
  static telaInicial + #1005, #256
  static telaInicial + #1006, #256
  static telaInicial + #1007, #256
  static telaInicial + #1008, #2304
  static telaInicial + #1009, #256
  static telaInicial + #1010, #256
  static telaInicial + #1011, #256
  static telaInicial + #1012, #256
  static telaInicial + #1013, #2816
  static telaInicial + #1014, #3922
  static telaInicial + #1015, #3922
  static telaInicial + #1016, #3840
  static telaInicial + #1017, #3840
  static telaInicial + #1018, #3840
  static telaInicial + #1019, #3840
  static telaInicial + #1020, #3840
  static telaInicial + #1021, #3840
  static telaInicial + #1022, #3840
  static telaInicial + #1023, #3840
  static telaInicial + #1024, #3840
  static telaInicial + #1025, #3840
  static telaInicial + #1026, #3840
  static telaInicial + #1027, #1536
  static telaInicial + #1028, #3328
  static telaInicial + #1029, #1536
  static telaInicial + #1030, #1536
  static telaInicial + #1031, #1536
  static telaInicial + #1032, #3328
  static telaInicial + #1033, #1536
  static telaInicial + #1034, #3922
  static telaInicial + #1035, #3922
  static telaInicial + #1036, #3922
  static telaInicial + #1037, #3922
  static telaInicial + #1038, #3922
  static telaInicial + #1039, #3922

  ;Linha 26
  static telaInicial + #1040, #3922
  static telaInicial + #1041, #3922
  static telaInicial + #1042, #3922
  static telaInicial + #1043, #3922
  static telaInicial + #1044, #3922
  static telaInicial + #1045, #3922
  static telaInicial + #1046, #3922
  static telaInicial + #1047, #2816
  static telaInicial + #1048, #3840
  static telaInicial + #1049, #2816
  static telaInicial + #1050, #3922
  static telaInicial + #1051, #3922
  static telaInicial + #1052, #3922
  static telaInicial + #1053, #3922
  static telaInicial + #1054, #3922
  static telaInicial + #1055, #3922
  static telaInicial + #1056, #3840
  static telaInicial + #1057, #3840
  static telaInicial + #1058, #3840
  static telaInicial + #1059, #3840
  static telaInicial + #1060, #3840
  static telaInicial + #1061, #3840
  static telaInicial + #1062, #3840
  static telaInicial + #1063, #3840
  static telaInicial + #1064, #3840
  static telaInicial + #1065, #3840
  static telaInicial + #1066, #3840
  static telaInicial + #1067, #3840
  static telaInicial + #1068, #1536
  static telaInicial + #1069, #1536
  static telaInicial + #1070, #1536
  static telaInicial + #1071, #1536
  static telaInicial + #1072, #1536
  static telaInicial + #1073, #3922
  static telaInicial + #1074, #3922
  static telaInicial + #1075, #3922
  static telaInicial + #1076, #3922
  static telaInicial + #1077, #3840
  static telaInicial + #1078, #3840
  static telaInicial + #1079, #3922

  ;Linha 27
  static telaInicial + #1080, #3922
  static telaInicial + #1081, #3922
  static telaInicial + #1082, #3922
  static telaInicial + #1083, #3922
  static telaInicial + #1084, #3922
  static telaInicial + #1085, #3922
  static telaInicial + #1086, #2048
  static telaInicial + #1087, #2048
  static telaInicial + #1088, #3840
  static telaInicial + #1089, #2048
  static telaInicial + #1090, #2048
  static telaInicial + #1091, #3922
  static telaInicial + #1092, #3922
  static telaInicial + #1093, #3922
  static telaInicial + #1094, #3922
  static telaInicial + #1095, #3922
  static telaInicial + #1096, #3840
  static telaInicial + #1097, #3840
  static telaInicial + #1098, #3840
  static telaInicial + #1099, #3840
  static telaInicial + #1100, #3840
  static telaInicial + #1101, #3840
  static telaInicial + #1102, #3840
  static telaInicial + #1103, #3840
  static telaInicial + #1104, #3922
  static telaInicial + #1105, #3922
  static telaInicial + #1106, #3922
  static telaInicial + #1107, #3922
  static telaInicial + #1108, #3922
  static telaInicial + #1109, #1536
  static telaInicial + #1110, #3922
  static telaInicial + #1111, #1536
  static telaInicial + #1112, #3922
  static telaInicial + #1113, #3922
  static telaInicial + #1114, #3922
  static telaInicial + #1115, #3922
  static telaInicial + #1116, #3840
  static telaInicial + #1117, #3840
  static telaInicial + #1118, #3840
  static telaInicial + #1119, #3922

  ;Linha 28
  static telaInicial + #1120, #3922
  static telaInicial + #1121, #3922
  static telaInicial + #1122, #3922
  static telaInicial + #1123, #3922
  static telaInicial + #1124, #3922
  static telaInicial + #1125, #3840
  static telaInicial + #1126, #3840
  static telaInicial + #1127, #3840
  static telaInicial + #1128, #3840
  static telaInicial + #1129, #3840
  static telaInicial + #1130, #3840
  static telaInicial + #1131, #3840
  static telaInicial + #1132, #3840
  static telaInicial + #1133, #3840
  static telaInicial + #1134, #3840
  static telaInicial + #1135, #3840
  static telaInicial + #1136, #3840
  static telaInicial + #1137, #3840
  static telaInicial + #1138, #3840
  static telaInicial + #1139, #3840
  static telaInicial + #1140, #3840
  static telaInicial + #1141, #3840
  static telaInicial + #1142, #3840
  static telaInicial + #1143, #3922
  static telaInicial + #1144, #3922
  static telaInicial + #1145, #3922
  static telaInicial + #1146, #3922
  static telaInicial + #1147, #3922
  static telaInicial + #1148, #3922
  static telaInicial + #1149, #3840
  static telaInicial + #1150, #3840
  static telaInicial + #1151, #3840
  static telaInicial + #1152, #3840
  static telaInicial + #1153, #3840
  static telaInicial + #1154, #3922
  static telaInicial + #1155, #3840
  static telaInicial + #1156, #3840
  static telaInicial + #1157, #3840
  static telaInicial + #1158, #3840
  static telaInicial + #1159, #3922

  ;Linha 29
  static telaInicial + #1160, #3922
  static telaInicial + #1161, #3922
  static telaInicial + #1162, #3922
  static telaInicial + #1163, #3922
  static telaInicial + #1164, #3922
  static telaInicial + #1165, #3922
  static telaInicial + #1166, #3922
  static telaInicial + #1167, #3922
  static telaInicial + #1168, #3922
  static telaInicial + #1169, #3922
  static telaInicial + #1170, #3922
  static telaInicial + #1171, #3922
  static telaInicial + #1172, #3922
  static telaInicial + #1173, #3922
  static telaInicial + #1174, #3922
  static telaInicial + #1175, #3840
  static telaInicial + #1176, #3840
  static telaInicial + #1177, #3840
  static telaInicial + #1178, #3840
  static telaInicial + #1179, #3840
  static telaInicial + #1180, #3840
  static telaInicial + #1181, #3840
  static telaInicial + #1182, #3840
  static telaInicial + #1183, #3840
  static telaInicial + #1184, #3840
  static telaInicial + #1185, #3840
  static telaInicial + #1186, #3840
  static telaInicial + #1187, #3840
  static telaInicial + #1188, #3840
  static telaInicial + #1189, #3840
  static telaInicial + #1190, #3922
  static telaInicial + #1191, #3922
  static telaInicial + #1192, #3840
  static telaInicial + #1193, #3840
  static telaInicial + #1194, #3840
  static telaInicial + #1195, #3840
  static telaInicial + #1196, #3840
  static telaInicial + #1197, #3840
  static telaInicial + #1198, #3922
  static telaInicial + #1199, #3922

printtelaInicialScreen:
  push R0
  push R1
  push R2
  push R3

  loadn R0, #telaInicial
  loadn R1, #0
  loadn R2, #1200

  printtelaInicialScreenLoop:

    add R3,R0,R1
    loadi R3, R3
    outchar R3, R1
    inc R1
    cmp R1, R2

    jne printtelaInicialScreenLoop

  pop R3
  pop R2
  pop R1
  pop R0
  rts