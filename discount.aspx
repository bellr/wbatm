<?php
require("customsql.inc.aspx");
$db = new CustomSQL($DBName);
//$db_admin = new CustomSQL_admin($DBName_admin);
//$db_exchange = new CustomSQL_exchange($DBName_exchange);
//$db_pay_desk = new CustomSQL_pay_desk($DBName_pay_desk);
include("usercheck.aspx");
if(!empty($_POST['add_d'])) {
$db->add_discount($_POST['indef'],$_POST['amount'],$_POST['size_d']);
}
elseif($_POST['edit_d']) {
if($_POST['status']) $status = 1;
else $status = 0;
$db->edit_discount($_POST['id'],$_POST['amount'],$_POST['size_d'],$status);
}
elseif($_POST['del_d']) {$db->del_discount($_POST['id']);}
?>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=win-1251">
<meta content="none" name="ROBOTS">
<link rel="stylesheet" href="http://atm.wm-rb.net/style/style.css" type="text/css">
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0">

<div style="width: 300px" align="right">
	<b>Добавить скидку</b><br />
<form method="post" action="discount.aspx">
	Индетификатор скидки : <input type="text" id="indef" name="indef" value="" /><br />
	Сумма скидки : <input type="text" name="amount" value="" /><br />
	Размер скидки : <input type="text" name="size_d" value="" /><br />
	<input type="submit" name="add_d" value="добавить"/>
</form>
</div>
<table width="50%" border="0" cellspacing="1" cellpadding="4" bgcolor="#FFFFFF">
	<tr align=center>
		<td bgcolor="#F2F2F2">Индетификатор</td>
		<td bgcolor="#F2F2F2">Сумма</td>
		<td bgcolor="#F2F2F2">% скидки</td>
		<td bgcolor="#F2F2F2">Статус</td>
		<td bgcolor="#F2F2F2"></td>
	</tr>
<?
$sel_d = $db->sel_discount();
foreach($sel_d as $ar) {
	echo "<form method=\"post\" action=\"discount.aspx\">
		<tr align=center>
		<td bgcolor=\"#99ccff\">{$ar[indef]}</td>
		<td bgcolor=\"#99ccff\"><input type=\"text\" size=7 name=\"amount\" value=\"{$ar[amount]}\" /></td>
		<td bgcolor=\"#99ccff\"><input type=\"text\" size=5 name=\"size_d\" value=\"{$ar[size_d]}\" /></td>
		<td bgcolor=\"#99ccff\"><input type=\"checkbox\" name=\"status\""; if($ar[status] == 1) echo " checked=1";
		echo "></td>
		<td bgcolor=\"#99ccff\"><input type=\"hidden\" name=\"id\" value=\"{$ar[id]}\" /><input type=\"submit\" name=\"edit_d\" value=\"изменить\" /> <input type=\"submit\" name=\"del_d\" value=\"удалить\" /></td>


	</tr>
	</form>";
}
?>
</table>

</body>
</html>
