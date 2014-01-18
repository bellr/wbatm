<?php
$i = 0;
require_once('icq/WebIcqPro.class.php');
include("customsql.inc.aspx");
set_time_limit(0);
ignore_user_abort(1);
$admin_uin = '200368960';

$wr_help = "Bot commands:\r
exch_dem - Показывает список оплаченных заявок на обмен\r
pay_dem - Показывает список оплаченных заявок на оплату услуг\r
cash_dem - Показывает список оплаченных заявок на пополнение\r
wr_exit - EXIT BOT\r";
    $icq = new WebIcqPro();
	$icq->setOption('UserAgent', 'miranda');
    $icq->connect('562718741', '16201986') or die($icq->error);
	$icq->setStatus('STATUS_ONLINE');
    while ($icq->isConnected()) {
        $msg = $icq->readMessage();
		$message = mb_convert_encoding($msg['message'], 'cp1251', 'UTF-16');

		switch (strtolower(trim($message))) :
			case ("exch_dem") :
			$db_exchange = new CustomSQL_exchange($DBName_exchange);
			$unachieved_demand = $db_exchange->unachieved_demand();
			if(!empty($unachieved_demand)){
				foreach($unachieved_demand as $ar) {
					$mes_infodem = "{$ar[1]}->{$ar[2]}:{$ar[3]}->{$ar[4]}||{$ar[0]}";
					$icq->sendMessage($msg['from'], $mes_infodem);
				}
			}
			break;

			case ("pay_dem") :
			$db_pay_desk = new CustomSQL_pay_desk($DBName_pay_desk);
			$unachieved_demand_pay = $db_pay_desk->unachieved_demand_pay();
			foreach($unachieved_demand_pay as $ar) {
				$mes_infodem = "{$ar[1]}->{$ar[2]}:{$ar[3]}||{$ar[0]}";
				$icq->sendMessage($msg['from'], $mes_infodem);
			}
			break;

			case ("cash_dem") :
			$db_pay_desk = new CustomSQL_pay_desk($DBName_pay_desk);
			$unachieved_demand_cash = $db_pay_desk->unachieved_demand_cash();
			foreach($unachieved_demand_cash as $ar) {
				$mes_infodem = "NAL->{$ar[1]}:{$ar[2]}->{$ar[3]}||{$ar[0]}";
				$icq->sendMessage($msg['from'], $mes_infodem);
			}
			break;
			case ("wr_help") :
			$icq->sendMessage($msg['from'], $wr_help);
			break;

			case ("wr_exit") :
			$icq->disconnect();
			exit();
			break;
			//default: $icq->sendMessage($msg['from'], 'Некорректная команда');
			//break;
		endswitch;
    }
?>