import { BusinessError } from '@ohos.base';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import UIAbility from '@ohos.app.ability.UIAbility';
import Want from '@ohos.app.ability.Want';
import hilog from '@ohos.hilog';
import window from '@ohos.window';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'HarmonyFox', '%{public}s', 'EntryAbility onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'HarmonyFox', '%{public}s', 'EntryAbility onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // 沉浸式：内容延伸至状态栏与导航条区域，顶部时间栏自行渲染
    windowStage.getMainWindow((err: BusinessError, win: window.Window) => {
      if (err.code) {
        hilog.error(0x0000, 'HarmonyFox', 'getMainWindow failed: %{public}s', JSON.stringify(err));
        return;
      }
      win.setWindowSystemBarProperties({
        statusBarColor: '#00000000',
        navigationBarColor: '#00000000'
      }).catch(() => {
      });
    });
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'HarmonyFox', 'loadContent failed: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(0x0000, 'HarmonyFox', 'loadContent succeed: %{public}s', JSON.stringify(data));
    });
  }

  onWindowStageDestroy(): void {
  }

  onForeground(): void {
  }

  onBackground(): void {
  }
}
