; main.ks - 育成メインループ

; ==========================================================
; メインループ
; ==========================================================
*mainloop

[cm]
[showmenubutton]
[bg storage="room.jpg" time=1]

[layopt layer=message0 visible=false]
[position layer=message0 page=fore left=160 top=955 width=1600 height=90 opacity=210 margint=18 marginl=40 marginr=40 marginb=10]

[iscript]
GameUI.drawStats();
f._actions_left = f.actions_left || 0;
f._is_night = f.phase === "night";
var jobs = GameLogic.getAvailableJobs();
var curTier = f.job_tier || 0;
var curName = f.job_name || "";
f._can_job = jobs.some(function(j) {
    if (curTier === 4) return j.name !== curName;
    return j.tier > curTier;
});
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
f._shop_entered = false;
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
var cur = f.outfit || "maid_mini";
GameUI.drawShopItems([
    { id:"maid_mini",      name:"メイド服(ミニ)",    price:12000, category:"outfit", isCurrent: cur==="maid_mini"      },
    { id:"maid_long",      name:"メイド服(ロング)",  price:15000, category:"outfit", isCurrent: cur==="maid_long"      },
    { id:"sailor_white",   name:"セーラー服(白)",    price:10000, category:"outfit", isCurrent: cur==="sailor_white"   },
    { id:"sailor_black",   name:"セーラー服(黒)",    price:10000, category:"outfit", isCurrent: cur==="sailor_black"   },
    { id:"virgin_killer",  name:"童貞を殺すセーター", price:40000, category:"outfit", isCurrent: cur==="virgin_killer"  }
], "*sel_shop", "*shop_clothes");
[endscript]
[layopt layer=message0 visible=false]
[s]

*shop_salon
[cm]
[iscript]
GameUI.drawStats();
[endscript]
[layopt layer=message0 visible=false]

[glink text="髪型変更" x=530  y=760 width=360 height=70 color=0xaabbff size=26 target="*shop_salon_style"]
[glink text="髪色変更" x=1030 y=760 width=360 height=70 color=0xaabbff size=26 target="*shop_salon_color"]
[glink text="← 戻る"  x=1670 y=860 width=180 height=70 color=0x777777 size=22 target="*sel_shop"]
[s]

*shop_salon_style
[cm]
[iscript]
GameUI.drawStats();
var cur = f.hair_style || "long";
GameUI.drawShopItems([
    { id:"short",     name:"ショートヘア", price:3000, category:"hair_style", isCurrent: cur==="short"     },
    { id:"semi_long", name:"セミロング",   price:3000, category:"hair_style", isCurrent: cur==="semi_long" },
    { id:"long",      name:"ロングヘア",   price:3000, category:"hair_style", isCurrent: cur==="long"      },
    { id:"twin",      name:"ツインテール", price:3000, category:"hair_style", isCurrent: cur==="twin"      },
    { id:"pony",      name:"ポニーテール", price:3000, category:"hair_style", isCurrent: cur==="pony"      }
], "*shop_salon", "*shop_salon_style");
[endscript]
[layopt layer=message0 visible=false]
[s]

*shop_salon_color
[cm]
[iscript]
GameUI.drawStats();
var cur = f.hair_color || "gold";
GameUI.drawShopItems([
    { id:"white",  name:"白",   price:3000, category:"hair_color", isCurrent: cur==="white"  },
    { id:"black",  name:"黒",   price:3000, category:"hair_color", isCurrent: cur==="black"  },
    { id:"red",    name:"赤",   price:3000, category:"hair_color", isCurrent: cur==="red"    },
    { id:"pink",   name:"ピンク", price:3000, category:"hair_color", isCurrent: cur==="pink"   },
    { id:"green",  name:"緑",   price:3000, category:"hair_color", isCurrent: cur==="green"  },
    { id:"blue",   name:"青",   price:3000, category:"hair_color", isCurrent: cur==="blue"   },
    { id:"gold",   name:"金",   price:3000, category:"hair_color", isCurrent: cur==="gold"   }
], "*shop_salon", "*shop_salon_color");
[endscript]
[layopt layer=message0 visible=false]
[s]

*shop_magic
[cm]
[iscript]
GameUI.drawStats();
var curH = f.height    || "low";
var curB = f.body_type || "slender";
GameUI.drawShopItems([
    { id:"high",      name:"高身長になる",    price:50000,  category:"height",    isCurrent: curH==="high"      },
    { id:"low",       name:"低身長になる",    price:50000,  category:"height",    isCurrent: curH==="low"       },
    { id:"glamorous", name:"グラマラスになる", price:150000, category:"body_type", isCurrent: curB==="glamorous" },
    { id:"slender",   name:"スレンダーになる", price:150000, category:"body_type", isCurrent: curB==="slender"   }
], "*sel_shop", "*shop_magic");
[endscript]
[layopt layer=message0 visible=false]
[s]

