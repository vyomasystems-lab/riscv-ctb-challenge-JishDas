export PYTHONPATH=/tools/riscv-dv/pygen:$PYTHONPATH
export PATH=/tools/spike_hyp_latest/bin:$PATH
pip install --upgrade pip
pip install aapg
pip install -r /tools/riscv-dv/requirements.txt