; main.ks - 育成メインループ

; ==========================================================
; メインループ
; ==========================================================
*mainloop

[cm]
[hidemenubutton]
[bg storage="room.jpg" time=1]

[layopt layer=message0 visible=false]
[position layer=message0 page=fore left=160 top=955 width=1600 height=90 opacity=210 margint=18 marginl=40 marginr=40 marginb=10]

[iscript]
GameUI.drawStats();
f._actions_left = f.actions_left || 0;
f._is_night = f.phase === "night";
var jobs = GameLogic.getAvailableJobs();
f._can_job = (jobs.length > 0 && jobs[0].tier > (f.job_tier || 0));
[endscript]

[if exp="f._actions_left <= 0"]
@jump target="*phase_end"
[endif]

[if exp="f._is_night"]
@jump target="*mainloop_night"
[endif]

[glink text="研鑽"   x=270  y=860 width=260 height=70 color=0x88ddff size=26 target="*sel_train"]
[glink text="仕事"   x=550  y=860 width=260 height=70 color=0xffdd88 size=26 target="*sel_work"]
[glink text="休養"   x=830  y=860 width=260 height=70 color=0xaaffaa size=26 target="*sel_rest"]
[glink text="買い物" x=1110 y=860 width=260 height=70 color=0xffaabb size=26 target="*sel_shop"]
[if exp="f._can_job"]
[glink text="転職"   x=1390 y=860 width=260 height=70 color=0xffd700 size=26 target="*sel_job"]
[else]
[glink text="転職"   x=1390 y=860 width=260 height=70 color=0x444444 size=26 target="*mainloop"]
[endif]

[s]

; ==========================================================
; 研鑽
; ==========================================================
*sel_train

[cm]
[iscript]
GameUI.drawStats();
[endscript]
[layopt layer=message0 visible=false]

[glink text="学力" x=155  y=760 width=220 height=70 color=0x88ddff size=26 target="*pre_train_gakuryoku"]
[glink text="体力" x=395  y=760 width=220 height=70 color=0xff8888 size=26 target="*pre_train_tairyoku"]
[glink text="気品" x=635  y=760 width=220 height=70 color=0xffdd88 size=26 target="*pre_train_hihin"]
[glink text="家事" x=875  y=760 width=220 height=70 color=0xaaffaa size=26 target="*pre_train_kaji"]
[glink text="社交" x=1115 y=760 width=220 height=70 color=0xff88ff size=26 target="*pre_train_shakou"]
[glink text="← 戻る" x=1600 y=860 width=200 height=70 color=0x777777 size=22 target="*mainloop"]

[s]

*pre_train_gakuryoku
[iscript]
f._train_stat = "gakuryoku";
f._train_name = "学力";
[endscript]
@jump target="*confirm_train"

*pre_train_tairyoku
[iscript]
f._train_stat = "tairyoku";
f._train_name = "体力";
[endscript]
@jump target="*confirm_train"

*pre_train_hihin
[iscript]
f._train_stat = "hihin";
f._train_name = "気品";
[endscript]
@jump target="*confirm_train"

*pre_train_kaji
[iscript]
f._train_stat = "kaji";
f._train_name = "家事";
[endscript]
@jump target="*confirm_train"

*pre_train_shakou
[iscript]
f._train_stat = "shakou";
f._train_name = "社交";
[endscript]
@jump target="*confirm_train"

*confirm_train

[cm]
[iscript]
GameUI.drawStats();
[endscript]
[layopt layer=message0 visible=true]
[emb exp="f._train_name"] を研鑽しますか？（行動を1消費します）
[glink text="決定"       x=660  y=860 width=260 height=70 color=0xffd700 size=28 target="*do_train"]
[glink text="キャンセル" x=1000 y=860 width=260 height=70 color=0x777777 size=26 target="*mainloop"]
[s]

*do_train

