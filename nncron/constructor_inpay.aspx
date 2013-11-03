<?
require("customsql.inc.aspx");
require("constructor_exch_auto.aspx");
$db = new CustomSQL($DBName);
$db_exchange = new CustomSQL_exchange($DBName_exchange);
$db_pay_desk = new CustomSQL_pay_desk($DBName_pay_desk);
$db_admin = new CustomSQL_admin($DBName_admin);


if (!empty($_POST['run_exch'])) {
$desc_pay = "Direction of the exchange: {$_POST['ex_output']}->{$_POST['ex_input']}, ID:{$_GET['did']}";
$sel_idpay = $db_admin->sel_idpay($_GET['did']);
$sel_purse_out = $db_exchange->sel_purse_out($_POST['ex_input']);
	if ($_POST['ex_input'] == "WMZ" || $_POST['ex_input'] == "WMR" || $_POST['ex_input'] == "WME" || $_POST['ex_input'] == "WMG" || $_POST['ex_input'] == "WMU" || $_POST['ex_input'] == "WMY" || $_POST['ex_input'] == "WMB") { $wmt_purse = $_POST['ex_input']; $_POST['ex_input'] = "WMT";}
switch ($_POST['ex_input']) :

	case ("WMT") :
		require($atm_dir."nncron/func_wm.aspx");
//вывод кошелька с которого будем платить
//$sel_purse_out = $db_exchange->sel_purse_out($_POST['ex_input']);
$class_WebMoney = new WebMoney();
$trans_result = $class_WebMoney->direct_translation_X2($_GET['did'],$sel_idpay[0]['id_pay'],$sel_purse_out[0]["purse"],$_POST['purse_in'],$_POST['in_val'],$desc_pay);
if($trans_result == "Payment_successfully") {$db_exchange->demand_edit('y',$_GET['did']);}
else {$db_pay_desk->demand_edit('er',$_GET['did']);
	$db_exchange->demand_add_coment('В связи с техническими неполадками, заявка была совершена некорректно. Сообщите администрации. ERROR='.$kod_error,$_GET['did']); exit();}
break;
	case ("EasyPay") :
			require($atm_dir."nncron/func_easypay.aspx");
			//вывод № кошелька на кот. будет выполняться перевод или авторизация для проверки платежа
			$sel_purse_out = $db_exchange->sel_purse_out('EasyPay');
			$p = "EP".$sel_purse_out[0]['purse'];
			$pp = "PP".$sel_purse_out[0]['purse'];

		$class_EasyPay = new EasyPay();
		$str_result = $class_EasyPay->direct_translation($sel_purse_out[0]['purse'],$$p,$$pp,$_POST['purse_in'],trim(sprintf("%8.0f ",$_POST['in_val'])),$_GET['did']);
		if($str_result == "TRANSFER_OK") {$db_exchange->demand_edit('y',$_GET['did']);}
        elseif($str_result == "TRANSFER_ERROR") {$db_exchange->demand_edit('er',$_GET['did']); $db_exchange->demand_add_coment('Операция была выполнена некорректно. Администрация оповещена об ошибке.',$_GET['did']);}
        elseif($str_result == "ERROR_RECIPIENT") {$db_exchange->demand_edit('er',$_GET['did']); $db_exchange->demand_add_coment('Для проведения этой операции требуется более высокий статус кошелька (кошелек получателя). Администрация оповещена об ошибке.',$_GET['did']);}
        elseif($str_result == "ERROR_BALANCE") {$db_exchange->demand_edit('er',$_GET['did']); $db_exchange->demand_add_coment('Недостаточный резерв для завершения операции. Администрация оповещена об ошибке.',$_GET['did']);}
        elseif($str_result == "MAX_LIMIT_DAY") {$db_exchange->demand_edit('er',$did); $db_exchange->demand_add_coment('Превышено дневное ограничение (кошелек отправителя). Администрация оповещена об ошибке.',$did);}
        elseif($str_result == "ERROR_CONNECT_SERVER") {$db_exchange->demand_edit('er',$_GET['did']); $db_exchange->demand_add_coment('Ошибка соединения с сервером EasyPay. Администрация оповещена об ошибке.',$_GET['did']);}
        elseif($str_result == "UNDEFINED_ACCOUNT") {$db_exchange->demand_edit('er',$_GET['did']); $db_exchange->demand_add_coment('Указан несуществующий Идентификатор (номер) электронного кошелька EasyPay.',$_GET['did']);}
break;
	case ("Z-PAYMENT") :
		$db_exchange->demand_edit('y',$_GET['did']);
	break;
endswitch;


/*
$sel_idpay = $db_admin->sel_idpay($_GET['did']);
$ex_output = $_POST['ex_output'];
	if ($ex_output == "WMZ" || $ex_output == "WMR" || $ex_output == "WME" || $ex_output == "WMG" || $ex_output == "WMU" || $ex_output == "WMY" || $ex_output == "WMB") { $wmt_purse = $ex_output; $ex_output = "WMT";}

	switch ($ex_output) :
	case ("WMT") :
		$db_exchange->demand_edit('y',$_GET['did']);
	break;
	case ("Z-PAYMENT") :
		$db_exchange->demand_edit('y',$_GET['did']);
	break;
	case ("RBK Money") :
		$exch_balance = $db_exchange->exch_balance($ex_output);
		$balance_out = $exch_balance[0]["balance"] + $_POST['out_val'];

		$db_exchange->demand_update_bal($balance_out,$ex_output);
		$desc_pay = "Direction of the exchange: {$_POST['ex_output']}->{$_POST['ex_input']}, ID:{$_GET['did']}";
		check_payment($_POST['ex_input'],$_POST['purse_in'],$_POST['in_val'],$desc_pay,$_GET['did'],$sel_idpay[0]['id_pay']);
		$db_exchange->demand_edit('y',$_GET['did']);
	break;
	case ("EasyPay") :
		$exch_balance = $db_exchange->exch_balance($ex_output);
		$balance_out = $exch_balance[0]["balance"] + $_POST['out_val'];

		$db_exchange->demand_update_bal($balance_out,$ex_output);

		$desc_pay = "Direction of the exchange: {$_POST['ex_output']}->{$_POST['ex_input']}, ID:{$_GET['did']}";
		check_payment($_POST['ex_input'],$_POST['purse_in'],$_POST['in_val'],$desc_pay,$_GET['did'],$sel_idpay[0]['id_pay']);
		$db_exchange->demand_edit('y',$_GET['did']);
	break;
	case ("YaDengi") :
		$exch_balance = $db_exchange->exch_balance($ex_output);
		$balance_out = $exch_balance[0]["balance"] + $_POST['out_val'];
echo $balance_out;
		$db_exchange->demand_update_bal($balance_out,$ex_output);
		$desc_pay = "Direction of the exchange: {$_POST['ex_output']}->{$_POST['ex_input']}, ID:{$_GET['did']}";
		check_payment($_POST['ex_input'],$_POST['purse_in'],$_POST['in_val'],$desc_pay,$_GET['did'],$sel_idpay[0]['id_pay']);
		$db_exchange->demand_edit('y',$_GET['did']);
	break;
		default:
endswitch;
*/

header("Location: http://atm.wm-rb.net/search_exch_d.aspx?did={$_GET['did']}");
}

