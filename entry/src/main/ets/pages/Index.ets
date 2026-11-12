import promptAction from '@ohos.promptAction';
import window from '@ohos.window';
import webview from '@ohos.web.webview';

const HOME_URL: string = 'resource://rawfile/home.html';
const TOOLBAR_BG: string = '#FF1C1B22';

@Entry
@Component
struct Index {
  private controller: webview.WebviewController = new webview.WebviewController();
  @State inputUrl: string = '';
  @State canGoBack: boolean = false;
  @State canGoForward: boolean = false;
  @State timeText: string = '';
  @State dateText: string = '';
  @State statusBarHeight: number = 0;
  private timer: number = -1;

  updateTime(): void {
    const now: Date = new Date();
    const hh: string = now.getHours().toString().padStart(2, '0');
    const mm: string = now.getMinutes().toString().padStart(2, '0');
    this.timeText = `${hh}:${mm}`;
    const weeks: string[] = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
    this.dateText = `${now.getMonth() + 1}月${now.getDate()}日 ${weeks[now.getDay()]}`;
  }

  aboutToAppear(): void {
    this.updateTime();
    this.timer = setInterval(() => {
      this.updateTime();
    }, 15000);
    window.getLastWindow(getContext(this)).then((win: window.Window) => {
      const avoidArea: window.AvoidArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      this.statusBarHeight = px2vp(avoidArea.topRect.height);
    }).catch(() => {
    });
  }

  aboutToDisappear(): void {
    clearInterval(this.timer);
  }

  normalizeUrl(raw: string): string {
    let target: string = raw.trim();
    if (target.length === 0) {
      return HOME_URL;
    }
    const hasScheme: boolean = /^[a-zA-Z][a-zA-Z0-9+.-]*:\/\//.test(target);
    if (!hasScheme) {
      target = `https://${target}`;
    }
    return target;
  }

  goto(raw: string): void {
    const target: string = this.normalizeUrl(raw);
    this.inputUrl = target;
    this.controller.loadUrl(target);
  }

  goHome(): void {
    this.inputUrl = '';
    this.controller.loadUrl(HOME_URL);
  }

  build() {
    Column() {
      // 顶部时间栏：沉浸式状态栏下方的大字号时间与日期
      Row() {
        Column({ space: 2 }) {
          Text(this.timeText)
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
          Text(this.dateText)
            .fontSize(12)
            .fontColor('#D0FFFFFF')
        }
        .alignItems(HorizontalAlign.Start)

        Blank()

        Text('HarmonyFox 0.0.1')
          .fontSize(12)
          .fontColor('#D0FFFFFF')
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: this.statusBarHeight + 6, bottom: 6 })
      .backgroundColor('#C01C1B22')

      // 网页区域（ArkWeb 系统内核）
      Web({ src: HOME_URL, controller: this.controller })
        .javaScriptAccess(true)
        .domStorageAccess(true)
        .width('100%')
        .layoutWeight(1)
        .onPageEnd((event) => {
          if (event) {
            this.inputUrl = event.url;
          }
          this.canGoBack = this.controller.accessBackward();
          this.canGoForward = this.controller.accessForward();
        })

      // 底部地址栏 + 工具栏（仿 Fenix 底部栏，非卓易通容器体验）
      Column({ space: 6 }) {
        TextInput({ placeholder: '搜索或输入网址', text: $$this.inputUrl })
          .height(38)
          .fontSize(14)
          .fontColor(Color.White)
          .placeholderColor('#99FFFFFF')
          .backgroundColor('#FF3B3A41')
          .borderRadius(19)
          .onSubmit(() => {
            this.goto(this.inputUrl);
          })

        Row() {
          Button('◀')
            .fontSize(16)
            .backgroundColor(Color.Transparent)
            .fontColor(this.canGoBack ? Color.White : '#55FFFFFF')
            .enabled(this.canGoBack)
            .onClick(() => {
              this.controller.backward();
            })
          Button('▶')
            .fontSize(16)
            .backgroundColor(Color.Transparent)
            .fontColor(this.canGoForward ? Color.White : '#55FFFFFF')
            .enabled(this.canGoForward)
            .onClick(() => {
              this.controller.forward();
            })
          Button('⟳')
            .fontSize(16)
            .backgroundColor(Color.Transparent)
            .fontColor(Color.White)
            .onClick(() => {
              this.controller.refresh();
            })
          Button('⌂')
            .fontSize(16)
            .backgroundColor(Color.Transparent)
            .fontColor(Color.White)
            .onClick(() => {
              this.goHome();
            })
          Button('⋮')
            .fontSize(16)
            .backgroundColor(Color.Transparent)
            .fontColor(Color.White)
            .onClick(() => {
              promptAction.showToast({ message: '多标签 / 设置（0.0.1 规划中）', duration: 2000 });
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceEvenly)
        .padding({ bottom: 6 })
      }
      .width('100%')
      .padding({ left: 12, right: 12, top: 8 })
      .backgroundColor(TOOLBAR_BG)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(TOOLBAR_BG)
  }
}
