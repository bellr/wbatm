<?php

require("customsql.inc.aspx");
include("usercheck.aspx");
//$db = new CustomSQL($DBName);
$db_exchange = new CustomSQL_exchange($DBName_exchange);
//$db_pay_desk = new CustomSQL_pay_desk($DBName_pay_desk);
if (!empty($_POST['bal_ep_edit'])) {
if($_POST['st_input']) $st_input = 1;
else $st_input = 0;
if($_POST['st_output']) $st_output = 1;
else $st_output = 0;
if($_POST['status']) $status = 1;
else $status = 0;


$db_exchange->bal_edit_ep($_POST['id'],$_POST['balance'],$_POST['input'],$_POST['output'],$st_input,$st_output,$status);
 }
?>
<html>
<head>
<title>EasyPay балансы</title>
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
<h3>Редактирование балансов в системе EasyPay</h3>	</td>
	</tr>
	<tr>
	<td align="right">Счет</td>
	<td align="center">Резерв</td>
	<td align="center">Входящие</td>
	<td align="center"><small>в день</small></td>
	<td align="center"><small>Принимаем</small></td>
	<td align="center">Исходящие</td>
	<td align="center"><small>в день</small></td>
	<td align="center"><small>Отправляем</small></td>
	<td align="center">Дата последнего входящего</td>
	<td align="center">Дата последнего исходящего</td>
	<td align="center">СТАТУС</td>
	<td></td>
	</tr>
<?
		$result = $db_exchange->bal_ep();
		$all_sum = 0;
		foreach($result as $arr)
		{$all_sum = $all_sum +$arr['balance'];
		echo "<form action=\"bal_ep.aspx\" method=\"POST\" style=\"display:inline;\">
		<tr>
		<td style='border-bottom:1px solid silver' align=\"right\">{$arr['acount']}</td>
		<td style='border-bottom:1px solid silver' align=\"center\"><input type=\"text\" size=7 name=\"balance\" value={$arr['balance']}></td>
		<td style='border-bottom:1px solid silver' align=\"center\"><input type=\"text\" size=7 name=\"input\" value={$arr['input']}> </td>
		<td style='border-bottom:1px solid silver' align=\"center\"><small><u>{$arr['inputday']}</u><br />".date('H:i',$arr['firstpayin'])."</small></td>
		<td style='border-bottom:1px solid silver' align=\"center\"><input type=\"checkbox\" name=\"st_input\""; if($arr['st_input'] == 1) echo " checked=1";
		echo "></td>
		<td style='border-bottom:1px solid silver' align=\"center\"><input type=\"text\" size=7 name=\"output\" value={$arr['output']}> </td>
		<td style='border-bottom:1px solid silver' align=\"center\"><small><u>{$arr['outputday']}</u><br />".date('H:i',$arr['firstpayout'])."</small></td>
		<td style='border-bottom:1px solid silver' align=\"center\"><input type=\"checkbox\" name=\"st_output\""; if($arr['st_output'] == 1) echo " checked=1";
		echo "></td>
		<td style='border-bottom:1px solid silver' align=\"center\">".date('d.m.Y H:i',$arr['time_payin'])."</td>
		<td style='border-bottom:1px solid silver' align=\"center\">".date('d.m.Y H:i',$arr['time_payout'])."</td>
		<td align=\"center\"><input type=\"checkbox\" name=\"status\""; if($arr['status'] == 1) echo " checked=1";
		echo "></td>
		<td align=\"left\">
		<input type=\"hidden\" name=\"id\" value={$arr['id']}>
		<input type=\"submit\" name=\"bal_ep_edit\" value=\"Изменить\"></td>
		</tr></form>\n";
		}
		echo "<b>Суммарный резерв -</b> {$all_sum}";
?>
		</table>





      </td>
  </tr>
</table>