[cm]
[iscript]
f._gain = GameLogic.doTraining(f._train_stat);
f._result_is_great = (f._gain === 4);
GameUI.drawStats();
[endscript]
[layopt layer=message0 visible=true]
[emb exp="f._train_name"] を研鑽しました！　[if exp="f._result_is_great"]【大成功！】[else]【成功】[endif]　+[emb exp="f._gain"][p]

@jump target="*mainloop"
[s]

; ==========================================================
; 仕事
; ==========================================================
*sel_work

[cm]
[iscript]
GameUI.drawStats();
[endscript]
[layopt layer=message0 visible=false]

[glink text="ダイナー" x=270  y=760 width=380 height=70 color=0xffdd88 size=26 target="*pre_work_diner"]
[glink text="図書館"   x=770  y=760 width=380 height=70 color=0x88ddff size=26 target="*pre_work_library"]
[glink text="警備"     x=1270 y=760 width=380 height=70 color=0xff8888 size=26 target="*pre_work_guard"]
[glink text="← 戻る"  x=1670 y=860 width=180 height=70 color=0x777777 size=22 target="*mainloop"]
[s]

*pre_work_diner
[iscript]
f._work_type = "diner";
f._work_name = "ダイナー";
[endscript]
@jump target="*confirm_work"

*pre_work_library
[iscript]
f._work_type = "library";
f._work_name = "図書館";
[endscript]
@jump target="*confirm_work"

*pre_work_guard
[iscript]
f._work_type = "guard";
f._work_name = "警備";
[endscript]
@jump target="*confirm_work"

*confirm_work

[cm]
[iscript]
GameUI.drawStats();
var bonus = GameLogic.getJobBonus();
var wages = { diner:1500, library:1200, guard:3000 };
f._work_wage = Math.floor(wages[f._work_type] * bonus);
[endscript]
[layopt layer=message0 visible=true]
[emb exp="f._work_name"] で働きますか？　報酬予定 [emb exp="f._work_wage"] 円（行動を1消費します）
[glink text="決定"       x=660  y=860 width=260 height=70 color=0xffd700 size=28 target="*do_work"]
[glink text="キャンセル" x=1000 y=860 width=260 height=70 color=0x777777 size=26 target="*mainloop"]
[s]

*do_work

[cm]
[iscript]
var result = GameLogic.doWork(f._work_type);
var nl = { gakuryoku:"学力", tairyoku:"体力", hihin:"気品", kaji:"家事", shakou:"社交" };
var gains = [];
for (var k in result.gains) {
    if (result.gains[k]) gains.push(nl[k] + "+" + result.gains[k]);
}
f._work_gains  = gains.join("  ");
f._work_earned = result.money;
GameUI.drawStats();
[endscript]
[layopt layer=message0 visible=true]
[emb exp="f._work_name"] で働きました！　[emb exp="f._work_gains"]　[emb exp="f._work_earned"] 円獲得[p]

@jump target="*mainloop"
[s]

; ==========================================================
; 休養
; ==========================================================
*sel_rest

[cm]
[iscript]
GameUI.drawStats();
[endscript]
[layopt layer=message0 visible=true]
ゆっくり休みますか？（行動を1消費します）
[glink text="決定"       x=660  y=860 width=260 height=70 color=0xffd700 size=28 target="*do_rest"]
[glink text="キャンセル" x=1000 y=860 width=260 height=70 color=0x777777 size=26 target="*mainloop"]
[s]

*do_rest

[cm]
[iscript]
f.actions_left = (f.actions_left || 0) - 1;
GameUI.drawStats();
[endscript]
[layopt layer=message0 visible=true]
ゆっくり休みました。[p]

@jump target="*mainloop"
[s]

; ==========================================================
; 買い物
; ==========================================================
*sel_shop

[cm]
[iscript]
GameUI.drawStats();
[endscript]
[layopt layer=message0 visible=false]

[glink text="服飾店"   x=270  y=760 width=360 height=70 color=0xffaabb size=26 target="*shop_clothes"]
[glink text="美容室"   x=750  y=760 width=360 height=70 color=0xaabbff size=26 target="*shop_salon"]
[glink text="魔法薬店" x=1230 y=760 width=360 height=70 color=0xaaffaa size=26 target="*shop_magic"]
[glink text="← 戻る"  x=1670 y=860 width=180 height=70 color=0x777777 size=22 target="*mainloop"]
[s]