if (!empty($_POST['run_pay']) || !empty($_POST['autopay'])) {


if(!empty($_POST['autopay'])){

$mass_oper = array(VELCOM => "velcom", MTS => "mts", LIFE => "best", Dialog => "belcel",
BF => "10131", BF17 => "10161", BF15 => "10155", BF16 => "10142", BF21 => "10213", BF22 => "10206", BF23 => "10234",
TEL => "10111", TEL17 => "10141", TEL15 => "10145", TEL16 => "10092", TEL21 => "10193", TEL22 => "10016", TEL022 => "10216", TEL23 => "10214", KTV => "cosmostv", AchinaPlus => "13431", ATLANT => "atlant", SOLO => "solo", ZKH => "10011", ZKH16 => "10032", ZKH21 => "10063", ZKH22 => "10026");
if($_POST['name_uslugi'] == 'BF' && preg_match("/1760[0-9]*/i",$_POST['pole1']) || preg_match("/1705[0-9]*/i",$_POST['pole1']) || preg_match("/1706[0-9]*/i",$_POST['pole1']) || preg_match("/1704[0-9]*/i",$_POST['pole1']) || preg_match("/1703[0-9]*/i",$_POST['pole1']) || preg_match("/1701[0-9]*/i",$_POST['pole1']) || preg_match("/1700[0-9]*/i",$_POST['pole1'])) {$mass_oper[$_POST['name_uslugi']] = '14521';}
if(!empty($mass_oper[$_POST['name_uslugi']])) {
	require($atm_dir."nncron/func_easypay.aspx");
	$class_EasyPay = new EasyPay();
	//установить новый кошелек
	$purse = $db_exchange->EP_purse_out_service($_POST['in_val']);
	$p = "EP".$purse[0]['acount'];
	$pp = "PP".$purse[0]['acount'];
	$str_result = $class_EasyPay->pay_usluga($purse[0]['acount'],$$p,$$pp,$_POST['pole2'].$_POST['pole1'],trim(sprintf("%8.0f ",$_POST['in_val'])),$mass_oper[$_POST['name_uslugi']]);
		if($str_result == "TRANSFER_OK") {$db_pay_desk->demand_edit('y',$did);
			//$balance_in = $exch_balance[0]["balance"] - $in_val * 1.02;
			//$db_pay_desk->update_bal_card($balance_in,'prior');]
			}
		if($str_result == "TRANSFER_ERROR" || empty($str_result)) {$db_pay_desk->demand_edit('er',$did); $db_pay_desk->demand_add_coment('TRANSFER_ERROR. Операция не выполнена. Администрация оповещена об ошибке.',$did);}
		if($str_result == "ERROR_BALANCE") {$db_pay_desk->demand_edit('er',$did); $db_pay_desk->demand_add_coment('Недостаточный резерв для завершения операции. Администрация оповещена об ошибке.',$did);}
		if($str_result == "ERROR_CONNECT_SERVER") {$db_pay_desk->demand_edit('er',$did); $db_pay_desk->demand_add_coment('Ошибка соединения с сервером EasyPay. Администрация оповещена об ошибке.',$did);}
}
}
$output = $_POST['output'];
	if ($output == "WMZ" || $output == "WMR" || $output == "WME" || $output == "WMG" || $output == "WMU" || $output == "WMY" || $output == "WMB" || $output == "Z-PAYMENT" || $output == "EasyPay") { $wmt_purse = $output; $output = "WMT";}

	switch ($output) :
	case ("WMT") :
		$db_pay_desk->demand_edit('y',$_POST['did']);
	break;
	case ("RBK Money") :
//пополнение баланса
		$exch_balance = $db_exchange->exch_balance($output);
		$bal_in = $exch_balance[0]['balance'] + $_POST['out_val'];
		$db_exchange->demand_update_bal($bal_in,$output);
//изменение баланса карты
		$exch_balance = $db_pay_desk->sel_card_bal('prior');

		if ($exch_balance[0]["balance"] >= $_POST['in_val']) {
			$balance_in = $exch_balance[0]["balance"] - $_POST['in_val'] * 1.02;
			$db_pay_desk->update_bal_card($balance_in,'prior');
			$db_pay_desk->demand_edit('y',$_POST['did']);
		}
		else {
			$db_pay_desk->demand_add_coment('Баланс обмениваемой валюты уменьшился в процессе обмена. Сообщите администрации.',$_POST['did']);
			$db_pay_desk->demand_edit('er',$_POST['did']);
		}
	break;
	case ("YaDengi") :
		$db_pay_desk->demand_edit('y',$_POST['did']);
	/*
//пополнение баланса
		$exch_balance = $db_exchange->exch_balance($output);
		$bal_in = $exch_balance[0]['balance'] + $_POST['out_val'];
		$db_exchange->demand_update_bal($bal_in,$output);
//изменение баланса карты
		$exch_balance = $db_pay_desk->sel_card_bal('prior');

		if ($exch_balance[0]["balance"] >= $_POST['in_val']) {
			$balance_in = $exch_balance[0]["balance"] - $_POST['in_val'] * 1.02;
			$db_pay_desk->update_bal_card($balance_in,'prior');
			$db_pay_desk->demand_edit('y',$_POST['did']);
		}
		else {
			$db_pay_desk->demand_add_coment('Баланс обмениваемой валюты уменьшился в процессе обмена. Сообщите администрации.',$_POST['did']);
			$db_pay_desk->demand_edit('er',$_POST['did']);
		}
		*/
	break;
		default:
endswitch;
		header("Location: http://atm.wm-rb.net/search_pay_d.aspx?did={$_POST['did']}");
}


