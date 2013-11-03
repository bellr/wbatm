<?php

require("const.inc.aspx");
require("dbsql.inc.aspx");
function edit_balance($parm) {
$parm = trim(sprintf("%8.0f ",$parm));
$invers_balance = '';
$balance = '';
	$string_len = strlen($parm);
	$c=0;
	for($i=$string_len;$i>=0;$i--) {
		$invers_balance .= $parm[$i];
		if($c == 3) $invers_balance .= " ";
		if($c == 6) $invers_balance .= " ";
		$c++;
	}
	$string_len = strlen($invers_balance);
	for($i=$string_len;$i>=0;$i--) {
		$balance .= $invers_balance[$i];
	}
return $balance;
}
Class CustomSQL extends DBSQL
{
   // the constructor
   function CustomSQL($DBName = "")
   {
      $this->DBSQL($DBName);
   }

//Новостная колонка
   function addnews($title,$contents,$data)
   {
      $sql = "insert into news (title,contents,data) values ('$title','$contents','$data')";
      $result = $this->insert($sql);
      return $result;
   }
//Выборка инфы партнеру по адресу
   function sel_partner($email)
   {
	$sql = "select * from partner where email='$email'";
	$result = $this->select($sql);
	return $result;
   }
//Выборка инфы партнеру по индификатору
   function sel_partner_id($id)
   {
	$sql = "select * from partner where id='$id'";
	$result = $this->select($sql);
	return $result;
   }
//обновление инфы
function update_partner($email,$username,$host,$balance,$percent,$st)
   {
      $sql = "update partner set username='$username', host='$host', balance='$balance', percent='$percent', status='$st' where email='$email'";
      $results = $this->update($sql);
      return $results;
   }
//Выборка инфы по партнеру
   function selall_partner($page,$record,$sort)
   {
	$start = $page*$record;
	$sql = "select id,email,host,balance,summa_bal,refer,count_oper,summ_oper,status from partner order by $sort DESC LIMIT $start,$record";
	$result = $this->select($sql);
	return $result;
   }
//Выборка инфы по партнеру
   function selall_partner_sort($page,$record,$sort)
   {
	$start = $page*$record;
	$sql = "select id,email,host,balance,summa_bal,refer,count_oper,summ_oper,status from partner where status='1' order by $sort DESC LIMIT $start,$record";
	$result = $this->select($sql);
	return $result;
   }
//подсчет количества пользователей-партнеров
function count_partner()
{
    $sql = "select count(id) as stotal from partner";
	$result = $this->select($sql);
	return $result;
}
//удаление партнера
   function del_partner($email)
   {
      $sql = "DELETE FROM partner where email='$email'";
      $result = $this->delete($sql);
      return $result;
   }
//Инфо по shop
   function sel_shop($name_shop)
   {
	$sql = "select refresh_url from terminal where name_shop='$name_shop'";
	$result = $this->select($sql);
	return $result;
   }
//подсчет количества незавешенных заявок(автомат)
function count_cheque_n($st)
{
    $sql = "select count(did) as stotal from auto_pay where  status='$st' and (oplata='RBK Money' or oplata='YaDengi')";
	$result = $this->select($sql);
	return $result;
}
//подсчет количества незавешенных заявок(автомат)
function count_cheque($st)
{
    $sql = "select count(did) as stotal from auto_pay where  status='$st'";
	$result = $this->select($sql);
	return $result;
}
//вывод незвершенных заявок(автомат)
   function unachieved_cheque($page,$record,$status)
   {
	  $start = $page*$record;
      $sql = "select * from auto_pay where status='$status' order by data ASC LIMIT $start,$record";
      $result = $this->select($sql);
      return $result;
   }
//вывод незвершенных заявок(автомат)
   function unachieved_cheque_n($page,$record,$status)
   {
	  $start = $page*$record;
      $sql = "select * from auto_pay where status='$status' and (output='RBK Money' or output='YaDengi') order by data ASC LIMIT $start,$record";
      $result = $this->select($sql);
      return $result;
   }
   //поиск эл. адресов
   function check_email($email)
   {
      $sql = "select id from email_base where email='$email'";
      $result = $this->select($sql);
      return $result;
   }
   //добавление эл. адреса
   function add_email($email)
   {
      $sql = "insert into email_base (email) values ('$email')";
      $this->insert($sql);
   }
   //поиск эл. адресов
   function sel_email()
   {
      $sql = "select id,email from email_base where status='0' order by id asc";
      $result = $this->select($sql);
      return $result;
   }
   //выборка эл. адресов из заявок
   function update_st_email($id)
   {
      $sql = "update email_base set status='1' where id='$id'";
      $this->update($sql);
   }
   //добавление скидки
   function add_discount($indef,$amount,$size_d)
   {
      $sql = "insert into discount (indef,amount,size_d) values ('$indef','$amount','$size_d')";
      $this->insert($sql);
   }
//выборка существующих скидок
   function sel_discount()
   {
      $sql = "select * from discount order by indef asc";
      $result = $this->select($sql);
      return $result;
   }
   //изменения в скидках
   function edit_discount($id,$amount,$size_d,$status)
   {
      $sql = "update discount set amount='$amount',size_d='$size_d',status='$status' where id='$id'";
      $this->update($sql);
   }
//удаление скидок
   function del_discount($id)
   {
      $sql = "DELETE FROM discount where id='$id'";
      $result = $this->delete($sql);
      return $result;
   }
}

