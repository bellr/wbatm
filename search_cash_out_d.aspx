<?php

require("customsql.inc.aspx");
require("nncron/constructor_exch_auto.aspx");
$db = new CustomSQL($DBName);
$db_exchange = new CustomSQL_exchange($DBName_exchange);
$db_pay_desk = new CustomSQL_pay_desk($DBName_pay_desk);
$db_admin = new CustomSQL_admin($DBName_admin);

$error_did = true;

if (!empty($_POST['change_status'])) {
$db_pay_desk->demand_edit_cash_out($_POST['status'],$_GET['did']);
}
if (!empty($_POST['search_pay'])) {$did = $_POST['did']; $error_did = false;}
if (!empty($_GET['did'])) {$did = $_GET['did']; $error_did = false;}

if (!$error_did) $info = $db_pay_desk->sel_cash_out_dem($did);

?>
<html>
<head>
<title>�������������� ������ �<? echo $did; ?></title>
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


<table width="100%" border="0" cellspacing="1" cellpadding="4">
	<form action="search_cash_out_d.aspx" method="POST">
<tr>
	<td width="100%" colspan="2" class="black" align="center">
	<h3>����� ������, ����� �� �����</h3>
	</td>
</tr>
<tr>
	<td width="50%" align="right">������� ����� ������ : </td>
	<td width="50%" align="left">
	<input type="text" name="did" value="<? echo $did; ?>">
	</td>
</tr>
<tr>
	<td colspan="2" align="center">
	<input type="submit" name="search_pay" value="�����"><br /><br />
	</td>
</tr>
	</form>
<?
if (!empty($info)) {
	$ip = $db_admin->sel_ip($did);
echo "
<tr>
	<td width=\"50%\" colspan=2><b>IP : </b> {$ip[0]["addr_remote"]}&nbsp;&nbsp;&nbsp;&nbsp; <b>PROXY : </b> {$ip[0]["proxy"]}</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>����� ������ : </b></td>
	<td width=\"50%\" align=\"left\">$did</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>���� ��� ������ : </b></td>
	<td width=\"50%\" align=\"left\"><i>{$info[0]["purse_payment"]}</i></td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>����� ���������� : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["name_bank"]} {$info[0]["name_card"]}</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>����� ����� : </b></td>
	<td width=\"50%\" align=\"left\"><u>{$info[0]["card"]}</u></td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>���� �������� : </b></td>
	<td width=\"50%\" align=\"left\"><u>{$info[0]["period"]}</u></td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>����������� : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["user_surname"]} {$info[0]["user_name"]}</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>WMID ����������� : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["wmid"]}</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>���� ����������� : </b></td>
	<td width=\"50%\" align=\"left\"><u>{$info[0]["purse_out"]}</u></td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>������������ ����� : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["in_val"]} {$info[0]["output"]}</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>���������� ����� : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["out_val"]} BLR</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>E-Mail : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["email"]}</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>����� ���������� ������ : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["data"]} {$info[0]["time"]}</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>����������� : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["coment"]}</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>������</b></td>
	<td width=\"50%\" align=\"left\" valign=middle>
	<form method=\"post\" action=\"search_cash_out_d.aspx?did=$did\">";
	if ($info[0]["status"] == "n") {echo "�� ��������";} if ($info[0]["status"] == "yn") {echo "��������";} if ($info[0]["status"] == "y") {echo "���������";} if ($info[0]["status"] == "er") {echo "������";}echo "
	<select name=\"status\">
		<option value=\"none\" selected=\"selected\">�������</option>
		<option value=\"n\">�� ��������</option>
		<option value=\"yn\">��������</option>
		<option value=\"y\">���������</option>
		<option value=\"er\">������</option>
	</select>
	<input type=\"submit\" name=\"change_status\" value=\"��������\"/><br /><br /></form>
	<form method=\"post\" action=\"nncron/constructor_inpay.aspx?did=$did\">
	<input type=\"hidden\" name=\"name_card\" value=\"{$info[0]['name_card']}\">
	<input type=\"hidden\" name=\"did\" value=\"{$did}\">
	<input type=\"hidden\" name=\"out_val\" value=\"{$info[0]['out_val']}\">
<tr>
	<td width=\"100%\" align=\"center\" colspan=2><input type=\"submit\" name=\"run_cash_out\" value=\"���������\"/></td>
</tr>
	</form>

</td>
</tr>
";
}
else { echo "<tr><td colspan=\"2\" align=\"center\"><b>������ � ����� ������� �� ����������</b></td></tr>"; }
?>
</table>

      </td>
  </tr>
</table>
