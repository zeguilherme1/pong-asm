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
	; 512 lima 1010 0000
	; 2816 amarelo 1011 0000
	; 3072 azul 1100 0000
	; 3328 rosa 1101 0000
	; 3584 aqua 1110 0000
	; 3840 branco 1111 0000




reset:
	
	
limpa: string " "
inicio: string "X - Pong aperte espaco para comecar"
cenario: string "                                         Bob Esponja             Plankton"
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
	loadn r2, #512                 ; Cor verde pra barrinha 2
	
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

	loadn r1, #'i'
	cmp r2, r1
	jeq MoveUp2
	
  loadn r0, #'j'
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
	
	loadn r2, #512
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
	
	loadn r2, #512
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
    push r2
     

    loadn r1, #2  ; MUDANCA DE VELOCIDADE DAS BARRA, QUANTO MENOR MAIS RAPIDO "fps do joguinho"
    loadn r2, #0   ; Constante 0 para comparação
     
DelayOuter:
    loadn r0, #6000 ; Loop Interno (não precisa mexer) velocidade da bolinha maior mais lerdo
     
DelayInner: 
    dec r0
    cmp r0, r2
    jne DelayInner
     
    dec r1
    cmp r1, r2
    jne DelayOuter
     
    pop r2
    pop r1
    pop r0
    rts
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

;FIX colisão da barra, pontinha funcionando agora 

  loadn r2, #1
    sub r1, r1, r2 ; Diminui 1 para verificar exatamente a borda superior
    cmp r0, r1
    jle nao_colidiu_plank ; Se bola <= (Topo-1), errou
    
    add r1, r1, r2 ; Restaura valor original do topo

    loadn r2, #8
    add r2, r1, r2

    cmp r0, r2
    jgr nao_colidiu_plank ; Se bola > (Topo+8), errou
	
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


loadn r2, #1
    sub r1, r1, r2 ; Diminui 1 para pegar o limite exato
    cmp r0, r1
    jle nao_colidiu ; Se bola <= (Topo-1), errou
    
    add r1, r1, r2 ; Restaura valor original

    loadn r2, #8
    add r2, r1, r2
 
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
	
	jeq printbobVitoriaScreen
	
	loadn r0, #pplank
	loadi r0, r0
	
	cmp r2, r0
	
	jeq printplankVitoriaScreen
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
	Fim:
    inchar r2             ; Lê o teclado
    
    ; Opção 1: Jogar Novamente (0)
    loadn r5, #'0'        ; Carrega 0
    cmp r2, r5            ; É 0?
    jeq ReiniciarJogo     ; Se sim, vai limpar e resetar
    
    ; Opção 2: Sair (1)
    loadn r5, #'1'         ; Carrega 1
    cmp r2, r5            ; É 1?
    jeq SairDoJogo        ; Se sim, desliga
    
    jmp Fim               ; Se não apertou nada útil, continua esperando

; Bloco que faz o reinício
ReiniciarJogo:
    loadn r0, #0
    store pbob, r0
    store pplank, r0
    
    loadn r0, #0          
    loadn r1, #limpa      
    loadn r2, #0          
    
    call PrintStr         ; Limpa a mensagem de vitória
    call LimpaTela        ; Garante que a tela toda apaga
    
    jmp reset             ; Volta lá pro topo

; --- Bloco que encerra o programa ---
SairDoJogo:
    call LimpaTela        ; Opcional: Limpa a tela para não ficar congelada
    halt                  ; Para o processador definitivamente                ; Encerra o programa


