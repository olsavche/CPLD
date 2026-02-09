---
category:
  - CERN ALICE FIT
---
# Oscilloscope measurements
## INR
### CLK20N / CLK80
![](attachments/tmp_000.png)
- CH1 - INTB_G_DRV (CLK20N)
- CH2 - ADCA_CLK (CLK80)
![](attachments/image-1.png)

### CLK20N / CLK40
![](attachments/tmp_001.png)
- CH1 - INTB_G_DRV (CLK20N)
- CH2 - Gate_STR1_i (CLK40)
![](attachments/image-4.png)
### CLK20N / GATE
![](attachments/tmp_003.png)
- CH1 - INTB_G_DRV (CLK20N)
- CH2 - D Flip-Flop PIN1 (GATE)
![](attachments/image-6.png)
## AGH
### CLK20N / CLK80
![](attachments/tmp_003-1.png)
- CH1 - INTB_G_DRV (CLK20N)
- CH2 - ADCA_CLK (CLK80)
![](attachments/image-2.png)
### CLK20N / CLK40
![](attachments/tmp_004.png)
- CH1 - INTB_G_DRV (CLK20N)
- CH2 - Gate_STR1_i (CLK40)
![](attachments/image-7.png)
### CLK20N / GATE
![](attachments/tmp_005.png)
- CH1 - INTB_G_DRV (CLK20N)
- CH2 - D Flip-Flop PIN1 (GATE)
![](attachments/image-5.png)

## Comparison INR and AGH

### CLK20N / CLK80
![](attachments/tmp_000.png)
![](attachments/tmp_003-1.png)


### CLK20N / CLK40
![](attachments/tmp_001.png)
![](attachments/tmp_004.png)

### CLK20N / GATE
![](attachments/image.png)
![](attachments/tmp_005.png)



# CS measurements
## INR CPLD
![](attachments/image-8.png)
## AGH CPLD
![](attachments/image-9.png)
## Comparison INR and AGH
![](attachments/image-10.png)

# Questions and Answers 

### Why do we need a gate?
- In my understanding, the gate is used  for background suppression.
- Physicists have determined (or measurements showed) that after the BC, the useful signal (СFD event (not backgr.)) is inside this  GATE time (±2.5 ns). This means that the CFD pulse must arrive inside this window GATE if an event happens. If the CFD pulse arrives outside this GATE, it is considered like background.”
![](attachments/image-29.png)


### How is a ~5 ns CFD gate generated? 
- CPLD output -> 40 MHz clock
![](attachments/image-28.png)

### Can a CFD pulse be shorter than 7 ns?   (For example 2 ns)
- Yes, because this signal captures the GATE in a D flip-flop (MC10EP52D)
![](attachments/image-27.png)
![](attachments/image-30.png)
- But CFD signal also comes to CPLD 
	- strb - CFD to CPLD
	- enai (Gate_STR1_o) - Gate latch
![](attachments/image-21.png)
![](attachments/image-22.png)
- Conclusion: The CFD signal may be so short that it is possible to see the Gate_STR1_o signal in the SPLD. (This also explains why we process the event on the falling edge.)
### Is the timing relationship between the GATE signal and the BC clock constant?
- Yes 
![](attachments/image-26.png)
![](attachments/image-25.png)
![](attachments/image-20.png)

### What time is it between CLK80MHZ and GATE ? 
![](attachments/image-31.png)
![](attachments/image-32.png)
![](attachments/image-33.png)
- 12.5 ns(GATE) - 2.5ns(80MHZ) = ~10ns 
- ![](attachments/image-34.png)

### If the timing relationship between the Gate signal and the BC clock changes, will this affect the charge measurement performed by the integrators or cpld? 
- No 

### What affects variations in the data output from the CPLD (signal integration) 
1. Phase relationship between the 80 MHz and 20 MHz (P and N) signals from the CPLD.
2. Pulse width of the 20 MHz (P and N) signals.

# ToDo

## 3 BC before and 1 BC afer
![](image-16.png)

# ILA measurements
## CPLD INR
### CSTR pattern
- After turning off and on the electronics - CSTR pattern changes
- I did not observe any correlations between the signals. Signals are independent.
![](attachments/image-35.png)
![](attachments/image-36.png)
### СFD in Gate CPLD INR
-  ILA clock = 320[MHz]
- CSTR1 and mt_cou
![](attachments/image-37.png)
- CSTR2 and mt_cou
![](attachments/image-38.png)
- CSTR3 and mt_cou
![](attachments/image-39.png)
- .........
- CSTR12 and mt_cou
![](attachments/image-40.png)

### CFD in gate
![](attachments/image-41.png)

# Other
## INR slides
[CFD_ADC_Timing](image-11.png), [Timing_and_Charge_Measurement_Scheme](image-12.png)

## PM baseline register 
[RegMap](attachments/image-3.png), [PmVHDL](attachments/image-14.png)

# Links 
[Warsaw CPLD](https://github.com/alice-fit-fee-upgrade/FIT_PM_GW_CPLD )
