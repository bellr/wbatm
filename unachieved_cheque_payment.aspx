<?php

require("customsql.inc.aspx");
$db_admin = new CustomSQL_admin($DBName_admin);
$db_pay_desk = new CustomSQL_pay_desk($DBName_pay_desk);
$record = 20;
if($_GET['oper'] == "del") {
	$db->del_dem($_GET['did']);
	$db_admin->del_idpay($_GET['did']);
	echo "<b>Заявка была успешно удалена</b>";
}
?>
<html>
<head>
<title>Незавершенные заявки</title>
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
	  <div align="center"><h1>Список незавершенных заявок(ПЛАТЕЖИ)</h1></div>

            <table width="100%" border="0" cellspacing="1" cellpadding="4" bgcolor="#F2F2F2">
              <tr bgcolor="#CCCCCC" align="center">
				<td>№ заявки</td>
                <td>Название услуги</td>
                <td>Отправляемая сумма</td>
				<td>Получаемая сумма</td>
                <td>Дата</td>
				<td>Действие</td>
              </tr>
              <?
if ($_GET['st'] == "n") {$unachieved_demand = $db_pay_desk->unachieved_demand_n($_GET['page'],$record,$_GET['st']);}
else {$unachieved_demand = $db_pay_desk->unachieved_demand($_GET['page'],$record,$_GET['st']);}


		foreach($unachieved_demand as $arr) {
              ?>
              <tr bgcolor="#FFFFFF" align="center">
                <td><? echo "<a href=\"search_pay_d.aspx?did=$did\">$did</a>"; ?></td>
				<td><? echo "$name_uslugi"; ?></td>
                <td><? echo "$in_val $output"; ?></td>
				<td><? echo "$out_val BLR"; ?></td>
                <td><? echo "$data $time"; ?></td>
				<td><? echo "<a href=unachieved_demand_pay.aspx?oper=del&st=".$_GET['st']."&did=".$did.">DEL</a>"; ?></td>
              </tr>
              <?
		}

              ?>
            <tr bgcolor="#FFFFFF">
            <td align="center" colspan="6">

			<?
	//количество заявок на вывод
if ($_GET['st'] == "n") {$number = $db_pay_desk->count_pay_dem_n($_GET['st']);}
else {$number = $db_pay_desk->count_pay_dem($_GET['st']);}


	$posts = $number[0]["stotal"];
	$total = intval(($posts - 1) / $record) + 1;
	$page = $_GET['page'];
if ($total > 1)
{
   	$i = 0;
   	while(++$i <= $total)
   	{
	if ($i == $page+1) {
	echo "<span class=\"black\">";
	echo "<u>";
	echo $page+1;
	echo "</u>";
	echo "</span>&nbsp;";
	continue;
	}
	$p = $i - 1;
     	echo "<a href=\"unachieved_demand_pay.aspx?page=$p&st=".$_GET['st']."\"><span class=\"text_log\">" . $i . "</span></a>&nbsp;";
   	}
}
?>

            </td>
            </tr>
            </table>
            </td>
        </tr>
        <tr>
        <td align="center">
        </td>
        </tr>
      </table>

      </td>
  </tr>
</table>
