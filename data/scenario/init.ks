; init.ks - ゲームロジック関数定義
; first.ks から @call storage="init.ks" で呼び出す
; ページロードのたびに実行してJavaScript関数を定義する

[iscript]

// ---- UIパネル ----
window.GameUI = {

    drawStats: function() {
        $("#game_stats_panel").remove();

        var isNight  = f.phase === "night";
        var labels   = isNight
            ? { gakuryoku:"知識", tairyoku:"精力", hihin:"清楚", kaji:"奉仕", shakou:"羞恥" }
            : { gakuryoku:"学力", tairyoku:"体力", hihin:"気品",  kaji:"家事",  shakou:"社交"  };

        var actLeft  = f.actions_left || 0;
        var actMax   = GameLogic.getMaxActions();
        var phaseStr = isNight ? "夜フェーズ" : "日中フェーズ";
        var phaseCol = isNight ? "#aaf"       : "#ffa";

        var rows = ["gakuryoku","tairyoku","hihin","kaji","shakou"].map(function(k) {
            var v   = f[k] || 0;
            var pct = v + "%";
            return '<div style="margin-bottom:7px;">'
                 + '<span style="display:inline-block;width:48px;font-size:14px;">' + labels[k] + '</span>'
                 + '<span style="display:inline-block;width:160px;height:10px;background:#333;border-radius:5px;vertical-align:middle;margin:0 6px;">'
                 + '<span style="display:inline-block;width:' + pct + ';height:10px;background:#4af;border-radius:5px;"></span></span>'
                 + '<span style="font-size:14px;">' + v + '</span>'
                 + '</div>';
        }).join('');

        var html = '<div id="game_stats_panel"'
            + ' style="position:absolute;top:20px;left:1600px;width:300px;'
            + 'background:rgba(0,0,0,0.80);border:1px solid #666;border-radius:8px;'
            + 'padding:16px;color:white;font-size:15px;pointer-events:none;z-index:500;">'
            + '<div style="font-size:17px;font-weight:bold;margin-bottom:8px;'
            + 'border-bottom:1px solid #555;padding-bottom:6px;">'
            + '第' + (f.week||1) + '週　<span style="color:' + phaseCol + ';">' + phaseStr + '</span></div>'
            + '<div style="margin-bottom:5px;">職業: <span style="color:#ffd700;">' + (f.job_name||"無職") + '</span></div>'
            + '<div style="margin-bottom:10px;">行動: <span style="color:#7f7;">' + actLeft + '</span> / ' + actMax + '</div>'
            + rows
            + '<div style="margin-top:8px;border-top:1px solid #555;padding-top:6px;">'
            + '所持金: <span style="color:#ffd700;">¥' + (f.money||0).toLocaleString() + '</span></div>'
            + '</div>';

        $("#tyrano_base").append(html);
    },

    clear: function() { $("#game_stats_panel").remove(); }
};

