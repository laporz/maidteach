# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Behavioral guidelines to reduce common LLM coding mistakes. Merge with project-specific instructions as needed.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

---

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.

---

## プロジェクト概要

ティラノスクリプトで作成する、キャラクター育成シミュレーションゲームを作成します。
基本的にボタンを押すことで、基礎的なステータス及びお金が増減するだけの、シンプルな内容です。

ターゲット解像度: 1920×1080

## ゲームシステム
### ゲーム期間
- 特に期限は設けず、ずっと続きます

### 女性を一流のメイドに育成するゲームです。
- キャラクター初期外見
  - 金髪・長髪
  - エルフ耳
  - 低身長スレンダー体型
  - メイド服

- キャラクターの見た目
アイテム・店舗で変更可能
  - ヘアカラー(髪色変更)
  - 美容室(髪型変更)
  - 魔法薬(体型変化)
  - 服飾店(服装変更)

### キャラクターの育成要素、日中のステータスと夜のステータスをそれぞれ育成する
- 日中のステータス
  - 学力
  - 体力
  - 気品
  - 家事
  - 社交
- 夜のステータス
  - 知識(学力と数値共有で、夜フェーズになった時に項目名だけ切り替わる)
  - 精力(体力と数値共有で、夜フェーズになった時に項目名だけ切り替わる)
  - 清楚(気品と数値共有で、夜フェーズになった時に項目名だけ切り替わる)
  - 奉仕(家事と数値共有で、夜フェーズになった時に項目名だけ切り替わる)
  - 羞恥(社交と数値共有で、夜フェーズになった時に項目名だけ切り替わる)
- 部位のステータス
  - 口
  - 胸
  - 下腹部
  - 陰核
  - 尻

- ステータスについて
  - 全て0～100で管理
  - それぞれのステータスの傾向で性格が決定する
  - 能力の上昇については、道具・イベント・コマンドによって影響する

- 性格については以下のように能力を参照して決定されます
  下記能力値を満たしたうえで、日中コマンドの転職を実行することで、転職を行う
  転職可能な職業が複数ある場合は、転職コマンドにて全ての選択肢を表示する
  - 1次職性格(フェーズ毎に3回行動可能)
    - 能力の合算が100以上、学力が30以上の場合→見習い魔術師
    - 能力の合算が100以上、体力が30以上の場合→見習い剣士
    - 能力の合算が100以上、気品が30以上の場合→修道女
    - 能力の合算が100以上、家事が30以上の場合→見習い錬金術師
    - 能力の合算が100以上、社交が30以上の場合→見習い吟遊詩人
  - 2次職性格(フェーズ毎に4回行動可能)
    - 能力の合算が200以上、学力が60以上の場合→魔術師
    - 能力の合算が200以上、体力が60以上の場合→剣士
    - 能力の合算が200以上、気品が60以上の場合→プリエステス
    - 能力の合算が200以上、家事が60以上の場合→錬金術師
    - 能力の合算が200以上、社交が60以上の場合→吟遊詩人
  - 3次職性格(フェーズ毎に5回行動可能)
    - 能力の合算が400以上、学力が100の場合→大賢者
    - 能力の合算が400以上、体力が100の場合→パラディン
    - 能力の合算が400以上、気品が100の場合→聖女
    - 能力の合算が400以上、家事が100の場合→アルケミマスター
    - 能力の合算が400以上、社交が100の場合→スーパーアイドル
  - 4次職性格(フェーズ毎に5回行動可能)
    - 能力の合算が500に到達、低身長スレンダー→エレメンタルマスター
    - 能力の合算が500に到達、高身長スレンダー→ハイエルフクイーン
    - 能力の合算が500に到達、低身長グラマラス→聖獣使い
    - 能力の合算が500に到達、高身長グラマラス→ナイトマスター
    ※4次職は全ての能力が100になっているため、体型と身長で職業が分岐する

## ゲームの流れ
- タイトル画面
  - スタート
  - ロード
  - 設定(音量設定：マスター、BGM、SE、ボイス)
  - ゲーム終了
- オープニング
  - 女性との出会い
- チュートリアル
  - 1週目の流れを説明し、その流れに沿って行動させる
    - 日中：それぞれの日中ステータスを強化するコマンドを実行し、結果表示
    - 夜：2次職性格到達後に解放のため初回はスキップされ、2次職到達時に説明を入れる
