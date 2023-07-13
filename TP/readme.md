# button_reader - Corre pero anda mal

ghdl -a  ./funciones.vhd ./mod_m_counter_prog.vhd ./button_reader.vhd ./tests/button_reader_tb.vhd
ghdl -e button_reader_tb
ghdl -r button_reader_tb --vcd=results/button_reader_tb.vcd

# signal_to_morse - Error durante elaboacion

ghdl -a ./signal_to_morse.vhd ./tests/signal_to_morse_tb.vhd
ghdl -e signal_to_morse_tb
ghdl -r signal_to_morse_tb --vcd=results/signal_to_morse_tb.vcd

# morse_buffer - Crear testbench

# morse_to_ascii_translator - Hay un typo entre las opciones