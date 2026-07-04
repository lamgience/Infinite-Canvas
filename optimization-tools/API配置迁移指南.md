# Infinite-Canvas API 配置迁移指南

这份文档只说一件事：换新画布、迁移到别的地方、或者重新下载一份全新画布时，哪些配置需要拷过去。

如果你不想纠结细节，直接看第一部分。

## 一、最省心迁移方式

关闭画布服务后，直接把旧画布里的整个 `data` 文件夹拷贝到新画布根目录，覆盖新画布的 `data` 文件夹：

```text
旧画布\data\
  -> 新画布\data\
```

这样会一起迁移：

- API 服务商配置
- API 令牌/密钥/鉴权相关配置
- 模型列表
- RunningHub 工作流配置
- 提示词库
- 项目列表
- 画布数据
- 会话记录
- 素材库索引
- 素材预览缓存

多拷一点没关系，最稳就是整个 `data` 文件夹。

## 二、只迁移 API 配置时最少拷贝

如果你只想迁移 API 配置，不想迁移画布和素材，至少拷贝这个文件：

```text
旧画布\data\api_providers.json
  -> 新画布\data\api_providers.json
```

它是最核心的 API 配置文件，通常包含：

- 服务商列表
- 服务商启用状态
- base_url / endpoint
- 图片模型、视频模型、聊天模型列表
- Comfly / ListenHub / 即梦 / RunningHub 等配置
- 令牌、密钥、鉴权信息或鉴权相关配置

如果你的目标是“新画布不用重新填 API”，这个文件最重要。

## 三、推荐一起拷贝的 data 内容

更推荐直接拷这些文件和文件夹：

```text
旧画布\data\api_providers.json
旧画布\data\runninghub_workflows.json
旧画布\data\prompt_libraries.json
旧画布\data\asset_library.json
旧画布\data\projects.json
旧画布\data\canvases\
旧画布\data\conversations\
旧画布\data\media_previews\
```

拷到新画布对应位置：

```text
新画布\data\api_providers.json
新画布\data\runninghub_workflows.json
新画布\data\prompt_libraries.json
新画布\data\asset_library.json
新画布\data\projects.json
新画布\data\canvases\
新画布\data\conversations\
新画布\data\media_previews\
```

简单理解：

- `api_providers.json`：API 配置和令牌，最重要。
- `runninghub_workflows.json`：RunningHub 工作流。
- `prompt_libraries.json`：提示词库。
- `asset_library.json`：素材库索引。
- `projects.json`：项目列表。
- `canvases`：普通画布和智能画布内容。
- `conversations`：会话记录。
- `media_previews`：素材预览缓存。

## 四、可以不管的文件夹

这些不影响 API 配置迁移，可以不拷：

```text
旧画布\data\update_backups\
旧画布\data\update_staging\
旧画布\__pycache__\
旧画布\*.bak
旧画布\*.pyc
```

它们一般是更新缓存、临时文件、补丁备份或 Python 缓存。

如果你直接复制整个 `data` 文件夹，带上 `update_backups`、`update_staging` 也通常没事，只是占空间。

## 五、根目录 history.json

根目录可能有：

```text
旧画布\history.json
  -> 新画布\history.json
```

它主要是历史记录，不是 API 配置核心文件。

想保留生成历史就拷，不想保留可以不拷。

## 六、推荐操作步骤

假设：

```text
旧画布 = E:\Infinite-Canvas
新画布 = D:\William\OneDrive\ProgramFiles\大雄画布\Infinite-Canvas-New
```

最省心做法：

1. 关闭旧画布和新画布服务。
2. 先备份新画布的 `data` 文件夹。
3. 把旧画布的 `data` 文件夹复制到新画布。
4. 启动新画布。
5. 进入 API 设置页面检查服务商和模型是否还在。
6. 测试一次连接或生成。

PowerShell 示例：

```powershell
$old = "E:\Infinite-Canvas"
$new = "D:\William\OneDrive\ProgramFiles\大雄画布\Infinite-Canvas-New"
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"

if (Test-Path "$new\data") {
  Copy-Item "$new\data" "$new\data.bak-$stamp" -Recurse -Force
}

Copy-Item "$old\data" "$new\data" -Recurse -Force
```

## 七、只复制常用配置的命令

如果不想复制整个 `data`，可以只复制常用配置：

```powershell
$old = "E:\Infinite-Canvas"
$new = "D:\William\OneDrive\ProgramFiles\大雄画布\Infinite-Canvas-New"

$items = @(
  "data\api_providers.json",
  "data\runninghub_workflows.json",
  "data\prompt_libraries.json",
  "data\asset_library.json",
  "data\projects.json",
  "data\canvases",
  "data\conversations",
  "data\media_previews",
  "history.json"
)

foreach ($item in $items) {
  $src = Join-Path $old $item
  $dst = Join-Path $new $item
  if (Test-Path $src) {
    New-Item -ItemType Directory -Force -Path (Split-Path $dst) | Out-Null
    Copy-Item $src $dst -Recurse -Force
    Write-Host "Copied $item"
  }
}
```

## 八、安全提醒

`data\api_providers.json` 可能包含 API 令牌、密钥、鉴权 URL 或服务商私有配置。

不要把它上传到 GitHub、公开网盘、聊天窗口或截图里。

如果要分享配置结构，先把令牌、密钥、URL 中的敏感部分删掉或替换成 `***`。

## 九、迁移成功的判断

迁移后检查：

- API 设置页面能看到原来的服务商。
- 服务商启用状态还在。
- 模型列表还在。
- 即梦、Comfly、ListenHub、RunningHub 等自定义配置还在。
- 不需要重新输入令牌即可连接成功。
- 能成功提交一次生成任务。

如果服务商存在但请求失败，优先检查：

- 新画布是否已经打了对应补丁。
- `data\api_providers.json` 是否被新画布初始化覆盖。
- base_url / endpoint 是否正确。
- 令牌是否过期。