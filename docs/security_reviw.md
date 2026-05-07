# セキュリティレビュー（初回）

## 概要

- 実施日：2026-05-07
- ブランチ：setup/security-tools
- 実施者：misaki_fk
- 目的：本格運用前の脆弱性棚卸し（Issue #173）

## 使用ツール

| ツール | バージョン | 役割 |
|---|---|---|
| Brakeman | （`bundle list \| grep brakeman` の結果） | Rails向け静的解析（コード由来の脆弱性検出） |
| bundler-audit | （`bundle list \| grep bundler-audit` の結果） | 依存Gemの既知CVEチェック |

## 結果サマリ

| 項目 | 件数 |
|---|---|
| Brakeman 検出（コード由来） | 0 件 |
| Brakeman 検出（依存EOL） | 2 件 |
| bundler-audit 検出（初回） | 7 件 |
| bundler-audit 検出（パッチ後） | 1 件 |

## 対応した内容

下記のGemをpatch updateして対応した。

| Gem | 旧 | 新 | 関連CVE/GHSA |
|---|---|---|---|
| bcrypt | 3.1.21 | 3.1.22+ | GHSA-f27w-vcwj-c954（JRuby限定なので実害なし） |
| devise | 5.0.0 | 5.0.3+ | GHSA-57hq-95w6-v4fc |
| loofah | 2.25.0 | 2.25.1+ | GHSA-46fp-8f5p-pf2m |
| nokogiri | 1.19.0 | 1.19.1+ | GHSA-wx95-c6cv-8532 |
| rack | 3.2.4 | 3.2.5+ | GHSA-mxw3-3hh2-x2mh（High）/ GHSA-whrj-4476-wvmp |

## 保留した内容（別issueで対応）

| 項目 | 理由 | 対応方針 |
|---|---|---|
| activestorage の DoS（CVE-2026-33658） | 単体で上げられず Rails 本体のアップグレードが必要 | Rails 7.2系 アップグレードのissueで対応 |
| Ruby 3.2.2 EOL | アップグレードに互換性検証が必要 | Issue②（テスト整備）後に対応 |
| Rails 7.1.6 EOL | 同上 | 同上 |

## 検証

- アプリ起動：問題なし
- ログイン（LINE）：成功
- ログイン（メール/パスワード、Devise）：成功
- Brakeman再実行：警告内容に変化なし（EOL 2件のみ）
- bundler-audit 再実行：activestorage 1件のみ残存（保留扱い）

## 次のアクション

- [ ] Issue 174：テスト実装
- [ ] 別issue：Rails 7.1 → 7.2系 アップグレード（activestorage / Rails EOL を解消）　検討
- [ ] 別issue：Ruby 3.2 → 3.3 系アップグレード 検討
- [ ] 別issue：CI（GitHub Actions）でセキュリティスキャンを自動化