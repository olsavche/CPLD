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
- In my opinion, the phase between these signals will change every time the CPLD code changes (the phase between CLK80 and CLK40 will change). (CLK40 + analog PM parts - gives GATE)
![](attachments/image.png)
![](attachments/tmp_005.png)
![](attachments/image-61.png)


# CS measurements

![](attachments/image-60.png)
## INR CPLD
![](attachments/image-8.png)
## AGH CPLD
![](attachments/image-9.png)
## Comparison INR and AGH
![](attachments/image-10.png)

# Questions and Answers 

### Why do we need a gate?
- In my understanding, the gate is used  for background suppression.
- Physicists have determined (or measurements showed) that after the BC, the useful signal (СFD event (not backgr.)) is inside this  GATE time (±2.5 ns). This means that the CFD pulse must arrive inside this window GATE if an event happens. If the CFD pulse arrives outside this GATE, it is considered like background.
![](attachments/image-29.png)


### How is a ~5 ns CFD gate generated? 
- CPLD output -> 40 MHz clock
![](attachments/image-28.png)

### Can a CFD pulse be shorter than 7 ns?   (For example 2 ns)
- Yes, because this signal captures the GATE in a D flip-flop (MC10EP52D) (The time limits for the MC10EP52D can be found in the datasheet.) (We can also look at the time constraints for CPLDs)
- Mezzanine pcb 
![](attachments/image-27.png)
- PM pcb
![](attachments/image-30.png)
- But CFD signal also comes to CPLD 
	- strb - CFD to CPLD
	- enai (Gate_STR1_o) - Gate latch
![](attachments/image-21.png)
![](attachments/image-22.png)
- Conclusion: The CFD signal may be so short that it is possible to see the Gate_STR1_o signal in the CPLD. (This also explains why we process the event on the falling edge.) 

### Is the timing relationship between the GATE signal and the BC clock constant?
- Yes 
![](attachments/image-26.png)
![](attachments/image-25.png)
![](attachments/image-20.png)

### What time is it between CLK80MHZ and GATE ? 
![](attachments/image-31.png)
![](attachments/image-32.png)
![](attachments/image-33.png)
- ~12.5 ns(GATE)  -  ~2.5ns(80MHZ) = ~10ns 
- ![](attachments/image-34.png)

### If the timing relationship between the Gate signal and the BC clock changes, will this affect the charge measurement performed by the integrators or cpld? 
- No (if CFD in GATE)
- If CFD is outside the gate, we will not measure anything (baseline).

### What affects variations in the data output from the CPLD (signal integration) 
1. Phase relationship between the 80 MHz and 20 MHz (P and N) signals from the CPLD.
2. Pulse width of the 20 MHz (P and N) signals.

# ToDo
## Check again whether the calibration works on the AGH CPLD 
- CFD zero calibration
## Vertex (zero) ? Plateau ? 
## Measure the EV signal using an oscilloscope.  (Also measure during calibration)
![EV](attachments/image-58.png)

## 3 BC before and 1 BC afer
![3_BC_before_1_BC_afer](attachments/image-16.png)

# ILA measurements
## CPLD 
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

### Gate time length
#### Before ADC zero calibrations (gate is ~5.5 ns) (Oscilloscope measurements also confirm this)
- СFD in gate = 0 
	- ![](attachments/image-23.png)
	- ![](attachments/image-43.png)
- CFD in gate = 1
	- ![](attachments/image-42.png)
	- ![](attachments/image-44.png)

- СFD in gate = 1
	- ![](attachments/image-45.png)
	- ![](attachments/image-46.png)
- СFD in gate = 0
	- ![](attachments/image-47.png)
	- ![](attachments/image-48.png)
- Notes
	12500  ~  ( -2.5 ns <-> 3ns ) 
	11000  ~  ( -4 ns <-> 1.5ns )
	9000   ~   ( -6 ns <-> -0.5ns )

### CPLD clock signals 
![](attachments/image-49.png)

### UCF
- ADC A - OK  [ADC_A](attachments/image-50.png)
- ADC B - OK [ADC_B](attachments/image-53.png)
- DI - OK [DI](attachments/image-54.png)
- Clock 80 - OK [Clock_80](attachments/image-55.png)
- EV  - Not OK [EV](attachments/image-56.png)
# Links 
[Warsaw CPLD](https://github.com/alice-fit-fee-upgrade/FIT_PM_GW_CPLD )



