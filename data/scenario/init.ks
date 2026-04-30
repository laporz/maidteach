; init.ks - ゲームロジック関数定義
; first.ks から @call storage="init.ks" で呼び出す
; ページロードのたびに実行してJavaScript関数を定義する

[iscript]

// ---- UIパネル ----
window.GameUI = {

    drawStats: function() {
        $("#game_stats_panel").remove();
        $("#game_chara_img").remove();

        // キャラ画像表示（命名規則ファイルが無ければ touka_test.png にフォールバック）
        var imgFile = "chara_" + (f.height||"low") + "_" + (f.body_type||"slender") + "_"
            + (f.outfit||"maid_mini") + "_" + (f.hair_style||"long") + "_" + (f.hair_color||"gold") + ".png";
        var charaBase = "data/fgimage/chara/arisia/";
        var $chara = $('<img id="game_chara_img" src="' + charaBase + imgFile + '"'
            + ' style="position:absolute;left:250px;bottom:80px;max-height:860px;'
            + 'object-fit:contain;pointer-events:none;z-index:100;">');
        $chara.on("error", function() {
            $(this).off("error").attr("src", charaBase + "touka_test.png");
        });
        $("#tyrano_base").append($chara);

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

        var partRows = "";
        if (isNight) {
            var partLabels = { kuchi:"口", mune:"胸", kabu:"下腹部", inkaku:"陰核", shiri:"尻" };
            partRows = '<div style="margin-top:10px;border-top:1px solid #555;padding-top:8px;font-size:13px;color:#aaa;margin-bottom:4px;">部位</div>'
                + ["kuchi","mune","kabu","inkaku","shiri"].map(function(k) {
                    var v   = f[k] || 0;
                    var pct = v + "%";
                    return '<div style="margin-bottom:7px;">'
                         + '<span style="display:inline-block;width:52px;font-size:14px;color:#ffaabb;">' + partLabels[k] + '</span>'
                         + '<span style="display:inline-block;width:140px;height:10px;background:#333;border-radius:5px;vertical-align:middle;margin:0 6px;">'
                         + '<span style="display:inline-block;width:' + pct + ';height:10px;background:#f8a;border-radius:5px;"></span></span>'
                         + '<span style="font-size:14px;">' + v + '</span>'
                         + '</div>';
                }).join('');
        }

        // stats content (pointer-events:none) + キャラステータスボタン (pointer-events:auto)
        var html = '<div id="game_stats_panel"'
            + ' style="position:absolute;top:20px;left:1600px;width:300px;'
            + 'background:rgba(0,0,0,0.80);border:1px solid #666;border-radius:8px;'
            + 'padding:16px;color:white;font-size:15px;z-index:1000000;">'
            + '<div style="pointer-events:none;">'
            + '<div style="font-size:17px;font-weight:bold;margin-bottom:8px;'
            + 'border-bottom:1px solid #555;padding-bottom:6px;">'
            + '第' + (f.week||1) + '週　<span style="color:' + phaseCol + ';">' + phaseStr + '</span></div>'
            + '<div style="margin-bottom:5px;">職業: <span style="color:#ffd700;">' + (f.job_name||"無職") + '</span></div>'
            + '<div style="margin-bottom:10px;">行動: <span style="color:#7f7;">' + actLeft + '</span> / ' + actMax + '</div>'
            + rows
            + partRows
            + '<div style="margin-top:8px;border-top:1px solid #555;padding-top:6px;">'
            + '所持金: <span style="color:#ffd700;">¥' + (f.money||0).toLocaleString() + '</span></div>'
            + '</div>'
            + '<div onclick="GameUI.showCharaStatus();" style="margin-top:10px;padding:7px 0;'
            + 'background:rgba(80,80,80,0.7);border:1px solid #999;border-radius:6px;'
            + 'text-align:center;font-size:14px;color:#ddd;cursor:pointer;pointer-events:auto;">'
            + 'キャラステータス</div>'
            + '</div>';

        $("#tyrano_base").append(html);
    },

    clear: function() { $("#game_stats_panel").remove(); $("#game_chara_img").remove(); },

    // エピソード中のキャラ表示（現在の外見を自動反映）
    // position: "left" / "center" / "right"
    showEpisodeChara: function(position) {
        $("#ep_chara_img").remove();
        var imgFile = "chara_" + (f.height||"low") + "_" + (f.body_type||"slender") + "_"
            + (f.outfit||"maid_mini") + "_" + (f.hair_style||"long") + "_" + (f.hair_color||"gold") + ".png";
        var xPos = { left: 100, center: 450, right: 1100 }[position || "center"] || 450;
        var $img = $('<img id="ep_chara_img" src="data/fgimage/chara/arisia/' + imgFile + '" '
            + 'style="position:absolute;left:' + xPos + 'px;bottom:80px;max-height:860px;'
            + 'object-fit:contain;pointer-events:none;z-index:100;">');
        $img.on("error", function() {
            $(this).off("error").attr("src", "data/fgimage/chara/arisia/touka_test.png");
        });
        $("#tyrano_base").append($img);
    },

    // エピソード中のキャラ非表示
    hideEpisodeChara: function() {
        $("#ep_chara_img").remove();
    },

    // items: [{id, name, price, category, isCurrent}]
    // parentTarget: ← 戻るの遷移先, selfTarget: 購入後・キャンセル後の遷移先
    drawShopItems: function(items, parentTarget, selfTarget) {
        $("#shop_items").remove();
        var $wrap = $('<div id="shop_items" style="position:absolute;top:0;left:0;width:1920px;height:1080px;pointer-events:none;z-index:1000010;"></div>');
        var BTN_W = 240, BTN_H = 80, GAP = 16, ROW_H = 104;
        var rows = [];
        for (var i = 0; i < items.length; i += 5) rows.push(items.slice(i, i + 5));
        var startY = Math.round((920 - rows.length * ROW_H) / 2);
        rows.forEach(function(rowItems, ri) {
            var rowW = rowItems.length * BTN_W + (rowItems.length - 1) * GAP;
            var startX = Math.round((1920 - rowW) / 2);
            var y = startY + ri * ROW_H;
            rowItems.forEach(function(item, ci) {
                (function(it, x) {
                    var cur = it.isCurrent;
                    var $btn = $('<div style="position:absolute;left:' + x + 'px;top:' + y + 'px;'
                        + 'width:' + BTN_W + 'px;height:' + BTN_H + 'px;'
                        + 'background:rgba(0,0,0,0.7);border:2px solid ' + (cur ? '#444' : '#88ddff') + ';border-radius:8px;'
                        + 'color:' + (cur ? '#555' : '#fff') + ';font-size:16px;text-align:center;'
                        + 'padding-top:12px;box-sizing:border-box;'
                        + 'cursor:' + (cur ? 'default' : 'pointer') + ';pointer-events:auto;">'
                        + '<div>' + it.name + '</div>'
                        + '<div style="font-size:12px;color:' + (cur ? '#555' : '#ffd700') + ';margin-top:4px;">'
                        + (cur ? '（現在）' : it.price.toLocaleString() + '円') + '</div>'
                        + '</div>');
                    if (!cur) {
                        $btn.on('click', function() {
                            f._shop_item_id     = it.id;
                            f._shop_item_name   = it.name;
                            f._shop_item_price  = it.price;
                            f._shop_category    = it.category;
                            f._shop_back_target = selfTarget;
                            $("#shop_items").remove();
                            TYRANO.kag.ftag.startTag("jump", { target: "*confirm_purchase", storage: "" });
                        });
                    }
                    $wrap.append($btn);
                })(rowItems[ci], startX + ci * (BTN_W + GAP));
            });
        });
        var $cancel = $('<div style="position:absolute;left:1660px;top:940px;width:180px;height:60px;'
            + 'background:rgba(0,0,0,0.5);border:2px solid #777;border-radius:8px;'
            + 'color:#777;font-size:20px;text-align:center;line-height:60px;'
            + 'cursor:pointer;pointer-events:auto;">← 戻る</div>');
        $cancel.on('click', function() {
            $("#shop_items").remove();
            TYRANO.kag.ftag.startTag("jump", { target: parentTarget, storage: "" });
        });
        $wrap.append($cancel);
        $("#tyrano_base").append($wrap);
    },

    showCharaStatus: function() {
        $("#chara_status_overlay").remove();

        var outfitNames = {
            maid_mini:     "メイド服(ミニ)",
            maid_long:     "メイド服(ロング)",
            sailor_white:  "セーラー服(白)",
            sailor_black:  "セーラー服(黒)",
            virgin_killer: "童貞を殺すセーター"
        };
        var nightOutfitNames = {
            negligee_white: "ネグリジェ(白)",
            negligee_black: "ネグリジェ(黒)",
            bikini_black:   "ビキニ(黒)",
            micro_white:    "マイクロビキニ(白)",
            bandage:        "絆創膏"
        };

        var $overlay = $('<div id="chara_status_overlay" style="position:absolute;top:0;left:0;width:1920px;height:1080px;background:rgba(0,0,0,0.95);z-index:1000020;pointer-events:auto;"></div>');

        // 左半分：キャラ画像
        // ファイル名規則: chara_{身長}_{体型}_{服}_{髪型}_{髪色}.png
        var imgFile = "chara_" + (f.height||"low") + "_" + (f.body_type||"slender") + "_"
            + (f.outfit||"maid_mini") + "_" + (f.hair_style||"long") + "_" + (f.hair_color||"gold") + ".png";
        var $imgArea = $('<div style="position:absolute;left:0;top:0;width:960px;height:1080px;display:flex;align-items:center;justify-content:center;"></div>');
        var $img = $('<img id="chara_img" src="data/fgimage/chara/arisia/' + imgFile + '" style="max-width:880px;max-height:960px;object-fit:contain;" onerror="$(this).replaceWith(\'<div style=\\\"color:#555;font-size:18px;\\\">（画像なし）</div>\');">');
        $imgArea.append($img);
        $overlay.append($imgArea);

        // 右半分：タブUI
        var $right = $('<div style="position:absolute;left:960px;top:0;width:960px;height:1080px;padding:40px 50px;box-sizing:border-box;color:white;overflow-y:auto;"></div>');
        var $tabBar = $('<div style="display:flex;gap:4px;margin-bottom:20px;"></div>');
        var $tabContent = $('<div></div>');
        var currentTab = 0;

        function renderTab(idx) {
            currentTab = idx;
            $tabBar.find(".cs-tab").each(function(i) {
                $(this).css({
                    background: i === idx ? "#ffd700" : "rgba(70,70,70,0.9)",
                    color:      i === idx ? "#000"    : "#fff"
                });
            });
            $tabContent.empty();

            if (idx === 0) {
                // ステータスタブ
                var isNight = f.phase === "night";
                var labels = isNight
                    ? { gakuryoku:"知識", tairyoku:"精力", hihin:"清楚", kaji:"奉仕", shakou:"羞恥" }
                    : { gakuryoku:"学力", tairyoku:"体力", hihin:"気品", kaji:"家事", shakou:"社交" };
                var html = '<div style="font-size:22px;font-weight:bold;margin-bottom:14px;">'
                    + '職業: <span style="color:#ffd700;">' + (f.job_name||"無職") + '</span></div>'
                    + '<div style="font-size:18px;margin-bottom:20px;">'
                    + '所持金: <span style="color:#ffd700;">¥' + (f.money||0).toLocaleString() + '</span></div>';
                ["gakuryoku","tairyoku","hihin","kaji","shakou"].forEach(function(k) {
                    var v = f[k]||0;
                    html += '<div style="margin-bottom:14px;font-size:17px;">'
                        + '<span style="display:inline-block;width:72px;">' + labels[k] + '</span>'
                        + '<span style="display:inline-block;width:280px;height:14px;background:#333;border-radius:7px;vertical-align:middle;margin:0 10px;">'
                        + '<span style="display:inline-block;width:' + v + '%;height:14px;background:#4af;border-radius:7px;"></span></span>'
                        + '<span>' + v + '</span></div>';
                });
                $tabContent.append($(html));

            } else if (idx === 1) {
                // 服タブ
                var ownedDay   = f.owned_outfits       || {};
                var ownedNight = f.owned_night_outfits || {};
                var curDay     = f.outfit      || "maid_mini";
                var curNight   = f.night_outfit || "";

                var $dayLabel = $('<div style="font-size:16px;color:#aaa;margin-bottom:12px;border-bottom:1px solid #444;padding-bottom:6px;">日中の服</div>');
                $tabContent.append($dayLabel);
                var $dayGrid = $('<div style="display:flex;flex-wrap:wrap;gap:10px;margin-bottom:28px;"></div>');
                Object.keys(outfitNames).forEach(function(id) {
                    var isCur   = curDay === id;
                    var isOwned = !!ownedDay[id];
                    var $item = $('<div style="width:150px;height:78px;border-radius:8px;text-align:center;padding-top:12px;box-sizing:border-box;font-size:14px;'
                        + (isCur   ? 'background:rgba(50,50,50,0.7);border:2px solid #555;color:#555;cursor:default;'
                          : isOwned ? 'background:rgba(0,0,0,0.7);border:2px solid #88ddff;color:#fff;cursor:pointer;'
                          :           'background:rgba(15,15,15,0.5);border:2px solid #333;color:#333;cursor:default;')
                        + '">'
                        + (isOwned || isCur ? outfitNames[id] : "？")
                        + '<div style="font-size:11px;margin-top:4px;color:'
                        + (isCur ? '#555' : isOwned ? '#88ddff' : '#2a2a2a') + ';">'
                        + (isCur ? '着用中' : isOwned ? '変更する' : '未購入') + '</div></div>');
                    if (isOwned && !isCur) {
                        (function(oid) {
                            $item.on("click", function() {
                                f.outfit = oid;
                                var newFile = "chara_" + (f.height||"low") + "_" + (f.body_type||"slender") + "_"
                                    + oid + "_" + (f.hair_style||"long") + "_" + (f.hair_color||"gold") + ".png";
                                $("#chara_img").attr("src", "data/fgimage/chara/arisia/" + newFile);
                                renderTab(1);
                            });
                        })(id);
                    }
                    $dayGrid.append($item);
                });
                $tabContent.append($dayGrid);

                if (f.night_unlocked) {
                    $tabContent.append($('<div style="font-size:16px;color:#aaa;margin-bottom:12px;border-bottom:1px solid #444;padding-bottom:6px;">夜の服</div>'));
                    var $nightGrid = $('<div style="display:flex;flex-wrap:wrap;gap:10px;"></div>');
                    Object.keys(nightOutfitNames).forEach(function(id) {
                        var isCur   = curNight === id;
                        var isOwned = !!ownedNight[id];
                        var $item = $('<div style="width:150px;height:78px;border-radius:8px;text-align:center;padding-top:12px;box-sizing:border-box;font-size:14px;'
                            + (isCur   ? 'background:rgba(50,50,50,0.7);border:2px solid #555;color:#555;cursor:default;'
                              : isOwned ? 'background:rgba(0,0,0,0.7);border:2px solid #ffaabb;color:#fff;cursor:pointer;'
                              :           'background:rgba(15,15,15,0.5);border:2px solid #333;color:#333;cursor:default;')
                            + '">'
                            + (isOwned || isCur ? nightOutfitNames[id] : "？")
                            + '<div style="font-size:11px;margin-top:4px;color:'
                            + (isCur ? '#555' : isOwned ? '#ffaabb' : '#2a2a2a') + ';">'
                            + (isCur ? '着用中' : isOwned ? '変更する' : '未購入') + '</div></div>');
                        if (isOwned && !isCur) {
                            (function(oid) {
                                $item.on("click", function() {
                                    f.night_outfit = oid;
                                    renderTab(1);
                                });
                            })(id);
                        }
                        $nightGrid.append($item);
                    });
                    $tabContent.append($nightGrid);
                }

            } else if (idx === 2) {
                // エッチステータスタブ
                var bodyLabel  = f.body_type === "glamorous" ? "グラマラス" : "スレンダー";
                var heightLabel = f.height === "high" ? "高身長" : "低身長";
                var partLabels = { kuchi:"口", mune:"胸", kabu:"下腹部", inkaku:"陰核", shiri:"尻" };
                var html = '<div style="margin-bottom:20px;font-size:17px;">'
                    + '<span style="color:#aaa;">体型: </span><span style="color:#ffaabb;">' + bodyLabel + '</span>'
                    + '　<span style="color:#aaa;">身長: </span><span style="color:#ffaabb;">' + heightLabel + '</span></div>';
                ["kuchi","mune","kabu","inkaku","shiri"].forEach(function(k) {
                    var v = f[k]||0;
                    html += '<div style="margin-bottom:14px;font-size:17px;">'
                        + '<span style="display:inline-block;width:72px;color:#ffaabb;">' + partLabels[k] + '</span>'
                        + '<span style="display:inline-block;width:260px;height:14px;background:#333;border-radius:7px;vertical-align:middle;margin:0 10px;">'
                        + '<span style="display:inline-block;width:' + v + '%;height:14px;background:#f8a;border-radius:7px;"></span></span>'
                        + '<span>' + v + '</span></div>';
                });
                $tabContent.append($(html));
            }
        }

        ["ステータス","服","エッチステータス"].forEach(function(name, i) {
            var $tab = $('<div class="cs-tab" style="padding:10px 22px;border-radius:6px 6px 0 0;font-size:17px;cursor:pointer;'
                + (i === 0 ? 'background:#ffd700;color:#000;' : 'background:rgba(70,70,70,0.9);color:#fff;')
                + '">' + name + '</div>');
            $tab.on("click", (function(idx){ return function(){ renderTab(idx); }; })(i));
            $tabBar.append($tab);
        });

        $right.append($tabBar);
        $right.append($tabContent);
        $overlay.append($right);

        // 閉じるボタン
        var $close = $('<div style="position:absolute;right:40px;top:30px;padding:10px 26px;'
            + 'background:rgba(70,70,70,0.9);border:2px solid #999;border-radius:8px;'
            + 'font-size:20px;color:#fff;cursor:pointer;">✕ 閉じる</div>');
        $close.on("click", function() {
            $("#chara_status_overlay").remove();
            GameUI.drawStats();
        });
        $overlay.append($close);

        renderTab(0);
        $("#tyrano_base").append($overlay);
    },

    drawJobButtons: function(jobs, cancelTarget) {
        $("#job_buttons").remove();
        var $wrap = $('<div id="job_buttons" style="position:absolute;top:0;left:0;width:1920px;height:1080px;pointer-events:none;z-index:1000010;"></div>');

        // tier でグループ化
        var groups = {};
        for (var i = 0; i < jobs.length; i++) {
            var t = jobs[i].tier;
            if (!groups[t]) groups[t] = [];
            groups[t].push(jobs[i]);
        }

        var tierOrder = [1, 2, 3, 4];
        var tierLabels = { 1:"1次職", 2:"2次職", 3:"3次職", 4:"4次職" };
        var BTN_W = 240, BTN_H = 64, GAP = 16;
        var ROW_H = 110; // ラベル＋ボタン
        var visibleTiers = tierOrder.filter(function(t){ return groups[t] && groups[t].length > 0; });
        var totalH = visibleTiers.length * ROW_H;
        var startY = Math.round((900 - totalH) / 2); // 画面中央より少し上

        visibleTiers.forEach(function(tier, rowIdx) {
            var rowJobs = groups[tier];
            var rowW = rowJobs.length * BTN_W + (rowJobs.length - 1) * GAP;
            var rowX = Math.round((1920 - rowW) / 2);
            var labelY = startY + rowIdx * ROW_H;
            var btnY   = labelY + 30;

            // tierラベル
            var $label = $('<div style="position:absolute;left:' + rowX + 'px;top:' + labelY + 'px;'
                + 'color:#aaa;font-size:14px;pointer-events:none;">' + tierLabels[tier] + '</div>');
            $wrap.append($label);

            rowJobs.forEach(function(job, col) {
                (function(j, bx) {
                    var $btn = $('<div style="position:absolute;left:' + bx + 'px;top:' + btnY + 'px;'
                        + 'width:' + BTN_W + 'px;height:' + BTN_H + 'px;'
                        + 'background:rgba(0,0,0,0.7);border:2px solid #ffd700;border-radius:8px;'
                        + 'color:#ffd700;font-size:18px;text-align:center;line-height:' + BTN_H + 'px;'
                        + 'cursor:pointer;pointer-events:auto;">' + j.name + '</div>');
                    $btn.on('click', function() {
                        f._next_job_name  = j.name;
                        f._next_job_tier  = j.tier;
                        f._next_job_route = j.route || "";
                        $("#job_buttons").remove();
                        TYRANO.kag.ftag.startTag("jump", { target: "*confirm_job_selected", storage: "" });
                    });
                    $wrap.append($btn);
                })(job, rowX + col * (BTN_W + GAP));
            });
        });

        var $cancel = $('<div style="position:absolute;left:1660px;top:940px;width:180px;height:60px;'
            + 'background:rgba(0,0,0,0.5);border:2px solid #777;border-radius:8px;'
            + 'color:#777;font-size:20px;text-align:center;line-height:60px;'
            + 'cursor:pointer;pointer-events:auto;">← 戻る</div>');
        $cancel.on('click', function() {
            $("#job_buttons").remove();
            TYRANO.kag.ftag.startTag("jump", { target: cancelTarget, storage: "" });
        });
        $wrap.append($cancel);
        $("#tyrano_base").append($wrap);
    }
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
        var total    = this.getTotal();
        var curTier  = f.job_tier  || 0;
        var curRoute = f.job_route || "";
        var sv = {
            gakuryoku: (f.gakuryoku||0),
            tairyoku:  (f.tairyoku||0),
            hihin:     (f.hihin||0),
            kaji:      (f.kaji||0),
            shakou:    (f.shakou||0)
        };
        var job1 = { gakuryoku:"見習い魔術師", tairyoku:"見習い剣士", hihin:"修道女",      kaji:"見習い錬金術師", shakou:"見習い吟遊詩人" };
        var job2 = { gakuryoku:"魔術師",       tairyoku:"剣士",       hihin:"プリエステス", kaji:"錬金術師",       shakou:"吟遊詩人"       };
        var job3 = { gakuryoku:"大賢者",       tairyoku:"パラディン", hihin:"聖女",         kaji:"アルケミマスター",shakou:"スーパーアイドル"};
        var bodyKey = (f.height||"low") + "_" + (f.body_type||"slender");
        var job4map = {
            "low_slender":    { tier:4, name:"エレメンタルマスター", route:"" },
            "high_slender":   { tier:4, name:"ハイエルフクイーン",   route:"" },
            "low_glamorous":  { tier:4, name:"聖獣使い",             route:"" },
            "high_glamorous": { tier:4, name:"ナイトマスター",        route:"" }
        };

        // 4次職後: 全1-3次職に自由転職 + 4次職体型転職
        if (curTier === 4) {
            var list = [];
            Object.keys(sv).forEach(function(k) {
                if (total >= 100 && sv[k] >= 30)  list.push({ tier:1, name:job1[k], route:k });
                if (total >= 200 && sv[k] >= 60)  list.push({ tier:2, name:job2[k], route:k });
                if (total >= 400 && sv[k] >= 100) list.push({ tier:3, name:job3[k], route:k });
            });
            list.push(job4map[bodyKey]);
            return list;
        }

        // 無職: 全1次職候補（ルート未確定）
        if (curTier === 0) {
            if (total >= 100)
                return Object.keys(sv).filter(function(k){ return sv[k] >= 30; })
                             .map(function(k){ return { tier:1, name:job1[k], route:k }; });
            return [];
        }

        // 1～3次職: 同ルートのみ上位職に進む
        if (total >= 500) return [ job4map[bodyKey] ];
        if (total >= 400 && sv[curRoute] >= 100) return [ { tier:3, name:job3[curRoute], route:curRoute } ];
        if (total >= 200 && sv[curRoute] >= 60)  return [ { tier:2, name:job2[curRoute], route:curRoute } ];
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
        //var gain = Math.random() < 0.33 ? 4 : 2;
        var gain = Math.random() < 0.33 ? 20 : 20;
        f[statName] = Math.min(100, (f[statName]||0) + gain);
        f.actions_left = (f.actions_left||0) - 1;
        return gain;
    },

    // ふれあい（同確率）
    doFureai: function(partName) {
        //var gain = Math.random() < 0.33 ? 4 : 2;
        var gain = Math.random() < 0.33 ? 20 : 20;
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
    changeJob: function(jobName, jobTier, jobRoute) {
        f.job_name  = jobName;
        f.job_tier  = jobTier;
        if (jobRoute) f.job_route = jobRoute;
        f.actions_left = (f.actions_left||0) - 1;
        if (jobTier >= 2) f.night_unlocked = true;
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
    },

    // ---- エピソード管理 ----

    // 指定キーのエピソードを閲覧済みか返す
    hasSeenEpisode: function(key) {
        return !!(f.episodes && f.episodes[key]);
    },

    // 指定キーのエピソードを閲覧済みにする
    markEpisode: function(key) {
        if (!f.episodes) f.episodes = {};
        f.episodes[key] = true;
    },

    // 休養・就寝時に再生すべき未視聴エピソードのラベルを返す
    // なければ null を返す（将来ここに条件を追加する）
    getPendingRestEpisode: function() {
        if (!f.episodes) f.episodes = {};
        // ここに解放済み・未視聴のエピソードチェックを追加可能
        // 例：if (f.episodes["ending_good_sage_unlocked"] && !f.episodes["ending_good_sage_seen"]) {
        //         f.episodes["ending_good_sage_seen"] = true;
        //         return "*ep_ending_good_sage";
        //     }
        return null;
    }
};

[endscript]

[return]
