#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status.

# Remove old files
echo 'Removing Old Files...'
rm -rf /usr/share/burpsuitepro
rm -rf /bin/burpsuitepro
rm -rf /home/*/bsp

# Clone repository
echo "Cloning coolgeek-ai bsp"
git clone https://github.com/coolgeek-ai/bsp.git

# Download Burpsuitepro Latest
echo "Downloading Burpsuitepro Latest..."
mkdir -p /usr/share/burpsuitepro
cp -r /home/*/bsp/loader.jar /usr/share/burpsuitepro

html=$(curl -s https://portswigger.net/burp/releases)
version=$(echo "$html" | grep -Po '(?<=/burp/releases/professional-community-)[0-9]+\-[0-9]+\-[0-9]+' | head -n 1)
link="https://portswigger-cdn.net/burp/releases/download?product=pro&type=Jar&version=&"

wget "$link" -O /usr/share/burpsuitepro/burpsuite_pro_v$version.jar --quiet --show-progress

# Execute Key Generator
echo "Starting Key Generator"
(java -jar /home/*/bsp/loader.jar) &

# Execute Burpsuitepro
echo "Executing Burpsuitepro with Key Generator"
cd /usr/share/burpsuitepro
echo "java --add-opens=java.desktop/javax.swing=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED -javaagent:$(pwd)/loader.jar -noverify -jar $(pwd)/burpsuite_pro_v$version.jar &" > burpsuitepro
chmod +x burpsuitepro
cp burpsuitepro /bin/burpsuitepro
(./burpsuitepro)