*shop_clothes
[cm]
[iscript]
GameUI.drawStats();
[endscript]
[layopt layer=message0 visible=true]
（服飾店は近日実装予定です）[p]
@jump target="*mainloop"
[s]

*shop_salon
[cm]
[iscript]
GameUI.drawStats();
[endscript]
[layopt layer=message0 visible=true]
（美容室は近日実装予定です）[p]
@jump target="*mainloop"
[s]

*shop_magic
[cm]
[iscript]
GameUI.drawStats();
[endscript]
[layopt layer=message0 visible=true]
（魔法薬店は近日実装予定です）[p]
@jump target="*mainloop"
[s]

; ==========================================================
; 転職
; ==========================================================
*sel_job

[cm]
[iscript]
GameUI.drawStats();
var jobs = GameLogic.getAvailableJobs();
f._next_job_name = jobs.length > 0 ? jobs[0].name : "";
f._next_job_tier = jobs.length > 0 ? jobs[0].tier  : 0;
[endscript]
[layopt layer=message0 visible=true]
[emb exp="f._next_job_name"] に転職しますか？（行動を1消費します）
[glink text="転職する"   x=660  y=860 width=260 height=70 color=0xffd700 size=28 target="*do_job"]
[glink text="キャンセル" x=1000 y=860 width=260 height=70 color=0x777777 size=26 target="*mainloop"]
[s]

*do_job

[cm]
[iscript]
GameLogic.changeJob(f._next_job_name, f._next_job_tier);
f._night_just_unlocked = (f._next_job_tier === 2);
GameUI.drawStats();
[endscript]
[layopt layer=message0 visible=true]
[emb exp="f._next_job_name"] に転職しました！[if exp="f._night_just_unlocked"]　夜フェーズが解放されました！[endif][p]

@jump target="*mainloop"
[s]

; ==========================================================
; 夜フェーズ
; ==========================================================
*mainloop_night

[cm]
[hidemenubutton]
[iscript]
GameUI.drawStats();
[endscript]
[layopt layer=message0 visible=false]

[glink text="ふれあい" x=270  y=860 width=260 height=70 color=0xffaabb size=26 target="*sel_fureai"]
[glink text="仕事"     x=550  y=860 width=260 height=70 color=0xffdd88 size=26 target="*sel_work"]
[glink text="就寝"     x=830  y=860 width=260 height=70 color=0xaaffaa size=26 target="*sel_rest"]
[glink text="買い物"   x=1110 y=860 width=260 height=70 color=0xffaabb size=26 target="*night_shop"]
[s]

; ==========================================================
; ふれあい
; ==========================================================
*sel_fureai

[cm]
[iscript]
GameUI.drawStats();
[endscript]
[layopt layer=message0 visible=false]

[glink text="口"     x=155  y=760 width=220 height=70 color=0xffaabb size=26 target="*pre_fureai_kuchi"]
[glink text="胸"     x=395  y=760 width=220 height=70 color=0xffaabb size=26 target="*pre_fureai_mune"]
[glink text="下腹部" x=635  y=760 width=220 height=70 color=0xffaabb size=26 target="*pre_fureai_kabu"]
[glink text="陰核"   x=875  y=760 width=220 height=70 color=0xffaabb size=26 target="*pre_fureai_inkaku"]
[glink text="尻"     x=1115 y=760 width=220 height=70 color=0xffaabb size=26 target="*pre_fureai_shiri"]
[glink text="← 戻る" x=1600 y=860 width=200 height=70 color=0x777777 size=22 target="*mainloop_night"]
[s]

*pre_fureai_kuchi
[iscript]
f._fureai_part = "kuchi";
f._fureai_name = "口";
[endscript]
@jump target="*confirm_fureai"

*pre_fureai_mune
[iscript]
f._fureai_part = "mune";
f._fureai_name = "胸";
[endscript]
@jump target="*confirm_fureai"

