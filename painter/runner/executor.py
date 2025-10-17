import subprocess

process = subprocess.Popen(
    ["cmd.exe", "/c", "script.bat"],
    stdout=subprocess.PIPE,
    stderr=subprocess.STDOUT,
    text=True
)

for line in process.stdout:
    print(line.strip())

process.wait()
print("Selesai!")