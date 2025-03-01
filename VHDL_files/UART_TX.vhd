LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY UART_TX is
		generic (
						c_clock_freq : integer := 100_000_000;
						c_baud_rate  : integer := 115_200;
						c_stop_bit   : integer := 2
		);		
		port (			-- INPUTS
						clk          	: in std_logic; -- 100 MHz
						tx_start_bit    : in std_logic;
						tx_data_in   	: in std_logic_Vector(7 downto 0); 
						-- OUTPUTS
						tx_data_output	: out std_logic; -- tx output wire
						tx_done_tick  	: out std_logic  -- Is comm done ?					
		);
end UART_TX;


architecture Behavioral of UART_TX Is

-- CONSTANT DECLERATIONS 

constant c_bit_timer_limit : integer := c_clock_freq/c_baud_rate; -- 100MHz/115200Baud ~ 8.68 us
constant c_stop_bit_limit  : integer := (c_clock_freq/c_baud_rate)*c_stop_bit; -- 2 bit delay

-- SIGNAL DECLERATIONS 
signal bit_timer 		: integer range 0 to c_bit_timer_limit := 0;
signal bit_done_counter : integer range 0 to 7 				 := 0;
signal shifter_register : std_logic_vector (7 downto 0) := (others => '0'); --  

type states is (TX_IDLE_STATE, TX_START_FRAME, TX_DATA_TRANSFER, TX_STOP_FRAME);
signal state : states := TX_IDLE_STATE;

begin


process(clk)
	begin
				if (rising_edge(clk)) then				
				
						case state is
						
								when TX_IDLE_STATE    =>
								
											tx_data_output   <= '1'; -- comm wire is disabled
											tx_done_tick     <= '0'; 
											bit_done_counter <= 0;
											
											if (tx_start_bit = '1') then
											
													tx_data_output <= '0';
													state <= TX_START_FRAME;
													shifter_register <= tx_data_in;
											end if;
											
								when TX_START_FRAME   => 
								
											if (bit_timer = c_bit_timer_limit - 1) then -- 1 bit için geçmesi gereken time
													
													tx_data_output 	<= shifter_register(0); -- firstly, least significant bit
													shifter_register(7) <= shifter_register(0);
													shifter_register(6 downto 0)  <= shifter_register(7 downto 1);
													bit_timer 		<= 0;
													state 			<= TX_DATA_TRANSFER;
													
											else
													bit_timer <= bit_timer + 1;
											end if;
								
								when TX_DATA_TRANSFER => 
								
													if (bit_done_counter = 7) then
													
															if (bit_timer = c_bit_timer_limit - 1) then
															
																	state <= TX_STOP_FRAME;
																	bit_timer <= 0;
																	bit_done_counter <= 0;
																	tx_data_output <= '1';
															
															else														
																	bit_timer <= bit_timer + 1;
															
															end if;
													else													
															if (bit_timer = c_bit_timer_limit - 1) then															
																	tx_data_output 	<= shifter_register(0);
																	shifter_register(7) <= shifter_register(0);
																	shifter_register(6 downto 0)  <= shifter_register(7 downto 1);
																	bit_timer <= 0;
																	bit_done_counter <= bit_done_counter + 1;															
															else
																	bit_timer <= bit_timer + 1;
															end if;
													
													end if;
																		
								when TX_STOP_FRAME    => 
								
											if (bit_timer = c_stop_bit_limit - 1) then
													
													state <= TX_IDLE_STATE;
													bit_timer <= 0;
													tx_done_tick <= '1'; -- INFO : MSB is transferred successfully.
													
											else
													bit_timer <= bit_timer + 1;
											end if;
								
								when others           => 
								
											state <= TX_IDLE_STATE; -- OTHERS STATES
																	
						end case;										
				end if;
end process;

end Behavioral;