		@ stm32f030f4p6 asm
	 .thumb
	         .syntax unified
	.section .data
shumaguanmabiao:
	.int 0x02,0xae,0x14,0x0c,0xa8,0x48,0x40,0x2e,0x00,0x08
wendubiao:
	.int 2520,2500,2460,2430,2410,2370,2340,2310,2260,2230,2200,2160,2130,2090,2050,2010,1980,1940,1910,1860,1830,1790,1760,1720,1680,1650,1614,1578,1542,1514,1472,1438,1403,1369,1336,1303,1271,1239,1208,1177,1146,1117,1087,1059,1031,1003,976,949,923,898,873,849,826,803,780,758,737,716,696,676,657,638,620,602,585,568,552,536,521,506,491,477,464,450,437,425,413,401,390,379,368,357,347,337,328,319,310,301,293,284,276,269,251,247,240,234,227,221,215,209,204,198,193,188,183,178,173,169,164,160,156,152,148,144,140,137,133,130,126,123
caidan:
	.word _tingting
	.word _wendushangxian +1
	.word _wenduxiaxian +1
	.word _baocunshezhi  +1
	
	.equ STACKINIT,        	        0x20001000
	.equ shumaguanma,		0x20000000
	.equ jishu,			0x20000010
	.equ lvbozhizhen,		0x20000014
	.equ lvbohuanchong,		0x20000018
	.equ dangqianwendu,		0x20000038
	.equ wendushangxian,		0x2000003c
	.equ wenduxiaxian,		0x20000040

.section .text
vectors:
	.word STACKINIT
	.word _start + 1
	.word _nmi_handler + 1
	.word _hard_fault  + 1
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word _svc_handler +1
	.word 0
	.word 0
	.word _pendsv_handler +1
	.word _systickzhongduan +1               @ 15
	.word aaa +1     @ _wwdg +1          @ 0
	.word aaa +1     @_pvd +1            @ 1
	.word aaa +1     @_rtc +1            @ 2
	.word aaa +1     @_flash +1          @ 3
	.word aaa +1	@ _rcc + 1          @ 4
	.word aaa +1	@_exti0_1  +1      @ 5
	.word aaa +1      @ _exti2_3 +1      @ 6
	.word aaa +1       @_exti4_15 +1     @ 7
	.word aaa +1                         @ 8
	.word aaa +1 	@_dma1_1  +1    @ 9
	.word aaa +1    @_dma1_2_3 +1        @ 10
	.word aaa +1       @_dma1_4_5 +1     @ 11
	.word aaa +1	 @_adc1 +1          @ 12
	.word aaa +1	@_tim1_brk_up +1  @ 13
	.word aaa +1 @_tim1_buhuo +1    @ 14
	.word aaa +1         @_tim2 +1       @ 15
	.word aaa +1          @_tim3 +1      @ 16
	.word aaa +1                         @ 17
	.word aaa +1		                @ 18
	.word aaa +1		@_tim14 +1    @ 19
	.word aaa +1                         @ 20
	.word aaa +1 	@_tim16 +1      @ 21
	.word aaa +1         @_tim17 +1      @ 22
	.word aaa +1          @_i2c   +1     @ 23
	.word aaa +1                         @ 24
	.word aaa +1           @_spi   +1    @ 25
	.word aaa +1                         @ 26
	.word aaa +1         @_usart1 +1     @ 27
