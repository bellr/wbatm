<?php
require("customsql.inc.aspx");
$db = new CustomSQL($DBName);
$db_admin = new CustomSQL_admin($DBName_admin);
$db_exchange = new CustomSQL_exchange($DBName_exchange);
$db_pay_desk = new CustomSQL_pay_desk($DBName_pay_desk);

include("usercheck.aspx");

//количество сообщений
$support_count = dataBase::DBadmin()->select('support',
	'count(id) as stotal',
	'where status=0 and owner_id=0'
);
//количество заявок на обмен
$count_exch_dem_n = $db_exchange->count_exch_dem_n('n');
$count_exch_dem_yn = $db_exchange->count_exch_dem('yn');
$count_exch_dem_er = $db_exchange->count_exch_dem('er');
//количество заявок на обмен
$count_pay_dem_n = $db_pay_desk->count_pay_dem_n('n');
$count_pay_dem_yn = $db_pay_desk->count_pay_dem('yn');
$count_pay_dem_er = $db_pay_desk->count_pay_dem('er');
//количество заявок в магазине
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


?>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="refresh" content="600; URL=menu.aspx">
<meta content="none" name="ROBOTS">
<link rel="stylesheet" href="style/style.css" type="text/css">
</head>
<script type="text/javascript">
function show_hide1(d){
var id=document.getElementById('d'+d);
if(id) id.style.display=id.style.display=='none'?'block':'none';
}
</script>
</head>

<body text="#000000" bgcolor="#99ccff" topmargin="2">
<center><input type="button" value="обновить" onClick=location.href="menu.aspx"><br />

</center>
<table width="100%" border="0" cellspacing="1" cellpadding="4" bgcolor="#FFFFFF">
  <tr>
    <td bgcolor="#F2F2F2"><a href="/content/?block=info.support&status=1" target="mainFrame" class="en_b">Служба поддержки</a> <a target="mainFrame" href="/content/?block=info.support&status=0"><b>(<? echo $support_count[0]["stotal"]; ?>)</b></a></td>
  </tr>



<tr>
    <td bgcolor="#99ccff"><b><a href="javascript:show_hide1(1)">Разное</a></b>
	</td>
  </tr>
  <tr style="display: none;" id="d1">
    <td>
	<a href="news.aspx" target="mainFrame" class="en_b">Новостная колонка</a>
	<a href="discount.aspx" target="mainFrame" class="en_b">Скидки</a><br />
	<a href="stat_oper.aspx" target="mainFrame" class="en_b">Статистика операций</a> <a target="_blank" href="/content/?block=webmoney.wm_example&interface=x3">wm</a><br />
	<a href="partner.aspx" target="mainFrame" class="en_b">Партнерка</a><br />
	<a href="partner_list.aspx" target="mainFrame" class="en_b">Список всех партнеров</a><br />
	</td>
  </tr>
