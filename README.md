
# ILA
## CPLD clock signals 
![CPLD clock signals ](attachments/image-8.png)
## After turning off and on the electronics - CSTR pattern changes
- I did not observe any correlations between the signals. Signals are independent.  
![](attachments/image-9.png)
![](attachments/image-13.png)

## CSTR and mt_cou
- ILA clock is equal 320[MHz]
- We can see that the **CSTR** signal from the CPLD appears only at a specific moment, namely when the **mt_cou** signal equals “0”.
- Also we can be observed that the CSTR signal is active for only four ILA clock cycles. 
	- 3.125[ns] * 4[cycles] = 12.5[ns]. 
- CSTR1 and mt_cou
![](attachments/CSTR1_and_mt_cou.png)
- CSTR2 and mt_cou
![](attachments/CSTR2_and_mt_cou.png)
- CSTR3 and mt_cou
![](attachments/CSTR3_and_mt_cou.png)
- CSTR4 and mt_cou
![](attachments/CSTR4_and_mt_cou.png)
- CSTR5 and mt_cou
![](attachments/CSTR5_and_mt_cou.png)
- CSTR6 and mt_cou
![](attachments/CSTR6_and_mt_cou.png)
- CSTR7 and mt_cou
![](attachments/CSTR7_and_mt_cou.png)
- CSTR8 and mt_cou
![](attachments/CSTR8_and_mt_cou.png)
- CSTR9 and mt_cou
![](attachments/CSTR9_and_mt_cou.png)
- CSTR10 and mt_cou
![](attachments/CSTR10_and_mt_cou.png)
- CSTR11 and mt_cou
![](attachments/CSTR11_and_mt_cou.png)
- CSTR12 and mt_cou
![](attachments/CSTR12_and_mt_cou.png)

## CFD and CFD in gate
- CFD_in gate  -> ENA(Altium),  i_gate_latch(VHDL)
-  CFD  ->  STR(Altium), i_cfd(VHDL)
![](attachments/CFD_in_gate.png)


# ADC Calibrations
- Before ADC zero calibrations (gate is ~5.5 ns)
	- СFD in gate = 0 
		![](attachments/СFD_1.png)
		![](attachments/СFD_2.png)
	- CFD in gate = 1 
		![](attachments/СFD_3.png)
		![](attachments/СFD_4.png)
	- СFD in gate = 1
		![](attachments/СFD_5.png)
		![](attachments/СFD_6.png)
	- СFD in gate = 0
		![](attachments/СFD_7.png)
		![](attachments/СFD_8.png)
	- Notes
		- 12500  ~  ( -2.5 ns <-> 3ns ) 
		- 11000  ~  ( -4 ns <-> 1.5ns )
		- 9000   ~   ( -6 ns <-> -0.5ns )
# Select ADC A, ADC B, or both

| BC        | ![](attachments/image-24.png)                                                                                                                         |
| --------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| 100 BC    | ADCA or ADCB - To choose which one to use, set it to 1 or 2.<br><br>![](attachments/image-25.png)<br>![](attachments/image-27.png) |
| 101<br>BC | ADCA and ADCB                                                                                                                                         |

# STR and baseline
- ILA clock is 320[Mhz]
![](attachments/image-36.png)
![](attachments/image-42.png)
![](attachments/image-40.png)
- Second STR is baseline (ADC 0) (Before that, the calibration was on (ADC 1).)
# Baseline 
- If STR (baseline) arrives on channel every 16.736 (320 MHz), it means that channel (ADC A side or ADC B side) updates its baseline every 16.376 x 2 -> 51.175[us] x 2 = 102.35[us]. (in the best case)
# UCF
## ADC A - OK 
![](attachments/image-14.png)

## ADC B - OK
![](attachments/image-15.png)

## DI - OK
![](attachments/image-16.png)

## Clock 80 - OK
![](attachments/image-18.png)

## EV  - Not OK
cpld - set all pins ZERO
![](attachments/image-19.png)
![](attachments/image-20.png)
![](attachments/image-21.png)


#  Code from Warsaw gitub - simulation
EVOUT will be logical 1 if and only if c_count = "1111111" and cal_str ="1". But this conditional is true only 25 ns  (From this code it follows that EVNT have to go every 256 clock cycle (80 MHZ)) )
- cal_str
![](attachments/image-46.png)
- EV - every 256 clock cycle
![](attachments/image-47.png)
- EV - every 300 clock cycle
![](attachments/image-48.png)

# PM baseline register
![PM baseline register](attachments/image-49.png)
![PM baseline register fpga](attachments/image-50.png)
