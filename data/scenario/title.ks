[cm]
@clearstack
[hidemenubutton]
@bg storage="title.png" time=1
@wait time=200

*start

; メッセージレイヤを透明背景で全画面展開
[layopt layer=message0 visible=true]
[position layer=message0 page=fore left=0 top=0 width=1920 height=1080 opacity=0]

; タイトル文字
[ptext name="title_text" layer=message0 page=fore x=560 y=160 size=64 color=0xffd700 bold=true text="メイドティーチング"]

; メニューボタン
[glink text="ゲームスタート" x=710 y=400 width=500 height=65 color=0xffffff size=32 target="*gamestart" keyfocus="1"]
[glink text="ロード"         x=710 y=490 width=500 height=65 color=0xffffff size=32 role="load" keyfocus="2"]
[glink text="設定"           x=710 y=580 width=500 height=65 color=0xffffff size=32 role="sleepgame" storage="config.ks" keyfocus="3"]
[glink text="ゲームを終了"   x=710 y=670 width=500 height=65 color=0xffffff size=32 target="*quit" keyfocus="4"]

[s]

*gamestart
@clearstack
@jump storage="scene1.ks"

*quit
[iscript]
window.close();
[endscript]
[s]
