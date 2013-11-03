<?php

require("customsql.inc.aspx");
require("nncron/constructor_exch_auto.aspx");
$db_admin = new CustomSQL_admin($DBName_admin);
//$db_exchange = new CustomSQL_exchange($DBName_exchange);
$db_pay_desk = new CustomSQL_pay_desk($DBName_pay_desk);

if(!empty($_POST['edit_goods'])) {
	if($_POST['status']) $status = 1;
	else $status = 0;
	$db_pay_desk->edit_goods($_POST['id'],$_POST['price'],$status);
}

?>
<html>
<head>
<title>Редактирование заявки №<? echo $did; ?></title>
<meta http-equiv="Content-Type" content="text/html; charset=win-1251">
<link rel="stylesheet" href="style/style.css" type="text/css">
<meta content="none" name="ROBOTS">
</head>
<body topmargin="0" leftmargin="0" MARGINWIDTH="0" MARGINHEIGHT="0">
<table width="100%" border="0" cellspacing="1" cellpadding="0" align="center">
  <tr>

      <td class="menu" bgcolor="#FFFFFF" valign="top" width="100%" align="center">
      <?php
      include("include/top.aspx");
      ?>
      <hr width="90%" size="1">


<table width="70%" border="0" cellspacing="1" cellpadding="4">
	<tr>
	<td colspan="3"><a href="goods.aspx?goods_cat=vkontakte" class="en_b">Голоса для Vkontakte.ru</a></td>
	</tr>
<?if(!empty($_GET['goods_cat'])) {?>
	<tr>
	<td>Стоимость</td>
	<td>Статус</td>
	<td></td>
	</tr>
<?
		$result = $db_pay_desk->sel_goods($_GET['goods_cat']);
		foreach($result as $arr)
		{
	echo "<tr>
	<form action=\"goods.aspx?goods_cat={$_GET['goods_cat']}\" method=\"POST\">
	<td><input type=\"text\" name=\"price\"  style=\"width:50px;\" value={$arr['2']}> {$arr['1']}</td>
	<td><input type=\"checkbox\" name=\"status\""; if($arr['3'] == 1) echo " checked=1";
		echo "></td>
	<td align=\"center\"><input type=\"hidden\" name=\"id\" value={$arr['0']}>
	<input type=\"submit\" name=\"edit_goods\" value=\"Изменить\">
					</td>

	<td></td>
	</tr></form>";
	}
}
?>


</table>

      </td>
  </tr>
</table>
