# useBacklogAPIinPowershell5
Backlog API をpowershell5系で使う

## 引数
- 以下のいずれかの方法で入力する
- .\BacklogApiExecuteHelper.ps1 param1 param2 param3 param4 param5
-  .\BacklogApiExecuteHelper.ps1を実行後、Arg1とArg2の入力を求められる

### 引数の内容
- 必須：method(GETまたはPOST)
	- "get", "post", "patch"のみ入力可能
- 必須：どのAPIを実行するかの識別子
	- "issues", "projects", "wikis", "watchings"のみ入力可能
- 任意：URLに組み込むパラメーター
	- ～/api/v2/users/:userId の「:userId」
- 任意：body経由で引き渡すパラメーター名
- 任意：body経由で引き渡すパラメーター
	- 2つで1セットとして扱う
	- $params = @{"$parameterName" = "$parameter"}
