<?
include('../const.inc.aspx');
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
return trim($balance);
}
function truncation_amount($amount) {
	$part = explode(".",$amount);
$result = strlen($part[0]);
$last = round($part[0]*0.1)*10;
return $last;
}

//КЛАСС ДЛЯ РАБОТЫ С ГЛАВНОЙ БАЗОЙ
Class CustomSQL extends DBSQL
{
   // the constructor
   function CustomSQL($DBName = "")
   {
      $this->DBSQL($DBName);
   }

//Вывод данных по партнеру
   function sel_info_partner($partner_id)
   {
	$sql = "select balance,summa_bal,count_oper,summ_oper,percent from partner where id='$partner_id'";
	$result = $this->select($sql);
	return $result;
   }
//Обновление баланса
	function update_bal_partner($res_balance,$res_summa_bal,$res_count_oper,$res_summ_oper,$id)
	{
	$sql = "update partner set balance='$res_balance', summa_bal='$res_summa_bal', count_oper='$res_count_oper', summ_oper='$res_summ_oper' where id='$id'";
	$this->update($sql);
	}
//удаление база IP
   function delip_partner_refer()
   {
      $sql = "DELETE FROM ip_partner_refer";
      $result = $this->delete($sql);
      return $result;
   }
//Вывод данных по shopу
   function sel_shop($name_shop)
   {
	$sql = "select percent,purse,refresh_url from terminal where name_shop='$name_shop'";
	$result = $this->select($sql);
	return $result;
   }
//Вывод данных по shopу(специально для автоматической проверки платежа)
   function autoPay_shop($name_shop)
   {
	$sql = "select percent,purse,refresh_url,remainder from terminal where name_shop='$name_shop'";
	$result = $this->select($sql);
	return $result;
   }
//Вывод данных по заявке на автоматические выплаты
   function demand_check($did)
   {
      $sql = "select terminal,summa,summa_pay,oplata from auto_pay where did='$did' and status='n'";
      $result = $this->select($sql);
      return $result;
   }
//Обнуление остатка платежа в базу терминала
	function remainder_null($name_shop)
	{
	$sql = "update terminal set remainder='0' where name_shop='$name_shop'";
	$this->update($sql);
	}
//обновление суммы платежа
	function upd_summa($amount,$did)
	{
	$sql = "update auto_pay set summa='$amount' where did='$did'";
	$this->update($sql);
	}
//Добавление комментария к платежу
	function add_comment($comment,$did)
	{
	$sql = "update auto_pay set comment='$comment' where did='$did'";
	$this->update($sql);
	}
//Обновление статуса чека
	function st_edit($st,$did)
	{
	$sql = "update auto_pay set status='$st' where did='$did'";
	$this->update($sql);
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
//Выборка направления валют
   function sel_rates()
   {
	$sql = "select direction from kurs order by id ASC";
	$result = $this->select($sql);
	return $result;
   }
//Проверка правильности курса(обменник)
   function CheckRate($in_val,$out_val,$n)
   {
	$u = $this->get_kurs($n);
	if($u[0]["direct"] == "y") $format_out_val = ($in_val*$u[0]["konvers"]*100)/100;
	if($u[0]["direct"] == "n") $format_out_val = ($in_val/$u[0]["konvers"]*100)/100;
	$ResOut_val = trim(sprintf("%8.0f ",$format_out_val));
	$out_val = trim(sprintf("%8.0f ",$out_val));
	if($ResOut_val == $out_val) {return 0;}
	else {return 1;}
   }

   function EP_purse_output($s_output) {
	global $limitday,$limitmouth;
	$sql = "select acount from acount_easypay where status=1 and st_output=1 and balance>=$s_output and outputday+'$s_output'<{$limitday} and output+'$s_output'<{$limitmouth} order by id ASC LIMIT 1";
	$result = $this->select($sql);
	return $result;
   }
   //Вывод номера счета и баланса для выбора счета с наибольшим балансом
function update_EP_purse($s_output) {
	global $limitday,$limitmouth;
	$sql = "select balance,outputday,output from acount_easypay where status=1 and st_output=1 and balance>=$s_output and outputday+'$s_output'<{$limitday} and output+'$s_output'<{$limitmouth} order by id ASC";
	$result = $this->select($sql);return $result;

}
//изменение номера счет и баланса в таблице валют
   function edit_EP_balance($balance)
   {
	$sql = "update balance set balance='$balance' where name='EasyPay'";
	$results = $this->update($sql);
	return $results;
   }
   //Вывод номера счета для осуществления оплаты услуг
function EP_purse_out_service($s_output) {
	$sql = "select acount from acount_easypay where st_output='0' and balance>='$s_output' order by id ASC LIMIT 1";
	$result = $this->select($sql);return $result;
}
//изменение суммы исходящих платежей
   function edit_bal_ep($acount,$summa) {
	$sql = "update acount_easypay set balance=balance-'$summa',output=output+'$summa',outputday=outputday+'$summa',time_payout=".time()."	where acount='$acount'";
	$results = $this->update($sql); return $results;
   }
//изменение суммы входящих платежей(пополнение)
   function edit_bal_ep_in($acount,$summa)
   {
	$sql = "update acount_easypay set balance=balance+'$summa' where acount='$acount'";
	$results = $this->update($sql);
	return $results;
   }
//изменение суммы исходящих платежей и баланса при возврате платежа
   function edit_ep_return($acount,$summa)
   {
	$sql = "update acount_easypay set balance=balance+'$summa',output=output-'$summa',outputday=outputday-'$summa',time_payout=".time()." where acount='$acount'";
	$results = $this->update($sql);
	return $results;
   }
//изменение суммы исходящих платежей и баланса при возврате платежа если EP исходящая сумма
function edit_ep_return_input($acount,$summa) {
	$sql = "update acount_easypay set balance=balance-'$summa',output=output+'$summa',outputday=outputday+'$summa' where acount='$acount'";
	$results = $this->update($sql); return $results;
}
//изменение суммы исходящих платежей и баланса при выборе нового кошелька
function return_data_ep($acount,$summa) {
	$sql = "update acount_easypay set balance=balance+'$summa',output=output-'$summa',outputday=outputday-'$summa' where acount='$acount'";
	$results = $this->update($sql); return $results;
}
//добавление времени первого платежа в день
   function upd_time_dayout($acount) {
	$sql = "update acount_easypay set firstpayout=".time()." where acount='$acount' and firstpayout=0";
	$results = $this->update($sql);return $results;
   }
//изменение суммы исходящих платежей(Оплата услуг)
   function edit_bal_ep_service($acount,$summa)
   {
	$sql = "update acount_easypay set balance=balance-'$summa' where acount='$acount'";
	$results = $this->update($sql);
	return $results;
   }
//Добавление счета на который пользователь должен оплатить
   function edit_purse_input($did,$purse)
   {
	$sql = "update demand set purse_payment='$purse' where did='$did'";
	$results = $this->update($sql);
	return $results;
   }
//изменение статуса отключение счетов
function zeroiz_st_input() {
	global $limitday,$limitmouth;
	$sql = "update acount_easypay set st_input='0' where input>{$limitmouth}-50000";
	$results = $this->update($sql);
}
//изменение статуса отключение счетов
function zeroiz_st_output() {
	global $limitday,$limitmouth;
	$sql = "update acount_easypay set st_output='0' where output>{$limitmouth}-50000";
	$results = $this->update($sql);
}
/*
//изменение статуса включение счетов
function on_st_output() {
	$sql = "update acount_easypay set st_output='1' where st_output='0' and output<{$limitmouth}-50000 and status='1'";
	$results = $this->update($sql);
}
*/


//изменение статуса включение счетов(обновление странз за месяц)
function update_month_input() {
	$month = time()-60*60*24*31;
	$sql = "update acount_easypay set st_input=1,input=0 where time_payin<='{$month}' and st_input=0 and status='1'"; $results = $this->update($sql);
}
//изменение статуса включение счетов(обновление странз за месяц)
function update_month_output() {
	$month = time()-60*60*24*31;
	$sql = "update acount_easypay set st_output=1,output=0 where time_payout<='{$month}' and st_output=0 and status='1'"; $results = $this->update($sql);
}
//изменение статуса включение счетов(обновление странз за сутки)
function update_day_input() {
	$day = time()-60*60*24;
	$sql = "update acount_easypay set inputday=0,firstpayin=0 where firstpayin<='{$day}' and status='1'"; $results = $this->update($sql);
}
//изменение статуса включение счетов(обновление странз за сутки)
function update_day_output() {
	$day = time()-60*60*24;
	$sql = "update acount_easypay set outputday=0,firstpayout=0 where firstpayout<='{$day}' and status='1'"; $results = $this->update($sql);
}

//Конверсии валют
   function get_kurs($n)
   {
	$sql = "select konvers,direct from kurs where direction='$n'";
	$result = $this->select($sql);
	return $result;
}
//изменение статуса включение счетов
   function update_purse_out($did,$purse)
   {
	$sql = "update demand set purse_out='$purse' where did='$did'";
	$results = $this->update($sql);
   }
//Вывод данных по заявке по которой будет производиться возврат
function sel_return($data,$time) {
	//$sql = "select did,ex_output,ex_input,out_val,in_val,purse_out,purse_in,purse_payment from demand where status='yn' and ((data<='$data_tom' and time<'12:00') or (data<='{$data}' and time<'{$time}'))";
	$sql = "select did,ex_output,ex_input,out_val,in_val,purse_out,purse_in,purse_payment from demand where status='yn' and data='{$data}' and time<='{$time}'";
	$result = $this->select($sql); return $result;
}
//Вывод данных по заявке по которой будет производиться возврат
function sel_purse_payment($did) {
	$sql = "select purse_payment from demand where did='$did'";
	$result = $this->select($sql); return $result;
}
//Проверка кошелька на возможность перевода
function check_purse_payment($in_val) {
	global $limitday,$limitmouth;
	$sql = "select acount from acount_easypay where status=1 and st_output=1 and balance>='{$in_val}' and outputday+'$in_val'<{$limitday} and output+'$in_val'<{$limitmouth} limit 1";
	$result = $this->select($sql); return $result;
}
//Повторная попытка завершить перевод
function sel_repet() {
	$sql = "select did,ex_output,ex_input,out_val,in_val,purse_in from demand where status='yn' and (ex_input='WMZ' or ex_input='WMR' or ex_input='WME' or ex_input='WMG' or ex_input='WMY' or ex_input='WMU' or ex_input='WMB' or ex_input='EasyPay')";
	$result = $this->select($sql);return $result;
}
//Вывод данных по заявке
   function demand_check($did,$st)
   {
      $sql = "select ex_output,ex_input,out_val,in_val,purse_out,purse_in,email from demand where did='$did' and status='$st'";
      $result = $this->select($sql);
      return $result;
   }
//Вывод баланса выбранной валюты
   function exch_balance($output)
   {
      $sql = "select balance,purse from balance where name ='$output'";
      $results = $this->select($sql);
      return $results;
   }
//Вывод баланса выбранной валюты
   function exch_balance_service($output)
   {
      $sql = "select balance,purse from balance where name_s ='$output'";
      $results = $this->select($sql);
      return $results;
   }
//Вывод номера кошелька выбранной валюты
   function sel_purse_out($output)
   {
      $sql = "select purse from balance where name ='$output'";
      $results = $this->select($sql);
      return $results;
   }
//Вывод номера кошелька выбранной валюты(для оплаты по чекам)
   function sel_purse_out_service($output)
   {
      $sql = "select purse from balance where name_s ='$output'";
      $results = $this->select($sql);
      return $results;
   }
//Вывод номера кошелька выбранной валюты(for pay in shop)
   function sel_purse_shop($output)
   {
      $sql = "select purse from balance where name_sp ='$output'";
      $results = $this->select($sql);
      return $results;
   }
//new update баланса валюты
	function increase_bal($balance_out,$ex_output)
	{
	$sql = "update balance set balance=balance+'$balance_out' where name='$ex_output'";
	$results = $this->update($sql);
	return $results;
	}
//update баланса валюты
	function demand_update_bal($balance_out,$ex_output)
	{
	$sql = "update balance set balance='$balance_out' where name='$ex_output'";
	$results = $this->update($sql);
	return $results;
	}
//update баланса валюты INPUT
	function edit_bal_plus($summa,$ex_input)
	{
	$sql = "update balance set balance=balance+'$summa' where name='$ex_input'";
	$results = $this->update($sql);
	return $results;
	}
//update баланса валюты OUTPUT
	function edit_bal_minus($summa,$ex_output)
	{
	$sql = "update balance set balance=balance-'$summa' where name='$ex_output'";
	$results = $this->update($sql);
	return $results;
	}
//update баланса валюты
	function demand_update_bal_service($balance_out,$ex_output)
	{
	$sql = "update balance set balance='$balance_out' where name_s='$ex_output'";
	$results = $this->update($sql);
	return $results;
	}
//вывод незвершенных неоплаченных заявок на обмен э/в и для скрипта проверки оплаты по RBK Money
   function sel_demand_cheak($email_merch,$summa_merch,$data_nach,$data_de)
   {
      $sql = "select did,ex_output,ex_input,purse_in,out_val,in_val,data from demand where ex_output='RBK Money' and purse_out='$email_merch' and out_val='$summa_merch' and status='n' and data='$data_nach' OR ex_output='RBK Money' and purse_out='$email_merch' and out_val='$summa_merch' and status='n' and data='$data_de'";
      $result = $this->select($sql);
      return $result;
   }
//вывод заявок со статусом n
   function sel_del_dem($data_1,$data_2)
   {
      $sql = "select did from demand where status='n' and (data='$data_1' or data='$data_2')";
      $results = $this->select($sql);
      return $results;
   }
//удаления просроченных заявок со статусом N
 function del_demand($did)
   {
      $sql = "delete from demand where did='$did'";
      $result = $this->delete($sql);
   }
//вывод всех балансов
   function sel_cash_bal()
   {
      $sql = "select name,balance from balance";
      $results = $this->select($sql);
      return $results;
   }
//При невозможности 100% обмена, запись комментария
	function demand_add_coment($coment,$did)
	{
	$sql = "update demand set coment='$coment' where did='$did'";
	$results = $this->update($sql);
	return $results;
	}
//смена статуса заявки
	function demand_edit($st,$did)
	{
	$sql = "update demand set status='$st' where did='$did'";
	$results = $this->update($sql);
	return $results;
	}
//Обновление курса банков
	function update_baserate($direct,$rate)
	{
	$sql = "update baserate set rate='$rate' where direct='$direct'";
	$this->update($sql);
	}
//Обновление курса банков
	function wm_kurs($rate,$direct)
	{
	$sql = "update wmrate set rate='$rate' where direction='$direct'";
	$this->update($sql);
	}
////////////////////////////////////////////////////////////////////////////////////////////////////////

//Вывод курса из базы курсов по WM
   function sel_wmrate($direct)
   {
	$sql = "select rate from wmrate where direction='$direct'";
	$result = $this->select($sql);
	return $result;
   }
//редактирование
	function update_kurs($konvers,$d)
	{
	$sql = "update kurs set konvers='$konvers' where direction='$d'";
	$this->update($sql);
	}
//редактирование
	function update_kurs_indef($konvers,$id) {
	$sql = "update kurs set konvers='$konvers' where id='$id' and upd='1'";
	$this->update($sql);
	}
//Вывод данных по курсу
   function sel_kom($kurse)
   {
	$sql = "select commission,direct,upd from kurs where direction='$kurse' and upd='1'";
	$result = $this->select($sql);
	return $result;
   }
//Вывод данных по индификатору
   function sel_kom_indef($ind)
   {
	$sql = "select id,commission from kurs where indefined='$ind' and upd='1'";
	$result = $this->select($sql);
	return $result;
   }

//Вывод данных по курсу
   function sel_kom_up($kurse)
   {
	$sql = "select commission,direct,upd from kurs where direction='$kurse'";
	$result = $this->select($sql);
	return $result;
   }
//вывод заявок со статусом n для расчета партнерки
   function partner_dem($data_start,$data_end)
   {
      $sql = "select ex_output,out_val,partner_id from demand where add_date BETWEEN {$data_start} and {$data_end} and status='y' and partner_id > '0'";
      $results = $this->select($sql);
      return $results;
   }
//Для БОТА вывод незвершенных оплаченных заявок на обмен э/в
   function unachieved_demand()
   {
      $sql = "select did,ex_output,ex_input,out_val,in_val from demand where status='yn'";
      $result = $this->select($sql);
      return $result;
   }
//Вывод курса(Для расчета вознаграждения партнерам)
   function sel_kurs($direct)
   {
	$sql = "select konvers,direct from kurs where direction='$direct'";
	$result = $this->select($sql);
	return $result;
   }
//Выборка базового курса по направления валюты
   function baserate($direct) {
	$sql = "select rate from baserate where direct='$direct'";
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
//Добавление строки в статистику баласов с сегоднешней датой
   function add_cash_str($data)
   {
      $sql = "insert into stat_bal (data) values ('$data')";
      $result = $this->insert($sql);
      return $result;
   }
//Добавление балансов в статистику
	function add_cash_bal($name,$balance,$data)
	{
	$sql = "update stat_bal set name='$balance' where data='$data'";
	$results = $this->update($sql);
	return $results;
	}
//Вывод номера платежа по заявке
   function sel_idpay($did)
   {
      $sql = "select id_pay from id_payment where did='$did'";
      $result = $this->select($sql);
      return $result;
   }
//Вывод номера платежа по заявке
   function sel_more_idpay($did)
   {
      $sql = "select more_idpay from id_payment where did='$did'";
      $result = $this->select($sql);
      return $result;
   }
//Вывод номера заявки по платежу
   function sel_idpay_did($id_pay)
   {
      $sql = "select did from id_payment where id_pay='$id_pay'";
      $result = $this->select($sql);
      return $result;
   }
//удаления просроченных платежей со статусом N
 function del_idpay($did)
   {
      $sql = "delete from id_payment where did='$did'";
      $this->insert($sql);
   }
//Добавление номера транзакции мнешних систем
	function add_more_idpay($more_idpay,$id_pay)
	{
	$sql = "update id_payment set more_idpay='$more_idpay' where id_pay='$id_pay'";
	$this->update($sql);
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
   //Поиск дисконтной карты
   function search_diskont($number)
   {
	$sql = "select procent from diskont where number ='$number' and status='1'";
	$result = $this->select($sql);
	return $result;
   }
//Вывод данных по заявке(МАГАЗИН новый)
   function demand_check_eshop($did)
   {
      $sql = "select output,id_goods,amount,email,data,time,type_goods,diskont_id from demand_eshop where did='$did' and status='n'";
      $result = $this->select($sql);
      return $result;
   }
//Вывод данных по заявке
   function demand_check($did)
   {
      $sql = "select output,name_uslugi,out_val,in_val,pole1,pole2,email,data,time,status from demand_uslugi where did='$did' and status='n'";
      $result = $this->select($sql);
      return $result;
   }
//смена статуса заявки
	function demand_edit($st,$did)
	{
	$sql = "update demand_uslugi set status='$st' where did='$did'";
	$results = $this->update($sql);
	return $results;
	}
//смена статуса заявки(МАГАЗИН)
	function demand_edit_eshop($st,$did)
	{
	$sql = "update demand_eshop set status='$st' where did='$did'";
	$results = $this->update($sql);
	return $results;
	}
//смена статуса заявки
	function dem_edit_output($st,$did)
	{
	$sql = "update demand_nal_out set status='$st' where did='$did'";
	$results = $this->update($sql);
	return $results;
	}
//При невозможности 100% обмена, запись комментария
	function demand_add_coment($coment,$did)
	{
	$sql = "update demand_uslugi set coment='$coment' where did='$did'";
	$results = $this->update($sql);
	return $results;
	}
//При невозможности 100% обмена, запись комментария(МАГАЗИН)
	function add_coment_eshop($coment,$did)
	{
	$sql = "update demand_eshop set coment='$coment' where did='$did'";
	$results = $this->update($sql);
	return $results;
	}
//вывод незвершенных неоплаченных заявок на обмен э/в и для скрипта проверки оплаты по RBK Money
   function sel_demand_pay($email_merch,$summa_merch,$data_nach,$data_de)
   {
      $sql = "select did,output,purse_out,out_val,in_val,data from demand_uslugi where output='RBK Money' and purse_out='$email_merch' and out_val='$summa_merch' and status='n' and data='$data_nach' OR output='RBK Money' and purse_out='$email_merch' and out_val='$summa_merch' and status='n' and data='$data_de'";
      $result = $this->select($sql);
      return $result;
   }
//вывод заявок со статусом n
   function sel_del_dem($data_1,$data_2)
   {
      $sql = "select did from demand_uslugi where status='n' and (data='$data_1' or data='$data_2')";
      $results = $this->select($sql);
      return $results;
   }
//вывод заявок со статусом n(МАГАЗИН)
   function del_dem_eshop($data_1,$data_2)
   {
      $sql = "select did from demand_eshop where status='n' and (data='$data_1' or data='$data_2')";
      $results = $this->select($sql);
      return $results;
   }
//удаления просроченных заявок со статусом N
 function del_demand($did)
   {
      $sql = "delete from demand_uslugi where did='$did'";
      $this->insert($sql);
   }
//удаления просроченных заявок со статусом N(МАГАЗИН)
 function del_demand_eshop($did)
   {
      $sql = "delete from demand_eshop where did='$did'";
      $this->insert($sql);
   }
//вывод заявок со статусом n
   function sel_del_dem_nal($data_1,$data_2)
   {
      $sql = "select did from demand_cash where status='n' and (data='$data_1' or data='$data_2')";
      $results = $this->select($sql);
      return $results;
   }
//вывод заявок со статусом n для удаления
   function sel_del_dem_out($data_1,$data_2)
   {
      $sql = "select did from demand_nal_out where status='n' and (data='$data_1' or data='$data_2')";
      $results = $this->select($sql);
      return $results;
   }
//удаления просроченных заявок со статусом N
 function del_demand_nal($did)
   {
      $sql = "delete from demand_cash where did='$did'";
      $this->insert($sql);
   }
//удаления просроченных заявок со статусом N
 function del_demand_out($did)
   {
      $sql = "delete from demand_nal_out where did='$did'";
      $this->insert($sql);
   }
//вывод заявок со статусом y для расчета партнерки
   function partner_dem($data_start,$data_end)
   {
      $sql = "select output,out_val,partner_id from demand_uslugi where BETWEEN {$data_start} and {$data_end} and status='y' and partner_id > '0'";
      $results = $this->select($sql);
      return $results;
   }
//вывод заявок со статусом y для расчета партнерки
   function partner_dem_nal($data_start,$data_end)
   {
      $sql = "select output,in_val,partner_id from demand_cash where BETWEEN {$data_start} and {$data_end} and status='y' and partner_id > '0'";
      $results = $this->select($sql);
      return $results;
   }
//вывод заявок со статусом y для расчета партнерки вывод на карты
   function partner_dem_nal_out($data)
   {
      $sql = "select output,in_val,partner_id from demand_nal_out where data='$data' and status='y' and partner_id > '0'";
      $results = $this->select($sql);
      return $results;
   }
//Вывод баланса выбранной валюты
   function sel_card_bal($card)
   {
      $sql = "select balance,com_card from name_card where name='$card'";
      $results = $this->select($sql);
      return $results;
   }
//update баланса карты
function update_cardbal($balance_in,$card)
   {
      $sql = "update name_card set balance='$balance_in' where name='$card'";
      $results = $this->update($sql);
   }
//update баланса карты
	function update_bal_card($balance_out,$card)
	{
	$sql = "update name_card set balance='$balance_out' where name='$card'";
	$this->update($sql);
	}
//При невозможности 100% оплаты услуг, запись комментария
	function cash_add_coment($coment,$did)
	{
	$sql = "update demand_cash set coment='$coment' where did='$did'";
	$this->update($sql);
	}
//При невозможности 100% пополнения карты, запись комментария
	function dem_coment_output($coment,$did)
	{
	$sql = "update demand_nal_out set coment='$coment' where did='$did'";
	$results = $this->update($sql);
	return $results;
	}
//смена статуса заявки
	function demand_edit_cash($st,$did)
	{
	$sql = "update demand_cash set status='$st' where did='$did'";
	$results = $this->update($sql);
	return $results;
	}
//Для БОТА вывод оплаченных заявок
   function unachieved_demand_pay()
   {
      $sql = "select did,output,name_uslugi,out_val from demand_uslugi where status='yn'";
      $result = $this->select($sql);
      return $result;
   }
//Для БОТА вывод оплаченных заявок(пополнение счета)
   function unachieved_demand_cash()
   {
      $sql = "select did,output,in_val,out_val from demand_cash where status='yn'";
      $result = $this->select($sql);
      return $result;
   }
//Вывод данных по заявке(пополнение карты)
   function demand_check_out($did,$st)
   {
      $sql = "select output,card,period,out_val,in_val,name_card from demand_nal_out where did='$did' and status='$st'";
      $result = $this->select($sql);
      return $result;
   }
//Добавление счета в заявку на который пользователь должен оплатить
   function edit_purse_input($did,$purse,$table)
   {
	$sql = "update $table set purse_payment='$purse' where did='$did'";
	$results = $this->update($sql);
	return $results;
   }
//Извлечение цены товара
	function sel_goods_price($id)
   {
	$sql = "select name_card,price from info_goods where id='$id'";
	$result = $this->select($sql);
	return $result;
   }
//Извлечение товара для отправки клиенту
   function select_goods($id) {
	  $p = $this->selpas();
      $sql = "select id,AES_DECRYPT(info_goods,'$p[0][0]') from goods where id_goods='$id' and status='1' order by id DESC limit 1";
      $result = $this->select($sql);
      return $result;
   }
//Изменение статуса товара
   function edit_st_goods($id)
   {
	$sql = "update goods set status='0' where id='$id'";
	$results = $this->update($sql);
   }
//Изменение статуса товара(уникальный товар)
   function edit_count($id)
   {
	$sql = "update info_goods set count=count-1,sale=sale+1 where id='$id'";
	$results = $this->update($sql);
   }
//Изменение статуса товара(не уникальный товар)
   function edit_count_un($id)
   {
	$sql = "update info_goods set sale=sale+1 where id='$id'";
	$results = $this->update($sql);
   }
//Изменение статуса товара
   function add_goods_dem($did,$id_goods)
   {
	$sql = "update demand_eshop set goods='$id_goods' where did='$did'";
	$results = $this->update($sql);
   }
//Изменение статуса товара
   function upd_diskont($number,$price)
   {
	$sql = "update diskont set amount=amount+$price where number='$number'";
	$results = $this->update($sql);
   }
//выборка заявок на пополнение наличными со стутусом y
   function sel_bill_post($st)
   {
	$sql = "select did,input,purse_in,out_val,in_val,purse_payment from demand_cash where output='pochta' and status='$st'";
	$result = $this->select($sql);
	return $result;
   }
//выборка заявки для завершения операции пополнения счета
   function sel_did_post($did)
   {
	$sql = "select did,input,purse_in,out_val,in_val,purse_payment from demand_cash where did='$did'";
	$result = $this->select($sql);
	return $result;
   }
}

?>