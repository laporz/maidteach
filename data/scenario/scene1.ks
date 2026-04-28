;ゲーム本編エントリーポイント
;タイトルの「ゲームスタート」から呼ばれる

*start

[cm]
[clearfix]
[start_keyconfig]
[hidemenubutton]

; ---- 新規ゲーム：全変数を初期値にリセット ----
[iscript]

// 日中ステータス（夜は数値共有のため同一変数）
f.gakuryoku  = 0;
f.tairyoku   = 0;
f.hihin      = 0;
f.kaji       = 0;
f.shakou     = 0;

// 部位ステータス
f.kuchi  = 0;
f.mune   = 0;
f.kabu   = 0;
f.inkaku = 0;
f.shiri  = 0;

// お金
f.money = 0;

// 職業
f.job_tier       = 0;
f.job_name       = "無職";
f.night_unlocked = false;

// 外見（初期：金髪・ロング・低身長・スレンダー・メイド服ミニ）
f.hair_color   = "gold";
f.hair_style   = "long";
f.height       = "low";
f.body_type    = "slender";
f.outfit       = "maid_mini";
f.night_outfit = "";

// 進行
f.phase        = "day";
f.week         = 1;
f.actions_left = GameLogic.getMaxActions();

// エピソード解放フラグ
f.episodes = {};

[endscript]

; ---- 育成メインへ ----
@jump storage="main.ks" target="*mainloop"

[s]
