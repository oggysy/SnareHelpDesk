## プロジェクト名
### Snare Help Desk

## 概要
いつでもスネアについての相談ができるチャット機能付きスネアドラム検索アプリ<br>
スネアを検索し、気になるスネアがあればチャットで質問すると、すぐに回答が得られる<br>
<br>
<br>
![SnareHelpDesk説明](https://github.com/oggysy/SnareHelpDesk/assets/93628118/60056130-1fd3-4c37-8dfd-9a8404a6d700)


## 環境構築
1. リポジトリをclone
　　git clone https://github.com/oggysy/SnareHelpDesk.git
2. cocoapodsをインストール
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
・MessageKit<br>
チャット画面のUIを作成するライブラリ<br>
・OpenAISwift<br>
ChatGPTAPIを利用するためのライブラリ<br>
・RealmSwift<br>
データをローカルに保存するためのデータベースライブラリ<br>
・SDWebImage<br>
URLから画像を挿入するためのライブラリ<br>
## バージョン管理
GitHubを使用
## デザインパターン
MVCモデルを使用
