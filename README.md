# Lua Starter · Lua 入门扩展

用 Lua 为 JackalClient 添加自己的模块。本示例启用时显示欢迎语和当前 FPS，运行期间观察 Clock 的开关，状态变化时发送通知。

[扩展与 SDK 完整教程](https://doc.wormwake.com/extension-sdk.html)

## 1. 安装和体验

1. 准备支持 Lua 扩展的 JackalClient，下载本示例文件夹或 ZIP。
2. 打开 **扩展 (Extensions) → 导入本地 (Import local...)**，选择本文件夹或 ZIP。
3. 在 **其他 (Misc)** 分类开启 **Lua 入门示例**。
4. 修改模块设置中的 **Lua 欢迎语 (Lua Greeting)**，重新启用模块查看通知；开关 Clock 可体验状态观察。

Lua 引擎由客户端提供，安装扩展即可运行，适用于 x86、x64 客户端。

## 2. 文件说明

| 文件 | 用途 |
| --- | --- |
| `extension.json` | 扩展信息、模块默认配置、回调映射与文件清单 |
| `main.lua` | 启用、周期更新、停用三个回调 |
| `Dictionary.txt` | 本扩展的中英文词条 |

客户端执行脚本所需的 API 通过全局 `jackal` 表提供。

开发时可提前下载 `JackalExtensionSDK`，与 `example-lua` 放在同一父目录，参考 `../JackalExtensionSDK/README.md`；Lua 脚本直接使用客户端内置的 `jackal` 接口。

## 3. 修改这个示例

从 `main.lua` 的启用回调开始：

```lua
function on_enable(config, context)
    previous_clock = jackal.modules.exists("Clock") and jackal.modules.get("Clock")
    jackal.notify(config["Lua Greeting"] .. " | FPS: " .. jackal.variables.get("fps"), "success", context.module)
end
```

- `config` 是本模块的配置快照，`context.module` 是原始模块名。
- `jackal.variables.get("fps")` 获取与 `/variables` 相同的变量值。
- `jackal.modules.exists("Clock")` 查询模块存在性，`.get("Clock")` 读取开关。
- `jackal.notify` 显示通知；`jackal.sleep(ms)` 可在回调内等待。
- `on_update` 每 100 毫秒观察一次 Clock，`on_disable` 显示停用通知。

创建自己的扩展时，修改 `extension.json` 中的 `id`、名称、作者及模块 `name`。`schemaVersion` 使用 2，`script.entry` 引用 `files.main`，`behaviors` 中的值对应脚本函数名。新增配置写入模块 `defaults`，新增文件在 `files` 登记；翻译放入 `Dictionary.txt`，由 `contributes.Dictionary` 引用。

HTTP、按键、客户端权限、隐私窗口和 Custom HUD 的调用方法见官网教程。同级 `../JackalExtensionSDK/README.md` 可帮助了解三种开发方式和原生接口。

## 4. 调试和发布

首次导入即可开启模块。修改脚本后，删除已安装扩展并重启客户端，再导入修改后的文件夹。运行错误会提示脚本位置；模块设置保存在当前配置档案。

本示例源码清单省略文件校验值，适合本地导入。发布时，为 `files` 中每个文件填写 `size` 与 `sha256`；若修改了带校验值的文件，也要重新计算。例如：

```powershell
(Get-Item -LiteralPath ./main.lua).Length
(Get-FileHash -LiteralPath ./main.lua -Algorithm SHA256).Hash.ToLowerInvariant()
```

将 `extension.json`、`main.lua` 和 `Dictionary.txt` 放在发布包根目录。SDK 和 README 是开发参考资料，可随源码仓库保留。

如果使用完整客户端源码仓库，可在仓库根目录自动打包：

```powershell
py -3 scripts/extension-package.py publish --id example-lua --destination temp/script-preview
```

导入生成的 `temp/script-preview/example-lua` 即可测试发布包。独立示例仓库可按同级 `../JackalExtensionSDK/README.md` 中的发布说明，或[官网教程](https://doc.wormwake.com/extension-sdk.html)准备清单。
