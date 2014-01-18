<?php

require("customsql.inc.aspx");

$error_did = true;

if (!empty($_POST['change_status'])) {

    dataBase::DBexchange()->update('demand',array('status'=>$_POST['status']),array(
        'did' => $_GET['did']
    ));
}
if (!empty($_POST['search_ex'])) {$did = $_POST['did']; $error_did = false;}
if (!empty($_GET['did'])) {$did = $_GET['did']; $error_did = false;}

if (!$error_did) {
	$info = dataBase::DBexchange()->select('demand','*','where did ='.$did);
}


?>
<html>
<head>
<title>Заявка №<? echo $did; ?></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
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


<table width="100%" border="0" cellspacing="1" cellpadding="4">
	<form action="search_exch_d.aspx" method="POST">
<tr>
	<td width="100%" colspan="2" class="black" align="center">
	<h3>Поиск заявок на обмен э/в</h3>
	</td>
</tr>
<tr>
	<td width="50%" align="right">Введите номер заявки : </td>
	<td width="50%" align="left">
	<input type="text" name="did" value="<? echo $did; ?>">
	</td>
</tr>
<tr>
	<td colspan="2" align="center">
	<input type="submit" name="search_ex" value="Поиск"><br /><br />
	</td>
</tr>
	</form>
<?
if (!empty($info)) {
	$ip = dataBase::DBadmin()->select('id_payment','id_pay,addr_remote,proxy','where did ='.$did);
if($info[0]["out_val"] > $info[0]["in_val"]) {
		$rate_exch = sprintf("%8.4f ",$info[0]["out_val"]/$info[0]["in_val"])." {$info[0]["ex_output"]} = 1 {$info[0]["ex_input"]}";
	}
if($info[0]["out_val"] < $info[0]["in_val"]) {
		$rate_exch = "1 {$info[0]["ex_input"]}  = ".sprintf("%8.4f ",$info[0]["in_val"]/$info[0]["out_val"])." {$info[0]["ex_output"]} ";
	}
echo"
<tr>
	<td width=\"50%\" colspan=2>
	<b>ID в системе:</b> {$ip[0]['id_pay']} <b> IP : </b> {$ip[0]["addr_remote"]}&nbsp;&nbsp;&nbsp;&nbsp; <b>PROXY : </b> {$ip[0]["proxy"]}
	&nbsp;&nbsp;&nbsp;&nbsp; </td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>Номер заявки : </b></td>
	<td width=\"50%\" align=\"left\">$did</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>Направление : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["ex_output"]} ››› {$info[0]["ex_input"]} <b>Обмен по курсу :</b> {$rate_exch}</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>СЧЕТ ДЛЯ ОПЛАТЫ : </b></td>
	<td width=\"50%\" align=\"left\"><i>{$info[0]["purse_payment"]}</i></td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>Счет отправителя : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["purse_out"]}</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>Счет получателя : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["purse_in"]}</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>Отправленная сумма : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["out_val"]} {$info[0]["ex_output"]}";
	if($info[0]["status"] == 'yn' || $info[0]["status"] == 'er') {
		echo " <a target=mainFrame href=index.aspx?process=transfers.return_pay&did={$did}&id_pay={$ip[0]['id_pay']}&p_output={$info[0]['purse_out']}&purse_type={$info[0]['ex_output']}&direct={$info[0]["ex_output"]}_{$info[0]["ex_input"]}&amount={$info[0]['out_val']}&comission=0>Вернуть полностью</a> |";
		echo " <a target=mainFrame href=index.aspx?process=transfers.return_pay&did={$did}&id_pay={$ip[0]['id_pay']}&p_output={$info[0]['purse_out']}&purse_type={$info[0]['ex_output']}&direct={$info[0]["ex_output"]}_{$info[0]["ex_input"]}&amount={$info[0]['out_val']}&comission=1>Вернуть без комиссии</a>";
	}
	
	echo "</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>Полученная сумма : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["in_val"]} {$info[0]["ex_input"]}</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>E-Mail : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["email"]}</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>Время оформления заявки : </b></td>
	<td width=\"50%\" align=\"left\">".date('d.m.Y H:i:s',$info[0]['add_date'])."</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>Комментарий : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["coment"]}</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>Статус</b></td>
	<td width=\"50%\" align=\"left\" valign=middle>
	<form method=\"post\" action=\"search_exch_d.aspx?did=$did\">";
	echo "<select name=\"status\">";
		echo swDemand::getStatusList($info[0]["status"]);
	echo "</select>

	<input type=\"submit\" name=\"change_status\" value=\"Изменить\"/><br /><br /></form>
	<form method=\"post\" action=\"nncron/constructor_inpay.aspx?did=$did\">
	<input type=\"hidden\" name=\"ex_output\" value=\"{$info[0]["ex_output"]}\">
	<input type=\"hidden\" name=\"ex_input\" value=\"{$info[0]["ex_input"]}\">
	<input type=\"hidden\" name=\"purse_in\" value=\"{$info[0]["purse_in"]}\">
	<input type=\"hidden\" name=\"out_val\" value=\"{$info[0]["out_val"]}\">
	<input type=\"hidden\" name=\"in_val\" value=\"{$info[0]["in_val"]}\">

<tr>
	<td width=\"100%\" align=\"center\" colspan=2><input type=\"submit\" name=\"run_exch\" value=\"Выполнить\"/></td>
</tr>";

	echo "</form>

</td>
</tr>
";
}
else { echo "<tr><td colspan=\"2\" align=\"center\"><b>Заявки с таким номером не существует</b></td></tr>"; }
?>
</table>

      </td>
  </tr>
</table>
