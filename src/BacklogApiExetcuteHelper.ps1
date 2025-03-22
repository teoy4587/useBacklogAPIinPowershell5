# 引数定義　
Param(
  [parameter(Mandatory = $true)][ValidateSet("get", "post")]$Arg1, #HTTPmethod(GETまたはPOST)
  [parameter(Mandatory = $true)][ValidateSet("issues", "projects", "wikis")]$Arg2, #issuesなどのURL部分
  $Arg3 #パラメーター
)

# 設定ファイルの読み込み
. .config.ps1

function BacklogApiExetcuteHelper {
  # ログ出力の開始
  Start-Transcript "./log/$today.log" -Append -ErrorAction Stop
  try {
    # 入力値を元にAPIを実行する
    $url = makeUrl $Arg2 $Arg3
    $res = executeApI $url $Arg1
    makeResultFile $res
  }
  catch {
    # Exceptionの文字コードはそのままで問題ないので変換しない
    $ErrorMessage = $_.Exception.Message
    Write-Host "ErrorMessage : $ErrorMessage"  
  }
  finally {
    # ログ出力の停止
    Stop-Transcript
  }
}

#実行対象のURLを組み立て
function makeUrl {
  Param ([parameter(Mandatory = $true)][string]$target, [parameter][string]$params)

  $urlStrings = $urlBase + $target + $apiKey

  return $urlStrings
}

#get/postリクエストを送信してAPIを実行
function executeApI {
  Param ([parameter(Mandatory = $true)]$urlFull, [parameter(Mandatory = $true)][string]$method)
  return Invoke-RestMethod -uri $urlFull -method $method -ErrorAction Stop
}

# 結果をutf8のJSON形式に変換してファイルに出力
function makeResultFile {
  Param ([parameter(Mandatory = $true)]$result)

  $res_JSON = ConvertTo-JSON $result 
  [System.Text.Encoding]::Utf8.GetString([System.Text.Encoding]::GetEncoding("ISO-8859-1").GetBytes($res_JSON)) | Out-File -LiteralPath "./output/result_$today.txt" -Encoding utf8 -ErrorAction Stop
}

BacklogApiExetcuteHelper