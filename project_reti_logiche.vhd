library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity project_reti_logiche is
    port(
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_start : in std_logic;
        i_add : in std_logic_vector(15 downto 0);
        i_k : in std_logic_vector(9 downto 0);
        
        o_done : out std_logic;
        
        o_mem_addr : out std_logic_vector(15 downto 0);
        i_mem_data : in std_logic_vector(7 downto 0);
        o_mem_data : out std_logic_vector(7 downto 0);
        o_mem_we : out std_logic;
        o_mem_en : out std_logic
    );
end project_reti_logiche;

architecture project_reti_logiche_arch of project_reti_logiche is
component fsm is
    port(
        i_start : in std_logic;
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_mem_data : in std_logic_vector(7 downto 0);
        val_k : in std_logic_vector(9 downto 0);
        val_add : in std_logic_vector(15 downto 0);
        val_res_old : in std_logic_vector(7 downto 0);
        val_c : in std_logic_vector(4 downto 0);
        
        o_done : out std_logic;
        o_mem_addr : out std_logic_vector(15 downto 0);
        o_mem_data : out std_logic_vector(7 downto 0);
        o_mem_we : out std_logic;
        o_mem_en : out std_logic;
        decrem_k : out std_logic;
        en_k : out std_logic;
        increm_add : out std_logic;
        en_add : out std_logic;
        val_res_new : out std_logic_vector(7 downto 0);
        res_we : out std_logic;
        decrem_c : out std_logic;
        rst_c : out std_logic;
        rst_all : out std_logic
    );
end component fsm;

component count_k is
    port(
        i_k : in std_logic_vector(9 downto 0);
        decrem_k : in std_logic;
        i_clk : in std_logic;
        rst : in std_logic;
        en_k : in std_logic;
        val_k : out std_logic_vector(9 downto 0)
    );
end component count_k;

component reg_add is
    port(
        i_add : in std_logic_vector(15 downto 0);
        increm_add : in std_logic;
        i_clk : in std_logic;
        rst : in std_logic;
        en_add : in std_logic;
        val_add : out std_logic_vector(15 downto 0)
    );
end component reg_add;

component reg_res is
    port(
        val_res_new : in std_logic_vector(7 downto 0);
        res_we : in std_logic;
        i_clk : in std_logic;
        rst : in std_logic;
        val_res_old : out std_logic_vector(7 downto 0)
    );
end component reg_res;

component reg_c is
    port(
        decrem_c : in std_logic;
        i_clk : in std_logic;
        rst : in std_logic;
        rst_c : in std_logic;
        val_c : out std_logic_vector(4 downto 0)
    );
end component reg_c;

--segnali per collegare i componenti
signal restart : std_logic;
signal p_val_k : std_logic_vector(9 downto 0);
signal p_decrem_k : std_logic;
signal p_en_k : std_logic;
signal p_val_add : std_logic_vector(15 downto 0);
signal p_increm_add : std_logic;
signal p_en_add : std_logic;
signal p_val_res_new : std_logic_vector(7 downto 0);
signal p_val_res_old : std_logic_vector(7 downto 0);
signal p_res_we : std_logic;
signal p_val_c : std_logic_vector(4 downto 0);
signal p_decrem_c : std_logic;
signal p_rst_c : std_logic;
signal done : std_logic;

begin

project_fsm : fsm port map(
    i_start => i_start,
    i_clk => i_clk,
    i_rst => i_rst,
    i_mem_data => i_mem_data,
    val_k => p_val_k,
    val_add => p_val_add,
    val_res_old => p_val_res_old,
    val_c => p_val_c,
    
    o_done => done,
    o_mem_addr => o_mem_addr,
    o_mem_data => o_mem_data,
    o_mem_we => o_mem_we,
    o_mem_en => o_mem_en,
    decrem_k => p_decrem_k,
    en_k =>p_en_k,
    increm_add => p_increm_add,
    en_add => p_en_add,
    val_res_new => p_val_res_new,
    res_we => p_res_we,
    decrem_c => p_decrem_c,
    rst_c => p_rst_c,
    rst_all => restart
);
 
project_count_k : count_k port map(
    i_k => i_k,
    decrem_k => p_decrem_k,
    i_clk => i_clk,
    rst => restart,
    en_k => p_en_k,
    val_k => p_val_k
);

project_reg_add : reg_add port map(
    i_add => i_add,
    increm_add => p_increm_add,
    i_clk => i_clk,
    rst => restart,
    en_add => p_en_add,
    val_add => p_val_add
);

project_reg_res : reg_res port map(
    val_res_new => p_val_res_new,
    res_we => p_res_we,
    i_clk => i_clk,
    rst => restart,
    val_res_old => p_val_res_old
);

