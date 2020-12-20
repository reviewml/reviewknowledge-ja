= htmltableのテスト

//htmltable[kakuteiA][確定申告書A]{
-----------------
@<dtp>{table rowspan=5,cellstyle=earning}所得金額	給与	区分	@<dtp>{table cellstyle=input}□□□	①	@<dtp>{table cellstyle=input}□□□□□□□□□
.	@<dtp>{table colspan=3}雑	.	.	②	@<dtp>{table cellstyle=input}□□□□□□□□□
.	@<dtp>{table colspan=3}配当	.	.	③	@<dtp>{table cellstyle=input}□□□□□□□□□
.	@<dtp>{table colspan=3}一時	.	.	④	@<dtp>{table cellstyle=input}□□□□□□□□□
.	@<dtp>{table colspan=3}合計@<br>{}(①+②+③+④)	.	.	⑤	@<dtp>{table cellstyle=input}□□□□□□□□□
//}

//rawhtmltable[freedom][自由すぎる表]{
<table>
<tr><th rowspan="2"></th><th colspan="2">データMAX 5G with Dazon</th></tr>
<tr><th>通常</th><th>2GB以下の場合</th></tr>
<tr><th>2年契約 適用時 <b>[1]</b></th><td>9,180円</td><td>7,700円</td></tr>
<tr><th>家族割プラス</th><td colspan="2"><table>
  <tr><th>2人</th><td>-500円</td></tr>
  <tr><th>3人</th><td>-1,000円</td></tr>
  <tr><th>4人 <b>[2]</b></th><td>-2,020円</td></tr>
  </table></td></tr>
<tr><th>スマートバリュー <b>[3]</b></th><td colspan="2">-1,000円</td></tr>
<tr><th>スマホ応援割 <b>[4]</b><span class="note">※翌月から6カ月間</span></th><td colspan="2">-1,400円</td></tr>
<tr><th>5Gスタート割 <b>[5]</b><span class="note">※翌月から12カ月間</span></th><td colspan="2">-1,000円</td></tr>
</table>
//}
