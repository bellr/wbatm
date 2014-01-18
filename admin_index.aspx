<?php
require("customsql.inc.aspx");
$db = new CustomSQL($DBName);
$db_admin = new CustomSQL_admin($DBName_admin);
$db_exchange = new CustomSQL_exchange($DBName_exchange);
$db_pay_desk = new CustomSQL_pay_desk($DBName_pay_desk);
include("usercheck.aspx");
//количество заявок на обмен
$count_exch_dem_n = $db_exchange->count_exch_dem_n('n');
$count_exch_dem_yn = $db_exchange->count_exch_dem('yn');
$count_exch_dem_er = $db_exchange->count_exch_dem('er');
//количество заявок по оплате услуг
$count_pay_dem_n = $db_pay_desk->count_pay_dem_n('n');
$count_pay_dem_yn = $db_pay_desk->count_pay_dem('yn');
$count_pay_dem_er = $db_pay_desk->count_pay_dem('er');
//количество заявок по оплате услуг
$count_eshop_dem_n = $db_pay_desk->count_eshop_dem_n('n');
$count_eshop_dem_yn = $db_pay_desk->count_eshop_dem('yn');
$count_eshop_dem_er = $db_pay_desk->count_eshop_dem('er');
//количество заявок(пополнение счета)
$count_cash_dem_n = $db_pay_desk->count_cash_dem('n');
$count_cash_dem_yn = $db_pay_desk->count_cash_dem('yn');
$count_cash_dem_er = $db_pay_desk->count_cash_dem('er');
//количество заявок(вывод со счета)
$count_cash_dem_out_n = $db_pay_desk->count_cash_dem_out_n('n');
$count_cash_dem_out_yn = $db_pay_desk->count_cash_dem_out('yn');
$count_cash_dem_out_er = $db_pay_desk->count_cash_dem_out('er');
//количество заявок(автомат)
$count_cheque_n = $db->count_cheque_n('n');
$count_cheque_yn = $db->count_cheque('yn');
$count_cheque_er = $db->count_cheque('er');
?>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta content="none" name="ROBOTS">
<meta http-equiv="refresh" content="<? echo "$refresh"; ?>; URL=admin_index.aspx">
<link rel="stylesheet" href="http://atm.wm-rb.net/style/style.css" type="text/css">
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0">
<a href="http://webmoney.ru/rus/developers/interfaces/xml/purse2purse/index.shtml" target="_blank">Детальное описание параметров</a>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="center" valign="top">
<center><input type="button" value="обновить" onClick=location.href="admin_index.aspx"></center>
      <hr width="95%" size="1" noshade>
      <table width="90%" border="0" cellspacing="1" cellpadding="3"  bgcolor="#CCCCCC">
        <tr bgcolor="#F2F2F2">
          <td align="center">Обменник</td>
		  <td align="center">Оплата услуг</td>
		  <td align="center">Магазин</td>
		  <td align="center">Пополнение счета</td>
		  <td align="center">Вывод со счета</td>
		  <td align="center">Автомат</td>
        </tr>
        <tr bgcolor="#ffffff">
          <td align="center"><a href="unachieved_demand_ex.aspx?st=n" target="mainFrame" class="en_b">Не оплачена</a> <b><? echo $count_exch_dem_n[0]["stotal"]; ?></b></td>
		  <td align="center"><a href="unachieved_demand_pay.aspx?st=n" target="mainFrame" class="en_b">Не оплачена</a> <b><? echo $count_pay_dem_n[0]["stotal"]; ?></b></td>
		  <td align="center"><a href="unachieved_demand_eshop.aspx?st=n" target="mainFrame" class="en_b">Не оплачена</a> <b><? echo $count_eshop_dem_n[0]["stotal"]; ?></b></td>
		  <td align="center"><a href="unachieved_demand_cash.aspx?st=n" target="mainFrame" class="en_b">Не оплачена</a> <b><? echo $count_cash_dem_n[0]["stotal"]; ?></b></td>
		  <td align="center"><a href="unachieved_demand_cash_out.aspx?st=n" target="mainFrame" class="en_b">Не оплачена</a> <b><? echo $count_cash_dem_out_n[0]["stotal"]; ?></b></td>
		  <td align="center"><a href="unachieved_cheque_payment.aspx?st=n" target="mainFrame" class="en_b">Не оплачена</a> <b><? echo $count_cheque_n[0]["stotal"]; ?></b></td>
        </tr>
        <tr bgcolor="#ffffff">
          <td align="center"><a href="unachieved_demand_ex.aspx?st=yn" target="mainFrame" class="en_b">Оплаченые</a> <b><? echo $count_exch_dem_yn[0]["stotal"]; ?></b></td>
		  <td align="center"><a href="unachieved_demand_pay.aspx?st=yn" target="mainFrame" class="en_b">Оплаченые</a> <b><? echo $count_pay_dem_yn[0]["stotal"]; ?></b></td>
		  <td align="center"><a href="unachieved_demand_eshop.aspx?st=yn" target="mainFrame" class="en_b">Оплаченые</a> <b><? echo $count_eshop_dem_yn[0]["stotal"]; ?></b></td>
		  <td align="center"><a href="unachieved_demand_cash.aspx?st=yn" target="mainFrame" class="en_b">Оплаченые</a> <b><? echo $count_cash_dem_yn[0]["stotal"]; ?></b></td>
		  <td align="center"><a href="unachieved_demand_cash_out.aspx?st=yn" target="mainFrame" class="en_b">Оплаченые</a> <b><? echo $count_cash_dem_out_yn[0]["stotal"]; ?></b></td>
		  <td align="center"><a href="unachieved_cheque_payment.aspx?st=yn" target="mainFrame" class="en_b">Оплаченые</a> <b><? echo $count_cheque_yn[0]["stotal"]; ?></b></td>
        </tr>
        <tr bgcolor="#ffffff">
          <td align="center"><a href="unachieved_demand_ex.aspx?st=er" target="mainFrame" class="en_b">Ошибка</a> <b><? echo $count_exch_dem_er[0]["stotal"]; ?></b></td>
		  <td align="center"><a href="unachieved_demand_pay.aspx?st=er" target="mainFrame" class="en_b">Ошибка</a> <b><? echo $count_pay_dem_er[0]["stotal"]; ?></b></td>
		  <td align="center"><a href="unachieved_demand_eshop.aspx?st=er" target="mainFrame" class="en_b">Ошибка</a> <b><? echo $count_eshop_dem_er[0]["stotal"]; ?></b></td>
		  <td align="center"><a href="unachieved_demand_cash.aspx?st=er" target="mainFrame" class="en_b">Ошибка</a> <b><? echo $count_cash_dem_er[0]["stotal"]; ?></b></td>
		  <td align="center"><a href="unachieved_demand_cash_out.aspx?st=er" target="mainFrame" class="en_b">Ошибка</a> <b><? echo $count_cash_dem_out_er[0]["stotal"]; ?></b></td>
		  <td align="center"><a href="unachieved_cheque_payment.aspx?st=er" target="mainFrame" class="en_b">Ошибка</a> <b><? echo $count_cheque_er[0]["stotal"]; ?></b></td>
        </tr>
      </table>



    </td>
  </tr>
  <tr>
    <td align="center" valign="top" height="40">&nbsp;</td>
  </tr>
</table>

</body>
</html>
