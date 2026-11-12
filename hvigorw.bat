@echo off
rem HarmonyFox hvigor wrapper
if not exist node_modules\@ohos\hvigor (
  echo Installing hvigor ...
  call npm config set @ohos:registry=https://repo.harmonyos.com/npm/
  call npm install @ohos/hvigor@2.4.2 @ohos/hvigor-ohos-plugin@2.4.2
)
call .\node_modules\.bin\hvigor %*
