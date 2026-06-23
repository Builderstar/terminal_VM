#!/usr/bin/env bash
set -euo pipefail

REPO="Builderstar/terminal_VM"
INSTALL_DIR="${HOME}/.terminal-vm"

BOLD='\033[1m'
DIM='\033[2m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

log()   { printf "${GREEN}==>${NC}${BOLD} %s${NC}\n" "$*"; }
info()  { printf "   ${CYAN}::${NC} %s\n" "$*"; }
warn()  { printf "   ${YELLOW}!!${NC} %s\n" "$*"; }
err()   { printf "   ${RED}XX${NC} %s\n" "$*" >&2; }

usage() {
  cat <<EOF
${BOLD}terminal_VM${NC} - Terminal-based virtual machine manager

${BOLD}USAGE${NC}
    curl -fsSL https://raw.githubusercontent.com/${REPO}/main/setup.sh | bash
    curl -fsSL https://raw.githubusercontent.com/${REPO}/main/setup.sh | bash -s -- --help

${BOLD}OPTIONS${NC}
    --help, -h          Show this help message
    --dir <path>        Install to a custom directory (default: ${INSTALL_DIR})
    --uninstall         Remove terminal_VM and all its files
    --version           Show version information

${BOLD}WHAT IT DOES${NC}
    Creates a sandboxed terminal environment at ${INSTALL_DIR}
    with isolated tools, configs, and workflow helpers.

${BOLD}SOURCE${NC}
    https://github.com/${REPO}
EOF
  exit 0
}

version() {
  echo "terminal_VM 0.1.0"
  exit 0
}
uninstall() {
  if [[ -d "$INSTALL_DIR" ]]; then
    log "Removing ${INSTALL_DIR}..."
    rm -rf "$INSTALL_DIR"
    info "Done."
  else
    info "Nothing to uninstall."
  fi
  exit 0
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --help|-h) usage ;;
    --version) version ;;
    --dir) INSTALL_DIR="$2"; shift 2 ;;
    --uninstall) uninstall ;;
    *) err "Unknown option: $1"; usage ;;
  esac
done

log "Installing terminal_VM to ${INSTALL_DIR}"

mkdir -p "$INSTALL_DIR/bin" "$INSTALL_DIR/config" "$INSTALL_DIR/data"

cat > "$INSTALL_DIR/bin/tvm" <<'TVMSCRIPT'
#!/usr/bin/env bash
set -euo pipefail
echo "terminal_VM v0.1.0 — ready"
TVMSCRIPT
chmod +x "$INSTALL_DIR/bin/tvm"

cat > "$INSTALL_DIR/config/env.sh" <<'ENVSCRIPT'
#!/usr/bin/env bash
export TERMINAL_VM_HOME="${HOME}/.terminal-vm"
export PATH="${TERMINAL_VM_HOME}/bin:${PATH}"
ENVSCRIPT
chmod +x "$INSTALL_DIR/config/env.sh"

log "Installation complete!"

cat <<EOF

  ${BOLD}terminal_VM${NC} has been installed to:
    ${DIM}${INSTALL_DIR}${NC}

  ${BOLD}Quick start:${NC}
    Add to your ${DIM}~/.bashrc${NC} or ${DIM}~/.zshrc${NC}:
      ${DIM}source ${INSTALL_DIR}/config/env.sh${NC}

    Then run:
      ${DIM}tvm${NC}

EOF
