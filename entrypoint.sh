#!/usr/bin/env sh
set -eu

case "${1:-}" in
  playbook|ansible-playbook) shift; exec ansible-playbook "$@" ;;
  galaxy|ansible-galaxy)     shift; exec ansible-galaxy "$@" ;;
  vault|ansible-vault)       shift; exec ansible-vault "$@" ;;
  lint|ansible-lint)         shift; exec ansible-lint "$@" ;;
  "")                               exec ansible --version ;;
  *)                                exec ansible "$@" ;;
esac
