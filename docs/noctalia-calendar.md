# Noctalia カレンダー

カレンダー機能とMeeting BarプラグインはHome Managerで設定している。反映後、Noctaliaの
**Settings → Calendar → Accounts → Add Account** からカレンダーを追加する。Google、CalDAV、iCloud、
ICS、ローカルvdirに対応する。アカウント情報はNoctalia上で入力し、Nix設定には保存しない。
GoogleトークンとCalDAVパスワードはSecret Serviceに保存される。

同期した予定はControl CenterのCalendarタブに表示される。Noctalia本体の予定通知では、予定に通知指定が
ない場合は10分前を既定値として使う。`yuta/meeting-bar` は同じ同期済み予定を読むため、別途認証は不要。

## Meeting Bar

プラグインは `~/.local/share/noctalia/plugins/meeting-bar` にNixで配置し、`config.toml` で有効化している。
バーの予定を左クリックすると予定一覧、右クリックすると認識済みオンライン会議への参加、中クリックで
プラグイン設定を開く。Niriでは `Mod+Shift+M` で予定一覧、`Mod+Ctrl+M` で現在または次の会議に参加できる。

予定一覧では検索、カレンダー名による絞り込み、会議リンクの表示・コピー、お気に入り登録ができる。
認識済みオンライン会議の開始5分前には全画面リマインダーが表示される。これはNoctalia本体の通知とは
独立しており、DNDや予定ごとの通知設定では抑制されない。リマインダーやバー表示は
**Settings → Plugins → Meeting Bar** から変更できる。

リンクを開くには `xdg-open` を使う。予定の作成や招待送信は行わない。お気に入り、通知済み予定、
スヌーズ状態はNoctaliaのユーザー状態ディレクトリに保存される。カレンダー認証情報や予定一覧全体は
プラグイン側に保存しない。認識されない会議サービスのURLも一覧から開けるが、自動参加や全画面通知の
対象にはならない。

表示中の全画面リマインダーをCLIから閉じる／スヌーズするには次を実行する。

```sh
noctalia msg plugin yuta/meeting-bar:calendar all dismiss
noctalia msg plugin yuta/meeting-bar:calendar all snooze
```

プラグイン本体は[community-plugins PR #1392](https://github.com/noctalia-dev/community-plugins/pull/1392)の
マージコミット `6ebf91a41e27f7e3d09e1edf0e7e035f9ce84917` を同梱している。Noctalia 5.4.0 / Plugin API 37が必要。

なお、v4向けマイク音量パッチはNoctalia v5で廃止されたQMLファイルを変更していたため引き継いでいない。
v5では音量制御がネイティブ実装に置き換わっている。
