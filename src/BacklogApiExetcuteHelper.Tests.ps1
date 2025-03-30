# 引数定義　
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

# 設定ファイルの読み込み
. .config.ps1

Describe 'BacklogApiExetcuteHelper' {

  Context 'Normal' {
    # 引き渡したパラメーターを元に作成したURLが返却される
    It 'makeUrl' {
      $result = makeUrl 'test'
      $result | Should Be ($urlBase + 'test' + $apiKey)
    }

    # GETリクエストで動作するAPIを実行して結果が返却される
    It 'executeApIGet' {
      $urlTest = makeUrl 'issues'
      executeApIGet $urlTest | Should not be $null
    }

    # postリクエストで動作するAPIを実行して結果が返却される
    It 'executeApIExceptGet' {
      $urlTest = makeUrl 'watchings' '1134245'
      executeApIExceptGet $urlTest 'post' 'note' 'test' | Should not be $null
    }

    IT 'makeResultFile' {
      # JSONデータを元にtxtファイルを作成する
      $jsonString = '{ "key1":"test", "key2" : "value2",  "key3" : "true" }'
      $jsonObject = ConvertFrom-Json $JsonString

      makeResultFile $jsonObject
      (Test-Path "./output/result_$today.txt") | Should be true

    }
  }
}