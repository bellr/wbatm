<?php

require("customsql.inc.aspx");
$record = 20;

if($_GET['oper'] == "del") {
	Model::Demand()->delete($_GET['did'],'demand_cash');
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
	  <div align="center"><h1>Список незавершенных заявок(ПОПОЛНЕНИЕ эл. счета)</h1></div>

            <table width="100%" border="0" cellspacing="1" cellpadding="4" bgcolor="#F2F2F2">
              <tr bgcolor="#CCCCCC" align="center">
				<td>№ заявки</td>
                <td>Пополняемый эл. счет</td>
                <td>Отправляемая сумма</td>
				<td>Получаемая сумма</td>
                <td>Дата</td>
				<td>Действие</td>
              </tr>
              <?

$start = $_GET['page']*$record;
$unachieved_demand = dataBase::DBpaydesk()->select('demand_cash','did,output,input,in_val,out_val,add_date',"where status='{$_GET['st']}'",'order by add_date ASC',"LIMIT {$start},{$record}");


		foreach((array)$unachieved_demand as $arr) {

              ?>
              <tr bgcolor="#FFFFFF" align="center">
                <td><? echo "<a href=\"search_cash_d.aspx?did={$arr['did']}\">{$arr['did']}</a>"; ?></td>
				<td><? echo $arr['input']; ?></td>
                <td><? echo $arr['out_val']." BLR"; ?></td>
				<td><? echo $arr['in_val']." ".$arr['input']; ?></td>
                <td><? echo date('d.m.Y H:i:s',$arr[0]['add_date']); ?></td>
				<td><? echo "<a href=unachieved_demand_cash.aspx?oper=del&st=".$_GET['st']."&did=".$arr['did'].">DEL</a>"; ?></td>
              </tr>
              <?
		}

              ?>
            <tr bgcolor="#FFFFFF">
            <td align="center" colspan="6">

			<?
	//количество заявок на вывод
$number = dataBase::DBpaydesk()->select('demand_cash','count(did) as stotal',"where status='{$_GET['st']}'");



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
     	echo "<a href=\"unachieved_demand_cash.aspx?page=$p&st=".$_GET['st']."\"><span class=\"text_log\">" . $i . "</span></a>&nbsp;";
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