*pre_fureai_kabu
[iscript]
f._fureai_part = "kabu";
f._fureai_name = "下腹部";
[endscript]
@jump target="*confirm_fureai"

*pre_fureai_inkaku
[iscript]
f._fureai_part = "inkaku";
f._fureai_name = "陰核";
[endscript]
@jump target="*confirm_fureai"

*pre_fureai_shiri
[iscript]
f._fureai_part = "shiri";
f._fureai_name = "尻";
[endscript]
@jump target="*confirm_fureai"

*confirm_fureai

[cm]
[iscript]
GameUI.drawStats();
[endscript]
[layopt layer=message0 visible=true]
[emb exp="f._fureai_name"] を触れますか？（行動を1消費します）
[glink text="決定"       x=660  y=860 width=260 height=70 color=0xffd700 size=28 target="*do_fureai"]
[glink text="キャンセル" x=1000 y=860 width=260 height=70 color=0x777777 size=26 target="*mainloop_night"]
[s]

*do_fureai

[cm]
[iscript]
var before = f[f._fureai_part] || 0;
f._gain = GameLogic.doFureai(f._fureai_part);
var tier = before < 20 ? 1 : before < 40 ? 2 : before < 60 ? 3 : before < 80 ? 4 : before < 90 ? 5 : 6;
var reactions = {
    kuchi: {
        1: "戸惑いながら、おずおずと口を開ける。その頬は赤く染まっていた。",
        2: "少し慣れてきた様子で、素直に従ってくれる。",
        3: "恥ずかしそうにしながらも、積極的になってきた。",
        4: "目を細めて、うっとりとした表情を見せる。",
        5: "自分から求めるように、ねだるような瞳を向けてくる。",
        6: "すっかり虜になった様子で、離れたくないと懇願する。"
    },
    mune: {
        1: "驚いて身体を固め、恥ずかしそうに目を逸らす。",
        2: "こそばゆそうにしながら、されるがままにしている。",
        3: "うっとりと目を閉じ、小さなため息をつく。",
        4: "自然と身体が反応し、期待するように前へ出てくる。",
        5: "快感に目を潤ませ、もっとと言いたげに体を寄せる。",
        6: "完全に開放されて、恍惚の表情を隠そうともしない。"
    },
    kabu: {
        1: "びくっと体を震わせ、強張った表情で耐えている。",
        2: "戸惑いながらも、触れられることを拒まなくなってきた。",
        3: "熱を帯びた吐息をもらし、腰が自然と動き出す。",
        4: "甘い声が漏れ、震える足で必死に立っている。",
        5: "もはや隠しようのない反応を示し、力が抜けていく。",
        6: "完全に身を委ねて、ひたすら快楽を享受している。"
    },
    inkaku: {
        1: "敏感なその部分に触れられ、跳ね上がるように反応する。",
        2: "戸惑いながらも、確かな感覚に息が乱れてくる。",
        3: "甘い刺激に耐えきれず、媚びるような声を上げる。",
        4: "強い快感に目が潤み、泣くように喘ぐ。",
        5: "繰り返される刺激で我を忘れ、自分から腰を動かす。",
        6: "もはや限界を超えて、意識が飛びそうなほど感じている。"
    },
    shiri: {
        1: "恥ずかしそうに顔を赤らめ、腰を引こうとする。",
        2: "されるがままにしながら、くすぐったそうに笑う。",
        3: "羞恥心と快感が混ざり合い、複雑な表情を浮かべる。",
        4: "いつの間にか受け入れて、期待するように身を差し出す。",
        5: "触れられることを喜び、積極的に応えるようになっている。",
        6: "すっかり蕩けて、求めるように体を押しつけてくる。"
    }
};
f._fureai_reaction = reactions[f._fureai_part][tier];
GameUI.drawStats();
[endscript]
[layopt layer=message0 visible=true]
[emb exp="f._fureai_reaction"]　（[emb exp="f._fureai_name"] +[emb exp="f._gain"]）[p]

