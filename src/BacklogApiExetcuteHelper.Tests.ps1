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
  }
}