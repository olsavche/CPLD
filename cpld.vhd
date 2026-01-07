
--=================================================================================================================================
-- Title                : cpld
-- File version         : v1.0
-- Author               : Oleksandr Savchenko
-- Company              : AGH University of Kraków 
-- Created              : 05.01.2026
-- ToDo <N>             : 1
-- Notes                : - 
--=================================================================================================================================


-- ================================================================================================================================
-- | Signal name        | Dir | Type / Width                 | Altium       | FPGA       | CPLD pin <UCF>                         |
-- ================================================================================================================================
-- | i_clk_80mhz        | in  | std_logic                    | ADC_CLK      | -          | <27>                                   |
-- | i_cfd              | in  | std_logic                    | STR          | -          | <63>                                   |
-- | i_gate_latch       | in  | std_logic                    | ENA          | -          | <64>                                   |
-- | i_adc_a            | in  | std_logic_vector(11 downto 0)| ADC_A_D<N>   | -          | <18><19><22><24><23><28-30><32-35> LSB |
-- | i_adc_b            | in  | std_logic_vector(11 downto 0)| ADC_B_D<N>   | -          | <36><37><39-44><46><49><50><52> LSB    |
-- |--------------------|-----|------------------------------|--------------|------------|----------------------------------------|
-- | o_adc_data         | out | std_logic_vector(12 downto 0)| DI<N>        | DI<N>      | <85-87><89-97><99> LSB                 |
-- | o_gate_clk_40mhz   | out | std_logic                    | Gate_STR1_1  | -          | <81>                                   |
-- | o_intg_clk_n_20mhz | out | std_logic                    | INTG_G_DRV   | -          | <54>                                   |
-- | o_intg_clk_p_20mhz | out | std_logic                    | INTA_G_DRV   | -          | <53>                                   |
-- | o_data_valid       | out | std_logic                    | STR1         | STR<N>     | <82>                                   |
-- ================================================================================================================================


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;

entity cpld is 
    Port( 
            i_clk_80mhz         : in  std_logic;
            i_cfd               : in std_logic;
            i_gate_latch        : in std_logic;
            i_adc_a             : in std_logic_vector(11 downto 0);
            i_adc_b             : in std_logic_vector(11 downto 0);
            o_adc_data          : out std_logic_vector(12 downto 0);
            o_gate_clk_40mhz    : out std_logic;
            o_intg_clk_n_20mhz  : out std_logic;
            o_intg_clk_p_20mhz  : out std_logic;
            o_data_valid        : out std_logic);
end cpld;

architecture Behavioral of cpld is

signal s_clk40, s_clk20                 : std_logic                     := '0';
signal s_strobe,s_strobe_2, s_strobe_3  : STD_LOGIC                     := '0';             -- < -- i_cfd.
signal s_delay_strobe                   : std_logic_vector(7 downto 0)  := (others => '0'); -- < -- ADC latency is 8 clock. 


signal cnt                              : std_logic_vector(11 downto 0) := (others => '0'); -- < -- 51.175 µs.
signal s_data_valid_cnt                 : std_logic_vector(2 downto 0)  := (others => '0'); -- < -- 3 BC before.
signal s_calibration_strobe             : std_logic;

begin

----------------------------------------------------------------------------------
---- clock < s_clk40 > and < s_clk20 >.
----------------------------------------------------------------------------------
process(i_clk_80mhz)
begin
  if falling_edge(i_clk_80mhz) then
    s_clk40 <= not s_clk40;
        if s_clk40 = '1' then
          s_clk20 <= not s_clk20;
        end if;
  end if;
end process;

---------------------------------------------------------------------------------
---- < i_cfd >.
----------------------------------------------------------------------------------
process(i_cfd)
begin
  if falling_edge(i_cfd) then
    if i_gate_latch = '1' then    -- Gate_STR1_o.
      s_strobe <= not s_strobe;   -- Event toggle flag (every i_cfd event flips a bit --> s_strobe)
                                  -- necessary until s_strobe is "seen" by synchronous logic.
    end if;
  end if;
end process;

process(i_clk_80mhz)             -- s_strobe to i_clk_80mhz clock domain and also "bind" it to a falling edge phase s_clk40.
begin
  if falling_edge(i_clk_80mhz) then
    if s_clk40 = '0' then
      s_strobe_2 <= s_strobe;
    end if;
  end if;
end process;

process(i_clk_80mhz)
begin
  if rising_edge(i_clk_80mhz) then
    s_strobe_3 <= s_strobe_2;                       -- s_strobe_3 is the previous value of s_strobe_2 which is shifted by 6.25[ns].
	 s_delay_strobe(0) <= (s_strobe_2 xor s_strobe_3)	-- edge detect for toggle flag.
							 or (s_calibration_strobe); 
    s_delay_strobe(7 downto 1) <= s_delay_strobe(6 downto 0);
  end if;
end process;

----------------------------------------------------------------------------------
---- adc data.
----------------------------------------------------------------------------------
process(i_clk_80mhz)
begin
    if rising_edge(i_clk_80mhz) then            -- adc clock.
		  if s_delay_strobe(6) = '1' then
            if s_clk20 = '1' then               -- i_adc_a or i_adc_b.
                o_adc_data <= '0' & i_adc_a;    -- '0' means i_adc_a.
            else
                o_adc_data <= '1' & i_adc_b;    -- '1' means i_adc_a.
            end if;
        end if;
    end if;
end process;

----------------------------------------------------------------------------------
---- baseline.
---------------------------------------------------------------------------------- 
process(i_clk_80mhz) begin
    if rising_edge(i_clk_80mhz) then
        if cnt = 4093 then                      -- 51.175 µs
            cnt <= (others => '0');
            if s_data_valid_cnt = "000" then    -- < -- 3 BC before (after o_data_valid).
                s_calibration_strobe <= '1';    -- < -- Start baseline after 87.5 ns (7 cycles of i_clk_80mhz).
            else
                s_calibration_strobe <= '0';
            end if;
        else 
            cnt <= cnt +1;
            s_calibration_strobe <= '0';
        end if ;
    end if;
end process;

process(i_clk_80mhz) begin
    if rising_edge(i_clk_80mhz) then 
        if s_delay_strobe(7) = '1' then        -- < -- o_data_valid.
            s_data_valid_cnt <= "110";         -- < -- 3 BC before ( ToDo ).
        elsif s_data_valid_cnt = "000" then
            s_data_valid_cnt <= s_data_valid_cnt;
        else
            s_data_valid_cnt <= s_data_valid_cnt - 1;
        end if;
    end if;
end process;

----------------------------------------------------------------------------------
---- <=
----------------------------------------------------------------------------------
o_gate_clk_40mhz        <= s_clk40;
o_intg_clk_n_20mhz 	    <= not s_clk20;
o_intg_clk_p_20mhz 	    <= s_clk20;
o_data_valid	          <= s_delay_strobe(7);

end Behavioral;