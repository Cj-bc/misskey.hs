[English](README.md)

---

# misskey-hs

[syuilo/Misskey](https://github.com/syuilo/misskey)のAPIのHaskellライブラリ

# 使用方法

## CLIツールとして

`stack run --`で、各種APIを呼び出すコマンドを使うことができます。
`optparse-applicative`を使っているので、`stack run -- --help`でヘルプが出ます。


## ライブラリとして

このライブラリは以下のモジュールを提供します:

| module                             | 説明                                         |
|:-:|:-:|
| `Network.Misskey.Type`             | ライブラリで共通して使う方が定義されています |
| `Network.Misskey.Api.Users.Show`   | `users/show`用のAPIRequestと関数             |
| `Network.Misskey.Api.Users.Search` | `users/search`用のAPIRequestと関数           |
| `Network.Misskey.Api.Users.Notes`  | `users/Notes`用のAPIRequestと関数            |
| `Network.Misskey.Api.Users.Users`  | `users`用のAPIRequestと関数                  |


### Basic usage

APIを呼び出す関数は`Network.Misskey.Api.*`にあります。  
呼びたいAPIに対応する関数(例えば`users/show`なら`usersShow`)に、
各モジュールで定義されている`APIRequest`型の値を与え、
`MisskeyEnv`とともに`runMisskey`を呼び出してください。


例. `users/show` APIリクエストを筆者(`cj_bc_sd@virtual-kaf.fun`)について飛ばして結果を出力する
```haskell
import Network.Misskey.Api.Users.Show (usersShow, APIRequest(..))
import Network.Misskey.Type (User(..), MisskeyEnv(..))


main :: IO ()
main = do
    let env = MisskeyEnv ""                -- Misskey token.今回は必要ないので空文字列にします。
                         "virtual-kaf.fun" -- APIリクエストを飛ばすドメイン
        req = UserName "cj_bc_sd"          -- `UserName`は`usersShow`用のAPIRequestの値コンストラクターです

    -- APIを叩き、結果を返します
    usr <- runMisskey (usersShow req) env

    print usr
```

詳細は[misskey's api document](https://misskey.io/api-doc)(少し情報が欠けている模様)とHaddockを確認してください。