; ----------------------------------------- TELAS ---------------------------------------------
plankVitoria : var #1200
  ;Linha 0
  static plankVitoria + #0, #3889
  static plankVitoria + #1, #3889
  static plankVitoria + #2, #3889
  static plankVitoria + #3, #3889
  static plankVitoria + #4, #3889
  static plankVitoria + #5, #3889
  static plankVitoria + #6, #3889
  static plankVitoria + #7, #3889
  static plankVitoria + #8, #3889
  static plankVitoria + #9, #3889
  static plankVitoria + #10, #3889
  static plankVitoria + #11, #3889
  static plankVitoria + #12, #3889
  static plankVitoria + #13, #3889
  static plankVitoria + #14, #3889
  static plankVitoria + #15, #3889
  static plankVitoria + #16, #3889
  static plankVitoria + #17, #3889
  static plankVitoria + #18, #3889
  static plankVitoria + #19, #3889
  static plankVitoria + #20, #3889
  static plankVitoria + #21, #3889
  static plankVitoria + #22, #3889
  static plankVitoria + #23, #3889
  static plankVitoria + #24, #3889
  static plankVitoria + #25, #3889
  static plankVitoria + #26, #3889
  static plankVitoria + #27, #3889
  static plankVitoria + #28, #3889
  static plankVitoria + #29, #3889
  static plankVitoria + #30, #3889
  static plankVitoria + #31, #3889
  static plankVitoria + #32, #3889
  static plankVitoria + #33, #3889
  static plankVitoria + #34, #3889
  static plankVitoria + #35, #3889
  static plankVitoria + #36, #3889
  static plankVitoria + #37, #3889
  static plankVitoria + #38, #3889
  static plankVitoria + #39, #3889

  ;Linha 1
  static plankVitoria + #40, #3889
  static plankVitoria + #41, #3889
  static plankVitoria + #42, #3889
  static plankVitoria + #43, #3889
  static plankVitoria + #44, #3889
  static plankVitoria + #45, #3889
  static plankVitoria + #46, #3889
  static plankVitoria + #47, #3889
  static plankVitoria + #48, #3889
  static plankVitoria + #49, #3889
  static plankVitoria + #50, #3889
  static plankVitoria + #51, #3889
  static plankVitoria + #52, #3889
  static plankVitoria + #53, #3889
  static plankVitoria + #54, #3889
  static plankVitoria + #55, #3889
  static plankVitoria + #56, #3889
  static plankVitoria + #57, #3889
  static plankVitoria + #58, #3889
  static plankVitoria + #59, #3889
  static plankVitoria + #60, #3889
  static plankVitoria + #61, #3889
  static plankVitoria + #62, #3889
  static plankVitoria + #63, #3889
  static plankVitoria + #64, #3889
  static plankVitoria + #65, #3889
  static plankVitoria + #66, #3889
  static plankVitoria + #67, #3889
  static plankVitoria + #68, #3889
  static plankVitoria + #69, #3889
  static plankVitoria + #70, #3889
  static plankVitoria + #71, #3889
  static plankVitoria + #72, #3889
  static plankVitoria + #73, #3889
  static plankVitoria + #74, #3889
  static plankVitoria + #75, #3889
  static plankVitoria + #76, #3889
  static plankVitoria + #77, #3889
  static plankVitoria + #78, #3889
  static plankVitoria + #79, #3889

  ;Linha 2
  static plankVitoria + #80, #3889
  static plankVitoria + #81, #3889
  static plankVitoria + #82, #17
  static plankVitoria + #83, #17
  static plankVitoria + #84, #3889
  static plankVitoria + #85, #3889
  static plankVitoria + #86, #3889
  static plankVitoria + #87, #3889
  static plankVitoria + #88, #3889
  static plankVitoria + #89, #80
  static plankVitoria + #90, #65
  static plankVitoria + #91, #82
  static plankVitoria + #92, #65
  static plankVitoria + #93, #66
  static plankVitoria + #94, #69
  static plankVitoria + #95, #78
  static plankVitoria + #96, #83
  static plankVitoria + #97, #44
  static plankVitoria + #98, #3889
  static plankVitoria + #99, #3664
  static plankVitoria + #100, #3660
  static plankVitoria + #101, #3649
  static plankVitoria + #102, #3662
  static plankVitoria + #103, #3659
  static plankVitoria + #104, #3668
  static plankVitoria + #105, #3663
  static plankVitoria + #106, #3662
  static plankVitoria + #107, #33
  static plankVitoria + #108, #3918
  static plankVitoria + #109, #3918
  static plankVitoria + #110, #3918
  static plankVitoria + #111, #3918
  static plankVitoria + #112, #3889
  static plankVitoria + #113, #3889
  static plankVitoria + #114, #3889
  static plankVitoria + #115, #3889
  static plankVitoria + #116, #3889
  static plankVitoria + #117, #3889
  static plankVitoria + #118, #3889
  static plankVitoria + #119, #3889

  ;Linha 3
  static plankVitoria + #120, #3889
  static plankVitoria + #121, #3889
  static plankVitoria + #122, #3889
  static plankVitoria + #123, #3889
  static plankVitoria + #124, #3889
  static plankVitoria + #125, #3889
  static plankVitoria + #126, #3889
  static plankVitoria + #127, #3889
  static plankVitoria + #128, #3889
  static plankVitoria + #129, #3889
  static plankVitoria + #130, #3889
  static plankVitoria + #131, #3889
  static plankVitoria + #132, #3889
  static plankVitoria + #133, #3889
  static plankVitoria + #134, #3889
  static plankVitoria + #135, #3889
  static plankVitoria + #136, #3889
  static plankVitoria + #137, #3889
  static plankVitoria + #138, #3889
  static plankVitoria + #139, #3889
  static plankVitoria + #140, #3889
  static plankVitoria + #141, #3889
  static plankVitoria + #142, #44
  static plankVitoria + #143, #3889
  static plankVitoria + #144, #3889
  static plankVitoria + #145, #3889
  static plankVitoria + #146, #3889
  static plankVitoria + #147, #3889
  static plankVitoria + #148, #3889
  static plankVitoria + #149, #3889
  static plankVitoria + #150, #3889
  static plankVitoria + #151, #3889
  static plankVitoria + #152, #3889
  static plankVitoria + #153, #3889
  static plankVitoria + #154, #3889
  static plankVitoria + #155, #3889
  static plankVitoria + #156, #3889
  static plankVitoria + #157, #3889
  static plankVitoria + #158, #3889
  static plankVitoria + #159, #3889

  ;Linha 4
  static plankVitoria + #160, #3889
  static plankVitoria + #161, #3889
  static plankVitoria + #162, #3926
  static plankVitoria + #163, #3926
  static plankVitoria + #164, #86
  static plankVitoria + #165, #79
  static plankVitoria + #166, #67
  static plankVitoria + #167, #69
  static plankVitoria + #168, #3926
  static plankVitoria + #169, #82
  static plankVitoria + #170, #79
  static plankVitoria + #171, #85
  static plankVitoria + #172, #66
  static plankVitoria + #173, #79
  static plankVitoria + #174, #85
  static plankVitoria + #175, #3889
  static plankVitoria + #176, #79
  static plankVitoria + #177, #3889
  static plankVitoria + #178, #72
  static plankVitoria + #179, #65
  static plankVitoria + #180, #77
  static plankVitoria + #181, #66
  static plankVitoria + #182, #85
  static plankVitoria + #183, #82
  static plankVitoria + #184, #71
  static plankVitoria + #185, #85
  static plankVitoria + #186, #69
  static plankVitoria + #187, #82
  static plankVitoria + #188, #3889
  static plankVitoria + #189, #68
  static plankVitoria + #190, #69
  static plankVitoria + #191, #3889
  static plankVitoria + #192, #83
  static plankVitoria + #193, #73
  static plankVitoria + #194, #82
  static plankVitoria + #195, #73
  static plankVitoria + #196, #33
  static plankVitoria + #197, #3889
  static plankVitoria + #198, #3889
  static plankVitoria + #199, #3889

  ;Linha 5
  static plankVitoria + #200, #3889
  static plankVitoria + #201, #3889
  static plankVitoria + #202, #3889
  static plankVitoria + #203, #3889
  static plankVitoria + #204, #3889
  static plankVitoria + #205, #3889
  static plankVitoria + #206, #3889
  static plankVitoria + #207, #3889
  static plankVitoria + #208, #3889
  static plankVitoria + #209, #3889
  static plankVitoria + #210, #3889
  static plankVitoria + #211, #3889
  static plankVitoria + #212, #3889
  static plankVitoria + #213, #3889
  static plankVitoria + #214, #3889
  static plankVitoria + #215, #3889
  static plankVitoria + #216, #3889
  static plankVitoria + #217, #3889
  static plankVitoria + #218, #3889
  static plankVitoria + #219, #3889
  static plankVitoria + #220, #3889
  static plankVitoria + #221, #3889
  static plankVitoria + #222, #3889
  static plankVitoria + #223, #3889
  static plankVitoria + #224, #3889
  static plankVitoria + #225, #3889
  static plankVitoria + #226, #3889
  static plankVitoria + #227, #3889
  static plankVitoria + #228, #3889
  static plankVitoria + #229, #3889
  static plankVitoria + #230, #3889
  static plankVitoria + #231, #3889
  static plankVitoria + #232, #3889
  static plankVitoria + #233, #3889
  static plankVitoria + #234, #3889
  static plankVitoria + #235, #3889
  static plankVitoria + #236, #3889
  static plankVitoria + #237, #3889
  static plankVitoria + #238, #3889
  static plankVitoria + #239, #3889

  ;Linha 6
  static plankVitoria + #240, #3889
  static plankVitoria + #241, #3889
  static plankVitoria + #242, #3889
  static plankVitoria + #243, #3889
  static plankVitoria + #244, #3889
  static plankVitoria + #245, #3889
  static plankVitoria + #246, #3889
  static plankVitoria + #247, #3889
  static plankVitoria + #248, #3889
  static plankVitoria + #249, #3889
  static plankVitoria + #250, #3889
  static plankVitoria + #251, #3889
  static plankVitoria + #252, #3840
  static plankVitoria + #253, #3840
  static plankVitoria + #254, #3889
  static plankVitoria + #255, #3889
  static plankVitoria + #256, #3889
  static plankVitoria + #257, #3840
  static plankVitoria + #258, #3889
  static plankVitoria + #259, #3840
  static plankVitoria + #260, #3840
  static plankVitoria + #261, #3840
  static plankVitoria + #262, #3840
  static plankVitoria + #263, #3840
  static plankVitoria + #264, #3840
  static plankVitoria + #265, #3840
  static plankVitoria + #266, #3889
  static plankVitoria + #267, #3889
  static plankVitoria + #268, #3889
  static plankVitoria + #269, #3889
  static plankVitoria + #270, #3889
  static plankVitoria + #271, #3889
  static plankVitoria + #272, #3889
  static plankVitoria + #273, #3889
  static plankVitoria + #274, #3889
  static plankVitoria + #275, #3889
  static plankVitoria + #276, #3889
  static plankVitoria + #277, #3889
  static plankVitoria + #278, #3889
  static plankVitoria + #279, #3889

  ;Linha 7
  static plankVitoria + #280, #3840
  static plankVitoria + #281, #3840
  static plankVitoria + #282, #3840
  static plankVitoria + #283, #3840
  static plankVitoria + #284, #3840
  static plankVitoria + #285, #3840
  static plankVitoria + #286, #3840
  static plankVitoria + #287, #3840
  static plankVitoria + #288, #3840
  static plankVitoria + #289, #3840
  static plankVitoria + #290, #3840
  static plankVitoria + #291, #3840
  static plankVitoria + #292, #3840
  static plankVitoria + #293, #3840
  static plankVitoria + #294, #3840
  static plankVitoria + #295, #3840
  static plankVitoria + #296, #3840
  static plankVitoria + #297, #3840
  static plankVitoria + #298, #3840
  static plankVitoria + #299, #3840
  static plankVitoria + #300, #3889
  static plankVitoria + #301, #3889
  static plankVitoria + #302, #3889
  static plankVitoria + #303, #3889
  static plankVitoria + #304, #3889
  static plankVitoria + #305, #3840
  static plankVitoria + #306, #3840
  static plankVitoria + #307, #3840
  static plankVitoria + #308, #3840
  static plankVitoria + #309, #3840
  static plankVitoria + #310, #3840
  static plankVitoria + #311, #3840
  static plankVitoria + #312, #3840
  static plankVitoria + #313, #3840
  static plankVitoria + #314, #3840
  static plankVitoria + #315, #3840
  static plankVitoria + #316, #3840
  static plankVitoria + #317, #3840
  static plankVitoria + #318, #3840
  static plankVitoria + #319, #3840

  ;Linha 8
  static plankVitoria + #320, #3840
  static plankVitoria + #321, #3840
  static plankVitoria + #322, #3840
  static plankVitoria + #323, #3840
  static plankVitoria + #324, #3840
  static plankVitoria + #325, #3840
  static plankVitoria + #326, #3840
  static plankVitoria + #327, #3840
  static plankVitoria + #328, #3840
  static plankVitoria + #329, #3840
  static plankVitoria + #330, #3840
  static plankVitoria + #331, #3840
  static plankVitoria + #332, #3840
  static plankVitoria + #333, #3840
  static plankVitoria + #334, #3840
  static plankVitoria + #335, #2816
  static plankVitoria + #336, #2816
  static plankVitoria + #337, #2816
  static plankVitoria + #338, #2816
  static plankVitoria + #339, #2816
  static plankVitoria + #340, #2816
  static plankVitoria + #341, #2816
  static plankVitoria + #342, #2816
  static plankVitoria + #343, #2816
  static plankVitoria + #344, #2816
  static plankVitoria + #345, #3889
  static plankVitoria + #346, #3889
  static plankVitoria + #347, #3889
  static plankVitoria + #348, #3889
  static plankVitoria + #349, #3889
  static plankVitoria + #350, #3889
  static plankVitoria + #351, #3889
  static plankVitoria + #352, #3889
  static plankVitoria + #353, #3889
  static plankVitoria + #354, #3889
  static plankVitoria + #355, #3889
  static plankVitoria + #356, #3889
  static plankVitoria + #357, #3889
  static plankVitoria + #358, #3889
  static plankVitoria + #359, #3889

  ;Linha 9
  static plankVitoria + #360, #3840
  static plankVitoria + #361, #3840
  static plankVitoria + #362, #3840
  static plankVitoria + #363, #3840
  static plankVitoria + #364, #3840
  static plankVitoria + #365, #3840
  static plankVitoria + #366, #3840
  static plankVitoria + #367, #3840
  static plankVitoria + #368, #3840
  static plankVitoria + #369, #3840
  static plankVitoria + #370, #3840
  static plankVitoria + #371, #3840
  static plankVitoria + #372, #3840
  static plankVitoria + #373, #2816
  static plankVitoria + #374, #2816
  static plankVitoria + #375, #2816
  static plankVitoria + #376, #2816
  static plankVitoria + #377, #2816
  static plankVitoria + #378, #2816
  static plankVitoria + #379, #2816
  static plankVitoria + #380, #2816
  static plankVitoria + #381, #2816
  static plankVitoria + #382, #2816
  static plankVitoria + #383, #2816
  static plankVitoria + #384, #2816
  static plankVitoria + #385, #2816
  static plankVitoria + #386, #2816
  static plankVitoria + #387, #3889
  static plankVitoria + #388, #3889
  static plankVitoria + #389, #3889
  static plankVitoria + #390, #3889
  static plankVitoria + #391, #3889
  static plankVitoria + #392, #3889
  static plankVitoria + #393, #3889
  static plankVitoria + #394, #3889
  static plankVitoria + #395, #3889
  static plankVitoria + #396, #3889
  static plankVitoria + #397, #3889
  static plankVitoria + #398, #3889
  static plankVitoria + #399, #3889

  ;Linha 10
  static plankVitoria + #400, #3840
  static plankVitoria + #401, #3840
  static plankVitoria + #402, #3840
  static plankVitoria + #403, #3840
  static plankVitoria + #404, #3840
  static plankVitoria + #405, #3840
  static plankVitoria + #406, #3840
  static plankVitoria + #407, #3840
  static plankVitoria + #408, #3840
  static plankVitoria + #409, #3840
  static plankVitoria + #410, #3840
  static plankVitoria + #411, #2816
  static plankVitoria + #412, #2816
  static plankVitoria + #413, #2816
  static plankVitoria + #414, #2816
  static plankVitoria + #415, #2816
  static plankVitoria + #416, #2816
  static plankVitoria + #417, #0
  static plankVitoria + #418, #2816
  static plankVitoria + #419, #2816
  static plankVitoria + #420, #2816
  static plankVitoria + #421, #2816
  static plankVitoria + #422, #2816
  static plankVitoria + #423, #0
  static plankVitoria + #424, #2816
  static plankVitoria + #425, #2816
  static plankVitoria + #426, #2816
  static plankVitoria + #427, #2816
  static plankVitoria + #428, #2816
  static plankVitoria + #429, #3889
  static plankVitoria + #430, #3889
  static plankVitoria + #431, #3889
  static plankVitoria + #432, #3889
  static plankVitoria + #433, #3889
  static plankVitoria + #434, #3889
  static plankVitoria + #435, #3889
  static plankVitoria + #436, #3889
  static plankVitoria + #437, #3889
  static plankVitoria + #438, #3889
  static plankVitoria + #439, #3889

  ;Linha 11
  static plankVitoria + #440, #3840
  static plankVitoria + #441, #3840
  static plankVitoria + #442, #3840
  static plankVitoria + #443, #3840
  static plankVitoria + #444, #3840
  static plankVitoria + #445, #3840
  static plankVitoria + #446, #3840
  static plankVitoria + #447, #3840
  static plankVitoria + #448, #3840
  static plankVitoria + #449, #3840
  static plankVitoria + #450, #2816
  static plankVitoria + #451, #2816
  static plankVitoria + #452, #2816
  static plankVitoria + #453, #0
  static plankVitoria + #454, #2816
  static plankVitoria + #455, #2816
  static plankVitoria + #456, #2816
  static plankVitoria + #457, #2816
  static plankVitoria + #458, #2816
  static plankVitoria + #459, #2816
  static plankVitoria + #460, #2816
  static plankVitoria + #461, #2816
  static plankVitoria + #462, #2816
  static plankVitoria + #463, #2816
  static plankVitoria + #464, #2816
  static plankVitoria + #465, #2816
  static plankVitoria + #466, #2816
  static plankVitoria + #467, #2816
  static plankVitoria + #468, #2816
  static plankVitoria + #469, #2816
  static plankVitoria + #470, #3889
  static plankVitoria + #471, #3889
  static plankVitoria + #472, #3889
  static plankVitoria + #473, #3889
  static plankVitoria + #474, #3889
  static plankVitoria + #475, #3889
  static plankVitoria + #476, #3889
  static plankVitoria + #477, #3889
  static plankVitoria + #478, #3889
  static plankVitoria + #479, #3889

  ;Linha 12
  static plankVitoria + #480, #3840
  static plankVitoria + #481, #3840
  static plankVitoria + #482, #3840
  static plankVitoria + #483, #3840
  static plankVitoria + #484, #3840
  static plankVitoria + #485, #3840
  static plankVitoria + #486, #3840
  static plankVitoria + #487, #3840
  static plankVitoria + #488, #3840
  static plankVitoria + #489, #2816
  static plankVitoria + #490, #2816
  static plankVitoria + #491, #2816
  static plankVitoria + #492, #2816
  static plankVitoria + #493, #2816
  static plankVitoria + #494, #2816
  static plankVitoria + #495, #0
  static plankVitoria + #496, #2816
  static plankVitoria + #497, #2816
  static plankVitoria + #498, #2816
  static plankVitoria + #499, #2816
  static plankVitoria + #500, #0
  static plankVitoria + #501, #2816
  static plankVitoria + #502, #2816
  static plankVitoria + #503, #2816
  static plankVitoria + #504, #2816
  static plankVitoria + #505, #2816
  static plankVitoria + #506, #0
  static plankVitoria + #507, #2816
  static plankVitoria + #508, #2816
  static plankVitoria + #509, #2816
  static plankVitoria + #510, #2816
  static plankVitoria + #511, #3889
  static plankVitoria + #512, #3889
  static plankVitoria + #513, #3889
  static plankVitoria + #514, #3889
  static plankVitoria + #515, #3889
  static plankVitoria + #516, #3889
  static plankVitoria + #517, #3889
  static plankVitoria + #518, #3889
  static plankVitoria + #519, #3889

  ;Linha 13
  static plankVitoria + #520, #3840
  static plankVitoria + #521, #3840
  static plankVitoria + #522, #3840
  static plankVitoria + #523, #3840
  static plankVitoria + #524, #3840
  static plankVitoria + #525, #3840
  static plankVitoria + #526, #3840
  static plankVitoria + #527, #3840
  static plankVitoria + #528, #2816
  static plankVitoria + #529, #2816
  static plankVitoria + #530, #2816
  static plankVitoria + #531, #2816
  static plankVitoria + #532, #2816
  static plankVitoria + #533, #2816
  static plankVitoria + #534, #2816
  static plankVitoria + #535, #2816
  static plankVitoria + #536, #2816
  static plankVitoria + #537, #2816
  static plankVitoria + #538, #2816
  static plankVitoria + #539, #2816
  static plankVitoria + #540, #2816
  static plankVitoria + #541, #2816
  static plankVitoria + #542, #2816
  static plankVitoria + #543, #2816
  static plankVitoria + #544, #2816
  static plankVitoria + #545, #2816
  static plankVitoria + #546, #2816
  static plankVitoria + #547, #2816
  static plankVitoria + #548, #2816
  static plankVitoria + #549, #2816
  static plankVitoria + #550, #2816
  static plankVitoria + #551, #2816
  static plankVitoria + #552, #3889
  static plankVitoria + #553, #3889
  static plankVitoria + #554, #3889
  static plankVitoria + #555, #3889
  static plankVitoria + #556, #3889
  static plankVitoria + #557, #3889
  static plankVitoria + #558, #3889
  static plankVitoria + #559, #3889

  ;Linha 14
  static plankVitoria + #560, #3840
  static plankVitoria + #561, #3840
  static plankVitoria + #562, #3840
  static plankVitoria + #563, #3840
  static plankVitoria + #564, #3840
  static plankVitoria + #565, #3840
  static plankVitoria + #566, #3840
  static plankVitoria + #567, #512
  static plankVitoria + #568, #512
  static plankVitoria + #569, #512
  static plankVitoria + #570, #512
  static plankVitoria + #571, #512
  static plankVitoria + #572, #512
  static plankVitoria + #573, #512
  static plankVitoria + #574, #512
  static plankVitoria + #575, #512
  static plankVitoria + #576, #512
  static plankVitoria + #577, #512
  static plankVitoria + #578, #512
  static plankVitoria + #579, #512
  static plankVitoria + #580, #512
  static plankVitoria + #581, #512
  static plankVitoria + #582, #512
  static plankVitoria + #583, #512
  static plankVitoria + #584, #512
  static plankVitoria + #585, #512
  static plankVitoria + #586, #512
  static plankVitoria + #587, #512
  static plankVitoria + #588, #512
  static plankVitoria + #589, #512
  static plankVitoria + #590, #512
  static plankVitoria + #591, #512
  static plankVitoria + #592, #512
  static plankVitoria + #593, #3889
  static plankVitoria + #594, #3889
  static plankVitoria + #595, #3889
  static plankVitoria + #596, #3889
  static plankVitoria + #597, #3889
  static plankVitoria + #598, #3889
  static plankVitoria + #599, #3889

  ;Linha 15
  static plankVitoria + #600, #3840
  static plankVitoria + #601, #3840
  static plankVitoria + #602, #3840
  static plankVitoria + #603, #3840
  static plankVitoria + #604, #3840
  static plankVitoria + #605, #3840
  static plankVitoria + #606, #3840
  static plankVitoria + #607, #3840
  static plankVitoria + #608, #512
  static plankVitoria + #609, #512
  static plankVitoria + #610, #512
  static plankVitoria + #611, #2304
  static plankVitoria + #612, #2304
  static plankVitoria + #613, #2304
  static plankVitoria + #614, #512
  static plankVitoria + #615, #512
  static plankVitoria + #616, #512
  static plankVitoria + #617, #512
  static plankVitoria + #618, #2304
  static plankVitoria + #619, #2304
  static plankVitoria + #620, #2304
  static plankVitoria + #621, #2304
  static plankVitoria + #622, #2304
  static plankVitoria + #623, #512
  static plankVitoria + #624, #512
  static plankVitoria + #625, #512
  static plankVitoria + #626, #512
  static plankVitoria + #627, #2304
  static plankVitoria + #628, #2304
  static plankVitoria + #629, #2304
  static plankVitoria + #630, #512
  static plankVitoria + #631, #512
  static plankVitoria + #632, #3889
  static plankVitoria + #633, #3889
  static plankVitoria + #634, #3889
  static plankVitoria + #635, #3889
  static plankVitoria + #636, #3889
  static plankVitoria + #637, #3889
  static plankVitoria + #638, #3889
  static plankVitoria + #639, #3889

  ;Linha 16
  static plankVitoria + #640, #3840
  static plankVitoria + #641, #3840
  static plankVitoria + #642, #3840
  static plankVitoria + #643, #3840
  static plankVitoria + #644, #3840
  static plankVitoria + #645, #3840
  static plankVitoria + #646, #3840
  static plankVitoria + #647, #3840
  static plankVitoria + #648, #2304
  static plankVitoria + #649, #2304
  static plankVitoria + #650, #2304
  static plankVitoria + #651, #2304
  static plankVitoria + #652, #2304
  static plankVitoria + #653, #2304
  static plankVitoria + #654, #2304
  static plankVitoria + #655, #2304
  static plankVitoria + #656, #2304
  static plankVitoria + #657, #2304
  static plankVitoria + #658, #2304
  static plankVitoria + #659, #2304
  static plankVitoria + #660, #2304
  static plankVitoria + #661, #2304
  static plankVitoria + #662, #2304
  static plankVitoria + #663, #2304
  static plankVitoria + #664, #2304
  static plankVitoria + #665, #2304
  static plankVitoria + #666, #2304
  static plankVitoria + #667, #2304
  static plankVitoria + #668, #2304
  static plankVitoria + #669, #2304
  static plankVitoria + #670, #2304
  static plankVitoria + #671, #2304
  static plankVitoria + #672, #3889
  static plankVitoria + #673, #3889
  static plankVitoria + #674, #3889
  static plankVitoria + #675, #3889
  static plankVitoria + #676, #3889
  static plankVitoria + #677, #3889
  static plankVitoria + #678, #3889
  static plankVitoria + #679, #3889

  ;Linha 17
  static plankVitoria + #680, #3840
  static plankVitoria + #681, #3840
  static plankVitoria + #682, #3840
  static plankVitoria + #683, #3840
  static plankVitoria + #684, #3840
  static plankVitoria + #685, #3840
  static plankVitoria + #686, #3840
  static plankVitoria + #687, #3840
  static plankVitoria + #688, #2816
  static plankVitoria + #689, #2816
  static plankVitoria + #690, #2816
  static plankVitoria + #691, #2816
  static plankVitoria + #692, #2816
  static plankVitoria + #693, #2816
  static plankVitoria + #694, #2816
  static plankVitoria + #695, #2816
  static plankVitoria + #696, #2816
  static plankVitoria + #697, #2816
  static plankVitoria + #698, #2816
  static plankVitoria + #699, #2816
  static plankVitoria + #700, #2816
  static plankVitoria + #701, #2816
  static plankVitoria + #702, #2816
  static plankVitoria + #703, #2816
  static plankVitoria + #704, #2816
  static plankVitoria + #705, #2816
  static plankVitoria + #706, #2816
  static plankVitoria + #707, #2816
  static plankVitoria + #708, #2816
  static plankVitoria + #709, #2816
  static plankVitoria + #710, #2816
  static plankVitoria + #711, #2816
  static plankVitoria + #712, #3889
  static plankVitoria + #713, #3889
  static plankVitoria + #714, #3889
  static plankVitoria + #715, #3889
  static plankVitoria + #716, #3889
  static plankVitoria + #717, #3889
  static plankVitoria + #718, #3889
  static plankVitoria + #719, #3889

  ;Linha 18
  static plankVitoria + #720, #3840
  static plankVitoria + #721, #3840
  static plankVitoria + #722, #3840
  static plankVitoria + #723, #3840
  static plankVitoria + #724, #3840
  static plankVitoria + #725, #3840
  static plankVitoria + #726, #3840
  static plankVitoria + #727, #3840
  static plankVitoria + #728, #256
  static plankVitoria + #729, #2816
  static plankVitoria + #730, #256
  static plankVitoria + #731, #256
  static plankVitoria + #732, #2816
  static plankVitoria + #733, #2816
  static plankVitoria + #734, #2816
  static plankVitoria + #735, #2816
  static plankVitoria + #736, #256
  static plankVitoria + #737, #256
  static plankVitoria + #738, #2816
  static plankVitoria + #739, #2816
  static plankVitoria + #740, #2816
  static plankVitoria + #741, #2816
  static plankVitoria + #742, #2816
  static plankVitoria + #743, #256
  static plankVitoria + #744, #256
  static plankVitoria + #745, #256
  static plankVitoria + #746, #2816
  static plankVitoria + #747, #2816
  static plankVitoria + #748, #2816
  static plankVitoria + #749, #2816
  static plankVitoria + #750, #2816
  static plankVitoria + #751, #256
  static plankVitoria + #752, #3889
  static plankVitoria + #753, #3889
  static plankVitoria + #754, #3889
  static plankVitoria + #755, #3889
  static plankVitoria + #756, #3889
  static plankVitoria + #757, #3889
  static plankVitoria + #758, #3889
  static plankVitoria + #759, #3889

  ;Linha 19
  static plankVitoria + #760, #3840
  static plankVitoria + #761, #3840
  static plankVitoria + #762, #3840
  static plankVitoria + #763, #3840
  static plankVitoria + #764, #3840
  static plankVitoria + #765, #3840
  static plankVitoria + #766, #3840
  static plankVitoria + #767, #256
  static plankVitoria + #768, #256
  static plankVitoria + #769, #256
  static plankVitoria + #770, #256
  static plankVitoria + #771, #256
  static plankVitoria + #772, #256
  static plankVitoria + #773, #2816
  static plankVitoria + #774, #2816
  static plankVitoria + #775, #256
  static plankVitoria + #776, #256
  static plankVitoria + #777, #256
  static plankVitoria + #778, #256
  static plankVitoria + #779, #256
  static plankVitoria + #780, #2816
  static plankVitoria + #781, #2816
  static plankVitoria + #782, #256
  static plankVitoria + #783, #256
  static plankVitoria + #784, #256
  static plankVitoria + #785, #256
  static plankVitoria + #786, #256
  static plankVitoria + #787, #256
  static plankVitoria + #788, #2816
  static plankVitoria + #789, #2816
  static plankVitoria + #790, #256
  static plankVitoria + #791, #256
  static plankVitoria + #792, #256
  static plankVitoria + #793, #3889
  static plankVitoria + #794, #3889
  static plankVitoria + #795, #3889
  static plankVitoria + #796, #3889
  static plankVitoria + #797, #3889
  static plankVitoria + #798, #3889
  static plankVitoria + #799, #3889

  ;Linha 20
  static plankVitoria + #800, #3840
  static plankVitoria + #801, #3840
  static plankVitoria + #802, #3840
  static plankVitoria + #803, #3840
  static plankVitoria + #804, #3840
  static plankVitoria + #805, #3840
  static plankVitoria + #806, #3840
  static plankVitoria + #807, #256
  static plankVitoria + #808, #256
  static plankVitoria + #809, #256
  static plankVitoria + #810, #256
  static plankVitoria + #811, #256
  static plankVitoria + #812, #256
  static plankVitoria + #813, #256
  static plankVitoria + #814, #256
  static plankVitoria + #815, #256
  static plankVitoria + #816, #256
  static plankVitoria + #817, #256
  static plankVitoria + #818, #256
  static plankVitoria + #819, #256
  static plankVitoria + #820, #256
  static plankVitoria + #821, #256
  static plankVitoria + #822, #256
  static plankVitoria + #823, #256
  static plankVitoria + #824, #256
  static plankVitoria + #825, #256
  static plankVitoria + #826, #256
  static plankVitoria + #827, #256
  static plankVitoria + #828, #256
  static plankVitoria + #829, #256
  static plankVitoria + #830, #256
  static plankVitoria + #831, #256
  static plankVitoria + #832, #256
  static plankVitoria + #833, #3889
  static plankVitoria + #834, #3889
  static plankVitoria + #835, #3889
  static plankVitoria + #836, #3889
  static plankVitoria + #837, #3889
  static plankVitoria + #838, #3889
  static plankVitoria + #839, #3889

  ;Linha 21
  static plankVitoria + #840, #3840
  static plankVitoria + #841, #3840
  static plankVitoria + #842, #3840
  static plankVitoria + #843, #3840
  static plankVitoria + #844, #3840
  static plankVitoria + #845, #3840
  static plankVitoria + #846, #3840
  static plankVitoria + #847, #3840
  static plankVitoria + #848, #256
  static plankVitoria + #849, #256
  static plankVitoria + #850, #256
  static plankVitoria + #851, #256
  static plankVitoria + #852, #256
  static plankVitoria + #853, #256
  static plankVitoria + #854, #256
  static plankVitoria + #855, #256
  static plankVitoria + #856, #256
  static plankVitoria + #857, #256
  static plankVitoria + #858, #256
  static plankVitoria + #859, #256
  static plankVitoria + #860, #256
  static plankVitoria + #861, #256
  static plankVitoria + #862, #256
  static plankVitoria + #863, #256
  static plankVitoria + #864, #256
  static plankVitoria + #865, #256
  static plankVitoria + #866, #256
  static plankVitoria + #867, #256
  static plankVitoria + #868, #256
  static plankVitoria + #869, #256
  static plankVitoria + #870, #256
  static plankVitoria + #871, #256
  static plankVitoria + #872, #3889
  static plankVitoria + #873, #3889
  static plankVitoria + #874, #3889
  static plankVitoria + #875, #3889
  static plankVitoria + #876, #3889
  static plankVitoria + #877, #3889
  static plankVitoria + #878, #3889
  static plankVitoria + #879, #3889

  ;Linha 22
  static plankVitoria + #880, #3840
  static plankVitoria + #881, #3840
  static plankVitoria + #882, #3840
  static plankVitoria + #883, #3840
  static plankVitoria + #884, #3840
  static plankVitoria + #885, #3840
  static plankVitoria + #886, #3840
  static plankVitoria + #887, #3840
  static plankVitoria + #888, #2816
  static plankVitoria + #889, #2816
  static plankVitoria + #890, #2816
  static plankVitoria + #891, #2816
  static plankVitoria + #892, #2816
  static plankVitoria + #893, #2816
  static plankVitoria + #894, #2816
  static plankVitoria + #895, #2816
  static plankVitoria + #896, #2816
  static plankVitoria + #897, #2816
  static plankVitoria + #898, #2816
  static plankVitoria + #899, #2816
  static plankVitoria + #900, #2816
  static plankVitoria + #901, #2816
  static plankVitoria + #902, #2816
  static plankVitoria + #903, #2816
  static plankVitoria + #904, #2816
  static plankVitoria + #905, #2816
  static plankVitoria + #906, #2816
  static plankVitoria + #907, #2816
  static plankVitoria + #908, #2816
  static plankVitoria + #909, #2816
  static plankVitoria + #910, #2816
  static plankVitoria + #911, #2816
  static plankVitoria + #912, #3889
  static plankVitoria + #913, #3889
  static plankVitoria + #914, #3889
  static plankVitoria + #915, #3889
  static plankVitoria + #916, #3889
  static plankVitoria + #917, #3889
  static plankVitoria + #918, #3889
  static plankVitoria + #919, #3889

  ;Linha 23
  static plankVitoria + #920, #3840
  static plankVitoria + #921, #3840
  static plankVitoria + #922, #3840
  static plankVitoria + #923, #3840
  static plankVitoria + #924, #3840
  static plankVitoria + #925, #3840
  static plankVitoria + #926, #3840
  static plankVitoria + #927, #3840
  static plankVitoria + #928, #2816
  static plankVitoria + #929, #2816
  static plankVitoria + #930, #2816
  static plankVitoria + #931, #2816
  static plankVitoria + #932, #2816
  static plankVitoria + #933, #2816
  static plankVitoria + #934, #2816
  static plankVitoria + #935, #2816
  static plankVitoria + #936, #2816
  static plankVitoria + #937, #2816
  static plankVitoria + #938, #2816
  static plankVitoria + #939, #2816
  static plankVitoria + #940, #2816
  static plankVitoria + #941, #2816
  static plankVitoria + #942, #2816
  static plankVitoria + #943, #2816
  static plankVitoria + #944, #2816
  static plankVitoria + #945, #2816
  static plankVitoria + #946, #2816
  static plankVitoria + #947, #2816
  static plankVitoria + #948, #2816
  static plankVitoria + #949, #2816
  static plankVitoria + #950, #2816
  static plankVitoria + #951, #2816
  static plankVitoria + #952, #3889
  static plankVitoria + #953, #3889
  static plankVitoria + #954, #3889
  static plankVitoria + #955, #3889
  static plankVitoria + #956, #3889
  static plankVitoria + #957, #3889
  static plankVitoria + #958, #3889
  static plankVitoria + #959, #3889

  ;Linha 24
  static plankVitoria + #960, #3840
  static plankVitoria + #961, #3840
  static plankVitoria + #962, #3840
  static plankVitoria + #963, #3840
  static plankVitoria + #964, #3840
  static plankVitoria + #965, #3840
  static plankVitoria + #966, #3840
  static plankVitoria + #967, #3840
  static plankVitoria + #968, #3840
  static plankVitoria + #969, #3840
  static plankVitoria + #970, #3840
  static plankVitoria + #971, #3840
  static plankVitoria + #972, #3840
  static plankVitoria + #973, #3840
  static plankVitoria + #974, #3840
  static plankVitoria + #975, #3840
  static plankVitoria + #976, #3840
  static plankVitoria + #977, #3840
  static plankVitoria + #978, #3840
  static plankVitoria + #979, #3840
  static plankVitoria + #980, #3840
  static plankVitoria + #981, #3840
  static plankVitoria + #982, #3840
  static plankVitoria + #983, #3840
  static plankVitoria + #984, #3840
  static plankVitoria + #985, #3840
  static plankVitoria + #986, #3840
  static plankVitoria + #987, #3840
  static plankVitoria + #988, #3840
  static plankVitoria + #989, #3840
  static plankVitoria + #990, #3840
  static plankVitoria + #991, #3840
  static plankVitoria + #992, #3840
  static plankVitoria + #993, #3840
  static plankVitoria + #994, #3840
  static plankVitoria + #995, #3840
  static plankVitoria + #996, #3840
  static plankVitoria + #997, #3840
  static plankVitoria + #998, #3840
  static plankVitoria + #999, #3840

  ;Linha 25
  static plankVitoria + #1000, #3840
  static plankVitoria + #1001, #3840
  static plankVitoria + #1002, #3840
  static plankVitoria + #1003, #3840
  static plankVitoria + #1004, #3840
  static plankVitoria + #1005, #3840
  static plankVitoria + #1006, #3840
  static plankVitoria + #1007, #3840
  static plankVitoria + #1008, #3840
  static plankVitoria + #1009, #3840
  static plankVitoria + #1010, #3840
  static plankVitoria + #1011, #3840
  static plankVitoria + #1012, #3840
  static plankVitoria + #1013, #3840
  static plankVitoria + #1014, #3840
  static plankVitoria + #1015, #3840
  static plankVitoria + #1016, #3840
  static plankVitoria + #1017, #3840
  static plankVitoria + #1018, #3840
  static plankVitoria + #1019, #3840
  static plankVitoria + #1020, #3840
  static plankVitoria + #1021, #3840
  static plankVitoria + #1022, #3840
  static plankVitoria + #1023, #3840
  static plankVitoria + #1024, #3840
  static plankVitoria + #1025, #3840
  static plankVitoria + #1026, #3840
  static plankVitoria + #1027, #3840
  static plankVitoria + #1028, #3840
  static plankVitoria + #1029, #3840
  static plankVitoria + #1030, #3840
  static plankVitoria + #1031, #3840
  static plankVitoria + #1032, #3840
  static plankVitoria + #1033, #3840
  static plankVitoria + #1034, #3840
  static plankVitoria + #1035, #3840
  static plankVitoria + #1036, #3840
  static plankVitoria + #1037, #3840
  static plankVitoria + #1038, #3840
  static plankVitoria + #1039, #3840

  ;Linha 26
  static plankVitoria + #1040, #3889
  static plankVitoria + #1041, #3889
  static plankVitoria + #1042, #3889
  static plankVitoria + #1043, #3889
  static plankVitoria + #1044, #3889
  static plankVitoria + #1045, #42
  static plankVitoria + #1046, #65
  static plankVitoria + #1047, #80
  static plankVitoria + #1048, #69
  static plankVitoria + #1049, #82
  static plankVitoria + #1050, #84
  static plankVitoria + #1051, #69
  static plankVitoria + #1052, #3889
  static plankVitoria + #1053, #3376
  static plankVitoria + #1054, #3889
  static plankVitoria + #1055, #80
  static plankVitoria + #1056, #65
  static plankVitoria + #1057, #82
  static plankVitoria + #1058, #65
  static plankVitoria + #1059, #3889
  static plankVitoria + #1060, #74
  static plankVitoria + #1061, #79
  static plankVitoria + #1062, #71
  static plankVitoria + #1063, #65
  static plankVitoria + #1064, #82
  static plankVitoria + #1065, #3889
  static plankVitoria + #1066, #78
  static plankVitoria + #1067, #79
  static plankVitoria + #1068, #86
  static plankVitoria + #1069, #65
  static plankVitoria + #1070, #77
  static plankVitoria + #1071, #69
  static plankVitoria + #1072, #78
  static plankVitoria + #1073, #84
  static plankVitoria + #1074, #69
  static plankVitoria + #1075, #3889
  static plankVitoria + #1076, #3889
  static plankVitoria + #1077, #3889
  static plankVitoria + #1078, #3889
  static plankVitoria + #1079, #3889

  ;Linha 27
  static plankVitoria + #1080, #3889
  static plankVitoria + #1081, #3889
  static plankVitoria + #1082, #3889
  static plankVitoria + #1083, #3889
  static plankVitoria + #1084, #3889
  static plankVitoria + #1085, #3889
  static plankVitoria + #1086, #3889
  static plankVitoria + #1087, #3889
  static plankVitoria + #1088, #3889
  static plankVitoria + #1089, #3889
  static plankVitoria + #1090, #3889
  static plankVitoria + #1091, #3889
  static plankVitoria + #1092, #3889
  static plankVitoria + #1093, #3889
  static plankVitoria + #1094, #3889
  static plankVitoria + #1095, #3889
  static plankVitoria + #1096, #3889
  static plankVitoria + #1097, #3889
  static plankVitoria + #1098, #3889
  static plankVitoria + #1099, #3889
  static plankVitoria + #1100, #3889
  static plankVitoria + #1101, #3889
  static plankVitoria + #1102, #3889
  static plankVitoria + #1103, #3889
  static plankVitoria + #1104, #3889
  static plankVitoria + #1105, #3889
  static plankVitoria + #1106, #3889
  static plankVitoria + #1107, #3889
  static plankVitoria + #1108, #3889
  static plankVitoria + #1109, #3889
  static plankVitoria + #1110, #3889
  static plankVitoria + #1111, #3889
  static plankVitoria + #1112, #3889
  static plankVitoria + #1113, #3889
  static plankVitoria + #1114, #3889
  static plankVitoria + #1115, #3889
  static plankVitoria + #1116, #3889
  static plankVitoria + #1117, #3889
  static plankVitoria + #1118, #3889
  static plankVitoria + #1119, #3889

  ;Linha 28
  static plankVitoria + #1120, #3889
  static plankVitoria + #1121, #3889
  static plankVitoria + #1122, #3889
  static plankVitoria + #1123, #3889
  static plankVitoria + #1124, #3889
  static plankVitoria + #1125, #42
  static plankVitoria + #1126, #65
  static plankVitoria + #1127, #80
  static plankVitoria + #1128, #69
  static plankVitoria + #1129, #82
  static plankVitoria + #1130, #84
  static plankVitoria + #1131, #69
  static plankVitoria + #1132, #3889
  static plankVitoria + #1133, #3377
  static plankVitoria + #1134, #3889
  static plankVitoria + #1135, #80
  static plankVitoria + #1136, #65
  static plankVitoria + #1137, #82
  static plankVitoria + #1138, #65
  static plankVitoria + #1139, #3889
  static plankVitoria + #1140, #83
  static plankVitoria + #1141, #65
  static plankVitoria + #1142, #73
  static plankVitoria + #1143, #82
  static plankVitoria + #1144, #3889
  static plankVitoria + #1145, #3889
  static plankVitoria + #1146, #3889
  static plankVitoria + #1147, #3889
  static plankVitoria + #1148, #3889
  static plankVitoria + #1149, #3889
  static plankVitoria + #1150, #3889
  static plankVitoria + #1151, #3889
  static plankVitoria + #1152, #3889
  static plankVitoria + #1153, #3889
  static plankVitoria + #1154, #3889
  static plankVitoria + #1155, #3889
  static plankVitoria + #1156, #3889
  static plankVitoria + #1157, #3889
  static plankVitoria + #1158, #3889
  static plankVitoria + #1159, #3889

  ;Linha 29
  static plankVitoria + #1160, #3889
  static plankVitoria + #1161, #3889
  static plankVitoria + #1162, #3889
  static plankVitoria + #1163, #3889
  static plankVitoria + #1164, #3889
  static plankVitoria + #1165, #3889
  static plankVitoria + #1166, #3889
  static plankVitoria + #1167, #3889
  static plankVitoria + #1168, #3889
  static plankVitoria + #1169, #3889
  static plankVitoria + #1170, #3889
  static plankVitoria + #1171, #3889
  static plankVitoria + #1172, #3889
  static plankVitoria + #1173, #3889
  static plankVitoria + #1174, #3889
  static plankVitoria + #1175, #3889
  static plankVitoria + #1176, #3889
  static plankVitoria + #1177, #3889
  static plankVitoria + #1178, #3889
  static plankVitoria + #1179, #3889
  static plankVitoria + #1180, #3889
  static plankVitoria + #1181, #3889
  static plankVitoria + #1182, #3889
  static plankVitoria + #1183, #3889
  static plankVitoria + #1184, #3889
  static plankVitoria + #1185, #3889
  static plankVitoria + #1186, #3889
  static plankVitoria + #1187, #3889
  static plankVitoria + #1188, #3889
  static plankVitoria + #1189, #3889
  static plankVitoria + #1190, #3889
  static plankVitoria + #1191, #3889
  static plankVitoria + #1192, #3889
  static plankVitoria + #1193, #3889
  static plankVitoria + #1194, #3889
  static plankVitoria + #1195, #3889
  static plankVitoria + #1196, #3889
  static plankVitoria + #1197, #3889
  static plankVitoria + #1198, #3889
  static plankVitoria + #1199, #3889