//КЛАСС ДЛЯ РАБОТЫ С БАЗОЙ EXCHENGE
Class CustomSQL_exchange extends DBSQL_exchange
{
   // the constructor
   function CustomSQL_exchange($DBName_exchange = "")
   {
      $this->DBSQL_exchange($DBName_exchange);
   }
   //выборка эл. адресов из заявок
   function sel_email()
   {
      $sql = "select email from demand";
      $result = $this->select($sql);
      return $result;
   }
   //Вывод номера счета для осуществления оплаты услуг
   function EP_purse_out_service($s_output)
   {
      $sql = "select acount from acount_easypay where st_output='0' and balance>='$s_output' order by id ASC LIMIT 1";
      $result = $this->select($sql);
      return $result;
   }
//Вывод номера кошелька выбранной валюты
   function sel_purse_out($output)
   {
      $sql = "select purse from balance where name ='$output'";
      $results = $this->select($sql);
      return $results;
   }
//База балансов э/в
   function exch_bal_sel()
   {
	$sql = "select id,name,balance,st_exch,st_pay,st_cash,st_out_nal,st_eshop,purse from balance order by id ASC";
	$result = $this->select($sql);
	return $result;
   }
function exch_bal_edit($id,$balance,$st_exch,$st_pay,$st_cash,$st_out_nal,$st_eshop,$purse)
   {
      $sql = "update balance set balance='$balance',st_exch='$st_exch',st_pay='$st_pay',st_cash='$st_cash',st_out_nal='$st_out_nal',st_eshop='$st_eshop',purse='$purse' where id='$id'";
      $results = $this->update($sql);
      return $results;
   }
//База балансов в системе EasyPay
   function bal_ep()
   {
	$sql = "select * from acount_easypay order by id ASC";
	$result = $this->select($sql);
	return $result;
   }
function bal_edit_ep($id,$balance,$input,$output,$st_input,$st_output,$status)
   {
      $sql = "update acount_easypay set balance='$balance',input='$input',st_input='$st_input',output='$output',st_output='$st_output',status='$status' where id='$id'";
      $results = $this->update($sql);
      return $results;
   }
   /*
//Выбор номера кошелька из заявки на который будет производиться оплата
   function epay_from_dem($did)
   {
	$sql = "select purse_payment from demand where did='$did'";
	$result = $this->select($sql);
	return $result;
   }
   */
//Редактирование инфы по курсам
function exch_kurs_edit($id,$konvers,$commission,$direct,$upd,$status)
   {
      $sql = "update kurs set konvers='$konvers', commission='$commission', direct='$direct', upd='$upd', status='$status' where id='$id'";
      $results = $this->update($sql);
      return $results;
   }
   //Выбор курсов валют
   function kurs_sel($main)
   {
	$sql = "select id,direction,konvers,commission,indefined,direct,upd,status,edit_date from kurs where main='$main' order by id ASC";
	$result = $this->select($sql);
	return $result;
   }
//вывод незвершенных заявок на обмен э/в
   function unachieved_demand($page,$record,$status)
   {
	  $start = $page*$record;
      $sql = "select did,ex_output,ex_input,purse_out,purse_in,out_val,in_val,data,time from demand where status='$status' order by data ASC LIMIT $start,$record";
      $result = $this->select($sql);
      return $result;
   }
//вывод данных о заявках на обмен э/в
   function sel_exchange_demand($did)
   {
      $sql = "select * from demand where did='$did'";
      $result = $this->select($sql);
      return $result;
   }
//вывод незвершенных неоплаченных заявок на обмен э/в
   function unachieved_demand_n($page,$record,$status)
   {
	  $start = $page*$record;
      $sql = "select did,ex_output,ex_input,purse_out,purse_in,out_val,in_val,data,time from demand where status='$status' and (ex_output='RBK Money' or ex_output='EasyPay' or ex_output='YaDengi')  order by data ASC LIMIT $start,$record";
      $result = $this->select($sql);
      return $result;
   }
//вывод количества незавешенных неоплаченных заявок на обмен
function count_exch_dem_n($st)
{
    $sql = "select count(did) as stotal from demand where (ex_output='RBK Money' or ex_output='EasyPay' or ex_output='YaDengi') and status='$st'";
	$result = $this->select($sql);
	return $result;
}
//подсчет количества незавешенных заявок на обмен
function count_exch_dem($st)
{
    $sql = "select count(did) as stotal from demand where status='$st'";
	$result = $this->select($sql);
	return $result;
}
//смена статуса заявки
	function demand_edit($status,$did)
	{
	$sql = "update demand set status='$status' where did='$did'";
	$results = $this->update($sql);
	return $results;
	}
//удаление заявки
   function del_dem($did)
   {
      $sql = "DELETE FROM demand where did='$did'";
      $result = $this->delete($sql);
      return $result;
   }
//Выбор заявок партнера
   function sel_dem_part($id)
   {
	$sql = "select did,ex_output,ex_input,out_val,in_val,data,time from demand where partner_id='$id' and status='y' order by data desc";
	$result = $this->select($sql);
	return $result;
   }
//Выборка базового курса по направления валюты
   function baserate($direct)
   {
	$sql = "select rate,procentbankrate from baserate where direct='$direct'";
	$result = $this->select($sql);
	return $result;
   }
//редактирование
	function edit_kurs($konvers,$id)
	{
	$sql = "update kurs set konvers='$konvers' where id='$id'";
	$this->update($sql);
	}
//вывод данных о заявках на обмен э/в СТАТИСТИКА
   function stat_exch_dem($data_n,$data_k)
   {
      $sql = "select did,ex_output,ex_input,out_val,in_val,data,time,status,partner_id from demand where data >= '$data_n' and data <= '$data_k' order by data asc, time asc";
      $result = $this->select($sql);
      return $result;
   }
//Вывод курса из базы курсов по WM
   function sel_wmrate($direct)
   {
	$sql = "select rate from wmrate where direction='$direct'";
	$result = $this->select($sql);
	return $result;
   }
}



