<?php

require("customsql.inc.aspx");
$db_pay_desk = new CustomSQL_pay_desk($DBName_pay_desk);
$db_admin = new CustomSQL_admin($DBName_admin);
$record = 50;
if(!empty($_POST['add_user'])) {
	$res = $db_pay_desk->search_card($_POST['card'],$_POST['period']);
	if(empty($res)) {$db_pay_desk->add_card($_POST['card'],$_POST['period']); echo "Карта успешно добавлена в базу";}
	else {echo "Данная карта уже существует в базе";}

}
if($_GET['oper'] == "del") {
	$db_pay_desk->del_card($_GET['id']);
	echo "<b>Карта успешно удалена</b>";
}
?>
<html>
<head>
<title>Список пользователей, которым разрешен вывод на карты</title>
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
	  <div align="center"><h1>Список пользователей, которым разрешен вывод на карты</h1></div>
<form method="post" action="list_wmid.aspx">
			 Номер карты :&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="card" />&nbsp;&nbsp;
				Срок действия :&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="period" />
				<input type="submit" name="add_user" />
			 </form>
            <table width="80%" border="0" cellspacing="1" cellpadding="4" bgcolor="#F2F2F2">
              <tr bgcolor="#CCCCCC" align="center">
				<td>ID</td>
                <td>Номер карты</td>
                <td>Срок действия</td>
				<td></td>
              </tr>
              <?
$list_wmid = $db_pay_desk->list_card($_GET['page'],$record);
if(!empty($list_wmid)) {

		foreach($list_wmid as $arr) {
	        $id = $arr['0'];
			$type_count = $arr['1'];
			$count = $arr['2'];
			$status = $arr['3'];
              ?>
              <tr bgcolor="#FFFFFF" align="center">
                <td><? echo "<a href=\"list_wmid.aspx?id=$id\">$id</a>"; ?></td>
				<td><? echo "$type_count"; ?></td>
                <td><? echo "$count"; ?></td>
				<td><? echo "<a href=list_wmid.aspx?oper=del&id=".$id.">DEL</a>";?></td>
              </tr>
              <?
		}

              ?>
            <tr bgcolor="#FFFFFF">
            <td align="center" colspan="6">

			<?
	//количество заявок на вывод
$number = $db_pay_desk->count_list_card($_GET['st']);


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
     	echo "<a href=\"list_wmid.aspx?page=$p&st=".$_GET['st']."\"><span class=\"text_log\">" . $i . "</span></a>&nbsp;";
   	}
}
?>

            </td>
            </tr>
            </table>
			<?}
			else echo "<h2>Список пуст</h2>";?>
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
