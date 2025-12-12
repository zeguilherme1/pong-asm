; Teste das instrucoes que vao sendo implementadas!


; 4 Perguntas ao implemantar as instrucoes:
;	1) O Que preciso fazer para esta instrucao?
;	2) Onde Comeca: Pegargcc o que tem que fazer e ir voltando ate' chegar em um registrador (ie. PC)
;	3) Qual e' a Sequencia de Operacoes: Descrever todos os comandos que tem que dar nos cilos de Dec e Exec
;	4) Ja' terminou??? Cumpriu o que tinha que fazer??? O PC esta' pronto para a proxima instrucao (cuidado com Load, Loadn, Store, Jmp, Call)

	; teste min
	loadn r1, #3
	loadn r2, #5
	max r3, r2, r1
	loadn r0, #18
	loadn r4, #'A'
	add r4, r4, r3
	outchar r4, r0
	
	
Fim:	
	halt

	
Dado : var #1  ; O comando VAR aloca bytes de memoria e associa o primeiro byte ao LABEL
static Dado + #0, #'B'

	
	
	
	
	
	
	
	
	
