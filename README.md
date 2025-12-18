# Claude Code 安装脚本

一键安装和配置 Claude Code CLI 工具的自动化脚本。

## 功能

此脚本会自动完成以下操作：

1. 在 `~/.zshrc` 中配置必要的环境变量：
   - `ANTHROPIC_BASE_URL`: 设置 API 基础 URL
   - `ANTHROPIC_AUTH_TOKEN`: 配置认证 Token
   - `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`: 禁用非必要流量
   - `DISABLE_TELEMETRY`: 禁用遥测数据收集

2. 全局安装 `@anthropic-ai/claude-code` npm 包

3. 自动安装 `cccleaner` 清理工具

## 前置要求

- macOS 或 Linux 系统
- 已安装 Node.js 和 npm
- 使用 zsh 作为默认 shell
- 有效的 Anthropic API Token

## 快速安装

一键安装命令：

```bash
curl -fsSL https://raw.githubusercontent.com/taotiaotech/cc/main/install.sh | bash -s -- <your_token>
```

将 `<your_token>` 替换为你的 Anthropic API Token。

### 非交互式模式

使用 `-y` 选项跳过确认提示：

```bash
curl -fsSL https://raw.githubusercontent.com/taotiaotech/cc/main/install.sh | bash -s -- <your_token> -y
```

### 使用环境变量

也可以通过环境变量传递 Token：

```bash
curl -fsSL https://raw.githubusercontent.com/taotiaotech/cc/main/install.sh | ANTHROPIC_AUTH_TOKEN=<your_token> bash
```

## 安装后

执行脚本后，运行以下命令使环境变量立即生效：

```bash
source ~/.zshrc
```

或者打开一个新的终端窗口。

## 注意事项

- 脚本会自动管理 `~/.zshrc` 中的配置块，重复运行不会产生重复配置
- 如果 npm 安装失败，可能需要使用 sudo 权限或修复 npm 权限设置
- 脚本仅支持 zsh，如使用其他 shell，请手动配置环境变量

## 卸载

如需卸载，手动执行以下步骤：

1. 从 `~/.zshrc` 中删除被标记的配置块：
   ```
   # >>> claude-code environment variables (managed by script) >>>
   ...
   # <<< claude-code environment variables (managed by script) <<<
   ```

2. 卸载全局 npm 包：
   ```bash
   npm uninstall -g @anthropic-ai/claude-code
   ```
