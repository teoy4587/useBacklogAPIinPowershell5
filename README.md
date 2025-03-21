# useBacklogAPIinPowershell5
Backlog API をpowershell5系で使う

公式ドキュメント：https://developer.nulab.com/ja/docs/backlog/

※自明とはいえ「パラメーターにapikeyは必須」という記述は無かったり、コピペ→編集で使えるようなサンプルが認証と認可のページにしか見当たらなかったり、ドキュメントの使い勝手はあまりよくない。あてにせず自力でトライアンドエラーした方が早い


## 基本的なURLの作り方
'ベースになるURL'＋'API操作したい対象項目'＋'APIKey'（～ここまで必須）+'個別のパラメーター'

'https://〇〇〇.backlog.jp/api/v2/' + 'issues' + '?apiKey=発行したAPIKey' + '&projectId[]=9999999'


組み立てたときに以下のようになっていればよい。
>'https://〇〇〇.backlog.jp/api/v2/issues?apiKey=発行したAPIKey&projectId[]=9999999'

### パラメーターの作り方
以下の三種類の方法が存在する。

- GETの場合、URL末尾に「&parameter[]=999999」のような記述を追加する
- POSTの場合、bodyにパラメーターを設定する
- 「API操作したい対象項目」側に記載する
    - 「ユーザー情報の取得」など
    - https://developer.nulab.com/ja/docs/backlog/api/2/get-user/
        - GET /api/v2/users/:userId
        - 「:」は不要、「v2/users/999」のように記載すればよい
         - ※この:userIdは「ユーザー一覧の取得」で取得出来る項目で言うとuserIdではなくidの方


## API実行サンプル
### GETする場合
特定のプロジェクトに対して課題一覧を取得するケース
>https://developer.nulab.com/ja/docs/backlog/api/2/get-issue-list/

~~~
Invoke-RestMethod -uri 'https://〇〇〇.backlog.jp/api/v2/issues?apiKey=発行したAPIKey&projectId[]=9999999' -method get
~~~

### POSTする場合
特定の課題（KADAI-01）に対して「test」というコメントを追加するケース
>https://developer.nulab.com/ja/docs/backlog/api/2/add-comment/

~~~
$headers = @{"Content-Type" = "application/x-www-form-urlencoded"}
$params = @{"content" = "test"}

$urlBase = 'https://〇〇〇.backlog.jp/api/v2/'
$apiKey = '?apiKey=発行したAPIKey'

$urlFull = $urlBase + 'issues/' + 'KADAI-01/' + 'comments' + $apikey

Invoke-RestMethod -uri $urlFull -method post -Headers $headers -Body $params
~~~

## 戻り値の扱い方
Invoke-RestMethodを使用する場合、戻り値がLatin-1として解釈されるため日本語が文字化けする。（Latin-1になるのはレスポンスヘッダにcharset指定がない時のpowershell側の仕様と思われる）

>https://learn.microsoft.com/en-us/archive/msdn-technet-forums/d795e7d2-dcf1-4323-8e06-8f06ce31a897

utf8等、他の文字コードで扱うためには以下のように変換が必要。

getした結果を変数$resに代入して、その中の「name」という項目の文字コードをutf-8とするケース

~~~
[System.Text.Encoding]::Utf8.GetString([System.Text.Encoding]::GetEncoding("ISO-8859-1").GetBytes($res[0].name))
~~~