if (!empty($_POST['run_cash'])) {
$output = $_POST['output'];
//изменение баланса валюты или карты которой происходит оплата
switch ($output) :

	case ("pochta") :
		$demand_info = $db_pay_desk->sel_did_post($_GET[did]);
		$db_exchange->edit_bal_ep_in($demand_info[0]['purse_payment'],$demand_info[0]['out_val']);
		$id_pay = $db_admin->sel_idpay($demand_info[0]['did']);
$desc_pay = "Renewing the electronic count: ".$demand_info[0]['input'].", DID".$demand_info[0]['did'].", bill merchant : ".$id_pay[0]['id_pay'];
$result = check_payment($demand_info[0]['input'],$demand_info[0]['purse_in'],$demand_info[0]['in_val'],$desc_pay,$demand_info[0]['did'],$id_pay[0]['id_pay'],'NAL');
	$exch_balance = $db_exchange->exch_balance('EasyPay');
	$balance_in = $exch_balance[0]["balance"] + $_POST['out_val'];
	$db_exchange->demand_update_bal($balance_in,'EasyPay');
	break;
	case ("bpsb") :
	$bal_card = $db_pay_desk->sel_card_bal($output);
	$balance_in = $bal_card[0]["balance"] + $_POST['out_val'];
	$db_pay_desk->update_cardbal($balance_in,$output);
	break;
	case ("belbank") :
	$bal_card = $db_pay_desk->sel_card_bal($output);
	$balance_in = $bal_card[0]["balance"] + $_POST['out_val'];
	$db_pay_desk->update_cardbal($balance_in,$output);
echo $balance_in;
	break;
	case ("prior") :
	$bal_card = $db_pay_desk->sel_card_bal($output);
	$balance_in = $bal_card[0]["balance"] + $_POST['out_val'];
	$db_pay_desk->update_cardbal($balance_in,$output);
	break;
	default:
endswitch;

$input = $_POST['input'];

	if ($input == "WMZ" || $inputut == "WMR" || $input == "WME" || $input == "WMG" || $input == "WMU" || $input == "WMY" || $input == "WMB") { $wmt_purse = $input; $input = "WMT";}
//Переключатель валют для пополнениея
switch ($input) :

	case ("WMT") :
include("xml/conf.php");
include("xml/wmxiparser.php");
$parser = new WMXIParser();
$exch_balance = $db_exchange->exch_balance($wmt_purse);
$balance_in = $exch_balance[0]["balance"];
$sel_idpay = $db_admin->sel_idpay($_GET['did']);
if ($balance_in >= $_POST['in_val']) {
	$desc_pay = "Пополнение: ".$wmt_purse.", ID".$_GET['did'];

$response = $wmxi->X2(
			intval($sel_idpay[0]['id_pay']),    # номер перевода в системе учета отправителя; любое целое число без знака, должно быть уникальным
			$exch_balance[0]["purse"],          # номер кошелька с которого выполняется перевод (отправитель)
			$_POST['purse_in'],         # номер кошелька, но который выполняется перевод (получатель)
			floatval($_POST['in_val']),  # число с плавающей точкой без незначащих символов
			'0',    # целое от 0 до 255 символов; 0 - без протекции
			'',       # произвольная строка от 0 до 255 символов; пробелы в начале или конце не допускаются
			trim($desc_pay),        # произвольная строка от 0 до 255 символов; пробелы в начале или конце не допускаются
			'0',    # целое число > 0; если 0 - перевод не по счету
			'1'    # если 0 – перевод будет выполняться без учета разрешает ли получатель перевод; 1 – перевод будет выполняться только если получатель разрешает перевод (в противном случае код возврата – 35)
		);
		$structure = $parser->Parse($response, DOC_ENCODING);
		$transformed = $parser->Reindex($structure, true);
		$kod_error = htmlspecialchars(@$transformed["w3s.response"]["retval"], ENT_QUOTES);
//echo $kod_error;

		if ($kod_error == "0") {
			$bal_in = $balance_in - $_POST['in_val'] * 1.008;

			$db_exchange->demand_update_bal($bal_in,$wmt_purse);
			$db_pay_desk->demand_edit_cash('y',$_GET['did']);
		}
		else {
			$db_exchange->demand_add_coment('В связи с техническими неполадками, заявка была совершена некорректно. Сообщите администрации. ERROR='.$kod_error,$_GET['did']); }
			}
			else {
				$db_exchange->demand_add_coment('Баланс обмениваемой валюты уменьшился в процессе обмена. Сообщите администрации.',$_GET['did']);
			}
	break;
	case ("RBK Money") :
$exch_balance = $db_exchange->exch_balance($input);

$balance_in = $exch_balance[0]["balance"];
if ($balance_in >= $_POST['in_val']) {
	$bal_in = $balance_in - $_POST['in_val'] * 1.005;
	$db_exchange->demand_update_bal($bal_in,$input);
	$db_pay_desk->demand_edit_cash('y',$_GET['did']);
}
	break;
	case ("EasyPay") :
$exch_balance = $db_exchange->exch_balance($input);

$balance_in = $exch_balance[0]["balance"];
$out_val_com = $_POST['in_val'] * 1.02;
if ($balance_in >= $out_val_com) {
	$bal_in = $balance_in - $out_val_com;
	$db_exchange->demand_update_bal($bal_in,$input);
	$db_pay_desk->demand_edit_cash('y',$_GET['did']);
}
	break;
	case ("YaDengi") :
$exch_balance = $db_exchange->exch_balance($input);
$balance_in = $exch_balance[0]["balance"];
if ($balance_in >= $_POST['in_val']) {
	$bal_in = $balance_in - $_POST['in_val'];
	$db_exchange->demand_update_bal($bal_in,$input);
	$db_pay_desk->demand_edit_cash('y',$_GET['did']);
}
	break;
	default:
endswitch;
}



