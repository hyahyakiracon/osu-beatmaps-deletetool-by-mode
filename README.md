osu! beatmaps delete tool by lovely_hyahya using OpenAI. (2024). ChatGPT (3.5) [Large language model]. https://chat.openai.com/share/7f4252ee-c120-43d3-8581-9b7c3b848325

-------------------------------------------------------------------------------------

0：把 Delete_Beatmaps_by_Mode_Tool.ps1 工具 放在Songs文件夹旁边，即 osu!.exe 所在同目录

1：右键 Delete_Beatmaps_by_Mode_Tool.ps1 工具

2：选择 使用 PowerShell 运行

3：输入 0~3 中的任意一个数字 (0 代表 std，1 代表 taiko，2 代表 catch，3 代表mania)

4：按下回车即可自动删除该模式内的所有谱面（包括音频文件等，如果该谱面集没有其他模式的谱面）

5：如果出现报错，请在 PowerShell（管理员启动） 下，依次执行以下命令。

Set-ExecutionPolicy RemoteSigned

Set-ExecutionPolicy RemoteSigned -Scope Process

-------------------------------------------------------------------------------------

0: Place the "Delete_Beatmaps_by_Mode_Tool.ps1" tool next to the Songs folder, i.e., in the same directory as osu!.exe.

1: Right-click on the "Delete_Beatmaps_by_Mode_Tool.ps1" tool.

2: Choose "Run with PowerShell."

3: Enter any number from 0 to 3 (0 for Standard, 1 for Taiko, 2 for Catch, 3 for Mania).

4: Press Enter to automatically delete all beatmaps in that mode (including audio files) if the beatmap set does not contain beatmaps for other modes.

5: If an error occurs, run the following commands in PowerShell (run as administrator):

Set-ExecutionPolicy RemoteSigned

Set-ExecutionPolicy RemoteSigned -Scope Process

