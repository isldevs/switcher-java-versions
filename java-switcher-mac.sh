#!/bin/bash
# ============================================
#       JAVA VERSION SWITCHER (macOS M1/M2)
# ============================================

# Hacker-style green text
GREEN="\033[0;32m"
CYAN="\033[0;36m"
RED="\033[0;31m"
RESET="\033[0m"

echo -e "${GREEN}============================================"
echo -e "          JAVA VERSION SWITCHER"
echo -e "============================================${RESET}"
echo

# Directories to search for JDKs
JAVA_DIRS=(
    "/Library/Java/JavaVirtualMachines"
    "$HOME/Library/Java/JavaVirtualMachines"
)

# Collect installed JDKs (ignore JREs)
JDK_LIST=()
for DIR in "${JAVA_DIRS[@]}"; do
    if [ -d "$DIR" ]; then
        for jdk in "$DIR"/*; do
            if [[ "$(basename "$jdk")" != *jre* ]]; then
                JDK_LIST+=("$jdk/Contents/Home")
            fi
        done
    fi
done

if [ ${#JDK_LIST[@]} -eq 0 ]; then
    echo -e "${RED}[X] No JDK installations found.${RESET}"
    exit 1
fi

# List JDKs with fake "hacker scanning" effect
echo -e "${CYAN}[*] Scanning for installed Java versions...${RESET}"
for i in "${!JDK_LIST[@]}"; do
    sleep 0.1
    echo -e "   [$((i+1))] ${JDK_LIST[$i]}"
done

echo
read -p ">> Enter the number of the Java version to switch to (1-${#JDK_LIST[@]}): " CHOICE

# Validate input
if ! [[ "$CHOICE" =~ ^[0-9]+$ ]] || [ "$CHOICE" -lt 1 ] || [ "$CHOICE" -gt ${#JDK_LIST[@]} ]; then
    echo -e "${RED}[X] Invalid choice.${RESET}"
    exit 1
fi

SELECTED_JAVA="${JDK_LIST[$((CHOICE-1))]}"

# Update shell config
SHELL_RC="$HOME/.zshrc"
if [ -n "$BASH_VERSION" ]; then
    SHELL_RC="$HOME/.bash_profile"
fi

# Remove previous JAVA_HOME lines
sed -i '' '/^export JAVA_HOME=/d' "$SHELL_RC"
sed -i '' '/^export PATH=.*JAVA_HOME\/bin/d' "$SHELL_RC"

# Add new JAVA_HOME and PATH
echo "export JAVA_HOME=\"$SELECTED_JAVA\"" >> "$SHELL_RC"
echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> "$SHELL_RC"

# Apply changes to current shell
export JAVA_HOME="$SELECTED_JAVA"
export PATH="$JAVA_HOME/bin:$PATH"

echo
echo -e "${GREEN}[OK] Successfully switched Java version${RESET}"
echo "JAVA_HOME = $JAVA_HOME"
echo "PATH      = $JAVA_HOME/bin"
echo
echo -e "${CYAN}Open a new terminal or run 'source $SHELL_RC' to apply changes permanently.${RESET}"