//КЛАСС ДЛЯ РАБОТЫ С БАЗОЙ ADMIN
Class CustomSQL_admin extends DBSQL_admin
{

   // the constructor
   function CustomSQL_admin($DBName_admin = "")
   {
      $this->DBSQL_admin($DBName_admin);
   }

   //подсчет количества заявок на вывод
   function count_out()
   {
    $sql = "select count(did) as stotal from out_log";
	$result = $this->select($sql);
	return $result;
   }
//вывод Непрочитанных сообщений
   function support_mess($st)
   {
	$sql = "select id,email,message,date,time from support where status='$st' order by id DESC LIMIT 20";
	$result = $this->select($sql);
	return $result;
   }
//ответ на непрочитанное сообщение
   function get_info_mess($id,$st)
   {
	$sql = "select id,ip,email,message from support where id='$id' and status='$st' order by id";
	$result = $this->select($sql);
	return $result;
   }
//удаление прочитанное сообщение
   function support_del($id)
   {
      $sql = "DELETE FROM support where id='$id'";
      $result = $this->delete($sql);
      return $result;
   }
//подсчет количества непрочитанных сообщений
function support_count()
{
    $sql = "select count(id) as stotal from support where status='n'";
	$result = $this->select($sql);
	return $result;
}
//Добавление инфы о переводе в WM
   function add_stat_fin($did)
   {
      $sql = "insert into demand (did) values ('$did')";
      $result = $this->insert($sql);
      return $result;
   }
//Выбор ID для перевода
function stat_fin_id($did)
{
	$sql = "select id from stat_out where did='$did'";
	$result = $this->select($sql);
	return $result;
}
//удаления просроченных платежей со статусом N
 function del_idpay($did)
   {
      $sql = "delete from id_payment where did='$did'";
      $result = $this->insert($sql);
   }
//Вывод IP адресов
   function sel_ip($did)
   {
      $sql = "select id_pay,addr_remote,proxy from id_payment where did='$did'";
      $result = $this->select($sql);
      return $result;
   }
}