@jump target="*mainloop_night"
[s]

; ==========================================================
; 夜の買い物
; ==========================================================
*night_shop

[cm]
[iscript]
GameUI.drawStats();
[endscript]
[layopt layer=message0 visible=false]

[glink text="服飾店"  x=430  y=760 width=360 height=70 color=0xffaabb size=26 target="*night_shop_clothes"]
[glink text="← 戻る" x=1670 y=860 width=180 height=70 color=0x777777 size=22 target="*mainloop_night"]
[s]

*night_shop_clothes

[cm]
[iscript]
GameUI.drawStats();
[endscript]
[layopt layer=message0 visible=false]

[glink text="ネグリジェ(3000円)"     x=155  y=660 width=380 height=70 color=0xffaabb size=22 target="*pre_night_buy_negligee"]
[glink text="ビキニ(5000円)"         x=555  y=660 width=380 height=70 color=0xffaabb size=22 target="*pre_night_buy_bikini"]
[glink text="マイクロビキニ(8000円)" x=955  y=660 width=380 height=70 color=0xffaabb size=22 target="*pre_night_buy_micro"]
[glink text="絆創膏(10000円)"        x=1355 y=660 width=380 height=70 color=0xffaabb size=22 target="*pre_night_buy_bandage"]
[glink text="← 戻る"                x=1670 y=860 width=180 height=70 color=0x777777 size=22 target="*night_shop"]
[s]

*pre_night_buy_negligee
[iscript]
f._shop_item_id    = "negligee";
f._shop_item_name  = "ネグリジェ";
f._shop_item_price = 3000;
[endscript]
@jump target="*confirm_night_buy"

*pre_night_buy_bikini
[iscript]
f._shop_item_id    = "bikini";
f._shop_item_name  = "ビキニ";
f._shop_item_price = 5000;
[endscript]
@jump target="*confirm_night_buy"

*pre_night_buy_micro
[iscript]
f._shop_item_id    = "micro_bikini";
f._shop_item_name  = "マイクロビキニ";
f._shop_item_price = 8000;
[endscript]
@jump target="*confirm_night_buy"

*pre_night_buy_bandage
[iscript]
f._shop_item_id    = "bandage";
f._shop_item_name  = "絆創膏";
f._shop_item_price = 10000;
[endscript]
@jump target="*confirm_night_buy"

*confirm_night_buy

[cm]
[iscript]
GameUI.drawStats();
f._shop_can_buy = (f.money || 0) >= f._shop_item_price;
[endscript]
[layopt layer=message0 visible=true]
[if exp="f._shop_can_buy"]
[emb exp="f._shop_item_name"] を購入しますか？　[emb exp="f._shop_item_price"] 円（行動を1消費します）
[glink text="購入する"   x=660  y=860 width=260 height=70 color=0xffd700 size=28 target="*do_night_buy"]
[glink text="キャンセル" x=1000 y=860 width=260 height=70 color=0x777777 size=26 target="*night_shop_clothes"]
[else]
所持金が足りません。（所持金: [emb exp="f.money"] 円 / 必要: [emb exp="f._shop_item_price"] 円）[p]
@jump target="*night_shop_clothes"
[endif]
[s]

*do_night_buy

[cm]
[iscript]
GameLogic.buyItem(f._shop_item_price);
f.night_outfit = f._shop_item_id;
GameUI.drawStats();
[endscript]
[layopt layer=message0 visible=true]
[emb exp="f._shop_item_name"] を購入しました！[p]

@jump target="*mainloop_night"
[s]

; ==========================================================
; フェーズ切替
; ==========================================================
*phase_end

[cm]
[iscript]
GameLogic.nextPhase();
GameUI.drawStats();
f._next_phase_str = f.phase === "night" ? "夜フェーズ" : "日中フェーズ";
f._next_week = f.week || 1;
[endscript]
[layopt layer=message0 visible=true]
フェーズが切り替わりました。　第[emb exp="f._next_week"]週　[emb exp="f._next_phase_str"][p]

@jump target="*mainloop"
[s]