// ---- ゲームロジック ----
window.GameLogic = {

    // ---- ステータス参照 ----

    getTotal: function() {
        return (f.gakuryoku||0) + (f.tairyoku||0) + (f.hihin||0) + (f.kaji||0) + (f.shakou||0);
    },

    getMaxStat: function() {
        var stats = {
            gakuryoku: (f.gakuryoku||0),
            tairyoku:  (f.tairyoku||0),
            hihin:     (f.hihin||0),
            kaji:      (f.kaji||0),
            shakou:    (f.shakou||0)
        };
        return Object.keys(stats).reduce(function(a, b) {
            return stats[a] >= stats[b] ? a : b;
        });
    },

    // ---- 転職可能な職業リスト ----

    getAvailableJobs: function() {
        var total   = this.getTotal();
        var maxStat = this.getMaxStat();
        var job1 = { gakuryoku:"見習い魔術師", tairyoku:"見習い剣士", hihin:"修道女",     kaji:"見習い錬金術師", shakou:"見習い吟遊詩人" };
        var job2 = { gakuryoku:"魔術師",       tairyoku:"剣士",       hihin:"プリエステス", kaji:"錬金術師",       shakou:"吟遊詩人"       };
        var job3 = { gakuryoku:"大賢者",       tairyoku:"パラディン", hihin:"聖女",         kaji:"アルケミマスター",shakou:"スーパーアイドル"};

        if (total >= 500) {
            var job4map = {
                "low_slender":    { tier:4, name:"エレメンタルマスター" },
                "high_slender":   { tier:4, name:"ハイエルフクイーン"   },
                "low_glamorous":  { tier:4, name:"聖獣使い"             },
                "high_glamorous": { tier:4, name:"ナイトマスター"        }
            };
            var key = (f.height||"low") + "_" + (f.body_type||"slender");
            return [ job4map[key] ];
        }
        if (total >= 400) return [ { tier:3, name:job3[maxStat] } ];
        if (total >= 300) return [ { tier:2, name:job2[maxStat] } ];
        if (total >= 100) return [ { tier:1, name:job1[maxStat] } ];
        return [];
    },

    // ---- 行動回数・職業補正 ----

    getMaxActions: function() {
        var tier = f.job_tier || 0;
        if (tier >= 3) return 5;
        if (tier === 2) return 4;
        if (tier === 1) return 3;
        return 2;
    },

    getJobBonus: function() {
        var tier = f.job_tier || 0;
        if (tier === 4) return 3.0;
        if (tier === 3) return 2.0;
        if (tier === 2) return 1.5;
        if (tier === 1) return 1.0;
        return 0.5;
    },

    // ---- アクション ----

    // 研鑽（67%で+2、33%で+4、失敗なし）
    doTraining: function(statName) {
        var gain = Math.random() < 0.33 ? 4 : 2;
        f[statName] = Math.min(100, (f[statName]||0) + gain);
        f.actions_left = (f.actions_left||0) - 1;
        return gain;
    },

    // ふれあい（同確率）
    doFureai: function(partName) {
        var gain = Math.random() < 0.33 ? 4 : 2;
        f[partName] = Math.min(100, (f[partName]||0) + gain);
        f.actions_left = (f.actions_left||0) - 1;
        return gain;
    },

    // 仕事
    doWork: function(workType) {
        var bonus  = this.getJobBonus();
        var result = { gains:{}, money:0 };

        if (workType === "diner") {
            f.shakou = Math.min(100, (f.shakou||0) + 1);
            f.kaji   = Math.min(100, (f.kaji||0)   + 1);
            result.gains = { shakou:1, kaji:1 };
            result.money = Math.floor(1500 * bonus);
        } else if (workType === "library") {
            f.gakuryoku = Math.min(100, (f.gakuryoku||0) + 1);
            f.hihin     = Math.min(100, (f.hihin||0)     + 1);
            result.gains = { gakuryoku:1, hihin:1 };
            result.money = Math.floor(1200 * bonus);
        } else if (workType === "guard") {
            f.tairyoku = Math.min(100, (f.tairyoku||0) + 1);
            result.gains = { tairyoku:1 };
            result.money = Math.floor(3000 * bonus);
        }

        f.money = (f.money||0) + result.money;
        f.actions_left = (f.actions_left||0) - 1;
        return result;
    },

    // 転職
    changeJob: function(jobName, jobTier) {
        f.job_name    = jobName;
        f.job_tier    = jobTier;
        f.actions_left = (f.actions_left||0) - 1;
        if (jobTier >= 2) {
            f.night_unlocked = true;
        }
    },

    // フェーズ送り（行動回数が0になったら呼ぶ）
    nextPhase: function() {
        if (f.phase === "day") {
            if (f.night_unlocked) {
                f.phase = "night";
            } else {
                f.week = (f.week||1) + 1;
            }
        } else {
            f.phase = "day";
            f.week  = (f.week||1) + 1;
        }
        f.actions_left = this.getMaxActions();
    },

    // 購入
    buyItem: function(price) {
        if ((f.money||0) < price) return false;
        f.money = (f.money||0) - price;
        f.actions_left = (f.actions_left||0) - 1;
        return true;
    }
};

[endscript]

[return]
