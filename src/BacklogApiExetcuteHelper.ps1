# 引数定義　
Param(
  [parameter(Mandatory = $true)][ValidateSet("get", "post", "patch")][string]$Arg1, #HTTPmethod(GETまたはPOST)
  [parameter(Mandatory = $true)][ValidateSet("issues", "projects", "wikis", "watchings")][string]$Arg2, #issuesなどのURL部分
  [string]$Arg3, #URLに組み込むパラメーター
  [string]$Arg4, #body経由で引き渡すパラメーター名
  [string]$Arg5 #body経由で引き渡すパラメーター
)

# 設定ファイルの読み込み
. .config.ps1

function BacklogApiExetcuteHelper {
  # ログ出力の開始
  Start-Transcript "./log/$today.log" -Append -ErrorAction Stop
  try {
    # 入力値を元にAPIを実行する
    $url = makeUrl $Arg2 $Arg3
    Write-Host $url
    if($arg1 -eq "get"){
    $res = executeApIGet $url
  } else {
    $res = executeApIExceptGet $url $Arg1 $Arg4 $Arg5
  }
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
  Param ([parameter(Mandatory = $true)][string]$target, [string]$params)

  if($null -eq $params){
    #URLにパラメーターを含まない場合
  $urlStrings = $urlBase + $target + $apiKey
  }
  else {
    #
    $urlStrings = $urlBase + $target + '/' + $params + $apiKey
  }

  return $urlStrings
}

#getリクエストを送信してAPIを実行
function executeApIGet {
  Param ([parameter(Mandatory = $true)]$urlFull)
  return Invoke-RestMethod -uri $urlFull -method get -ErrorAction Stop
}

#get以外（postやpatch）のリクエストを送信してAPIを実行
function executeApIExceptGet {
  Param ([parameter(Mandatory = $true)]$urlFull, [parameter(Mandatory = $true)][string]$method, [string]$parameterName, [string]$parameter)

  if ($null -ne $parameterName){
    $headers = @{"Content-Type" = "application/x-www-form-urlencoded"}
    $params = @{"$parameterName" = "$parameter"}
  }

    return Invoke-RestMethod -uri $urlFull  -method $method -Headers $headers -Body $params -ErrorAction Stop

}

# 結果をutf8のJSON形式に変換してファイルに出力
function makeResultFile {
  Param ([parameter(Mandatory = $true)]$result)

  $res_JSON = ConvertTo-JSON $result 
  [System.Text.Encoding]::Utf8.GetString([System.Text.Encoding]::GetEncoding("ISO-8859-1").GetBytes($res_JSON)) | Out-File -LiteralPath "./output/result_$today.txt" -Encoding utf8 -ErrorAction Stop
}

BacklogApiExetcuteHelper