project_reg_c : reg_c port map(
    decrem_c => p_decrem_c,
    i_clk => i_clk,
    rst => restart,
    rst_c => p_rst_c,
    val_c => p_val_c
);
o_done <= done;
end project_reti_logiche_arch;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

entity fsm is
    port(
        i_start : in std_logic;
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_mem_data : in std_logic_vector(7 downto 0);
        val_k : in std_logic_vector(9 downto 0);
        val_add : in std_logic_vector(15 downto 0);
        val_res_old : in std_logic_vector(7 downto 0);
        val_c : in std_logic_vector(4 downto 0);
        
        o_done : out std_logic;
        o_mem_addr : out std_logic_vector(15 downto 0);
        o_mem_data : out std_logic_vector(7 downto 0);
        o_mem_we : out std_logic;
        o_mem_en : out std_logic;
        decrem_k : out std_logic;
        en_k : out std_logic;
        increm_add : out std_logic;
        en_add : out std_logic;
        val_res_new : out std_logic_vector(7 downto 0);
        res_we : out std_logic;
        decrem_c : out std_logic;
        rst_c : out std_logic;
        rst_all : out std_logic
    );
end fsm;

architecture fsm_arch of fsm is
    type S is (
               INIT,
               ENABLE_K,
               READ_K,
               READ_ADD,
               SEND_TO_MEM1,
               WAIT_FOR_MEM1,
               READ_MEM,
               UPDATE_RES,
               SEND_TO_MEM2,
               WAIT_FOR_C,
               READ_C,
               WRITE_MEM,
               INCREASE_ADD,
               END_SEQ,
               RESET);
    signal curr_state : S;

begin
    process(i_rst, i_clk)
    begin
        if i_rst = '1' then
            curr_state <= RESET;     
        elsif i_clk'event and i_clk = '1' then
            case curr_state is
                when RESET =>
                    curr_state <= INIT;
                when INIT =>
                    if i_start = '1' then
                        curr_state <= ENABLE_K;
                    elsif i_start = '0' then
                        curr_state <= INIT;
                    end if;
                 
                 when ENABLE_K =>
                    curr_state <= READ_K;
                 when READ_K =>
                    if val_k = "0000000000" then 
                        curr_state <= END_SEQ;
                    else 
                        curr_state <= READ_ADD; 
                    end if;
                    
                 when READ_ADD =>
                    curr_state <= SEND_TO_MEM1;
                    
                 when SEND_TO_MEM1 =>
                    curr_state <= WAIT_FOR_MEM1;
                 
                 when WAIT_FOR_MEM1 =>
                    curr_state <= READ_MEM;
                    
                 when READ_MEM =>
                    if i_mem_data = "00000000" then 
                        curr_state <= SEND_TO_MEM2;
                    else
                        curr_state <= UPDATE_RES;
                    end if;
                    
                 when SEND_TO_MEM2 =>
                    curr_state <= WAIT_FOR_C;
                    
                 when UPDATE_RES =>
                    curr_state <= WAIT_FOR_C;
                 
                 when WAIT_FOR_C =>
                    curr_state <= READ_C;
                 
                 when READ_C =>
                    curr_state <= WRITE_MEM;
                    
                 when WRITE_MEM =>
                    curr_state <= INCREASE_ADD;
                    
                 when INCREASE_ADD =>
                    curr_state <= READ_K;
                    
                 when END_SEQ =>
                    if i_start = '0' then
                        curr_state <= RESET;
                    else
                        curr_state <= END_SEQ;
                    end if;       
             end case;       
        end if;
    end process;
    
    process(curr_state)
    begin
        o_done <= '0';
        o_mem_addr <= (others => '0');
        o_mem_data <= (others => '0');
        o_mem_we <= '0';
        o_mem_en <= '0';
        decrem_k <= '0';
        en_k <= '0';
        increm_add <= '0';
        en_add <= '0';
        val_res_new <= (others => '0');
        res_we <= '0';
        decrem_c <= '0';
        rst_all <= '0';
        rst_c <= '0';
        
        case curr_state is 
            when ENABLE_K =>
                en_add <= '1';
                en_k <= '1';
            
            when READ_ADD =>
                en_add <= '0';
                en_k <= '0';
                decrem_k <= '1';
                
            when SEND_TO_MEM1 =>
                o_mem_addr <= val_add;
                o_mem_we <= '0';
                o_mem_en <= '1';
                decrem_k <= '0';
            
            when UPDATE_RES =>
                rst_c <= '1';
                val_res_new <= i_mem_data;
                res_we <= '1';
                o_mem_en <= '0';
                
            when SEND_TO_MEM2 =>
                o_mem_addr <= val_add;
                o_mem_we <= '1';
                o_mem_en <= '1';
                o_mem_data <= val_res_old;
                decrem_c <= '1';
                
            when WAIT_FOR_C =>
                increm_add <= '1';
                
            when READ_C =>
                increm_add <= '0';
                rst_c <= '0';
                decrem_c <= '0';
                res_we <= '0';
                
            when WRITE_MEM =>
                o_mem_addr <= val_add;
                o_mem_we <= '1';
                o_mem_en <= '1';
                o_mem_data <= std_logic_vector("00000000" + unsigned(val_c));
                
            when INCREASE_ADD =>
                increm_add <= '1';
                o_mem_we <= '0';
                o_mem_en <= '0';
                
            when END_SEQ =>
                o_done <= '1';

            when RESET =>
                o_done <= '0';
                rst_c <= '0';
                rst_all <= '1';
                     
            when others =>
                o_done <= '0';
                o_mem_addr <= (others => '0');
                o_mem_data <= (others => '0');
                o_mem_we <= '0';
                o_mem_en <= '0';
                decrem_k <= '0';
                en_k <= '0';
                increm_add <= '0';
                en_add <= '0';
                val_res_new <= (others => '0');
                res_we <= '0';
                decrem_c <= '0';
                rst_all <= '0';
                rst_c <= '0';   
                
        end case;     
    end process;

