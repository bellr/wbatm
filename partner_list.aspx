<?php

require("customsql.inc.aspx");
$db = new CustomSQL($DBName);
$record = 30;
?>
<html>
<head>
<title>Проссмотр всех зарегистрированных пользователей</title>
<meta http-equiv="Content-Type" content="text/html; charset=win-1251">
<link rel="stylesheet" href="style/style.css" type="text/css">
<meta content="none" name="ROBOTS">
</head>
<body topmargin="0" leftmargin="0" MARGINWIDTH="0" MARGINHEIGHT="0">
<table width="100%" border="0" cellspacing="1" cellpadding="0" align="center">
  <tr>

      <td class="menu" bgcolor="#FFFFFF" valign="top" width="100%" align="center">
    <table width="90%" border="0" cellspacing="1" cellpadding="4" bgcolor="#FFFFFF">
        <tr align="center" bgcolor="#F2F2F2">
          <td><a href="admin_index.aspx" target="mainFrame" class="en_b">adminindex</a></td>
          <td><a href="/partner_list.aspx" target="mainFrame" class="en_b">Список всех партнеров</a></td>
          <td><a href="/partner.aspx" target="mainFrame" class="en_b">Поиск партнера</a></td>
        </tr>
    </table>
      <hr width="90%" size="1" noshade>


<table width="100%" border="0" cellspacing="1" cellpadding="4" bgcolor="#F2F2F2">
	<tr>
	<td align="center"><a href="partner_list.aspx?sort=id">Номер</a></td>
	<td align="center"><a href="partner_list.aspx?sort=email">E-Mail</a></td>
	<td align="center"><a href="partner_list.aspx?sort=host">Сайт</a></td>
	<td align="center"><a href="partner_list.aspx?sort=balance">Баланс</a></td>
	<td align="center"><a href="partner_list.aspx?sort=refer">Кол-во переходов</a></td>
	<td align="center"><a href="partner_list.aspx?sort=count_oper">Кол-во заверш. опер.</a></td>
	<td align="center"><a href="partner_list.aspx?sort=summ_oper">Сумма поступ. средств</a></td>
	<td align="center"><a href="partner_list.aspx?sort=summa_bal">Всего поступило</a></td>
	</tr>
<?
if(!empty($_GET['sort'])) { $result = $db->selall_partner_sort($_GET['page'],$record,$_GET['sort']);}
else {$result = $db->selall_partner($_GET['page'],$record,'id');}


		foreach($result as $arr)
		{
		echo "
		<tr bgcolor=\"#FFFFFF\" align=\"center\">
		<td>";
		if($arr['status'] == 1) {echo "{$arr['0']}";}
		else{echo "<span class=\"red\">{$arr['0']}</span>";}

		echo "</td>
		<td><a href=\"partner.aspx?email={$arr['1']}\">{$arr['1']}</a></td>
		<td>{$arr['2']}</td>
		<td>{$arr['3']}$</td>
		<td>{$arr['5']}</td>
		<td>{$arr['6']}</td>
		<td>{$arr['7']}$</td>
		<td>{$arr['4']}$</td>
		</tr>";
		}
		echo "</table><center>";

	//количество заявок на вывод
$number = $db->count_partner();

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
     	echo "<a href=\"partner_list.aspx?page=$p\"><span class=\"text_log\">" . $i . "</span></a>&nbsp;";

   	}
}
		echo "</center>";
?>


      </td>
  </tr>
</table>
