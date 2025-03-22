$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

# 設定ファイルの読み込み
. .config.ps1

Describe "BacklogApiExetcuteHelper" {
  Context "Normal"{
    # 対象あり・ISSUE_KEYなし
    It "get issues" {
      makeUrl | Should Be $urlBase + 'issuess' + $apiKey
    }
  }

  Context "abnormal"{
  }
}