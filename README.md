# Preset Enhancer v2.0
 
SillyTavern 预设 AI 增强器。导入预设 JSON → AI 分析破限/越狱链 → 一键下载增强版。
 
作者：凌宇和苏苏子。

本工具完全开源，完全免费。本地 Web 工具，数据不上传第三方，纯 Python stdlib。
 
## 快速开始
 
```powershell
.\enhancer-web.cmd
```
 
浏览器自动打开 `http://127.0.0.1:8765`。

如果想让工具在缺少 Python 时自动下载安装依赖，可以运行：

```powershell
.\enhancer-web-auto.cmd
```

`enhancer-web-auto.cmd` 会在找不到 Python 3.10+ 时，从 python.org 下载官方 Python 安装器，当前用户静默安装并加入 PATH。
 
## 四步使用流程
 
1. 填入 API 地址和 Key，点击拉取模型列表
2. 从下拉菜单选取模型
3. 拖拽或点击上传 SillyTavern 预设 JSON
4. 点击开始增强，AI 分析优化后下载增强版
 
## API 兼容性
 
| 提供商 | 编写地址 | 自动处理 |
|--------|---------|---------|
| 任意 OpenAI 兼容 | `https://your-api.com` | 自动补 `/v1` |
| DeepSeek 官方 | `https://platform.deepseek.com` | 自动转到 `api.deepseek.com` |
| DeepSeek 直连 | `https://api.deepseek.com` | 直连 |
 
## 增强原理
 
工具内嵌多层自破限壳让模型穿透安全过滤，再用 8 种高阶技术强化你的预设：
 
- 标签注入 · 多层覆盖 · 身份锚定 · 双次确认
- 思维链注入 · 自强化锚点 · 语义切换 · 角色消解

## 项目结构

```
 preset-enhancer/
 ├── assets/
 │   └── favicon.png          WebUI 浏览器标签页图标
 ├── server.py              Web 服务主程序
 ├── enhancer-web.cmd       Windows 启动器（自动检测 python/py）
 ├── enhancer-web-auto.cmd  Windows 自动依赖补全启动器
 ├── enhancer.py            旧版 CLI 工具
 ├── tests/                 单元测试
 └── README.md
```

## 分享给他人

打包整个 `preset-enhancer/` 文件夹即可。对方只需：

1. 安装 Python 3.10+
2. 安装时勾选 **Add python.exe to PATH**
3. 双击 `enhancer-web.cmd`
  
无需 pip install，无需配置文件，无需 API Key 预置。

`enhancer-web.cmd` 会自动检测可用的 `python` 或 `py -3`，并验证版本必须是 Python 3.10+。如果系统里只有 WindowsApps 的 Python 占位符，会自动判定为不可用并提示安装真正的 Python。

如果希望对方少一步安装操作，可以让对方双击 `enhancer-web-auto.cmd`。它会：

1. 检测 Python 3.10+
2. 没有时提示用户确认
3. 从 python.org 官方地址下载 Python 3.12.10
4. 当前用户静默安装并加入 PATH
5. 安装完成后自动启动 WebUI

打包时可以删除 `__pycache__/`，它只是运行缓存。

## 运行测试

```powershell
python tests\test_api_endpoints.py
 ```
 
## 技术
 
纯 Python 标准库，零 pip 依赖。
 
## 许可
 
MIT

> 需要 **Python 3.10+**。零 pip 依赖，纯标准库。
 