<tr>
    <td bgcolor="#99ccff"><a href="javascript:show_hide1(2)"><b>Обменник</b></a></td>
  </tr>
  <tr style="display: none;" id="d2">
    <td>
	<a href="exch_balance.aspx" target="mainFrame" class="en_b">Балансы э/в, card</a> <a target="_blank" href="/content/?block=webmoney.wm_example&interface=x9">wm</a><br />
	<a href="bal_ep.aspx" target="mainFrame" class="en_b">Балансы EasyPay</a> <a href="/content/?block=easypay.history_data" target="mainFrame" >ac</a><br />
	<a href="search_exch_d.aspx" target="mainFrame" class="en_b">Поиск заявки</a><br />
	<a href="edit_kurs.aspx" target="mainFrame" class="en_b">Редактирование курсов</a><br />

	<b>Незавер-ные заявки</b><br />
	<div align="right"><a href="unachieved_demand_ex.aspx?st=n" target="mainFrame" class="en_b">Не оплачена</a> <b><? echo $count_exch_dem_n[0]["stotal"]; ?></b></div>
	<div align="right"><a href="unachieved_demand_ex.aspx?st=yn" target="mainFrame" class="en_b">Оплаченые</a> <b><? echo $count_exch_dem_yn[0]["stotal"]; ?></b></div>
	<div align="right"><a href="unachieved_demand_ex.aspx?st=er" target="mainFrame" class="en_b">Ошибка</a> <b><? echo $count_exch_dem_er[0]["stotal"]; ?></b></div>
	</td>
  </tr>

  <tr>
    <td bgcolor="#99ccff"><a href="javascript:show_hide1(3)"><b>Платежи</b></a></td>
  </tr>
  <tr style="display: none;" id="d3">
    <td>
	<a href="search_pay_d.aspx" target="mainFrame" class="en_b">Поиск заявки</a><br />
	<a href="edit_pay.aspx" target="mainFrame" class="en_b">Edit/Add pay</a><br />
	<b>Незавер-ные заявки</b><br />
	<div align="right"><a href="unachieved_demand_pay.aspx?st=n" target="mainFrame" class="en_b">Не оплачена</a> <b><? echo $count_pay_dem_n[0]["stotal"]; ?></b></div>
	<div align="right"><a href="unachieved_demand_pay.aspx?st=yn" target="mainFrame" class="en_b">Оплаченые</a> <b><? echo $count_pay_dem_yn[0]["stotal"]; ?></b></div>
	<div align="right"><a href="unachieved_demand_pay.aspx?st=er" target="mainFrame" class="en_b">Ошибка</a> <b><? echo $count_pay_dem_er[0]["stotal"]; ?></b></div>
	</td>
  </tr>
  <tr>
    <td bgcolor="#99ccff"><a href="javascript:show_hide1(6)"><b>Магазин</b></a></td>
  </tr>
  <tr style="display: none;" id="d6">
    <td>
	<a href="search_eshop_d.aspx" target="mainFrame" class="en_b">Поиск заявки</a><br />
	<a href="select_goods.aspx" target="mainFrame" class="en_b">Список товаров</a><br />
	<a href="goods_add.aspx" target="mainFrame" class="en_b">Добавление</a><br />
	<b>Незавер-ные заявки</b><br />
	<div align="right"><a href="unachieved_demand_eshop.aspx?st=n" target="mainFrame" class="en_b">Не оплачена</a> <b><? echo $count_eshop_dem_n[0]["stotal"]; ?></b></div>
	<div align="right"><a href="unachieved_demand_eshop.aspx?st=yn" target="mainFrame" class="en_b">Оплаченые</a> <b><? echo $count_eshop_dem_yn[0]["stotal"]; ?></b></div>
	<div align="right"><a href="unachieved_demand_eshop.aspx?st=er" target="mainFrame" class="en_b">Ошибка</a> <b><? echo $count_eshop_dem_er[0]["stotal"]; ?></b></div>
	</td>
  </tr>

  <tr>
    <td bgcolor="#99ccff"><a href="javascript:show_hide1(4)"><b>Пополнение счета</b></a></td>
  </tr>
  <tr style="display: none;" id="d4">
    <td>
	<a href="search_cash_d.aspx" target="mainFrame" class="en_b">Поиск заявки</a><br />
	<b>Незавер-ные заявки</b><br />
	<div align="right"><a href="unachieved_demand_cash.aspx?st=n" target="mainFrame" class="en_b">Не оплачена</a> <b><? echo $count_cash_dem_n[0]["stotal"]; ?></b></div>
	<div align="right"><a href="unachieved_demand_cash.aspx?st=yn" target="mainFrame" class="en_b">Оплаченые</a> <b><? echo $count_cash_dem_yn[0]["stotal"]; ?></b></div>
	<div align="right"><a href="unachieved_demand_cash.aspx?st=er" target="mainFrame" class="en_b">Ошибка</a> <b><? echo $count_cash_dem_er[0]["stotal"]; ?></b></div>
	</td>
  </tr>
  <tr>
    <td bgcolor="#99ccff"><a href="javascript:show_hide1(5)"><b>Вывод на карту</b></a></td>
  </tr>
  <tr style="display: none;" id="d5">
    <td>
	<a href="search_cash_out_d.aspx" target="mainFrame" class="en_b">Поиск заявки</a><br />
	<a href="list_wmid.aspx" target="mainFrame" class="en_b">Список пользователей</a><br />
	<b>Незавер-ные заявки</b><br />
	<div align="right"><a href="unachieved_demand_cash_out.aspx?st=n" target="mainFrame" class="en_b">Не оплачена</a> <b><? echo $count_cash_dem_out_n[0]["stotal"]; ?></b></div>
	<div align="right"><a href="unachieved_demand_cash_out.aspx?st=yn" target="mainFrame" class="en_b">Оплаченые</a> <b><? echo $count_cash_dem_out_yn[0]["stotal"]; ?></b></div>
	<div align="right"><a href="unachieved_demand_cash_out.aspx?st=er" target="mainFrame" class="en_b">Ошибка</a> <b><? echo $count_cash_dem_out_er[0]["stotal"]; ?></b></div>
	</td>
  </tr>

<tr>
    <td bgcolor="#99ccff"><a target="_parent" href="/?action=logout" class="en_b">Выход</a></td>
  </tr>
</table>
</body>
</html>
