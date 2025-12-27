#!/usr/bin/env bash
set -euo pipefail

# 简短说明：
# 1) 将以下四行写入 $HOME/.zshrc（可重复运行且不会重复追加）
#    export ANTHROPIC_BASE_URL="https://cr.api.taotiao.tech/api"
#    export ANTHROPIC_AUTH_TOKEN="<token>"
#    export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
#    export DISABLE_TELEMETRY=1
# 2) 运行: npm install -g @anthropic-ai/claude-code@latest

usage() {
  cat <<EOF
用法:
  ANTHROPIC_AUTH_TOKEN=your_token_here $0 [-y]
  或
  $0 your_token_here [-y]

选项:
  -y    跳过确认提示（非交互式部署可用）
EOF
  exit 1
}

# 解析选项
YES=0
while getopts ":y" opt; do
  case $opt in
    y) YES=1 ;;
    *) usage ;;
  esac
done
shift $((OPTIND-1))

# 获取 token（先用位置参数，再用环境变量）
TOKEN="${1:-${ANTHROPIC_AUTH_TOKEN:-}}"
if [ -z "$TOKEN" ]; then
  echo "错误：未提供 ANTHROPIC_AUTH_TOKEN。"
  usage
fi

ZSHRC="$HOME/.zshrc"

if [ "$YES" -ne 1 ]; then
  echo "此脚本将修改: $ZSHRC 并运行 'npm install -g @anthropic-ai/claude-code@latest'。继续吗？ [y/N]"
  if [ -r /dev/tty ]; then
    read -r ans </dev/tty
  else
    echo "警告：无法读取终端输入（非交互式环境？）。请使用 -y 参数跳过确认。"
    exit 1
  fi
  if [[ ! "$ans" =~ ^[Yy] ]]; then
    echo "已取消。"
    exit 0
  fi
fi

# 确保文件存在
if [ ! -f "$ZSHRC" ]; then
  touch "$ZSHRC"
fi

# 删除已有的管理块（如果存在）
if grep -q '# >>> claude-code environment variables' "$ZSHRC" 2>/dev/null; then
  # 使用备份方式兼容 macOS/BSD sed
  sed -i.bak '/# >>> claude-code environment variables/,/# <<< claude-code environment variables/d' "$ZSHRC" && rm -f "$ZSHRC.bak"
fi

# 转义双引号以安全写入
ESC_TOK=$(printf '%s' "$TOKEN" | sed 's/"/\\"/g')

# 追加新的管理块
cat >> "$ZSHRC" <<EOF

# >>> claude-code environment variables (managed by script) >>>
export ANTHROPIC_BASE_URL="https://cr.api.taotiao.tech/api"
export ANTHROPIC_AUTH_TOKEN="$ESC_TOK"
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
export DISABLE_TELEMETRY=1
# <<< claude-code environment variables (managed by script) <<<
EOF

echo "已将环境变量写入： $ZSHRC"

# 运行 npm install
if command -v npm >/dev/null 2>&1; then
  echo "执行: npm install -g @anthropic-ai/claude-code@latest"
  if npm install -g @anthropic-ai/claude-code@latest; then
    echo "npm 包安装完成。"
  else
    echo "npm install 失败。可能需要使用 sudo 或修复 npm 权限。可尝试: sudo npm install -g @anthropic-ai/claude-code@latest"
  fi
else
  echo "未检测到 npm。请先安装 Node.js 和 npm，然后运行: npm install -g @anthropic-ai/claude-code@latest"
fi

# 安装 cccleaner
echo "执行: 安装 cccleaner..."
curl -s https://raw.githubusercontent.com/geminiwen/cccleaner/master/install.sh | bash

echo "完成。要立即在当前 shell 生效，请运行： source \"$ZSHRC\" （或打开一个新的终端窗口）。"

exit 0
