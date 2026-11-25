LOSMG_PATCHES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/patches"

losmg_apply_all() {
    local top p repo
    top="$(gettop 2>/dev/null)"; top="${top:-$PWD}"

    while IFS= read -r p; do
        repo="$top/$(dirname "${p#$LOSMG_PATCHES/}")"
        [ -d "$repo" ] || { echo "[LOSMG] repo não existe: $repo" >&2; continue; }

        if git -C "$repo" apply --reverse --check "$p" 2>/dev/null; then
            echo "[LOSMG] já aplicado: $(basename "$p")"
        elif git -C "$repo" apply --check "$p" 2>/dev/null; then
            git -C "$repo" apply "$p" && echo "[LOSMG] aplicado: $(basename "$p")"
        else
            echo "[LOSMG] FALHOU (conflito): $(basename "$p")" >&2
        fi
    done < <(find "$LOSMG_PATCHES" -name '*.patch' | sort)
}; losmg_apply_all

losmg_kernel_patches() {
    local top
    top="$(gettop 2>/dev/null)"; top="${top:-$PWD}"
    ROOT_DIR="$top" bash "$LOSMG_PATCHES/kernel_patches.sh"
}

# curl -fsSL https://gist.githubusercontent.com/WhoFoss/4bfd6c040c7e66f39b9c47774fcbc5d8/raw/b95b8398fcef409e61054635b710087d1f36a72d/patch_viperfx.sh | bash
