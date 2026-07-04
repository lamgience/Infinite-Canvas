# Infinite-Canvas API 配置迁移指南

本文用于把旧画布中的 API 服务商配置、模型列表、令牌/密钥配置迁移到一个全新的 Infinite-Canvas 目录。

> 重要：如果只想迁移 API 配置，不要直接覆盖整个 `data` 目录；整个 `data` 目录还包含画布、素材库、项目、历史记录等内容。

## 一、最少必须拷贝的文件

从旧画布目录拷贝到新画布目录的相同位置：

```text
旧画布\data\api_providers.json
  -> 新画布\data\api_providers.json
```

这个文件是 API 配置迁移的核心文件，通常包含：

- API 服务商列表
- 服务商启用状态
- base_url / endpoint
- 图片模型、视频模型、聊天模型列表
- RunningHub / Comfly / ListenHub / 即梦等服务商配置
- 令牌、密钥、鉴权信息或与鉴权相关的配置

如果你的令牌是通过画布 API 设置页面保存的，优先迁移这个文件。

## 二、建议一并拷贝的配置文件

如果你希望迁移后体验尽量一致，可以同时拷贝：

```text
旧画布\data\runninghub_workflows.json
  -> 新画布\data\runninghub_workflows.json

旧画布\data\prompt_libraries.json
  -> 新画布\data\prompt_libraries.json

旧画布\data\asset_library.json
  -> 新画布\data\asset_library.json

旧画布\data\projects.json
  -> 新画布\data\projects.json
```

含义：

- `runninghub_workflows.json`：RunningHub 工作流配置。
- `prompt_libraries.json`：提示词库。
- `asset_library.json`：素材库索引，不一定包含素材文件本体。
- `projects.json`：项目列表。

## 三、可选迁移的数据

如果你想连画布、会话、素材预览也一起迁移，再拷贝这些目录：

```text
旧画布\data\canvases\
  -> 新画布\data\canvases\

旧画布\data\conversations\
  -> 新画布\data\conversations\

旧画布\data\media_previews\
  -> 新画布\data\media_previews\
```

含义：

- `canvases`：普通画布和智能画布数据。
- `conversations`：聊天/会话记录。
- `media_previews`：素材预览缓存。

这些不是 API 配置必须文件。只迁移 API 时可以不拷贝。

## 四、一般不建议拷贝的内容

这些通常不需要迁移：

```text
旧画布\data\update_backups\
旧画布\data\update_staging\
旧画布\__pycache__\
旧画布\*.bak
旧画布\*.pyc
```

说明：

- `update_backups` / `update_staging` 是更新过程产生的临时或备份内容。
- `__pycache__`、`.pyc` 是 Python 缓存。
- `.bak` 是补丁或更新时生成的备份文件。

## 五、根目录 history.json 是否要拷贝

根目录可能有：

```text
旧画布\history.json
  -> 新画布\history.json
```

这个文件主要是历史记录，不是 API 配置的核心文件。一般不需要为了 API 配置迁移它。

如果你希望保留旧的生成历史，可以拷贝；否则建议不拷贝，减少旧数据干扰。

## 六、推荐迁移步骤

假设：

```text
旧画布 = E:\Infinite-Canvas
新画布 = D:\William\OneDrive\ProgramFiles\大雄画布\Infinite-Canvas-New
```

步骤：

1. 关闭旧画布和新画布服务。
2. 确认新画布已经可以正常启动一次。
3. 备份新画布现有配置：

```powershell
Copy-Item "D:\William\OneDrive\ProgramFiles\大雄画布\Infinite-Canvas-New\data\api_providers.json" `
  "D:\William\OneDrive\ProgramFiles\大雄画布\Infinite-Canvas-New\data\api_providers.json.bak" -Force
```

4. 拷贝旧 API 配置到新画布：

```powershell
Copy-Item "E:\Infinite-Canvas\data\api_providers.json" `
  "D:\William\OneDrive\ProgramFiles\大雄画布\Infinite-Canvas-New\data\api_providers.json" -Force
```

5. 如需迁移 RunningHub 工作流：

```powershell
Copy-Item "E:\Infinite-Canvas\data\runninghub_workflows.json" `
  "D:\William\OneDrive\ProgramFiles\大雄画布\Infinite-Canvas-New\data\runninghub_workflows.json" -Force
```

6. 启动新画布，进入 API 设置页面检查服务商、模型和令牌是否正常。
7. 测试一个最小请求，例如拉取模型、生成一张小图或进行一次连接测试。

## 七、一键拷贝 API 配置示例

只迁移 API 配置和常用配置文件，可以使用：

```powershell
$old = "E:\Infinite-Canvas"
$new = "D:\William\OneDrive\ProgramFiles\大雄画布\Infinite-Canvas-New"

$files = @(
  "data\api_providers.json",
  "data\runninghub_workflows.json",
  "data\prompt_libraries.json",
  "data\asset_library.json",
  "data\projects.json"
)

foreach ($file in $files) {
  $src = Join-Path $old $file
  $dst = Join-Path $new $file
  if (Test-Path $src) {
    New-Item -ItemType Directory -Force -Path (Split-Path $dst) | Out-Null
    if (Test-Path $dst) {
      Copy-Item $dst "$dst.bak" -Force
    }
    Copy-Item $src $dst -Force
    Write-Host "Copied $file"
  }
}
```

## 八、安全提醒

`data\api_providers.json` 可能包含令牌、密钥、鉴权 URL 或服务商私有配置。

请不要把这个文件上传到 GitHub、网盘公开目录、聊天窗口或截图里。如果需要分享配置结构，先手动删除或替换密钥内容。

## 九、快速判断迁移是否成功

迁移后检查：

- API 设置页面能看到原来的服务商。
- 服务商启用状态和模型列表仍在。
- 即梦、Comfly、ListenHub、RunningHub 等自定义服务商仍存在。
- 不需要重新输入令牌即可连接成功。
- 测试生成能正常提交任务。

如果服务商存在但请求失败，优先检查：

- 新画布是否已经打了对应补丁。
- `data\api_providers.json` 是否被新版初始化覆盖。
- 服务商 base_url / endpoint 是否仍然正确。
- 令牌是否过期或被平台重置。