; 購入確認（日中・夜共通）
*confirm_purchase

[cm]
[iscript]
GameUI.drawStats();
f._shop_can_buy = (f.money || 0) >= f._shop_item_price;
[endscript]
[layopt layer=message0 visible=true]
[if exp="f._shop_can_buy"]
[emb exp="f._shop_item_name"] を購入しますか？　[emb exp="f._shop_item_price"] 円
[glink text="購入する"   x=660  y=860 width=260 height=70 color=0xffd700 size=28 target="*do_purchase"]
[glink text="キャンセル" x=1000 y=860 width=260 height=70 color=0x777777 size=26 target="*shop_back_from_confirm"]
[else]
所持金が足りません。（[emb exp="f.money"] 円 / 必要: [emb exp="f._shop_item_price"] 円）[p]
@jump target="*shop_back_from_confirm"
[endif]
[s]

*shop_back_from_confirm
[iscript]
TYRANO.kag.ftag.startTag("jump", { target: f._shop_back_target || "*sel_shop", storage: "" });
[endscript]
[s]

*do_purchase

[cm]
[iscript]
if (!f._shop_entered) {
    f.actions_left = (f.actions_left || 0) - 1;
    f._shop_entered = true;
}
f.money = (f.money || 0) - f._shop_item_price;
if (f._shop_category === "outfit") {
    f.outfit = f._shop_item_id;
    if (!f.owned_outfits) f.owned_outfits = {};
    f.owned_outfits[f._shop_item_id] = true;
}
if (f._shop_category === "hair_style")   f.hair_style   = f._shop_item_id;
if (f._shop_category === "hair_color")   f.hair_color   = f._shop_item_id;
if (f._shop_category === "height")       f.height       = f._shop_item_id;
if (f._shop_category === "body_type")    f.body_type    = f._shop_item_id;
if (f._shop_category === "night_outfit") {
    f.night_outfit = f._shop_item_id;
    if (!f.owned_night_outfits) f.owned_night_outfits = {};
    f.owned_night_outfits[f._shop_item_id] = true;
}
GameUI.drawStats();
[endscript]
[layopt layer=message0 visible=true]
[emb exp="f._shop_item_name"] を購入しました！[p]
@jump target="*shop_back_from_confirm"
[s]

; ==========================================================
; 転職
; ==========================================================
*sel_job

[cm]
[iscript]
GameUI.drawStats();
var jobs = GameLogic.getAvailableJobs();
var curTier = f.job_tier || 0;
var curName = f.job_name || "";
var eligible = jobs.filter(function(j) {
    if (curTier === 4) return j.name !== curName;
    return j.tier > curTier;
});
GameUI.drawJobButtons(eligible, "*mainloop");
[endscript]
[layopt layer=message0 visible=false]
[s]

*confirm_job_selected

[cm]
[iscript]
GameUI.drawStats();
[endscript]
[layopt layer=message0 visible=true]
[emb exp="f._next_job_name"] に転職しますか？（行動を1消費します）
[glink text="転職する"   x=660  y=860 width=260 height=70 color=0xffd700 size=28 target="*do_job"]
[glink text="キャンセル" x=1000 y=860 width=260 height=70 color=0x777777 size=26 target="*mainloop"]
[s]

*do_job

[cm]
[iscript]
GameLogic.changeJob(f._next_job_name, f._next_job_tier, f._next_job_route);
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
[showmenubutton]
[iscript]
GameUI.drawStats();
f._actions_left = f.actions_left || 0;
[endscript]

[if exp="f._actions_left <= 0"]
@jump target="*phase_end"
[endif]

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
f._shop_entered = false;
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
var cur = f.night_outfit || "";
GameUI.drawShopItems([
    { id:"negligee_white", name:"ネグリジェ(白)",    price:20000, category:"night_outfit", isCurrent: cur==="negligee_white" },
    { id:"negligee_black", name:"ネグリジェ(黒)",    price:20000, category:"night_outfit", isCurrent: cur==="negligee_black" },
    { id:"bikini_black",   name:"ビキニ(黒)",        price:50000, category:"night_outfit", isCurrent: cur==="bikini_black"   },
    { id:"micro_white",    name:"マイクロビキニ(白)", price:50000, category:"night_outfit", isCurrent: cur==="micro_white"    },
    { id:"bandage",        name:"絆創膏",            price:5000,  category:"night_outfit", isCurrent: cur==="bandage"        }
], "*night_shop", "*night_shop_clothes");
[endscript]
[layopt layer=message0 visible=false]
[s]

; ==========================================================
; キャラステータス画面
; ==========================================================
*chara_status

[cm]
[iscript]
GameUI.showCharaStatus();
[endscript]
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
