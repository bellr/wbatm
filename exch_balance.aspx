<?php

require("customsql.inc.aspx");

//$db = new CustomSQL($DBName);
$db_exchange = new CustomSQL_exchange($DBName_exchange);
$db_pay_desk = new CustomSQL_pay_desk($DBName_pay_desk);
if (!empty($_POST['exch_bal_edit'])) {
if($_POST['st_exch']) $st_exch = 1;
else $st_exch = 0;
if($_POST['st_pay']) $st_pay = 1;
else $st_pay = 0;
if($_POST['st_cash']) $st_cash = 1;
else $st_cash = 0;
if($_POST['st_out_nal']) $st_out_nal = 1;
else $st_out_nal = 0;
if($_POST['st_eshop']) $st_eshop = 1;
else $st_eshop = 0;
$db_exchange->exch_bal_edit($_POST['id'],$_POST['balance'],$st_exch,$st_pay,$st_cash,$st_out_nal,$st_eshop,$_POST['purse']);
 }
if (!empty($_POST['card_bal_edit'])) {
if($_POST['status']) $status = 1;
else $status = 0;
$db_pay_desk->card_bal_edit($_POST['id'],$_POST['balance'],$status,$_POST['bonus']);
}
if (!empty($_POST['goods_bal_edit'])) {
if($_POST['status']) $status = 1;
else $status = 0;
$db_pay_desk->goods_bal_edit($_POST['id'],$_POST['balance'],$status);
}
?>
<html>
<head>
<title>Редактирование балансов э/в</title>
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
      <hr width="90%" size="1" noshade>


<table width="100%" border="0" cellspacing="1" cellpadding="4">
	<tr>
	<td colspan="6" class="black" align="center">
<h3>Редактирование балансов э/в</h3>	</td>
	</tr>
	<tr>
	<td align="right">Валюта</td>
	<td>Резерв</td>
	<td>№ счета</td>
	<td align="center">Обменник</td>
	<td align="center">Платежи</td>
	<td align="center">Пополнение</td>
	<td align="center">Вывод</td>
	<td align="center">Магазин</td>
	<td></td>
	</tr>
<?
		$result = $db_exchange->exch_bal_sel();

		foreach($result as $arr)
		{
	        $id = $arr['0'];
	        $name = $arr['1'];
	        $balance = $arr['2'];
			$st_exch = $arr['3'];
			$st_pay = $arr['4'];
			$st_cash = $arr['5'];
			$st_out_nal = $arr['6'];
			$st_eshop = $arr['7'];
			$purse = $arr['8'];

		echo "<form action=\"exch_balance.aspx\" method=\"POST\" style=\"display:inline;\">
		<tr>
		<td style=\"border-bottom: #aaaaaa 1px solid;\" align=\"right\">$name</td>
		<td style=\"border-bottom: #aaaaaa 1px solid;\" align=\"left\"><input type=\"text\" name=\"balance\" value=$balance></td>
		<td style=\"border-bottom: #aaaaaa 1px solid;\" align=\"left\"><input type=\"text\" name=\"purse\" value=$purse></td>
		<td style=\"border-bottom: #aaaaaa 1px solid;\" align=\"center\"><input type=\"checkbox\" name=\"st_exch\""; if($st_exch == 1) echo " checked=1";
		echo "></td>
		<td style=\"border-bottom: #aaaaaa 1px solid;\" align=\"center\"><input type=\"checkbox\" name=\"st_pay\""; if($st_pay == 1) echo " checked=1";
		echo "></td>
		<td style=\"border-bottom: #aaaaaa 1px solid;\" align=\"center\"><input type=\"checkbox\" name=\"st_cash\""; if($st_cash == 1) echo " checked=1";
		echo "></td>
		<td style=\"border-bottom: #aaaaaa 1px solid;\" align=\"center\"><input type=\"checkbox\" name=\"st_out_nal\""; if($st_out_nal == 1) echo " checked=1";
		echo "></td>
		<td style=\"border-bottom: #aaaaaa 1px solid;\" align=\"center\"><input type=\"checkbox\" name=\"st_eshop\""; if($st_eshop == 1) echo " checked=1";
		echo "></td>
		<td style=\"border-bottom: #aaaaaa 1px solid;\" align=\"left\"><input type=\"submit\" name=\"exch_bal_edit\" value=\"Изменить\">
					<input type=\"hidden\" name=\"id\" value=$id></td>
		</tr></form>\n";

		}
?>
		</table>
		<hr />
<br />
<table width="100%" border="0" cellspacing="1" cellpadding="4">
	<tr>
	<td colspan="6" class="black" align="center">
<h3>Редактирование балансов карт</h3>	</td>
	</tr>
	<tr>
	<td align="right">Карта</td>
	<td>Резерв</td>
	<td align="center"><b>%</b> бонуса</td>
	<td align="center">статус</td>

	<td></td>
	</tr>
<?
		$card_bal_sel = $db_pay_desk->card_bal_sel();

		foreach($card_bal_sel as $arr)
		{
	        $id = $arr['0'];
	        $desc_val = $arr['1'];
	        $balance = $arr['2'];
			$status = $arr['3'];
			$bonus = $arr['4'];

		echo "<form action=\"exch_balance.aspx\" method=\"POST\" style=\"display:inline;\">
		<tr>
		<td align=\"right\">$desc_val</td>
		<td align=\"left\"><input type=\"text\" name=\"balance\" value=$balance></td>
		<td align=\"center\"><input type=\"text\" size=5 name=\"bonus\" value=$bonus></td>
		<td align=\"center\"><input type=\"checkbox\" name=\"status\""; if($status == 1) echo " checked=1";
		echo "></td>
		<td align=\"left\"><input type=\"submit\" name=\"card_bal_edit\" value=\"Изменить\">
					<input type=\"hidden\" name=\"id\" value=$id></td>
		</tr></form>\n";

		}
?>
		</table>


      </td>
  </tr>
</table>
