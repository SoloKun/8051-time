	ORG 	0000H	    ;程序从此地址开始运行
	LJMP 	MAIN
	

	ORG 	0003H
LOOP:
	ACALL DISPLAY 
	JNB P3.7 ,RE0  //暂停中断
	AJMP LOOP
RE0:
	RETI
	
	
	ORG 0013H				//显示日期并重置计时
	MOV 	TCON,#05H
	MOV 	IE,#85H			
LOOP1:
	
    ACALL YEAR
	JNB P3.6,RE1   //判断是否按下退出按钮
	AJMP LOOP1
	RE1:
	DEC SP
	DEC SP
	PUSH DPL
	PUSH DPL
	PUSH DPH
	RETI		   //重置
    ORG 	0030H        	
MAIN:
    MOV 	TCON,#05H
	MOV 	IE,#85H
	MS1		EQU   10H
	MS2     EQU   11H
	S1      EQU   12H
	S2      EQU   13H
	M1		EQU	  14H
	M2		EQU   15H
	H1		EQU   16H
	H2		EQU   17H     //定义时分秒毫秒的地址
    MOV DPTR,#TAB
    LJMP    NEWDAY //跳转计时 
YEAR:
	CLR P2.2
	CLR  P2.3
	CLR  P2.4  //译码器选择第一个数码管000
	MOV  P0,#5BH  //2
	MOV  P0,#00H //消隐 
	SETB P2.2
	CLR  P2.3
	CLR  P2.4
	MOV  P0,#3FH  //0
	MOV  P0,#00H
	CLR P2.2
	SETB  P2.3
	CLR  P2.4
	MOV  P0,#06H //1
	MOV  P0,#00H
	SETB P2.2
	SETB  P2.3
	CLR  P2.4
	MOV  P0,#6FH //9
	MOV  P0,#00H
MONTH:	
	CLR P2.2
	CLR  P2.3
	SETB  P2.4
	MOV  P0,#06H //1
	MOV  P0,#00H
	SETB P2.2
	CLR  P2.3
	SETB  P2.4
	MOV  P0,#5BH //2
	MOV  P0,#00H
DAY:
	CLR   P2.2
	SETB  P2.3
	SETB  P2.4
	MOV  P0,#3FH //0
	MOV  P0,#00H
	SETB P2.2
	SETB  P2.3
	SETB  P2.4
	MOV  P0,#4FH //3
	MOV  P0,#00H
    RET 
////////////初始为年月日显示////////////
NEWDAY:
	MOV MS1,#0FFH
	MOV MS2,#0FFH
	MOV S1,#0FFH
	MOV S2,#0FFH
	MOV M1,#0FFH
	MOV M2,#0FFH
	MOV H1,#0FFH
	MOV H2,#0FFH
TIME:
	MOV R7,#02H		//设置时第二位进位
	MOV H1,#0FFH
	INC H2	 	  //设置时
OVH1:
	MOV R6,#02H //设置时第一位进位
	MOV M2,#0FFH
	INC H1
OVM2:
	MOV R5,#0AH
	MOV M1,#0FFH
	INC M2
OVM1:
	MOV R4,#06H
	MOV S2,#0FFH
	INC M1	
OVS2:
	MOV R3,#0AH
	MOV S1,#0FFH
	INC S2
	  
OVS1:
	MOV	R2,#0AH
	MOV MS2,#0FFH
	INC S1
OVMS2:
	MOV R1,#0AH
	MOV MS1,#0FFH
	INC MS2
OVMS1:
	MOV R0,#0AH
	
START:
    MOV TMOD,#01H
	MOV TH0,#0FCH
	MOV TL0,#0B4H 
	SETB TR0
	JNB TF0,$		//延时1ms
	CLR TF0
	INC MS1
	ACALL DISPLAY
	DJNZ R0,START
	DJNZ R1,OVMS1
	DJNZ R2,OVMS2
	DJNZ R3,OVS1
	DJNZ R4,OVS2
	DJNZ R5,OVM1
	DJNZ R6,OVM2
	DJNZ R7,OVH1
	AJMP NEWDAY
DISPLAY:
	SETB  P2.2
	SETB  P2.3
	SETB  P2.4
	MOV A,MS1
	MOVC A,@A+DPTR
	MOV P0,A  
	MOV P0,#00H//写毫秒第一位、消隐
	CLR  P2.2
	SETB  P2.3
	SETB  P2.4
	MOV A,MS2
	MOVC A,@A+DPTR
	MOV P0,A  
	MOV P0,#00H//写毫秒第二位
	SETB  P2.2
	CLR  P2.3
	SETB  P2.4
	MOV A,S1
	MOVC A,@A+DPTR
	MOV P0,A  
	MOV P0,#00H//写秒第一位
	CLR  P2.2
	CLR  P2.3
	SETB  P2.4
	MOV A,S2
	MOVC A,@A+DPTR
	MOV P0,A  
	MOV P0,#00H//写秒第二位
	SETB  P2.2
	SETB  P2.3
	CLR  P2.4
	MOV A,M1
	MOVC A,@A+DPTR
	MOV P0,A  
	MOV P0,#00H//写分第一位
	CLR  P2.2
	SETB  P2.3
	CLR  P2.4
	MOV A,M2
	MOVC A,@A+DPTR
	MOV P0,A  
	MOV P0,#00H//写分第二位
	SETB  P2.2
	CLR  P2.3
	CLR  P2.4
	MOV A,H1
	MOVC A,@A+DPTR
	MOV P0,A  
	MOV P0,#00H//写时第一位
	CLR  P2.2
	CLR  P2.3
	CLR  P2.4
	MOV A,H2
	MOVC A,@A+DPTR
	MOV P0,A  
	MOV P0,#00H//写时第二位
	RET
;*********************************************************************
	AJMP 	MAIN        ;跳转到主程序处
ORG 400H
TAB: DB 3Fh,06h,5Bh,4Fh,66h,6Dh,7Dh,07h,7Fh,6Fh 		;共阴极七段数码显管
END