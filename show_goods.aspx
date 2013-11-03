<?php

require("customsql.inc.aspx");

$db = new CustomSQL($DBName);
$db_pay_desk = new CustomSQL_pay_desk($DBName_pay_desk);
$record = '1';
if(!empty($_POST['del_goods'])) {
$db_pay_desk->del_goods($_GET['id']);
if($_GET['status'] == '1') $db_pay_desk->update_count_goods($_GET['id_goods']);}
?>
<html>
<head>
<title>Список товаров</title>
<meta http-equiv="Content-Type" content="text/html; charset=win-1251">
<link rel="stylesheet" href="style/style.css" type="text/css">
</head>
<body topmargin="0" leftmargin="0" MARGINWIDTH="0" MARGINHEIGHT="0">
<table width="100%" border="0" cellspacing="1" cellpadding="0" align="center">
  <tr>

      <td class="menu" bgcolor="#FFFFFF" valign="top" width="100%">
      <?php
      include("include/top.aspx");
      ?>
      <hr width="90%" size="1" noshade>
     <table border="0" cellspacing="0" cellpadding="4" width="100%">
<?
$goods = $db_pay_desk->show_goods($_GET['id_goods'],$_GET['page'],$record,$_GET['status']);
$goods_info = $db_pay_desk->goods_info($_GET['id_goods']);
echo "<tr><td><h1>{$goods_info[0]['name_card']}</h1><br />
<b>ID товара в базе : </b>{$goods[0]['id']}</td></tr>";
echo "<tr><td>
<form method=\"POST\" action=\"show_goods.aspx?id_goods={$_GET['id_goods']}&status={$_GET['status']}&id={$goods[0]['id']}&page={$_GET['page']}\">
	<p>{$goods[0][1]}</p>
	<input type=\"submit\" name=\"del_goods\" value=\"Удалить\" />
</form>";
?>
</td>
</tr>
<tr>
<td>		<?
	$number = $db_pay_desk->count_goods($_GET['id_goods'],$_GET['status']);
	//$posts = $number[0]["stotal"];
	$total = intval(($number[0]["stotal"] - 1) / $record) + 1;
	$page = $_GET['page'];
if ($total > 1)
{
   	$i = 0;
   	while(++$i <= $total)
   	{
	if ($i == $page+1) {
	echo "<span class=\"black\"><u>";
	echo $page+1;
	echo "</u></span>&nbsp;";
	continue;
	}
	$p = $i - 1;
     	echo "<a href=\"show_goods.aspx?page=$p&id_goods={$_GET['id_goods']}&status={$_GET['status']}\"><span class=\"text_log\">" . $i . "</span></a>&nbsp;";
   	}
}
?></td></tr>
</table>