if (!empty($_POST['run_shop'])) {

include("xml/conf.php");
include("xml/wmxiparser.php");
$parser = new WMXIParser();

$output = $_POST['output'];

	switch ($output) :
	case ("RBK Money") :
//вывод данных по заявке
	$demand_info = $db_pay_desk->demand_check($_POST['did']);
//вывод номера транзакции по номеру заявки
	$sel_idpay = $db_admin->sel_idpay($_POST['did']);
//пополнение баланса
	$exch_balance = $db_exchange->exch_balance($output);
	$bal_in = $exch_balance[0]['balance'] + $_POST['in_val'];
	$db_exchange->demand_update_bal($bal_in,$output);
//вывод инфы по магазину
	$sel_shop = $db->sel_shop($_POST['name_shop']);
//вывод кошелька
	$sel_purse_out = $db_exchange->sel_purse_out('WMB');
//оплата на кошелек партнера
	$sum_tranz = $_POST['out_val'] - $_POST['out_val'] * $sel_shop[0]['percent'];

if($demand_info[0]["status"] != "y") {
///!!!!!!!!!!!!!!!Отправка запроса
$send_summ = explode('.',$demand_info[0]['out_val']);
$sig = md5("230113050722009:".$demand_info[0]['pole1'].":".$send_summ['0']);
$postfields = "n_order=".$demand_info[0]['pole1']."&out_val=".$send_summ['0']."&email=".$demand_info[0]['email']."&data_pay=".$demand_info[0]['data']."&time_pay=".$demand_info[0]['time']."&sig=".$sig;

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $sel_shop[0]['refresh_url']);
curl_setopt($ch, CURLOPT_HEADER, 0);
curl_setopt($ch, CURLOPT_RETURNTRANSFER,0);
curl_setopt($ch, CURLOPT_POST,1);
curl_setopt($ch, CURLOPT_NOBODY, 1);
curl_setopt($ch, CURLOPT_POSTFIELDS, $postfields);
$res = curl_exec($ch);
///!!!!!!!!!!!!!!!Отправка запроса

	$desc_pay = "Оплата по заказу №".$demand_info[0]['pole1'].", ID".$_POST['did'];

	$response = $wmxi->X2(
			intval($sel_idpay[0]['id_pay']),    # номер перевода в системе учета отправителя; любое целое число без знака, должно быть уникальным
			'B146213360627',          # номер кошелька с которого выполняется перевод (отправитель)
			$sel_shop[0]['purse'],         # номер кошелька, но который выполняется перевод B144877377115 (получатель)
			floatval($sum_tranz),  # число с плавающей точкой без незначащих символов
			'0',    # целое от 0 до 255 символов; 0 - без протекции
			'',       # произвольная строка от 0 до 255 символов; пробелы в начале или конце не допускаются
			trim($desc_pay),        # произвольная строка от 0 до 255 символов; пробелы в начале или конце не допускаются
			'0',    # целое число > 0; если 0 - перевод не по счету
			'1'    # если 0 – перевод будет выполняться без учета разрешает ли получатель перевод; 1 – перевод будет выполняться только если получатель разрешает перевод (в противном случае код возврата – 35)
		);
		$structure = $parser->Parse($response, DOC_ENCODING);
		$transformed = $parser->Reindex($structure, true);
		$kod_error = htmlspecialchars(@$transformed["w3s.response"]["retval"], ENT_QUOTES);
echo $res."<br />";
echo "Ошибка - ".$kod_error;

		if ($kod_error == "0") {

$db_pay_desk->demand_edit('y',$_POST['did']);
}
		else {
			$db_pay_desk->demand_add_coment('В связи с техническими неполадками, заявка была совершена некорректно. Сообщите администрации. ERROR='.$kod_error,$_POST['did']); }
}
	break;
	case ("EasyPay") :

