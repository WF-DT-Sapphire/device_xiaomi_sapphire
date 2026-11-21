patch_ime_navbar() {
    local arq="frameworks/base/packages/overlays/NavigationBarModeGesturalOverlay/res/values/config.xml"

    [ -f "$arq" ] || {
        echo -e "${YELLOW}Arquivo não encontrado: $arq${RESET}"
        return 1
    }

    grep -qE 'name="config_imeDrawsImeNavBar">[[:space:]]*false' "$arq" \
        && { echo -e "${GREEN}Patch IME navbar já aplicado${RESET}"; return 0; }

    sed -i -E 's|(name="config_imeDrawsImeNavBar">)[[:space:]]*true|\1false|' "$arq" \
        || { echo -e "${RED}sed falhou em $arq${RESET}"; return 1; }

    grep -qE 'name="config_imeDrawsImeNavBar">[[:space:]]*false' "$arq" \
        && { echo -e "${GREEN}Patch IME navbar aplicado${RESET}"; return 0; } \
        || { echo -e "${RED}sed rodou mas o valor não mudou${RESET}"; return 1; }
}; patch_ime_navbar



gofile_install()
{
    echo -e "${YELLOW}Installing gofile upload tool...${RESET}"
    wget -q https://raw.githubusercontent.com/kenway214/GoFile-Upload-Script/master/upload.sh \
        -O "$TARGET_DIR/gofile" && chmod +x "$TARGET_DIR/gofile" || error_exit "Failed to install gofile"

    grep -q 'alias gofile' ~/.bashrc || echo "alias gofile=\"$TARGET_DIR/gofile\"" >> ~/.bashrc
}; gofile_install