_start:
shizhong:
	ldr r0, = 0x40021000 @ rcc
	ldr r2, = 0x40022000   @FLASH访问控制
	movs r1, # 0x32
	str r1, [r2]           @FLASH缓冲 缓冲开启
	ldr r0, = 0x40021000 @ rcc
	ldr r1, = 0x100002
	str r1, [r0, # 0x04]
	ldr r1, = 0x1000001
	str r1, [r0]
dengrc:
	ldr r1, [r0]
	lsls r1, # 30
	bpl dengrc
dengpll:
	ldr r1, [r0]
	lsls r1, # 6
	bpl dengpll
	@0x34时钟控制寄存器 2 (RCC_CR2)
	movs r1, # 0x01
	str r1, [r0, # 0x34]  @ HSI开14M时钟
dengdai14mshizhongwending:
	ldr r1, [r0, # 0x34]
	lsls r1, r1, # 30     @ 左移30位
	bpl dengdai14mshizhongwending  @ 等待14M时钟稳定
	
neicunqingling:
	ldr r0, = 0x20000000
	movs r1, # 0
	ldr r3, = 0x1000
neicunqinglingxunhuan:
	subs r3, # 4
	str r1, [r0, r3]
	bne neicunqinglingxunhuan

_waisheshizhong:			 @ 外设时钟
	@ +0x14=RCC_AHBENR
	@ 0=DMA 2=SRAM 4=FLITF 6=CRC  17=PA  18=PB 19=PC 20=PD 22=PF
	ldr r0, = 0x40021000
	ldr r1, = 0x460005
	str r1, [r0, # 0x14]

	@ +0x18外设时钟使能寄存器 (RCC_APB2ENR)
	@ 0=SYSCFG 5=USART6EN 9=ADC 11=TIM1 12=SPI1 14=USART1
	@ 16=TIM15 17=TIM16 18=TIM17 22=DBGMCU
	ldr r1, = 0x200
	str r1, [r0, # 0x18]
	@+0X1C=RCC_APB1ENR
	@ 1=TIM3 4=TIM6 5=TIM7 8=TIM14 11=WWDG 14=SPI 17=USRT2 18=USART3
	@ 20=USART5 21=I2C1 22=I2C2  23=USB 28=PWR
	movs r1, # 0x01
	lsls r1, r1, # 11
	str r1, [r0, # 0x1c]


_adcchushihua:
        ldr r0, = 0x40012400  @ adc基地址
        ldr r1, = 0x80000000
        str r1, [r0, # 0x08]  @ ADC 控制寄存器 (ADC_CR)  @adc校准
_dengadcjiaozhun:
        ldr r1, [r0, # 0x08]
         movs r1, r1
	bmi _dengadcjiaozhun   @ 等ADC校准
_kaiadc:
        ldr r1, [r0, # 0x08]
        movs r2, # 0x01
	orrs r1, r1, r2
        str r1, [r0, # 0x08]
_dengdaiadcwending:
	ldr r1, [r0]
	lsls r1, r1, # 31
        bpl _dengdaiadcwending @ 等ADC稳定
_tongdaoxuanze:
	ldr r1, = 0x01
        str r1, [r0, # 0x28]    @ 通道选择寄存器 (ADC_CHSELR)
        ldr r1, = 0x2000        @ 13 连续转换
        str r1, [r0, # 0x0c]    @ 配置寄存器 1 (ADC_CFGR1)
        movs r1, # 0x07         @
        str r1, [r0, # 0x14]    @ ADC 采样时间寄存器 (ADC_SMPR)
	ldr r1, [r0, # 0x08]
        movs r2, # 0x04         @ 开始转换
        orrs r1, r1, r2
        str r1, [r0, # 0x08]    @ 控制寄存器 (ADC_CR)

_kanmengou:
	ldr r0, = 0x40003000
	ldr r1, = 0x5555
	str r1, [r0]
	movs r1, # 7
	str r1, [r0, # 4]
	ldr r1, = 0xfff
	str r1, [r0, # 8]
	ldr r1, = 0xaaaa
	str r1, [r0]
	ldr r1, = 0xcccc
	str r1, [r0]

_systick:                               @ systick定时器初始化

	ldr r0, = 0xe000e010
        ldr r1, = 0xfffff
        str r1, [r0, # 4]
        str r1, [r0, # 8]
        movs r1, # 0x07
	str r1, [r0]

io_she_zhi:
	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	@a(0x48000000)b(0x48000400)c(0x48000800)d(0x48000c00)f(0x48001400)
	@ 输入（00），通用输出（01），复用功能（10），模拟（11）
	@偏移0x4 = 端口输出类型 @ （0 推挽），（ 1 开漏）
	@偏移0x8 = 输出速度  00低速， 01中速， 11高速
	@偏移0xC = 上拉下拉 (00无上下拉，  01 上拉， 10下拉)
	@偏移0x10 = 输入数据寄存器
	@偏移0x14 = 输出数据寄存器
	@偏移0x18 = 端口开  0-15置位
	@偏移0x28 = 端口关
	@0X20 = 复用低
	@GPIO口0（0-3位）每个IO口占用4位
	@ AF0 = 0X0000, AF1 = 0X0001, AF2 = 0X0010 AF3 = 0X0011, AF4 = 0X0100
	@ AF5 = 0X0101, AF6 = 0X0111, AF7 = 0X1000
	@0x24 = 复用高
	@GPIO口8 （0-3位）每个IO口占用4位
	@ AF0 = 0X0000, AF1 = 0X0001, AF2 = 0X0010 AF3 = 0X0011, AF4 = 0X0100
	@ AF5 = 0X0101, AF6 = 0X0111, AF7 = 0X1000
	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	
	ldr r0, = 0x48000000
	ldr r1, = 0x145557
	str r1, [r0]
	ldr r1, = 0x14000000
	str r1, [r0, # 0x0c]

	ldr r0, = 0x48000400
	movs r1, # 0x04 @ pb1
	str r1, [r0]
	
	ldr r0, = 0x48001400
	movs r1, # 0x05
	str r1, [r0]
	movs r1, # 0x00
	str r1, [r0, # 0x14]
	
	ldr r0, = 0x8001000
	ldr r1, [r0]
	cmp r1, # 99
	bls _duflash
	ldr r0, = wendushangxian
	movs r1, # 0
	str r1, [r0]
	ldr r0, = wenduxiaxian
	movs r1, # 99
	str r1, [r0]
	b _tiaochujianceflash
_duflash:	
	ldr r2, = wendushangxian
	ldr r3, = wenduxiaxian
	str r1, [r2]
	ldr r1, [r0, # 0x04]
	str r1, [r3]
	
_tiaochujianceflash:

_tingting:
	bl _dangqianwendu
	ldr r0, = dangqianwendu
	ldr r1, = wendushangxian
	bl _xianshiwendu
	ldr r5, = wenduxiaxian
	ldr r2, [r0]
	ldr r3, [r1]
	ldr r5, [r5]
	cmp r2, r3
	beq _jidianqiguan
	cmp r2, r5
	beq _jidianqikai
	b _caidanjiance
_jidianqiguan:
	ldr r0, = 0x48000400
	movs r1, # 0x02
	str r1, [r0, # 0x28]
	b _caidanjiance
_jidianqikai:
	ldr r0, = 0x48000400
	movs r1, # 0x02
	str r1, [r0, # 0x18]
	
_caidanjiance:
	ldr r0, = 0x48000010
	ldr r2, = caidan
	ldr r1, [r0]
	mvns r1, r1
	lsls r1, r1, # 17
	lsrs r1, r1, # 30
	lsls r1, r1, # 2
	ldr r2, [r2, r1]
	mov pc, r2
	
	b _tingting

_wenduxiaxian:
	ldr r0, = wendushangxian
	ldr r1, = wenduxiaxian
	bl _xianshiwendu
	ldr r2, = jishu
	ldr r0, [r2]
	cmp r0, # 2
	bls _wenduxiaxian
	movs r0, # 0
	str r0, [r2]
	ldr r0, [r1]
	adds r0, r0, # 1
	cmp r0, # 99
	bls _chucunwendu1
	movs r0, # 0
_chucunwendu1:	
	str r0, [r1]
	ldr r0, = 0x48000010
	ldr r2, = caidan
        ldr r1, [r0]
	mvns r1, r1
	lsls r1, r1, # 17
        lsrs r1, r1, # 30
        lsls r1, r1, # 2
	ldr r2, [r2, r1]
        mov pc, r2
	
_wendushangxian:
        ldr r0, = wendushangxian
        ldr r1, = wenduxiaxian
	bl _xianshiwendu
	ldr r2, = jishu
        ldr r1, [r2]
	cmp r1, # 2
        bls _wendushangxian
	movs r1, # 0
        str r1, [r2]
        ldr r1, [r0]
	adds r1, r1, # 1
        cmp r1, # 99
        bls _chucunwendu
        movs r1, # 0
_chucunwendu:
        str r1, [r0]
        ldr r0, = 0x48000010
        ldr r2, = caidan
        ldr r1, [r0]
	mvns r1, r1
	lsls r1, r1, # 17
        lsrs r1, r1, # 30
        lsls r1, r1, # 2
        ldr r2, [r2, r1]
	mov pc, r2

_baocunshezhi:
	ldr r0, = 0xffffff
_baocunyanshi:
	subs r0, r0, # 1
	bne _baocunyanshi
_xieflash:			@ flsh解锁
	ldr r0, = 0x40022000
	ldr r1, = 0x45670123
	str r1, [r0, # 0x04]
	ldr r1, = 0xcdef89ab
	str r1, [r0, # 0x04]
					@擦除2页
	movs r5, # 1
	ldr r4, = 0x8001000
	movs r7, # 1
	lsls r7, r7, # 10
_flashmang:
	ldr r2, [r0, # 0x0c]
	lsls r2, r2, # 31
	bmi _flashmang
	movs r1, # 2
	str r1, [r0, # 0x10]
	str r4, [r0, # 0x14]
	movs r1, # 0x42
	str r1, [r0, # 0x10]
	add r4, r4, r7
	subs r5, # 1
	bne _flashmang
						@写FLASH
	ldr r7, = 0x8001000
	ldr r4, = 0x2000003c
	movs r5, # 0
	movs r6, # 0x02
_flashmang1:
	ldr r2, [r0, # 0x0c]
	lsls r2, r2, # 31
	bmi _flashmang1
	movs r1, # 1
	str r1, [r0, # 0x10]
	ldrh r3, [r4, r5]
	strh r3, [r7, r5]
	adds r5, r5, # 2
_flashmang2:
	ldr r2, [r0, # 0x0c]
	lsls r2, r2, # 31
	bmi _flashmang2
	ldrh r3, [r4, r5]
	strh r3, [r7, r5]
	adds r5, r5, # 2
	subs r6, r6, # 1
	bne _flashmang1
_flashmang4:
	ldr r2, [r0, # 0x0c]
	lsls r2, r2, # 31
	bmi _flashmang4
	@movs r1, # 0x80
	@str r1, [r0]          		@flsh上锁
	ldr r0, = 0xe000ed0c
	ldr r1, = 0x05fa0004
	str r1, [r0]          		@复位


_xianshiwendu:
	push {r0-r2,lr}
	ldr r0, [r0]
	ldr r1, [r1]
        movs r2, # 100
        muls r1, r1, r2
        add r0, r0, r1
	movs r1, # 4
        ldr r2, = shumaguanma
        bl _zhuanshumaguanma
        bl _xieshumaguan
	ldr r0, = 0x40003000
        ldr r1, = 0xaaaa
        str r1, [r0]
	pop {r0-r2,pc}
_dangqianwendu:
	push {r0-r6,lr}
	ldr r0, = 0x40012400
	ldr r1, = 3300
	ldr r0, [r0, # 0x40]
	movs r2, # 12
	muls r0, r1
	asrs r0, r0, r2
	ldr r2, = lvbozhizhen		@滤波器指针
	mov r3, r0			@adc数据
	ldr r0, = lvbohuanchong		@滤波器缓冲区
	ldr r1, = 16			@级数
	bl _lvboqi			@返回R0=电压
_chabiaowendu:
        ldr r2, = wendubiao
	ldr r5, = 0x18c
	movs r3, # 0
	ldr r6, = 2510
_chabiaowenduxunhuan:
	ldr r4, [r2, r3]
	cmp r0, r4
	bls _wendufanhui
	cmp r4, r6
	bls _wendufanhui1
	movs r3, # 0
_wendufanhui1:	
	ldr r5, = dangqianwendu
	lsrs r3, r3, # 2
	str r3, [r5]
	pop {r0-r6,pc}
_wendufanhui:
	adds r3, r3, # 4
	cmp r3, r5
	bls _chabiaowenduxunhuan
	pop {r0-r6,pc}
	
_xieshumaguan:			@ r0=4位10进制数
	push {r0-r7,lr}
	ldr r2, = shumaguanma
	ldr r7, = 0xfff
	ldr r4, = 0x48000000
	ldr r5, = 0x48001400
	ldr r6, = 0x200
	ldr r1, [r2]
	str r6, [r4, # 0x18]
	strb r1, [r4, # 0x14]
_shumaguanyanshi:	
	subs r7, r7, # 1
	bne _shumaguanyanshi
	str r6, [r4, # 0x28]
	lsls r6, r6, # 1
	ldr r7, = 0xfff
	ldr r1, [r2, # 0x04]
	str r6, [r4, # 0x18]
	strb r1, [r4, # 0x14]
	ldr r6, = 0x600
_shumaguanyanshi1:	
	subs r7, r7, # 1
	bne _shumaguanyanshi1
	str  r6, [r4, # 0x28]
	movs r6, # 0x02
	ldr r7, = 0xfff
	ldr r1, [r2, # 0x08]
	str r6, [r5, # 0x14]
	strb r1, [r4, # 0x14]
_shumaguanyanshi2:	
	subs r7, r7, # 1
	bne _shumaguanyanshi2
	movs r6, # 0x01
	ldr r7, = 0xfff
	ldr r1, [r2, # 0x0c]
	str r6, [r5, # 0x14]
	strb r1, [r4, # 0x14]
_shumaguanyanshi3:
	subs r7,  r7, # 1
	bne _shumaguanyanshi3
	movs r3, # 0
	str r3, [r5, # 0x14]
	pop {r0-r7,pc}
	
_zhuanshumaguanma:			@ 16进制转数码管码
		@ R0要转的数据， R1长度，R2结果表首地址
	push {r0-r7,lr}
	ldr r7, = shumaguanmabiao
	mov r5, r0
	mov r6, r1
	movs r1, # 10
_xunhuanqiuma:
	bl _chufa
	mov r4, r0
	muls r4, r1
	subs r3, r5, r4
	lsls r3, # 2
	ldr r4, [r7, r3]
	str r4, [r2]
	mov r5, r0
	adds r2, r2, # 4
	subs r6, # 1
	bne _xunhuanqiuma
	pop {r0-r7,pc}
_lvboqi:				@滤波器
			@R0=地址，R1=长度,r2=表指针地址,r3=ADC数值
			@出R0=结果
	push {r1-r7,lr}	
	ldr r5, [r2]		@读出表指针
	lsls r6, r1, # 1	
	strh r3, [r0, r5]	@数值写到滤波器缓冲区
	adds r5, r5, # 2
	cmp r5, r6
	bne _lvboqimeidaohuanchongquding
	movs r5, # 0
_lvboqimeidaohuanchongquding:
	str r5, [r2]
	movs r7, # 0
_lvboqixunhuan:
	cmp r5, r6
	bne _lvbozonghe
	movs r5, # 0
_lvbozonghe:
	ldrh r4, [r0, r5]
	adds r5, r5, # 2
	adds r7, r7, r4
	subs r1, r1, # 1
	bne _lvboqixunhuan
	asrs r0, r7, # 4	@平均
	pop {r1-r7,pc}	
	
_chufa:				@软件除法
	@ r0 除以 r1 等于 商(r0)余数R1
	push {r1-r4,lr}
	cmp r0, # 0
	beq _chufafanhui
	cmp r1, # 0
	beq _chufafanhui
	mov r2, r0
	movs r3, # 1
	lsls r3, r3, # 31
	movs r0, # 0
	mov r4, r0
_chufaxunhuan:
	lsls r2, r2, # 1
	adcs r4, r4, r4
	cmp r4, r1
	bcc _chufaweishubudao0
	adds r0, r0, r3
	subs r4, r4, r1
_chufaweishubudao0:
	lsrs r3, r3, # 1
	bne _chufaxunhuan
_chufafanhui:
	pop {r1-r4,pc}
_nmi_handler:
	bx lr
_hard_fault:
	bx lr
_svc_handler:
	bx lr
_pendsv_handler:
	bx lr
_systickzhongduan:
	ldr r2, = jishu
	ldr r0, = 0xe0000d04
	ldr r3, [r2]
	ldr r1, = 0x02000000
	adds r3, r3, # 1
	str r3, [r2]
	str r1, [r0]                 @ 清除SYSTICK中断
aaa:
	bx lr


