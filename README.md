Repository del progetto di Reti Logiche anno 2024/2025.
Marco Zanatta - Andrea Pollini - Daniele De Marco - Mattia Pistollato

# VHDL-fluid-simulator
Simulazione semplificata e interattiva di fluidi viscosi, visualizzata su una matrice led 16x16 Toshiba. Utilizzando un modulo con accelerometro e giroscopio in modo che la simulazione del fluido possa reagire alle rotazioni e ai movimenti del dispositivo.

Implementato su board FPGA Xilinx Artix7 in VHDL.

## Compilazione e Simulazione
> Per la compilazione e la simulazione utilizziamo il compilatore `ghdl` e il visualizzatore `gtkwave`.

Questo comando analizza il codice VHDL, controllando sintassi e semantica del codice delle sources e lo compila in un formato intermedio che può essere successivamente simulato o elaborato (*.o):
```bash
ghdl -a --work=xil_defaultlib Fluid_dynamic.srcs/sources_1/new/*.vhd
```

Questo fa lo stesso ma per le testbench:
```bash
ghdl -a Fluid_dynamic.srcs/sim_1/new/*.vhd
```

Questo comando elabora il progetto, cioè collega le varie parti del progetto tra loro (praticamente un linker):
```bash
ghdl -e nome_testbench # senza estensione
```

Esegue la simulazione sul file di output del comando precedente:
```bash
ghdl -r nome_testbench --wave=wave.ghw --stop-time=1ms
```
qui: 
- `wave.ghw` è il file in cui verrà salvata la simulazione,
- `--stop-time` è il tempo di simulazione.

Infine, per visualizzare la simulazione:
```bash
gtkwave wave.ghw
```