- ゲーム本編開始
  - 育成を重ねて、ステータス・職業変化が発生するタイミングで画像とストーリーを元にエピソードを開始する
- 3次職性格到達時
  - それぞれの職でGoodエンディングを解放する
- 4次職性格到達次
  - それぞれの職でTrueエンディングを解放する

## ゲーム本編の詳細
- 日中フェーズ(職性格毎の行動回数を以下から選択して消費する。すべての行動は行動回数を１消費で実行。)
  それぞれの大項目を選択して決定した場合に行動回数を消費します。確認画面でキャンセルした場合は消費無し。
  それぞれの大項目の中の小項目での選択には行動回数を消費しませんので、髪色を複数回変更したり、複数の買い物をしても、１の消費となります。
  - 研鑽(学力・体力・気品・家事・社交それぞれの項目を選んで能力をあげる(成功時+2、大成功時+4：成功判定は33%で大成功、失敗は無し))
  - 仕事
    - ダイナー(社交+1・家事+1 ＋ 基礎給料1500円*職業補正
    - 図書館(学力+1・気品+1 ＋ 基礎給料1200円*職業補正
    - 警備(体力+1 ＋ 基礎給料3000円*職業補正
    - ※職業補正について：一次0.7、二次1.0、三次1.5、四次1.8倍
  - 休養
    - 解放されたエピソードがある場合はそのシーンを再生
    - ない場合はプレイヤーとの会話
  - 買い物
    - 服飾店
      - 服が売ってあり、服装変更が可能
        - メイド服(ミニスカート)：12000円
        - メイド服(ロングスカート)：15000円
        - セーラー服(白)：10000円
        - セーラー服(黒)：10000円
        - 童貞を殺すセーター：40000円
    - 美容室
      - 髪型を変更可能(現在の髪型はグレーアウトなどで選択できなくする)
        - ショートヘア：3000円
        - セミロング：3000円
        - ロングヘア：3000円
        - ツインテール：3000円
        - ポニテール：3000円
      - 髪色の変更(現在の髪色はグレーアウトなどで選択できなくする)
        - 白・黒・赤・ピンク・緑・青・金　それぞれ3000円で変更可能
    - 魔法薬店
      - 身長・体型を変更させる薬を処方してもらうことができる
      - 現在の体型はグレーアウトなどで選択できなくする
        - 高身長になる：50000円
        - 低身長になる：50000円
        - スレンダーになる：150000円
        - グラマラスになる：150000円
  - 転職
    - 条件を満たしている場合に、選択できる職業を選択することで、転職が可能
    - 条件を満たしたうえで、この行動を実行することで職業の変更が可能です
    - 行動力は他と同じく１消費されます。

- 夜フェーズ(※二次職到達後に解放、職性格毎の行動回数を以下から選択して消費する)
  それぞれの大項目を選択して決定した場合に行動回数を消費します。確認画面でキャンセルした場合は消費無し。
  - ふれあい
    - 部位毎の選択肢を表示し、それぞれの開発度をあげる
    - 0-19,20-39,40-59,60-79,80-89,90-100で違う反応を返す
    - 成功時+2、大成功時+4：成功判定は33%で大成功、失敗は無し
  - 仕事
    - ダイナー(社交+1・家事+1 ＋ 基礎給料1500円*職業補正
    - 図書館(学力+1・気品+1 ＋ 基礎給料1200円*職業補正
    - 警備(体力+1 ＋ 基礎給料3000円*職業補正
    - ※職業補正について：一次0.7、二次1.0、三次1.5、四次1.8倍
  - 就寝
    - 解放されたエピソードがある場合はそのシーンを再生
    - ない場合はプレイヤーとの会話
  - 買い物(他の店舗は営業時間を終えているので、服飾店のみ選択可能です)
    - 服飾店
      - 日中フェーズとは別のテイストの服が売ってあり、服装変更が可能
        - ネグリジェ(白)：20000円
        - ネグリジェ(黒)：20000円
        - ビキニ(黒)：50000円
        - マイクロビキニ(白)：50000円
        - 絆創膏(ニップレス)：5000円
  

## セーブ仕様
- ゲーム画面の右上にハンバーガーメニューを配置し、ゲーム中の如何なる場面でもセーブ＆ロード可能

## エピソード発生条件
- 各職業に就いたタイミングで、その職業固有のエピソード発生
- 3次職、4次職時でエンディングを閲覧した時にエピソード発生
- エンディング後も次の週にシーンを映すだけで、ゲームの終了にはならない