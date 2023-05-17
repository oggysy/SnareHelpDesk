## プロジェクト名
### Snare Help Desk

## 概要
いつでもスネアについての相談ができるチャット機能付きスネアドラム検索アプリ<br>
スネアを検索し、気になるスネアがあればチャットで質問すると、すぐに回答が得られる<br>

## 環境構築
1. リポジトリをclone
　　git clone https://github.com/oggysy/SnareHelpDesk.git
1. cocoapodsをインストール
　　sudo gem install cocoapods
3. cocoapodsをセットアップ
　　pod setup
4. ライブラリのインストール
　　pod install

### 開発環境
| 項目 | バージョン |
| ---- | -------- |
| Xcode | 14.1 |
| Swift    | 5.7.2 |
| iOS    | 15.0以上 |
| CocoaPods    | 1.12.0 |
| MessageKit | 4.1.1 |
| OpenAISwift | 1.3.0 |
| SDWebImage | 5.15.6 |
| Realm | 10.39.0 |

## 使用ライブラリ
・MessageKit
チャット画面のUIを作成するライブラリ
・OpenAISwift
ChatGPTAPIを利用するためのライブラリ
・RealmSwift
データをローカルに保存するためのデータベースライブラリ
・SDWebImage
URLから画像を挿入するためのライブラリ
## バージョン管理
GitHubを使用
## デザインパターン
MVCモデルを使用
