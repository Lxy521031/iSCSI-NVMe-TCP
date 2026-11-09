# iSCSI 存储管理 · 简体中文分支

基于 [jherskovic/iSCSI-NVMe-TCP](https://github.com/jherskovic/iSCSI-NVMe-TCP)，为 Apple Silicon Mac 上的 iSCSI 与 NVMe/TCP 客户端提供简体中文界面。保留上游 Apache 2.0 许可和英文回退。

## 中文支持

覆盖菜单、存储目标、设备发现、连接详情、初始设置、挂载与推出提示、卸载流程，以及常见存储错误。用语按实际操作调整，例如“存储目标”“发现设备”“CHAP 密钥”，保留 IQN、NQN、LUN、NSID 等协议标识。设备返回的原始错误会保留，便于排查。

界面随 macOS 的首选语言显示。也可在“系统设置 → 通用 → 语言与地区 → 应用程序”中为本应用选择简体中文，退出并重新打开后生效。

本分支停用 Sparkle 自动更新。“查看中文版更新…”会打开本分支的 Releases 页面，避免上游更新覆盖中文资源。协议实现、存储格式、主机标识与磁盘读写策略沿用上游。

## 当前交付状态

本分支已在 macOS 27.2、Xcode 27.2、Apple Silicon 上通过 Release 编译；399 项 Swift 测试通过。中文资源的编译与格式占位符经过检查。尚未进行中文界面的逐屏视觉验收，也未使用此构建验证真实存储设备的挂载与读写。

**本地 ZIP 是未签名的构建产物，不是可安装发行版，不能用它替换正在工作的应用。** 当前 Apple 个人开发团队无法配置 FSKit Module；实际签名构建已被 Xcode 拒绝。现有 `/Applications/iSCSI Initiator.app` 保留不动。

制作可安装版本需要有相应资格的 Apple Developer 团队、Developer ID Application 证书，以及容器应用和 FSKit 扩展的有效描述文件。还需把 `apps/project.yml` 的团队和 `Sources/iSCSIDaemon/ClientAuthorization.swift` 的可信团队同步配置为发行团队，保留 Developer ID 校验，并完成归档、签名、公证及真实挂载验证。只修改 Xcode 的团队或临时签名不足以完成发行；本分支没有放宽后台服务的身份验证。详细流程见上游 [签名与发布文档](docs/releasing.md)。

## 本地构建

完整 Xcode 27 及其命令行工具就绪后，在仓库根目录运行：

```sh
bash scripts/build-chinese.sh
```

脚本构建 Release，输出到 `build/localized/Build/Products/Release/iSCSI Initiator.app`，并将应用、此说明和许可证打包到 `dist/iSCSI-Initiator-0.9.1-zh-Hans-unsigned.zip`。不安装应用、不注册扩展、不更改现有服务。可将另一个输出目录作为脚本的唯一参数。

等价的编译命令：

```sh
xcodebuild -project apps/iSCSIInitiator.xcodeproj \
  -scheme 'iSCSI Initiator' -configuration Release \
  -derivedDataPath build/localized CODE_SIGNING_ALLOWED=NO build
```

工程以 `apps/project.yml` 为源，更新它后需使用仓库固定版本的 XcodeGen（见 `scripts/install-build-tools.sh`）重新生成并提交工程。此仓库在生成工程时使用目录名 `iSCSI`，以保持父目录 Swift 包引用一致。

## 后续翻译

中文词条位于 `apps/iSCSIApp/Localizable.xcstrings`，应用名称位于 `apps/iSCSIApp/zh-Hans.lproj/InfoPlist.strings`。新增动态提示应使用 `String(localized:)`，保持格式占位符的类型、参数编号与含义一致。翻译应说明操作与后果，完整保留涉及推出磁盘、断开连接、缓存写入和数据丢失的含义。
