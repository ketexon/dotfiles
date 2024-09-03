import subprocess
import sys
import json

if len(sys.argv) <= 1:
    sys.exit(1)

which = sys.argv[1]

if which == "gpu":
    # get GPU temp
    check_gpu = subprocess.run([
        "nvidia-smi",
        "--query-gpu=temperature.gpu",
        "--format=csv,noheader"
    ], capture_output = True)

    if check_gpu.returncode != 0:
        sys.exit(1)

    gpu_temp = check_gpu.stdout.decode().strip()
    print(f'{{ "text": "󰍹  {gpu_temp}C" }}')
elif which == "cpu":
    # get CPU temp
    check_cpu = subprocess.run([
        "sensors",
        "-j"
    ], capture_output=True)

    if check_cpu.returncode != 0:
        sys.exit(1)

    json = json.loads(check_cpu.stdout)
    cpu_keys = [key for key in json.keys() if key.startswith("k10")]
    if len(cpu_keys) == 0:
        print("No CPU found in sensors")
        sys.exit(1)

    cpu_key = cpu_keys[0]
    tctl = json[cpu_key]["Tctl"]["temp1_input"]
    tctl = int(tctl)
    print(f'{{ "text": "  {tctl}C" }}')