printplankVitoriaScreen:
  push R0
  push R1
  push R2
  push R3

  loadn R0, #plankVitoria
  loadn R1, #0
  loadn R2, #1200

  printplankVitoriaScreenLoop:

    add R3,R0,R1
    loadi R3, R3
    outchar R3, R1
    inc R1
    cmp R1, R2

    jne printplankVitoriaScreenLoop

  pop R3
  pop R2
  pop R1
  pop R0
  jmp Fim


bobVitoria : var #1200
  ;Linha 0
  static bobVitoria + #0, #3889
  static bobVitoria + #1, #3889
  static bobVitoria + #2, #3889
  static bobVitoria + #3, #3889
  static bobVitoria + #4, #3889
  static bobVitoria + #5, #3889
  static bobVitoria + #6, #3889
  static bobVitoria + #7, #3889
  static bobVitoria + #8, #3889
  static bobVitoria + #9, #3889
  static bobVitoria + #10, #3889
  static bobVitoria + #11, #3889
  static bobVitoria + #12, #3889
  static bobVitoria + #13, #3889
  static bobVitoria + #14, #3889
  static bobVitoria + #15, #3889
  static bobVitoria + #16, #3889
  static bobVitoria + #17, #3889
  static bobVitoria + #18, #3889
  static bobVitoria + #19, #3889
  static bobVitoria + #20, #3889
  static bobVitoria + #21, #3889
  static bobVitoria + #22, #3889
  static bobVitoria + #23, #3889
  static bobVitoria + #24, #3889
  static bobVitoria + #25, #3889
  static bobVitoria + #26, #3889
  static bobVitoria + #27, #3889
  static bobVitoria + #28, #3889
  static bobVitoria + #29, #3889
  static bobVitoria + #30, #3889
  static bobVitoria + #31, #3889
  static bobVitoria + #32, #3889
  static bobVitoria + #33, #3889
  static bobVitoria + #34, #3889
  static bobVitoria + #35, #3889
  static bobVitoria + #36, #3889
  static bobVitoria + #37, #3889
  static bobVitoria + #38, #3889
  static bobVitoria + #39, #3889

  ;Linha 1
  static bobVitoria + #40, #3889
  static bobVitoria + #41, #3889
  static bobVitoria + #42, #3889
  static bobVitoria + #43, #3889
  static bobVitoria + #44, #3889
  static bobVitoria + #45, #3889
  static bobVitoria + #46, #3889
  static bobVitoria + #47, #3889
  static bobVitoria + #48, #3889
  static bobVitoria + #49, #3889
  static bobVitoria + #50, #3889
  static bobVitoria + #51, #3889
  static bobVitoria + #52, #3889
  static bobVitoria + #53, #3889
  static bobVitoria + #54, #3889
  static bobVitoria + #55, #3889
  static bobVitoria + #56, #3889
  static bobVitoria + #57, #3889
  static bobVitoria + #58, #3889
  static bobVitoria + #59, #3889
  static bobVitoria + #60, #3889
  static bobVitoria + #61, #3889
  static bobVitoria + #62, #3889
  static bobVitoria + #63, #3889
  static bobVitoria + #64, #3889
  static bobVitoria + #65, #3889
  static bobVitoria + #66, #3889
  static bobVitoria + #67, #3889
  static bobVitoria + #68, #3889
  static bobVitoria + #69, #3889
  static bobVitoria + #70, #3889
  static bobVitoria + #71, #3889
  static bobVitoria + #72, #3889
  static bobVitoria + #73, #3889
  static bobVitoria + #74, #3889
  static bobVitoria + #75, #3889
  static bobVitoria + #76, #3889
  static bobVitoria + #77, #3889
  static bobVitoria + #78, #3889
  static bobVitoria + #79, #3889

  ;Linha 2
  static bobVitoria + #80, #3889
  static bobVitoria + #81, #3889
  static bobVitoria + #82, #17
  static bobVitoria + #83, #17
  static bobVitoria + #84, #3889
  static bobVitoria + #85, #3889
  static bobVitoria + #86, #3889
  static bobVitoria + #87, #3889
  static bobVitoria + #88, #3889
  static bobVitoria + #89, #80
  static bobVitoria + #90, #65
  static bobVitoria + #91, #82
  static bobVitoria + #92, #65
  static bobVitoria + #93, #66
  static bobVitoria + #94, #69
  static bobVitoria + #95, #78
  static bobVitoria + #96, #83
  static bobVitoria + #97, #44
  static bobVitoria + #98, #3889
  static bobVitoria + #99, #2882
  static bobVitoria + #100, #2895
  static bobVitoria + #101, #2882
  static bobVitoria + #102, #3889
  static bobVitoria + #103, #2885
  static bobVitoria + #104, #2899
  static bobVitoria + #105, #2896
  static bobVitoria + #106, #2895
  static bobVitoria + #107, #2894
  static bobVitoria + #108, #2890
  static bobVitoria + #109, #2881
  static bobVitoria + #110, #33
  static bobVitoria + #111, #3889
  static bobVitoria + #112, #3889
  static bobVitoria + #113, #3889
  static bobVitoria + #114, #3889
  static bobVitoria + #115, #3889
  static bobVitoria + #116, #3889
  static bobVitoria + #117, #3889
  static bobVitoria + #118, #3889
  static bobVitoria + #119, #3889

  ;Linha 3
  static bobVitoria + #120, #3889
  static bobVitoria + #121, #3889
  static bobVitoria + #122, #3889
  static bobVitoria + #123, #3889
  static bobVitoria + #124, #3889
  static bobVitoria + #125, #3889
  static bobVitoria + #126, #3889
  static bobVitoria + #127, #3889
  static bobVitoria + #128, #3889
  static bobVitoria + #129, #3889
  static bobVitoria + #130, #3889
  static bobVitoria + #131, #3889
  static bobVitoria + #132, #3889
  static bobVitoria + #133, #3889
  static bobVitoria + #134, #3889
  static bobVitoria + #135, #3889
  static bobVitoria + #136, #3889
  static bobVitoria + #137, #3889
  static bobVitoria + #138, #3889
  static bobVitoria + #139, #3889
  static bobVitoria + #140, #3889
  static bobVitoria + #141, #3889
  static bobVitoria + #142, #44
  static bobVitoria + #143, #3889
  static bobVitoria + #144, #3889
  static bobVitoria + #145, #3889
  static bobVitoria + #146, #3889
  static bobVitoria + #147, #3889
  static bobVitoria + #148, #3889
  static bobVitoria + #149, #3889
  static bobVitoria + #150, #3889
  static bobVitoria + #151, #3889
  static bobVitoria + #152, #3889
  static bobVitoria + #153, #3889
  static bobVitoria + #154, #3889
  static bobVitoria + #155, #3889
  static bobVitoria + #156, #3889
  static bobVitoria + #157, #3889
  static bobVitoria + #158, #3889
  static bobVitoria + #159, #3889

  ;Linha 4
  static bobVitoria + #160, #3889
  static bobVitoria + #161, #3889
  static bobVitoria + #162, #86
  static bobVitoria + #163, #79
  static bobVitoria + #164, #67
  static bobVitoria + #165, #69
  static bobVitoria + #166, #3889
  static bobVitoria + #167, #68
  static bobVitoria + #168, #69
  static bobVitoria + #169, #70
  static bobVitoria + #170, #69
  static bobVitoria + #171, #78
  static bobVitoria + #172, #68
  static bobVitoria + #173, #69
  static bobVitoria + #174, #85
  static bobVitoria + #175, #3889
  static bobVitoria + #176, #79
  static bobVitoria + #177, #3889
  static bobVitoria + #178, #72
  static bobVitoria + #179, #65
  static bobVitoria + #180, #77
  static bobVitoria + #181, #66
  static bobVitoria + #182, #85
  static bobVitoria + #183, #82
  static bobVitoria + #184, #71
  static bobVitoria + #185, #85
  static bobVitoria + #186, #69
  static bobVitoria + #187, #82
  static bobVitoria + #188, #3889
  static bobVitoria + #189, #68
  static bobVitoria + #190, #69
  static bobVitoria + #191, #3889
  static bobVitoria + #192, #83
  static bobVitoria + #193, #73
  static bobVitoria + #194, #82
  static bobVitoria + #195, #73
  static bobVitoria + #196, #33
  static bobVitoria + #197, #3889
  static bobVitoria + #198, #3889
  static bobVitoria + #199, #3889

  ;Linha 5
  static bobVitoria + #200, #3889
  static bobVitoria + #201, #3889
  static bobVitoria + #202, #3889
  static bobVitoria + #203, #3889
  static bobVitoria + #204, #3889
  static bobVitoria + #205, #3889
  static bobVitoria + #206, #3889
  static bobVitoria + #207, #3889
  static bobVitoria + #208, #3889
  static bobVitoria + #209, #3889
  static bobVitoria + #210, #3889
  static bobVitoria + #211, #3889
  static bobVitoria + #212, #3889
  static bobVitoria + #213, #3889
  static bobVitoria + #214, #3889
  static bobVitoria + #215, #3889
  static bobVitoria + #216, #3889
  static bobVitoria + #217, #3889
  static bobVitoria + #218, #3889
  static bobVitoria + #219, #3889
  static bobVitoria + #220, #3889
  static bobVitoria + #221, #3889
  static bobVitoria + #222, #3889
  static bobVitoria + #223, #3889
  static bobVitoria + #224, #3889
  static bobVitoria + #225, #3889
  static bobVitoria + #226, #3889
  static bobVitoria + #227, #3889
  static bobVitoria + #228, #3889
  static bobVitoria + #229, #3889
  static bobVitoria + #230, #3889
  static bobVitoria + #231, #3889
  static bobVitoria + #232, #3889
  static bobVitoria + #233, #3889
  static bobVitoria + #234, #3889
  static bobVitoria + #235, #3889
  static bobVitoria + #236, #3889
  static bobVitoria + #237, #3889
  static bobVitoria + #238, #3889
  static bobVitoria + #239, #3889

  ;Linha 6
  static bobVitoria + #240, #3889
  static bobVitoria + #241, #3889
  static bobVitoria + #242, #3889
  static bobVitoria + #243, #3889
  static bobVitoria + #244, #3889
  static bobVitoria + #245, #3889
  static bobVitoria + #246, #3889
  static bobVitoria + #247, #3889
  static bobVitoria + #248, #3889
  static bobVitoria + #249, #3889
  static bobVitoria + #250, #3889
  static bobVitoria + #251, #3889
  static bobVitoria + #252, #3840
  static bobVitoria + #253, #3840
  static bobVitoria + #254, #3889
  static bobVitoria + #255, #3889
  static bobVitoria + #256, #3889
  static bobVitoria + #257, #3840
  static bobVitoria + #258, #3889
  static bobVitoria + #259, #3840
  static bobVitoria + #260, #3840
  static bobVitoria + #261, #3840
  static bobVitoria + #262, #3840
  static bobVitoria + #263, #3840
  static bobVitoria + #264, #3840
  static bobVitoria + #265, #3840
  static bobVitoria + #266, #3889
  static bobVitoria + #267, #3889
  static bobVitoria + #268, #3889
  static bobVitoria + #269, #3889
  static bobVitoria + #270, #3889
  static bobVitoria + #271, #3889
  static bobVitoria + #272, #3889
  static bobVitoria + #273, #3889
  static bobVitoria + #274, #3889
  static bobVitoria + #275, #3889
  static bobVitoria + #276, #3889
  static bobVitoria + #277, #3889
  static bobVitoria + #278, #3889
  static bobVitoria + #279, #3889

  ;Linha 7
  static bobVitoria + #280, #3840
  static bobVitoria + #281, #3840
  static bobVitoria + #282, #3840
  static bobVitoria + #283, #3840
  static bobVitoria + #284, #3840
  static bobVitoria + #285, #3840
  static bobVitoria + #286, #3840
  static bobVitoria + #287, #3840
  static bobVitoria + #288, #3840
  static bobVitoria + #289, #3840
  static bobVitoria + #290, #3840
  static bobVitoria + #291, #3840
  static bobVitoria + #292, #3840
  static bobVitoria + #293, #3840
  static bobVitoria + #294, #3840
  static bobVitoria + #295, #3840
  static bobVitoria + #296, #3840
  static bobVitoria + #297, #3840
  static bobVitoria + #298, #3840
  static bobVitoria + #299, #3840
  static bobVitoria + #300, #3889
  static bobVitoria + #301, #3889
  static bobVitoria + #302, #3889
  static bobVitoria + #303, #3889
  static bobVitoria + #304, #3889
  static bobVitoria + #305, #3840
  static bobVitoria + #306, #3840
  static bobVitoria + #307, #3840
  static bobVitoria + #308, #3840
  static bobVitoria + #309, #3840
  static bobVitoria + #310, #3840
  static bobVitoria + #311, #3840
  static bobVitoria + #312, #3840
  static bobVitoria + #313, #3840
  static bobVitoria + #314, #3840
  static bobVitoria + #315, #3840
  static bobVitoria + #316, #3840
  static bobVitoria + #317, #3840
  static bobVitoria + #318, #3840
  static bobVitoria + #319, #3840

  ;Linha 8
  static bobVitoria + #320, #3840
  static bobVitoria + #321, #3840
  static bobVitoria + #322, #3840
  static bobVitoria + #323, #3840
  static bobVitoria + #324, #3840
  static bobVitoria + #325, #3840
  static bobVitoria + #326, #3840
  static bobVitoria + #327, #3840
  static bobVitoria + #328, #3840
  static bobVitoria + #329, #3840
  static bobVitoria + #330, #3840
  static bobVitoria + #331, #3840
  static bobVitoria + #332, #3840
  static bobVitoria + #333, #3840
  static bobVitoria + #334, #3840
  static bobVitoria + #335, #2816
  static bobVitoria + #336, #2816
  static bobVitoria + #337, #2816
  static bobVitoria + #338, #2816
  static bobVitoria + #339, #2816
  static bobVitoria + #340, #2816
  static bobVitoria + #341, #2816
  static bobVitoria + #342, #2816
  static bobVitoria + #343, #2816
  static bobVitoria + #344, #2816
  static bobVitoria + #345, #3889
  static bobVitoria + #346, #3889
  static bobVitoria + #347, #3889
  static bobVitoria + #348, #3889
  static bobVitoria + #349, #3889
  static bobVitoria + #350, #3889
  static bobVitoria + #351, #3889
  static bobVitoria + #352, #3889
  static bobVitoria + #353, #3889
  static bobVitoria + #354, #3889
  static bobVitoria + #355, #3889
  static bobVitoria + #356, #3889
  static bobVitoria + #357, #3889
  static bobVitoria + #358, #3889
  static bobVitoria + #359, #3889

  ;Linha 9
  static bobVitoria + #360, #3840
  static bobVitoria + #361, #3840
  static bobVitoria + #362, #3840
  static bobVitoria + #363, #3840
  static bobVitoria + #364, #3840
  static bobVitoria + #365, #3840
  static bobVitoria + #366, #3840
  static bobVitoria + #367, #3840
  static bobVitoria + #368, #3840
  static bobVitoria + #369, #3840
  static bobVitoria + #370, #3840
  static bobVitoria + #371, #3840
  static bobVitoria + #372, #3840
  static bobVitoria + #373, #2816
  static bobVitoria + #374, #2816
  static bobVitoria + #375, #2816
  static bobVitoria + #376, #2816
  static bobVitoria + #377, #2816
  static bobVitoria + #378, #2816
  static bobVitoria + #379, #2816
  static bobVitoria + #380, #2816
  static bobVitoria + #381, #2816
  static bobVitoria + #382, #2816
  static bobVitoria + #383, #2816
  static bobVitoria + #384, #2816
  static bobVitoria + #385, #2816
  static bobVitoria + #386, #2816
  static bobVitoria + #387, #3889
  static bobVitoria + #388, #3889
  static bobVitoria + #389, #3889
  static bobVitoria + #390, #3889
  static bobVitoria + #391, #3889
  static bobVitoria + #392, #3889
  static bobVitoria + #393, #3889
  static bobVitoria + #394, #3889
  static bobVitoria + #395, #3889
  static bobVitoria + #396, #3889
  static bobVitoria + #397, #3889
  static bobVitoria + #398, #3889
  static bobVitoria + #399, #3889

  ;Linha 10
  static bobVitoria + #400, #3840
  static bobVitoria + #401, #3840
  static bobVitoria + #402, #3840
  static bobVitoria + #403, #3840
  static bobVitoria + #404, #3840
  static bobVitoria + #405, #3840
  static bobVitoria + #406, #3840
  static bobVitoria + #407, #3840
  static bobVitoria + #408, #3840
  static bobVitoria + #409, #3840
  static bobVitoria + #410, #3840
  static bobVitoria + #411, #2816
  static bobVitoria + #412, #2816
  static bobVitoria + #413, #2816
  static bobVitoria + #414, #2816
  static bobVitoria + #415, #2816
  static bobVitoria + #416, #2816
  static bobVitoria + #417, #0
  static bobVitoria + #418, #2816
  static bobVitoria + #419, #2816
  static bobVitoria + #420, #2816
  static bobVitoria + #421, #2816
  static bobVitoria + #422, #2816
  static bobVitoria + #423, #0
  static bobVitoria + #424, #2816
  static bobVitoria + #425, #2816
  static bobVitoria + #426, #2816
  static bobVitoria + #427, #2816
  static bobVitoria + #428, #2816
  static bobVitoria + #429, #3889
  static bobVitoria + #430, #3889
  static bobVitoria + #431, #3889
  static bobVitoria + #432, #3889
  static bobVitoria + #433, #3889
  static bobVitoria + #434, #3889
  static bobVitoria + #435, #3889
  static bobVitoria + #436, #3889
  static bobVitoria + #437, #3889
  static bobVitoria + #438, #3889
  static bobVitoria + #439, #3889

  ;Linha 11
  static bobVitoria + #440, #3840
  static bobVitoria + #441, #3840
  static bobVitoria + #442, #3840
  static bobVitoria + #443, #3840
  static bobVitoria + #444, #3840
  static bobVitoria + #445, #3840
  static bobVitoria + #446, #3840
  static bobVitoria + #447, #3840
  static bobVitoria + #448, #3840
  static bobVitoria + #449, #3840
  static bobVitoria + #450, #2816
  static bobVitoria + #451, #2816
  static bobVitoria + #452, #2816
  static bobVitoria + #453, #0
  static bobVitoria + #454, #2816
  static bobVitoria + #455, #2816
  static bobVitoria + #456, #2816
  static bobVitoria + #457, #2816
  static bobVitoria + #458, #2816
  static bobVitoria + #459, #2816
  static bobVitoria + #460, #2816
  static bobVitoria + #461, #2816
  static bobVitoria + #462, #2816
  static bobVitoria + #463, #2816
  static bobVitoria + #464, #2816
  static bobVitoria + #465, #2816
  static bobVitoria + #466, #2816
  static bobVitoria + #467, #2816
  static bobVitoria + #468, #2816
  static bobVitoria + #469, #2816
  static bobVitoria + #470, #3889
  static bobVitoria + #471, #3889
  static bobVitoria + #472, #3889
  static bobVitoria + #473, #3889
  static bobVitoria + #474, #3889
  static bobVitoria + #475, #3889
  static bobVitoria + #476, #3889
  static bobVitoria + #477, #3889
  static bobVitoria + #478, #3889
  static bobVitoria + #479, #3889

  ;Linha 12
  static bobVitoria + #480, #3840
  static bobVitoria + #481, #3840
  static bobVitoria + #482, #3840
  static bobVitoria + #483, #3840
  static bobVitoria + #484, #3840
  static bobVitoria + #485, #3840
  static bobVitoria + #486, #3840
  static bobVitoria + #487, #3840
  static bobVitoria + #488, #3840
  static bobVitoria + #489, #2816
  static bobVitoria + #490, #2816
  static bobVitoria + #491, #2816
  static bobVitoria + #492, #2816
  static bobVitoria + #493, #2816
  static bobVitoria + #494, #2816
  static bobVitoria + #495, #0
  static bobVitoria + #496, #2816
  static bobVitoria + #497, #2816
  static bobVitoria + #498, #2816
  static bobVitoria + #499, #2816
  static bobVitoria + #500, #0
  static bobVitoria + #501, #2816
  static bobVitoria + #502, #2816
  static bobVitoria + #503, #2816
  static bobVitoria + #504, #2816
  static bobVitoria + #505, #2816
  static bobVitoria + #506, #0
  static bobVitoria + #507, #2816
  static bobVitoria + #508, #2816
  static bobVitoria + #509, #2816
  static bobVitoria + #510, #2816
  static bobVitoria + #511, #3889
  static bobVitoria + #512, #3889
  static bobVitoria + #513, #3889
  static bobVitoria + #514, #3889
  static bobVitoria + #515, #3889
  static bobVitoria + #516, #3889
  static bobVitoria + #517, #3889
  static bobVitoria + #518, #3889
  static bobVitoria + #519, #3889

  ;Linha 13
  static bobVitoria + #520, #3840
  static bobVitoria + #521, #3840
  static bobVitoria + #522, #3840
  static bobVitoria + #523, #3840
  static bobVitoria + #524, #3840
  static bobVitoria + #525, #3840
  static bobVitoria + #526, #3840
  static bobVitoria + #527, #3840
  static bobVitoria + #528, #2816
  static bobVitoria + #529, #2816
  static bobVitoria + #530, #2816
  static bobVitoria + #531, #2816
  static bobVitoria + #532, #2816
  static bobVitoria + #533, #2816
  static bobVitoria + #534, #2816
  static bobVitoria + #535, #2816
  static bobVitoria + #536, #2816
  static bobVitoria + #537, #2816
  static bobVitoria + #538, #2816
  static bobVitoria + #539, #2816
  static bobVitoria + #540, #2816
  static bobVitoria + #541, #2816
  static bobVitoria + #542, #2816
  static bobVitoria + #543, #2816
  static bobVitoria + #544, #2816
  static bobVitoria + #545, #2816
  static bobVitoria + #546, #2816
  static bobVitoria + #547, #2816
  static bobVitoria + #548, #2816
  static bobVitoria + #549, #2816
  static bobVitoria + #550, #2816
  static bobVitoria + #551, #2816
  static bobVitoria + #552, #3889
  static bobVitoria + #553, #3889
  static bobVitoria + #554, #3889
  static bobVitoria + #555, #3889
  static bobVitoria + #556, #3889
  static bobVitoria + #557, #3889
  static bobVitoria + #558, #3889
  static bobVitoria + #559, #3889

  ;Linha 14
  static bobVitoria + #560, #3840
  static bobVitoria + #561, #3840
  static bobVitoria + #562, #3840
  static bobVitoria + #563, #3840
  static bobVitoria + #564, #3840
  static bobVitoria + #565, #3840
  static bobVitoria + #566, #3840
  static bobVitoria + #567, #512
  static bobVitoria + #568, #512
  static bobVitoria + #569, #512
  static bobVitoria + #570, #512
  static bobVitoria + #571, #512
  static bobVitoria + #572, #512
  static bobVitoria + #573, #512
  static bobVitoria + #574, #512
  static bobVitoria + #575, #512
  static bobVitoria + #576, #512
  static bobVitoria + #577, #512
  static bobVitoria + #578, #512
  static bobVitoria + #579, #512
  static bobVitoria + #580, #512
  static bobVitoria + #581, #512
  static bobVitoria + #582, #512
  static bobVitoria + #583, #512
  static bobVitoria + #584, #512
  static bobVitoria + #585, #512
  static bobVitoria + #586, #512
  static bobVitoria + #587, #512
  static bobVitoria + #588, #512
  static bobVitoria + #589, #512
  static bobVitoria + #590, #512
  static bobVitoria + #591, #512
  static bobVitoria + #592, #512
  static bobVitoria + #593, #3889
  static bobVitoria + #594, #3889
  static bobVitoria + #595, #3889
  static bobVitoria + #596, #3889
  static bobVitoria + #597, #3889
  static bobVitoria + #598, #3889
  static bobVitoria + #599, #3889

  ;Linha 15
  static bobVitoria + #600, #3840
  static bobVitoria + #601, #3840
  static bobVitoria + #602, #3840
  static bobVitoria + #603, #3840
  static bobVitoria + #604, #3840
  static bobVitoria + #605, #3840
  static bobVitoria + #606, #3840
  static bobVitoria + #607, #3840
  static bobVitoria + #608, #512
  static bobVitoria + #609, #512
  static bobVitoria + #610, #512
  static bobVitoria + #611, #2304
  static bobVitoria + #612, #2304
  static bobVitoria + #613, #2304
  static bobVitoria + #614, #512
  static bobVitoria + #615, #512
  static bobVitoria + #616, #512
  static bobVitoria + #617, #512
  static bobVitoria + #618, #2304
  static bobVitoria + #619, #2304
  static bobVitoria + #620, #2304
  static bobVitoria + #621, #2304
  static bobVitoria + #622, #2304
  static bobVitoria + #623, #512
  static bobVitoria + #624, #512
  static bobVitoria + #625, #512
  static bobVitoria + #626, #512
  static bobVitoria + #627, #2304
  static bobVitoria + #628, #2304
  static bobVitoria + #629, #2304
  static bobVitoria + #630, #512
  static bobVitoria + #631, #512
  static bobVitoria + #632, #3889
  static bobVitoria + #633, #3889
  static bobVitoria + #634, #3889
  static bobVitoria + #635, #3889
  static bobVitoria + #636, #3889
  static bobVitoria + #637, #3889
  static bobVitoria + #638, #3889
  static bobVitoria + #639, #3889

  ;Linha 16
  static bobVitoria + #640, #3840
  static bobVitoria + #641, #3840
  static bobVitoria + #642, #3840
  static bobVitoria + #643, #3840
  static bobVitoria + #644, #3840
  static bobVitoria + #645, #3840
  static bobVitoria + #646, #3840
  static bobVitoria + #647, #3840
  static bobVitoria + #648, #2304
  static bobVitoria + #649, #2304
  static bobVitoria + #650, #2304
  static bobVitoria + #651, #2304
  static bobVitoria + #652, #2304
  static bobVitoria + #653, #2304
  static bobVitoria + #654, #2304
  static bobVitoria + #655, #2304
  static bobVitoria + #656, #2304
  static bobVitoria + #657, #2304
  static bobVitoria + #658, #2304
  static bobVitoria + #659, #2304
  static bobVitoria + #660, #2304
  static bobVitoria + #661, #2304
  static bobVitoria + #662, #2304
  static bobVitoria + #663, #2304
  static bobVitoria + #664, #2304
  static bobVitoria + #665, #2304
  static bobVitoria + #666, #2304
  static bobVitoria + #667, #2304
  static bobVitoria + #668, #2304
  static bobVitoria + #669, #2304
  static bobVitoria + #670, #2304
  static bobVitoria + #671, #2304
  static bobVitoria + #672, #3889
  static bobVitoria + #673, #3889
  static bobVitoria + #674, #3889
  static bobVitoria + #675, #3889
  static bobVitoria + #676, #3889
  static bobVitoria + #677, #3889
  static bobVitoria + #678, #3889
  static bobVitoria + #679, #3889

  ;Linha 17
  static bobVitoria + #680, #3840
  static bobVitoria + #681, #3840
  static bobVitoria + #682, #3840
  static bobVitoria + #683, #3840
  static bobVitoria + #684, #3840
  static bobVitoria + #685, #3840
  static bobVitoria + #686, #3840
  static bobVitoria + #687, #3840
  static bobVitoria + #688, #2816
  static bobVitoria + #689, #2816
  static bobVitoria + #690, #2816
  static bobVitoria + #691, #2816
  static bobVitoria + #692, #2816
  static bobVitoria + #693, #2816
  static bobVitoria + #694, #2816
  static bobVitoria + #695, #2816
  static bobVitoria + #696, #2816
  static bobVitoria + #697, #2816
  static bobVitoria + #698, #2816
  static bobVitoria + #699, #2816
  static bobVitoria + #700, #2816
  static bobVitoria + #701, #2816
  static bobVitoria + #702, #2816
  static bobVitoria + #703, #2816
  static bobVitoria + #704, #2816
  static bobVitoria + #705, #2816
  static bobVitoria + #706, #2816
  static bobVitoria + #707, #2816
  static bobVitoria + #708, #2816
  static bobVitoria + #709, #2816
  static bobVitoria + #710, #2816
  static bobVitoria + #711, #2816
  static bobVitoria + #712, #3889
  static bobVitoria + #713, #3889
  static bobVitoria + #714, #3889
  static bobVitoria + #715, #3889
  static bobVitoria + #716, #3889
  static bobVitoria + #717, #3889
  static bobVitoria + #718, #3889
  static bobVitoria + #719, #3889

  ;Linha 18
  static bobVitoria + #720, #3840
  static bobVitoria + #721, #3840
  static bobVitoria + #722, #3840
  static bobVitoria + #723, #3840
  static bobVitoria + #724, #3840
  static bobVitoria + #725, #3840
  static bobVitoria + #726, #3840
  static bobVitoria + #727, #3840
  static bobVitoria + #728, #256
  static bobVitoria + #729, #2816
  static bobVitoria + #730, #256
  static bobVitoria + #731, #256
  static bobVitoria + #732, #2816
  static bobVitoria + #733, #2816
  static bobVitoria + #734, #2816
  static bobVitoria + #735, #2816
  static bobVitoria + #736, #256
  static bobVitoria + #737, #256
  static bobVitoria + #738, #2816
  static bobVitoria + #739, #2816
  static bobVitoria + #740, #2816
  static bobVitoria + #741, #2816
  static bobVitoria + #742, #2816
  static bobVitoria + #743, #256
  static bobVitoria + #744, #256
  static bobVitoria + #745, #256
  static bobVitoria + #746, #2816
  static bobVitoria + #747, #2816
  static bobVitoria + #748, #2816
  static bobVitoria + #749, #2816
  static bobVitoria + #750, #2816
  static bobVitoria + #751, #256
  static bobVitoria + #752, #3889
  static bobVitoria + #753, #3889
  static bobVitoria + #754, #3889
  static bobVitoria + #755, #3889
  static bobVitoria + #756, #3889
  static bobVitoria + #757, #3889
  static bobVitoria + #758, #3889
  static bobVitoria + #759, #3889

  ;Linha 19
  static bobVitoria + #760, #3840
  static bobVitoria + #761, #3840
  static bobVitoria + #762, #3840
  static bobVitoria + #763, #3840
  static bobVitoria + #764, #3840
  static bobVitoria + #765, #3840
  static bobVitoria + #766, #3840
  static bobVitoria + #767, #256
  static bobVitoria + #768, #256
  static bobVitoria + #769, #256
  static bobVitoria + #770, #256
  static bobVitoria + #771, #256
  static bobVitoria + #772, #256
  static bobVitoria + #773, #2816
  static bobVitoria + #774, #2816
  static bobVitoria + #775, #256
  static bobVitoria + #776, #256
  static bobVitoria + #777, #256
  static bobVitoria + #778, #256
  static bobVitoria + #779, #256
  static bobVitoria + #780, #2816
  static bobVitoria + #781, #2816
  static bobVitoria + #782, #256
  static bobVitoria + #783, #256
  static bobVitoria + #784, #256
  static bobVitoria + #785, #256
  static bobVitoria + #786, #256
  static bobVitoria + #787, #256
  static bobVitoria + #788, #2816
  static bobVitoria + #789, #2816
  static bobVitoria + #790, #256
  static bobVitoria + #791, #256
  static bobVitoria + #792, #256
  static bobVitoria + #793, #3889
  static bobVitoria + #794, #3889
  static bobVitoria + #795, #3889
  static bobVitoria + #796, #3889
  static bobVitoria + #797, #3889
  static bobVitoria + #798, #3889
  static bobVitoria + #799, #3889

  ;Linha 20
  static bobVitoria + #800, #3840
  static bobVitoria + #801, #3840
  static bobVitoria + #802, #3840
  static bobVitoria + #803, #3840
  static bobVitoria + #804, #3840
  static bobVitoria + #805, #3840
  static bobVitoria + #806, #3840
  static bobVitoria + #807, #256
  static bobVitoria + #808, #256
  static bobVitoria + #809, #256
  static bobVitoria + #810, #256
  static bobVitoria + #811, #256
  static bobVitoria + #812, #256
  static bobVitoria + #813, #256
  static bobVitoria + #814, #256
  static bobVitoria + #815, #256
  static bobVitoria + #816, #256
  static bobVitoria + #817, #256
  static bobVitoria + #818, #256
  static bobVitoria + #819, #256
  static bobVitoria + #820, #256
  static bobVitoria + #821, #256
  static bobVitoria + #822, #256
  static bobVitoria + #823, #256
  static bobVitoria + #824, #256
  static bobVitoria + #825, #256
  static bobVitoria + #826, #256
  static bobVitoria + #827, #256
  static bobVitoria + #828, #256
  static bobVitoria + #829, #256
  static bobVitoria + #830, #256
  static bobVitoria + #831, #256
  static bobVitoria + #832, #256
  static bobVitoria + #833, #3889
  static bobVitoria + #834, #3889
  static bobVitoria + #835, #3889
  static bobVitoria + #836, #3889
  static bobVitoria + #837, #3889
  static bobVitoria + #838, #3889
  static bobVitoria + #839, #3889

  ;Linha 21
  static bobVitoria + #840, #3840
  static bobVitoria + #841, #3840
  static bobVitoria + #842, #3840
  static bobVitoria + #843, #3840
  static bobVitoria + #844, #3840
  static bobVitoria + #845, #3840
  static bobVitoria + #846, #3840
  static bobVitoria + #847, #3840
  static bobVitoria + #848, #256
  static bobVitoria + #849, #256
  static bobVitoria + #850, #256
  static bobVitoria + #851, #256
  static bobVitoria + #852, #256
  static bobVitoria + #853, #256
  static bobVitoria + #854, #256
  static bobVitoria + #855, #256
  static bobVitoria + #856, #256
  static bobVitoria + #857, #256
  static bobVitoria + #858, #256
  static bobVitoria + #859, #256
  static bobVitoria + #860, #256
  static bobVitoria + #861, #256
  static bobVitoria + #862, #256
  static bobVitoria + #863, #256
  static bobVitoria + #864, #256
  static bobVitoria + #865, #256
  static bobVitoria + #866, #256
  static bobVitoria + #867, #256
  static bobVitoria + #868, #256
  static bobVitoria + #869, #256
  static bobVitoria + #870, #256
  static bobVitoria + #871, #256
  static bobVitoria + #872, #3889
  static bobVitoria + #873, #3889
  static bobVitoria + #874, #3889
  static bobVitoria + #875, #3889
  static bobVitoria + #876, #3889
  static bobVitoria + #877, #3889
  static bobVitoria + #878, #3889
  static bobVitoria + #879, #3889

  ;Linha 22
  static bobVitoria + #880, #3840
  static bobVitoria + #881, #3840
  static bobVitoria + #882, #3840
  static bobVitoria + #883, #3840
  static bobVitoria + #884, #3840
  static bobVitoria + #885, #3840
  static bobVitoria + #886, #3840
  static bobVitoria + #887, #3840
  static bobVitoria + #888, #2816
  static bobVitoria + #889, #2816
  static bobVitoria + #890, #2816
  static bobVitoria + #891, #2816
  static bobVitoria + #892, #2816
  static bobVitoria + #893, #2816
  static bobVitoria + #894, #2816
  static bobVitoria + #895, #2816
  static bobVitoria + #896, #2816
  static bobVitoria + #897, #2816
  static bobVitoria + #898, #2816
  static bobVitoria + #899, #2816
  static bobVitoria + #900, #2816
  static bobVitoria + #901, #2816
  static bobVitoria + #902, #2816
  static bobVitoria + #903, #2816
  static bobVitoria + #904, #2816
  static bobVitoria + #905, #2816
  static bobVitoria + #906, #2816
  static bobVitoria + #907, #2816
  static bobVitoria + #908, #2816
  static bobVitoria + #909, #2816
  static bobVitoria + #910, #2816
  static bobVitoria + #911, #2816
  static bobVitoria + #912, #3889
  static bobVitoria + #913, #3889
  static bobVitoria + #914, #3889
  static bobVitoria + #915, #3889
  static bobVitoria + #916, #3889
  static bobVitoria + #917, #3889
  static bobVitoria + #918, #3889
  static bobVitoria + #919, #3889

  ;Linha 23
  static bobVitoria + #920, #3840
  static bobVitoria + #921, #3840
  static bobVitoria + #922, #3840
  static bobVitoria + #923, #3840
  static bobVitoria + #924, #3840
  static bobVitoria + #925, #3840
  static bobVitoria + #926, #3840
  static bobVitoria + #927, #3840
  static bobVitoria + #928, #2816
  static bobVitoria + #929, #2816
  static bobVitoria + #930, #2816
  static bobVitoria + #931, #2816
  static bobVitoria + #932, #2816
  static bobVitoria + #933, #2816
  static bobVitoria + #934, #2816
  static bobVitoria + #935, #2816
  static bobVitoria + #936, #2816
  static bobVitoria + #937, #2816
  static bobVitoria + #938, #2816
  static bobVitoria + #939, #2816
  static bobVitoria + #940, #2816
  static bobVitoria + #941, #2816
  static bobVitoria + #942, #2816
  static bobVitoria + #943, #2816
  static bobVitoria + #944, #2816
  static bobVitoria + #945, #2816
  static bobVitoria + #946, #2816
  static bobVitoria + #947, #2816
  static bobVitoria + #948, #2816
  static bobVitoria + #949, #2816
  static bobVitoria + #950, #2816
  static bobVitoria + #951, #2816
  static bobVitoria + #952, #3889
  static bobVitoria + #953, #3889
  static bobVitoria + #954, #3889
  static bobVitoria + #955, #3889
  static bobVitoria + #956, #3889
  static bobVitoria + #957, #3889
  static bobVitoria + #958, #3889
  static bobVitoria + #959, #3889

  ;Linha 24
  static bobVitoria + #960, #3840
  static bobVitoria + #961, #3840
  static bobVitoria + #962, #3840
  static bobVitoria + #963, #3840
  static bobVitoria + #964, #3840
  static bobVitoria + #965, #3840
  static bobVitoria + #966, #3840
  static bobVitoria + #967, #3840
  static bobVitoria + #968, #3840
  static bobVitoria + #969, #3840
  static bobVitoria + #970, #3840
  static bobVitoria + #971, #3840
  static bobVitoria + #972, #3840
  static bobVitoria + #973, #3840
  static bobVitoria + #974, #3840
  static bobVitoria + #975, #3840
  static bobVitoria + #976, #3840
  static bobVitoria + #977, #3840
  static bobVitoria + #978, #3840
  static bobVitoria + #979, #3840
  static bobVitoria + #980, #3840
  static bobVitoria + #981, #3840
  static bobVitoria + #982, #3840
  static bobVitoria + #983, #3840
  static bobVitoria + #984, #3840
  static bobVitoria + #985, #3840
  static bobVitoria + #986, #3840
  static bobVitoria + #987, #3840
  static bobVitoria + #988, #3840
  static bobVitoria + #989, #3840
  static bobVitoria + #990, #3840
  static bobVitoria + #991, #3840
  static bobVitoria + #992, #3840
  static bobVitoria + #993, #3840
  static bobVitoria + #994, #3840
  static bobVitoria + #995, #3840
  static bobVitoria + #996, #3840
  static bobVitoria + #997, #3840
  static bobVitoria + #998, #3840
  static bobVitoria + #999, #3840

  ;Linha 25
  static bobVitoria + #1000, #3840
  static bobVitoria + #1001, #3840
  static bobVitoria + #1002, #3840
  static bobVitoria + #1003, #3840
  static bobVitoria + #1004, #3840
  static bobVitoria + #1005, #3840
  static bobVitoria + #1006, #3840
  static bobVitoria + #1007, #3840
  static bobVitoria + #1008, #3840
  static bobVitoria + #1009, #3840
  static bobVitoria + #1010, #3840
  static bobVitoria + #1011, #3840
  static bobVitoria + #1012, #3840
  static bobVitoria + #1013, #3840
  static bobVitoria + #1014, #3840
  static bobVitoria + #1015, #3840
  static bobVitoria + #1016, #3840
  static bobVitoria + #1017, #3840
  static bobVitoria + #1018, #3840
  static bobVitoria + #1019, #3840
  static bobVitoria + #1020, #3840
  static bobVitoria + #1021, #3840
  static bobVitoria + #1022, #3840
  static bobVitoria + #1023, #3840
  static bobVitoria + #1024, #3840
  static bobVitoria + #1025, #3840
  static bobVitoria + #1026, #3840
  static bobVitoria + #1027, #3840
  static bobVitoria + #1028, #3840
  static bobVitoria + #1029, #3840
  static bobVitoria + #1030, #3840
  static bobVitoria + #1031, #3840
  static bobVitoria + #1032, #3840
  static bobVitoria + #1033, #3840
  static bobVitoria + #1034, #3840
  static bobVitoria + #1035, #3840
  static bobVitoria + #1036, #3840
  static bobVitoria + #1037, #3840
  static bobVitoria + #1038, #3840
  static bobVitoria + #1039, #3840

  ;Linha 26
  static bobVitoria + #1040, #3889
  static bobVitoria + #1041, #3889
  static bobVitoria + #1042, #3889
  static bobVitoria + #1043, #3889
  static bobVitoria + #1044, #3889
  static bobVitoria + #1045, #42
  static bobVitoria + #1046, #65
  static bobVitoria + #1047, #80
  static bobVitoria + #1048, #69
  static bobVitoria + #1049, #82
  static bobVitoria + #1050, #84
  static bobVitoria + #1051, #69
  static bobVitoria + #1052, #3889
  static bobVitoria + #1053, #3376
  static bobVitoria + #1054, #3889
  static bobVitoria + #1055, #80
  static bobVitoria + #1056, #65
  static bobVitoria + #1057, #82
  static bobVitoria + #1058, #65
  static bobVitoria + #1059, #3889
  static bobVitoria + #1060, #74
  static bobVitoria + #1061, #79
  static bobVitoria + #1062, #71
  static bobVitoria + #1063, #65
  static bobVitoria + #1064, #82
  static bobVitoria + #1065, #3889
  static bobVitoria + #1066, #78
  static bobVitoria + #1067, #79
  static bobVitoria + #1068, #86
  static bobVitoria + #1069, #65
  static bobVitoria + #1070, #77
  static bobVitoria + #1071, #69
  static bobVitoria + #1072, #78
  static bobVitoria + #1073, #84
  static bobVitoria + #1074, #69
  static bobVitoria + #1075, #3889
  static bobVitoria + #1076, #3889
  static bobVitoria + #1077, #3889
  static bobVitoria + #1078, #3889
  static bobVitoria + #1079, #3889

  ;Linha 27
  static bobVitoria + #1080, #3889
  static bobVitoria + #1081, #3889
  static bobVitoria + #1082, #3889
  static bobVitoria + #1083, #3889
  static bobVitoria + #1084, #3889
  static bobVitoria + #1085, #3889
  static bobVitoria + #1086, #3889
  static bobVitoria + #1087, #3889
  static bobVitoria + #1088, #3889
  static bobVitoria + #1089, #3889
  static bobVitoria + #1090, #3889
  static bobVitoria + #1091, #3889
  static bobVitoria + #1092, #3889
  static bobVitoria + #1093, #3889
  static bobVitoria + #1094, #3889
  static bobVitoria + #1095, #3889
  static bobVitoria + #1096, #3889
  static bobVitoria + #1097, #3889
  static bobVitoria + #1098, #3889
  static bobVitoria + #1099, #3889
  static bobVitoria + #1100, #3889
  static bobVitoria + #1101, #3889
  static bobVitoria + #1102, #3889
  static bobVitoria + #1103, #3889
  static bobVitoria + #1104, #3889
  static bobVitoria + #1105, #3889
  static bobVitoria + #1106, #3889
  static bobVitoria + #1107, #3889
  static bobVitoria + #1108, #3889
  static bobVitoria + #1109, #3889
  static bobVitoria + #1110, #3889
  static bobVitoria + #1111, #3889
  static bobVitoria + #1112, #3889
  static bobVitoria + #1113, #3889
  static bobVitoria + #1114, #3889
  static bobVitoria + #1115, #3889
  static bobVitoria + #1116, #3889
  static bobVitoria + #1117, #3889
  static bobVitoria + #1118, #3889
  static bobVitoria + #1119, #3889

  ;Linha 28
  static bobVitoria + #1120, #3889
  static bobVitoria + #1121, #3889
  static bobVitoria + #1122, #3889
  static bobVitoria + #1123, #3889
  static bobVitoria + #1124, #3889
  static bobVitoria + #1125, #42
  static bobVitoria + #1126, #65
  static bobVitoria + #1127, #80
  static bobVitoria + #1128, #69
  static bobVitoria + #1129, #82
  static bobVitoria + #1130, #84
  static bobVitoria + #1131, #69
  static bobVitoria + #1132, #3889
  static bobVitoria + #1133, #3377
  static bobVitoria + #1134, #3889
  static bobVitoria + #1135, #80
  static bobVitoria + #1136, #65
  static bobVitoria + #1137, #82
  static bobVitoria + #1138, #65
  static bobVitoria + #1139, #3889
  static bobVitoria + #1140, #83
  static bobVitoria + #1141, #65
  static bobVitoria + #1142, #73
  static bobVitoria + #1143, #82
  static bobVitoria + #1144, #3889
  static bobVitoria + #1145, #3889
  static bobVitoria + #1146, #3889
  static bobVitoria + #1147, #3889
  static bobVitoria + #1148, #3889
  static bobVitoria + #1149, #3889
  static bobVitoria + #1150, #3889
  static bobVitoria + #1151, #3889
  static bobVitoria + #1152, #3889
  static bobVitoria + #1153, #3889
  static bobVitoria + #1154, #3889
  static bobVitoria + #1155, #3889
  static bobVitoria + #1156, #3889
  static bobVitoria + #1157, #3889
  static bobVitoria + #1158, #3889
  static bobVitoria + #1159, #3889

  ;Linha 29
  static bobVitoria + #1160, #3889
  static bobVitoria + #1161, #3889
  static bobVitoria + #1162, #3889
  static bobVitoria + #1163, #3889
  static bobVitoria + #1164, #3889
  static bobVitoria + #1165, #3889
  static bobVitoria + #1166, #3889
  static bobVitoria + #1167, #3889
  static bobVitoria + #1168, #3889
  static bobVitoria + #1169, #3889
  static bobVitoria + #1170, #3889
  static bobVitoria + #1171, #3889
  static bobVitoria + #1172, #3889
  static bobVitoria + #1173, #3889
  static bobVitoria + #1174, #3889
  static bobVitoria + #1175, #3889
  static bobVitoria + #1176, #3889
  static bobVitoria + #1177, #3889
  static bobVitoria + #1178, #3889
  static bobVitoria + #1179, #3889
  static bobVitoria + #1180, #3889
  static bobVitoria + #1181, #3889
  static bobVitoria + #1182, #3889
  static bobVitoria + #1183, #3889
  static bobVitoria + #1184, #3889
  static bobVitoria + #1185, #3889
  static bobVitoria + #1186, #3889
  static bobVitoria + #1187, #3889
  static bobVitoria + #1188, #3889
  static bobVitoria + #1189, #3889
  static bobVitoria + #1190, #3889
  static bobVitoria + #1191, #3889
  static bobVitoria + #1192, #3889
  static bobVitoria + #1193, #3889
  static bobVitoria + #1194, #3889
  static bobVitoria + #1195, #3889
  static bobVitoria + #1196, #3889
  static bobVitoria + #1197, #3889
  static bobVitoria + #1198, #3889
  static bobVitoria + #1199, #3889

printbobVitoriaScreen:
  push R0
  push R1
  push R2
  push R3

  loadn R0, #bobVitoria
  loadn R1, #0
  loadn R2, #1200

  printbobVitoriaScreenLoop:

    add R3,R0,R1
    loadi R3, R3
    outchar R3, R1
    inc R1
    cmp R1, R2

    jne printbobVitoriaScreenLoop

  pop R3
  pop R2
  pop R1
  pop R0
  jmp Fim


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