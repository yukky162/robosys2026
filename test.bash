#!/bin/bash
# SPDX-FileCopyrightText: 2026 Yukine Higuchi
# SPDX-License-Identifier: BSD-3-Clause

ng () {                               # 関数ngの定義（P18と同じ）
         echo ${1}行目のテスト失敗
         res=1                          # 失敗したことを記録
}

res=0                                  # 0: 失敗なし（ngが呼ばれると1になる）

### NORMAL INPUT ###
out=$(seq 5 | ./plus)
[ "$?" = 0 ]      || ng "$LINENO"
[ "${out}" = 15 ] || ng "$LINENO"
### STRANGE INPUT ###
out=$(echo あ | ./plus)           #計算できない値を入力してみる
[ "$?" = 1 ]      || ng "$LINENO" #終了ステータスが1なのを確認
[ "${out}" = "" ] || ng "$LINENO" #上の行と入れ替えるとダメ（なぜ？）

out=$(echo | ./plus)              #なにも入力しない
[ "$?" = 1 ]      || ng "$LINENO" #これも異常終了する
[ "${out}" = "" ] || ng "$LINENO"

### STATS NORMAL INPUT ###
expected=$'count: 5\nsum: 15\nmean: 3.0\nmin: 1\nmax: 5'
out=$(seq 5 | ./stats)
[ "$?" = 0 ]        || ng "$LINENO"
[ "${out}" = "${expected}" ] || ng "$LINENO"

out=$(seq 5 | ./stats --min --max)
[ "$?" = 0 ]        || ng "$LINENO"
[ "${out}" = $'min: 1\nmax: 5' ] || ng "$LINENO"

### STATS STRANGE INPUT ###
out=$(echo あ | ./stats 2>/dev/null)
[ "$?" = 1 ]        || ng "$LINENO"
[ "${out}" = "" ]   || ng "$LINENO"

out=$(echo | ./stats 2>/dev/null)
[ "$?" = 1 ]        || ng "$LINENO"
[ "${out}" = "" ]   || ng "$LINENO"
[ "${res}" = 0 ] && echo OK
exit $res

