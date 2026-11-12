# HarmonyFox

Firefox 风格的 HarmonyOS 原生浏览器（ArkTS + ArkWeb），纯开源。

本项目与 Mozilla / Firefox 无任何隶属、授权或赞助关系。界面布局参考 Firefox for Android（Fenix）的设计语言，但全部代码为原创。Firefox® 是 Mozilla 基金会的注册商标。

## 0.0.1 功能

- **底部工具栏**：仿 Fenix 的地址栏 + 后退 / 前进 / 刷新 / 主页 / 菜单（在系统导航条之上渲染，不再是卓易通容器里那种割裂体验）
- **顶部时间栏**：大字号系统时间 + 日期星期，沉浸式状态栏（透明状态栏，内容延伸到系统栏区域）
- **ArkWeb 内核**：使用 HarmonyOS 系统 Web 内核渲染网页
- **起始页**：内置深色起始页（rawfile/home.html），支持跳转搜索引擎

## ⚠️ 启用 CI（重要，只需一次）

工作流文件当前位于 [`.github/workflow/release.yml`](.github/workflow/release.yml)。由于自动化写入工具对 `.github/workflows/` 路径有写入限制，**请在网页端把它移动过去**：

1. 打开 <https://github.com/nzzlwang/harmonyfox/blob/main/.github/workflow/release.yml>
2. 点右上角 ✏️（Edit this file），把路径改为 `.github/workflows/release.yml`，提交。

移动后推送到 `main` 会自动构建未签名 hap；发布 0.0.1 见下文。

## 目录结构

```
├── AppScope/                # 应用级配置（bundleName、版本、图标）
├── entry/                   # 主模块（entry hap）
│   └── src/main/
│       ├── ets/entryability/EntryAbility.ets
│       ├── ets/pages/Index.ets        # 浏览器主界面
│       ├── resources/                 # 字符串 / 颜色 / 图标 / 起始页
│       └── module.json5
├── assets/                  # 图标 base64 源文件
├── scripts/                 # gen_icon.py（PIL 生成图标）、prepare_assets.py（解码图标）
├── .github/workflow/release.yml       # CI 工作流（需移到 .github/workflows/ 下生效）
└── build-profile.json5 / hvigorfile.ts / oh-package.json5
```

## 本地构建（DevEco Studio）

1. 安装 DevEco Studio 3.1 或更高版本（当前工程以 API 9 / HarmonyOS 为目标）。
2. 克隆本仓库：
   ```bash
   git clone https://github.com/nzzlwang/harmonyfox.git
   cd harmonyfox
   ```
3. 生成图标资源（仓库中为控制体积只存了 base64，需解码一次）：
   ```bash
   python3 scripts/prepare_assets.py
   # 或者用 PIL 重新生成：pip install pillow && python3 scripts/gen_icon.py
   ```
4. 用 DevEco Studio 打开工程，`Build → Build Hap(s)/APP(s) → Build Hap(s)`。
   未配置签名时产物为未签名 hap（`entry-default-unsigned.hap`）。

## CI 云端构建（GitHub Actions）

启用 CI（见上文）后：

- **推送到 `main`**：自动构建未签名 hap 并上传为 Actions artifact。
- **手动发布 Release**：在 Actions 页面运行 `Release` 工作流，输入版本号（默认 `0.0.1`），将自动构建并创建 Release（tag `v<版本号>`），附 **未签名 hap + 源码压缩包**。

构建过程：下载 HarmonyOS 命令行工具与 SDK（API 9 toolchain）→ 解码图标 → 安装 hvigor 2.4.2 → `assembleHap`（无签名配置，产物为 unsigned hap）。

## 安装未签名 hap（开发者调试）

> 未签名 hap 只能通过 hdc 安装到开启了开发者模式的设备/模拟器，普通用户无法直接安装。

```bash
hdc install harmonyfox-0.0.1-unsigned.hap
```

## 关于 HarmonyOS NEXT 设备

当前 CI 产物是 API 9 调试包。若要在 HarmonyOS NEXT（星河版）真机上运行，请用 DevEco Studio（API 12+）打开工程，将 `build-profile.json5` 中的 `compileSdkVersion` / `compatibleSdkVersion` 提升到 12 并重新构建；正式发布还需华为开发者证书签名。

## License

MPL-2.0（与 Fenix 相同），见 [LICENSE](LICENSE)。