//КЛАСС ДЛЯ РАБОТЫ С БАЗОЙ PAY-DESK
Class CustomSQL_pay_desk extends DBSQL_pay_desk
{

   // the constructor
   function CustomSQL_pay_desk($DBName_pay_desk = "")
   {
      $this->DBSQL_pay_desk($DBName_pay_desk);
   }
   function selpas()
   {
    $sql = "SELECT @password:='dbnfkbq1986'";
	$result = $this->select($sql);
	return $result;
   }
//Выборка инфы по партнеру
   function show_goods($id_goods,$page,$record,$st)
   {
	$p = $this->selpas();
	$start = $page*$record;
	$sql = "select id,AES_DECRYPT(info_goods,'$p[0][0]') from goods where id_goods='$id_goods' and status='$st' order by id DESC LIMIT $start,$record";
	$result = $this->select($sql);
	return $result;
   }
//подсчет количества товаров
function count_goods($id_goods,$st)
{
    $sql = "select count(id) as stotal from goods where id_goods='$id_goods' and status='$st'";
	$result = $this->select($sql);
	return $result;
}
//удаление товара
   function del_goods($id)
   {
      $sql = "DELETE FROM goods where id='$id'";
      $this->delete($sql);
   }
//Обновление количества карт(при удалении товара)
function update_count_goods($id_goods)
   {
      $sql = "update info_goods set count=count-1 where id='$id_goods'";
		$this->update($sql);
   }
//подсчет количества магазина
function count_eshop_dem($st)
{
    $sql = "select count(did) as stotal from demand_eshop where status='$st'";
	$result = $this->select($sql);
	return $result;
}
//подсчет количества по оплате услуг
function count_pay_dem($st)
{
    $sql = "select count(did) as stotal from demand_uslugi where status='$st'";
	$result = $this->select($sql);
	return $result;
}

//подсчет количества незавешенных неоплаченных по оплате услуг
function count_pay_dem_n($st)
{
    $sql = "select count(did) as stotal from demand_uslugi where status='$st' and (output='RBK Money' or output='EasyPay' or output='YaDengi')";
	$result = $this->select($sql);
	return $result;
}
//подсчет количества незавешенных неоплаченных заявок магазина
function count_eshop_dem_n($st)
{
    $sql = "select count(did) as stotal from demand_eshop where status='$st' and (output='RBK Money' or output='EasyPay' or output='YaDengi')";
	$result = $this->select($sql);
	return $result;
}
//вывод данных по заявке оплаты услуг
   function sel_pay_demand($did)
   {
      $sql = "select output,name_uslugi,purse_out,out_val,email,in_val,pole1,pole2,data,time,status,coment,purse_payment from demand_uslugi where did='$did'";
      $result = $this->select($sql);
      return $result;
   }
//Извлечение информации о выбранном товаре
	function goods_info($id)
   {
	$sql = "select name_card from info_goods where id='$id'";
	$result = $this->select($sql);
	return $result;
   }
//вывод данных по заявке магазина
   function sel_eshop_demand($did)
   {
      $sql = "select did,output,id_goods,amount,email,data,time,status,coment,purse_payment from demand_eshop where did='$did'";
      $result = $this->select($sql);
      return $result;
   }
//вывод незвершенных заявок
   function unachieved_demand($page,$record,$status)
   {
	  $start = $page*$record;
      $sql = "select did,output,name_uslugi,out_val,in_val,data,time from demand_uslugi where status='$status' order by data ASC LIMIT $start,$record";
      $result = $this->select($sql);
      return $result;
   }
//вывод незвершенных неоплаченных заявок
   function unachieved_demand_n($page,$record,$status)
   {
	  $start = $page*$record;
      $sql = "select did,output,name_uslugi,out_val,in_val,data,time from demand_uslugi where status='$status' and (output='RBK Money' or output='EasyPay' or output='YaDengi') order by data ASC LIMIT $start,$record";
      $result = $this->select($sql);
      return $result;
   }
//вывод инфы по незавершенным заявкам магазина
   function unachieved_demand_eshop($page,$record,$status)
   {
	  $start = $page*$record;
      $sql = "select did,output,id_goods,amount,data,time from demand_eshop where status='$status' order by data ASC LIMIT $start,$record";
      $result = $this->select($sql);
      return $result;
   }
//вывод инфы понезавершенным неоплаченным заявкам магазина
   function unachieved_demand_n_eshop($page,$record,$status)
   {
	  $start = $page*$record;
      $sql = "select did,output,id_goods,amount,data,time from demand_eshop where status='$status' and (output='RBK Money' or output='EasyPay' or output='YaDengi') order by data ASC LIMIT $start,$record";
      $result = $this->select($sql);
      return $result;
   }
//подсчет количества незавешенных заявок(пополнение счета)
function count_cash_dem($st)
{
    $sql = "select count(did) as stotal from demand_cash where status='$st'";
	$result = $this->select($sql);
	return $result;
}
//подсчет количества незавешенных заявок(вывод со счета)
function count_cash_dem_out($st)
{
    $sql = "select count(did) as stotal from demand_nal_out where  status='$st'";
	$result = $this->select($sql);
	return $result;
}
//подсчет количества незавешенных заявок(вывод со счета)
function count_cash_dem_out_n($st)
{
    $sql = "select count(did) as stotal from demand_nal_out where  status='$st' and (output='RBK Money' or output='EasyPay' or output='YaDengi')";
	$result = $this->select($sql);
	return $result;
}
//вывод незвершенных заявок(пополнение счета)
   function unachieved_demand_cash($page,$record,$status)
   {
	  $start = $page*$record;
      $sql = "select did,output,input,in_val,out_val,data,time from demand_cash where status='$status' order by data ASC LIMIT $start,$record";
      $result = $this->select($sql);
      return $result;
   }
//вывод незвершенных заявок(вывод со счета)
   function unachieved_demand_cash_out($page,$record,$status)
   {
	  $start = $page*$record;
      $sql = "select did,output,in_val,out_val,name_card,data,time from demand_nal_out where status='$status' order by data ASC LIMIT $start,$record";
      $result = $this->select($sql);
      return $result;
   }
//вывод незвершенных заявок(вывод со счета)
   function unachieved_demand_cash_out_n($page,$record,$status)
   {
	  $start = $page*$record;
      $sql = "select did,output,in_val,out_val,name_card,data,time from demand_nal_out where status='$status' and (output='RBK Money' or output='EasyPay' or output='YaDengi') order by data ASC LIMIT $start,$record";
      $result = $this->select($sql);
      return $result;
   }
//смена статуса заявки в заявке по оплате услуг
	function demand_edit($status,$did)
	{
	$sql = "update demand_uslugi set status='$status' where did='$did'";
	$results = $this->update($sql);
	return $results;
	}
//смена статуса заявки по заявкаам магазина
	function demand_edit_eshop($status,$did)
	{
	$sql = "update demand_eshop set status='$status' where did='$did'";
	$results = $this->update($sql);
	return $results;
	}
//смена статуса заявки(пополнение счета)
	function demand_edit_cash($status,$did)
	{
	$sql = "update demand_cash set status='$status' where did='$did'";
	$results = $this->update($sql);
	return $results;
	}
//смена статуса заявки(вывод со счета)
	function demand_edit_cash_out($status,$did)
	{
	$sql = "update demand_nal_out set status='$status' where did='$did'";
	$results = $this->update($sql);
	return $results;
	}
//вывод данных о заявках(пополнение счета)
   function sel_cash_demand($did)
   {
      $sql = "select output,input,card,period,purse_in,in_val,out_val,email,data,time,status,coment,purse_payment from demand_cash where did='$did'";
      $result = $this->select($sql);
      return $result;
   }
//вывод данных о заявках(вывод со счета)
   function sel_cash_out_dem($did)
   {
      $sql = "select output,card,period,in_val,out_val,purse_out,name_card,email,data,time,status,coment,wmid,user_surname,user_name,name_bank,purse_payment from demand_nal_out where did='$did'";
      $result = $this->select($sql);
      return $result;
   }
   //Выбор платежа
   function info_pay($name_cat)
   {
	$sql = "select * from uslugi where name_cat='$name_cat' order by id ASC";
	$result = $this->select($sql);
	return $result;
   }
//Редактирование инфы по платежам
function edit_pay($id,$commission,$bankpay,$status)
   {
      $sql = "update uslugi set commission='$commission', bankpay='$bankpay', status='$status' where id='$id'";
      $results = $this->update($sql);
   }
//Добавление платежа из админки
   function add_pay($name_cat,$desc_uslugi,$name,$desc_val,$bankpay)
   {
      $sql = "insert into uslugi (name_cat,desc_uslugi,name,desc_val,bankpay) values ('$name_cat','$desc_uslugi','$name','$desc_val','$bankpay')";
      $result = $this->insert($sql);
      return $result;
   }
//удаление заявки(платеж)
   function del_dem($did)
   {
      $sql = "DELETE FROM demand_uslugi where did='$did'";
      $result = $this->delete($sql);
      return $result;
   }
//удаление заявки(магазин)
   function del_dem_shop($did)
   {
      $sql = "DELETE FROM demand_eshop where did='$did'";
      $result = $this->delete($sql);
      return $result;
   }
//удаление заявки(пополнение счета)
   function del_dem_nal($did)
   {
      $sql = "DELETE FROM demand_cash where did='$did'";
      $result = $this->delete($sql);
      return $result;
   }
//удаление заявки(вывод со счета)
   function del_dem_nal_out($did)
   {
      $sql = "DELETE FROM demand_nal_out where did='$did'";
      $result = $this->delete($sql);
      return $result;
   }
//Выбор заявок партнера по платежам
   function sel_dempay_part($id)
   {
	$sql = "select did,output,name_uslugi,out_val,in_val,data,time from demand_uslugi where partner_id='$id' and status='y' order by data desc";
	$result = $this->select($sql);
	return $result;
   }
//Выбор заявок партнера по пополнению
   function sel_demcash_part($id)
   {
	$sql = "select did,output,in_val,out_val,data,time from demand_cash where partner_id='$id' and status='y' order by data desc";
	$result = $this->select($sql);
	return $result;
   }
//База балансов катр
   function card_bal_sel()
   {
	$sql = "select id,desc_val,balance,status,bonus from name_card order by id ASC";
	$result = $this->select($sql);
	return $result;
   }
//редактирование данных о картах
function card_bal_edit($id,$balance,$status,$bonus)
   {
      $sql = "update name_card set balance='$balance',status='$status',bonus='$bonus' where id='$id'";
      $results = $this->update($sql);
      return $results;
   }
//База балансов товаров
   function goods_bal_sel()
   {
	$sql = "select * from reserv_goods order by id ASC";
	$result = $this->select($sql);
	return $result;
   }
//редактирование данных о товарах
function goods_bal_edit($id,$balance,$status)
   {
      $sql = "update reserv_goods set balance='$balance',status='$status' where id='$id'";
      $results = $this->update($sql);
      return $results;
   }
//для вывода статистики по операциям(УСЛУГИ)
   function stat_pay_dem($data_n,$data_k)
   {
      $sql = "select did,output,name_uslugi,out_val,in_val,data,time,status,partner_id from demand_uslugi where data >= '$data_n' and data <= '$data_k' order by data asc, time asc";
      $result = $this->select($sql);
      return $result;
   }
//для вывода статистики по операциям(УСЛУГИ)
   function stat_eshop_dem($data_n,$data_k)
   {
      $sql = "select did,output,id_goods,amount,data,time,status,partner_id from demand_eshop where data >= '$data_n' and data <= '$data_k' order by data asc, time asc";
      $result = $this->select($sql);
      return $result;
   }
//для вывода статистики по операциям(ПОПОЛНЕНИЕ)
   function stat_pay_dem_cash($data_n,$data_k)
   {
      $sql = "select did,output,input,out_val,in_val,data,time,status,partner_id from demand_cash where data >= '$data_n' and data <= '$data_k' order by data asc, time asc";
      $result = $this->select($sql);
      return $result;
   }
//для вывода статистики по операциям(ВЫВОД)
   function stat_pay_dem_cash_out($data_n,$data_k)
   {
      $sql = "select did,output,out_val,in_val,name_card,data,time,status,partner_id from demand_nal_out where data >= '$data_n' and data <= '$data_k' order by data asc, time asc";
      $result = $this->select($sql);
      return $result;
   }
//вывод списка пользователей, которым разрешен вывод на карты
   function list_card($page,$record)
   {
	  $start = $page*$record;
      $sql = "select * from list_card order by id ASC LIMIT $start,$record";
      $result = $this->select($sql);
      return $result;
   }
//подсчет количества пользователей, которым разрешен вывод на карты
function count_list_card()
{
    $sql = "select count(id) as stotal from list_card";
	$result = $this->select($sql);
	return $result;
}
//Добавление пользователя в систему
   function add_card($card,$period)
   {
      $sql = "insert into list_card (card,period) values ('$card','$period')";
      $result = $this->insert($sql);
      return $result;
   }
//удаление карты
   function del_card($id)
   {
      $sql = "DELETE FROM list_card where id='$id'";
      $result = $this->delete($sql);
      return $result;
   }
//проверка наличия карты в базе
   function search_card($number_card,$period)
   {
      $sql = "select id from list_card where card='$number_card' and period='$period'";
      $result = $this->select($sql);
      return $result;
   }
//Добавление пользователя в систему
   function add_company($main_cat,$side_cat,$company,$desc_company)
   {
      $sql = "insert into goods_company (main_cat,side_cat,company,desc_company) values ('$main_cat','$side_cat','$company','$desc_company')";
      $this->insert($sql);
   }
//выбор всех компаний
   function sel_company()
   {
      $sql = "select company,desc_company from goods_company";
      $result = $this->select($sql);
      return $result;
   }
//Добавление нового товара в систему
   function add_goods($name_company,$id_company,$name_goods,$desc,$price,$type_goods)
   {
      $sql = "insert into info_goods (name_company,card,name_card,name_desc,price,type_goods) values ('$name_company','$id_company','$name_goods','$desc','$price','$type_goods')";
      $this->insert($sql);
   }
//Добавление пин-кода
   function add_goods_text($id_goods,$info_goods)
   {
	  $p = $this->selpas();
      $sql = "insert into goods (id_goods,info_goods) values ('$id_goods',AES_ENCRYPT('$info_goods','$p[0][0]'))";
      $this->insert($sql);
   }

//выбор выбор товаров по названию компании
   function sel_goods_company($company)
   {
      $sql = "select id,card,name_card,name_desc,price,count,sale from info_goods where name_company='$company'";
      $result = $this->select($sql);
      return $result;
   }
//Обновление количества карт
function update_count($id_goods,$c)
   {
      $sql = "update info_goods set count=count+{$c} where id='$id_goods'";
		$this->update($sql);
   }
//смена статуса заявки в заявке по оплате услуг
	function edit_info_goods($name_goods,$name_desc,$price,$id)
	{
	$sql = "update info_goods set name_card='$name_goods',name_desc='$name_desc',price='$price' where id='$id'";
	$results = $this->update($sql);
	return $results;
	}
}
?>