end fsm_arch;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.08.2024 16:21:39
-- Design Name: 
-- Module Name: count_k - count_k_arch
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity count_k is
  port (
        i_k : in std_logic_vector(9 downto 0);
        decrem_k : in std_logic;
        i_clk : in std_logic;
        rst : in std_logic;
        en_k : in std_logic;
        
        val_k : out std_logic_vector(9 downto 0)
  );
end count_k;

architecture count_k_arch of count_k is
signal stored_value : std_logic_vector(9 downto 0);
begin
process(i_clk, rst)
begin
    if rst = '1' then 
        stored_value <= (others => '0');
    elsif i_clk'event and i_clk = '1' then
        if en_k = '1' then 
            stored_value <= i_k;
        elsif decrem_k = '1' then
            stored_value <= std_logic_vector(unsigned(stored_value) - 1);
        end if;
    end if;        
end process;
val_k <= stored_value;


end count_k_arch;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.03.2024 12:59:42
-- Design Name: 
-- Module Name: reg_add - reg_add_arch
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

entity reg_add is
    port( 
        i_add : in std_logic_vector(15 downto 0);
        increm_add : in std_logic;
        i_clk : in std_logic;
        rst : in std_logic;
        en_add : in std_logic;
        
        val_add : out std_logic_vector(15 downto 0)

    );
end reg_add;

architecture reg_add_arch of reg_add is
signal stored_value : std_logic_vector(15 downto 0);
begin
process(i_clk, rst)
begin
    if rst = '1' then 
        stored_value <= (others => '0');
    elsif i_clk'event and i_clk = '1' then
        if en_add = '1' then 
            stored_value <= i_add;
        elsif increm_add = '1' then
            stored_value <= std_logic_vector(unsigned(stored_value) + 1);
        end if;
    end if;        
end process;
val_add <= stored_value;


end reg_add_arch;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.08.2024 16:54:14
-- Design Name: 
-- Module Name: reg_res - reg_res_arch
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg_res is
    port(
        val_res_new : in std_logic_vector(7 downto 0);
        res_we : in std_logic;
        --res_re : in std_logic;
        i_clk : in std_logic;
        rst : in std_logic;
        
        val_res_old : out std_logic_vector(7 downto 0)
    );
end reg_res;

architecture reg_res_arch of reg_res is
signal stored_value : std_logic_vector(7 downto 0);
begin
    process(rst, i_clk)
    begin
        if rst = '1' then 
            stored_value <= (others => '0');
        elsif i_clk'event and i_clk = '1' then
            if res_we = '1' then
                stored_value <= val_res_new;
            end if;
        end if;
    end process;
    val_res_old <= stored_value;

end reg_res_arch;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.08.2024 16:55:02
-- Design Name: 
-- Module Name: reg_c - reg_c_arch
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reg_c is
    port(
        decrem_c : in std_logic;
        i_clk : in std_logic;
        rst : in std_logic;
        rst_c : in std_logic;
        
        val_c : out std_logic_vector(4 downto 0)
    );
end reg_c;

architecture reg_c_arch of reg_c is
signal stored_value : std_logic_vector(4 downto 0);
begin
    process(i_clk, rst)
    begin
        if rst = '1' then 
            stored_value <= (others => '0');
        elsif i_clk'event and i_clk = '1' then
            if decrem_c = '1' then
                if unsigned(stored_value) > 0 then
                    stored_value <= std_logic_vector(unsigned(stored_value) - 1);
                end if;    
            elsif rst_c = '1' then
                stored_value <= (others => '1');
            end if;
        end if;
    end process;
val_c <= stored_value;
end reg_c_arch;