echo shop_new($_POST['did'],$_POST['in_val'],$_POST['out_val'],$_POST['output'],$_POST['name_shop']);

	break;
	case ("YaDengi") :
//вывод данных по заявке
	$demand_info = $db_pay_desk->demand_check($_POST['did']);
//вывод номера транзакции по номеру заявки
	$sel_idpay = $db_admin->sel_idpay($_POST['did']);
//пополнение баланса
	$exch_balance = $db_exchange->exch_balance($output);
	$bal_in = $exch_balance[0]['balance'] + $_POST['in_val'];
	$db_exchange->demand_update_bal($bal_in,$output);
//вывод инфы по магазину
	$sel_shop = $db->sel_shop($_POST['name_shop']);
//вывод кошелька
	$sel_purse_out = $db_exchange->sel_purse_out('WMB');
//оплата на кошелек партнера
	$sum_tranz = $_POST['out_val'] - $_POST['out_val'] * $sel_shop[0]['percent'];

///!!!!!!!!!!!!!!!Отправка запроса
$send_summ = explode('.',$demand_info[0]['out_val']);
$sig = md5("230113050722009:".$demand_info[0]['pole1'].":".$send_summ['0']);
$postfields = "n_order=".$demand_info[0]['pole1']."&out_val=".$send_summ['0']."&email=".$demand_info[0]['email']."&data_pay=".$demand_info[0]['data']."&time_pay=".$demand_info[0]['time']."&sig=".$sig;

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $sel_shop[0]['refresh_url']);
curl_setopt($ch, CURLOPT_HEADER, 0);
curl_setopt($ch, CURLOPT_RETURNTRANSFER,1);
curl_setopt($ch, CURLOPT_POST,1);
curl_setopt($ch, CURLOPT_NOBODY, false);
curl_setopt($ch, CURLOPT_POSTFIELDS, $postfields);
$res = curl_exec($ch);
///!!!!!!!!!!!!!!!Отправка запроса

	$desc_pay = "Оплата по заказу №".$demand_info[0]['pole1'].", ID".$_POST['did'];

	$response = $wmxi->X2(
			intval($sel_idpay[0]['id_pay']),    # номер перевода в системе учета отправителя; любое целое число без знака, должно быть уникальным
			'B146213360627',          # номер кошелька с которого выполняется перевод (отправитель)
			$sel_shop[0]['purse'],         # номер кошелька, но который выполняется перевод B144877377115 (получатель)
			floatval($sum_tranz),  # число с плавающей точкой без незначащих символов
			'0',    # целое от 0 до 255 символов; 0 - без протекции
			'',       # произвольная строка от 0 до 255 символов; пробелы в начале или конце не допускаются
			trim($desc_pay),        # произвольная строка от 0 до 255 символов; пробелы в начале или конце не допускаются
			'0',    # целое число > 0; если 0 - перевод не по счету
			'1'    # если 0 – перевод будет выполняться без учета разрешает ли получатель перевод; 1 – перевод будет выполняться только если получатель разрешает перевод (в противном случае код возврата – 35)
		);
		$structure = $parser->Parse($response, DOC_ENCODING);
		$transformed = $parser->Reindex($structure, true);
		$kod_error = htmlspecialchars(@$transformed["w3s.response"]["retval"], ENT_QUOTES);
echo $res."<br />";
echo "Ошибка - ".$kod_error;

		if ($kod_error == "0") {

$db_pay_desk->demand_edit('y',$_POST['did']);
}
		else {
			$db_pay_desk->demand_add_coment('В связи с техническими неполадками, заявка была совершена некорректно. Сообщите администрации. ERROR='.$kod_error,$_POST['did']); }
	break;
		default:
endswitch;
}

if (!empty($_POST['run_cash_out'])) {
$name_card = $_POST['name_card'];
echo $_POST['did'];

switch ($name_card) :
	case ("bpsb") :
	$db_pay_desk->dem_edit_output('y',$_POST['did']);
	break;
	case ("belbank") :
	$db_pay_desk->dem_edit_output('y',$_POST['did']);
	break;
	case ("prior") :
	$db_pay_desk->dem_edit_output('y',$_POST['did']);
	break;
	default:
endswitch;
}
?>