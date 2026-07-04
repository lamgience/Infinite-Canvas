# Infinite-Canvas API 配置迁移指南

这份文档用于换新画布、迁移到别的目录、或者重新下载全新画布时，判断哪些配置需要拷贝。

如果不想纠结细节，直接看第一部分。

## 一、最省心迁移方式

关闭画布服务后，直接拷贝这些内容到新画布根目录的对应位置：

```text
旧画布\data\
  -> 新画布\data\

旧画布\API\
  -> 新画布\API\
```

这样会迁移大部分个人配置：

- API 服务商配置
- API 令牌、密钥、鉴权相关配置
- `API\.env` 环境变量配置
- 模型列表
- RunningHub 工作流配置
- 提示词库
- 项目列表
- 画布数据
- 会话记录
- 素材库索引
- 素材预览缓存

多拷一点没关系。最稳就是 `data` 和 `API` 两个文件夹一起拷。

## 二、最核心文件

如果只迁移 API 配置，至少拷贝：

```text
旧画布\data\api_providers.json
  -> 新画布\data\api_providers.json
```

这个文件通常包含：

- 服务商列表
- 服务商启用状态
- base_url / endpoint
- 图片模型、视频模型、聊天模型列表
- Comfly / ListenHub / 即梦 / RunningHub 等配置
- 令牌、密钥、鉴权信息或鉴权相关配置

另外建议一起拷贝：

```text
旧画布\API\
  -> 新画布\API\
```

当前版本里 `API` 文件夹通常只有 `.env`，甚至可能是空文件。但如果你以后把 API key、token、环境变量、代理配置写进 `.env`，这个文件夹就必须迁移。

## 三、推荐一起拷贝的内容

如果你想迁移后尽量保持原样，推荐拷贝：

```text
旧画布\data\api_providers.json
旧画布\data\runninghub_workflows.json
旧画布\data\prompt_libraries.json
旧画布\data\asset_library.json
旧画布\data\projects.json
旧画布\data\canvases\
旧画布\data\conversations\
旧画布\data\media_previews\
旧画布\API\
旧画布\history.json
```

对应拷到：

```text
新画布\data\api_providers.json
新画布\data\runninghub_workflows.json
新画布\data\prompt_libraries.json
新画布\data\asset_library.json
新画布\data\projects.json
新画布\data\canvases\
新画布\data\conversations\
新画布\data\media_previews\
新画布\API\
新画布\history.json
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
- `API`：环境变量配置目录，可能包含 `.env`。
- `history.json`：根目录历史记录，可选。

## 四、除了 data 和 API，还可能要拷贝什么

如果你做过更多自定义，可以额外关注这些根目录内容：

```text
旧画布\workflows\
旧画布\output\
旧画布\assets\
```

说明：

- `workflows`：工作流模板。如果你改过里面的 JSON，建议拷贝。
- `output`：输出文件。如果你想保留旧生成结果，可以拷贝；只迁移 API 不需要。
- `assets`：本地素材目录。如果你把素材存在这里，建议拷贝。

通常不需要拷贝：

```text
旧画布\python\
旧画布\packages\
旧画布\static\
旧画布\tools\
旧画布\CLI\
```

这些更偏程序本体。新版本画布自带即可，除非你手动改过其中内容。

即梦 CLI 的登录态可能不在画布根目录里，而是在用户目录、WSL 或 CLI 自己的配置目录里。换机器后如果即梦 CLI 无法直接使用，重新运行登录即梦 CLI 的脚本最稳。

## 五、可以不管的内容

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

## 六、推荐操作步骤

假设：

```text
旧画布 = E:\Infinite-Canvas
新画布 = D:\William\OneDrive\ProgramFiles\大雄画布\Infinite-Canvas-New
```

最省心做法：

1. 关闭旧画布和新画布服务。
2. 先备份新画布的 `data` 和 `API`。
3. 把旧画布的 `data` 和 `API` 复制到新画布。
4. 启动新画布。
5. 进入 API 设置页面检查服务商和模型是否还在。
6. 测试一次连接或生成。

PowerShell 示例：

```powershell
$old = "E:\Infinite-Canvas"
$new = "D:\William\OneDrive\ProgramFiles\大雄画布\Infinite-Canvas-New"
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"

foreach ($folder in @("data", "API")) {
  if (Test-Path "$new\$folder") {
    Copy-Item "$new\$folder" "$new\$folder.bak-$stamp" -Recurse -Force
  }
  if (Test-Path "$old\$folder") {
    Copy-Item "$old\$folder" "$new\$folder" -Recurse -Force
  }
}
```

## 七、只复制常用配置的命令

如果不想复制整个 `data`，可以只复制常用配置和文件夹：

```powershell
$old = "E:\Infinite-Canvas"
$new = "D:\William\OneDrive\ProgramFiles\大雄画布\Infinite-Canvas-New"

$items = @(
  "API",
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

`data\api_providers.json` 和 `API\.env` 都可能包含 API 令牌、密钥、鉴权 URL 或服务商私有配置。

不要把它们上传到 GitHub、公开网盘、聊天窗口或截图里。

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
- `API\.env` 是否已迁移。
- base_url / endpoint 是否正确。
- 令牌是否过期。