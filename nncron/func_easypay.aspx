<?
Class EasyPay {

function connect_history_easypay($login,$pass,$mode) {
$headers = array
(	'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Accept-Language: ru',
    'Accept-Charset: windows-1251,utf-8;q=0.7,*;q=0.7');
$days = date("d");
$mon = date("m");
$yaer = date("Y");

$data_tom = date( "Y-n-j",mktime(0,0,0,$mon,$days-1,$yaer) );
$data_today = date( "Y-n-j",mktime(0,0,0,$mon,$days,$yaer) );

$data_start = explode('-',$data_tom);
$data_finish = explode('-',$data_today);
//делаем запрос на авторизацию
$ch = curl_init('https://ssl.easypay.by/pay/');
curl_setopt  ($ch, CURLOPT_HEADER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER,$headers);
curl_setopt($ch, CURLOPT_REFERER, 'https://ssl.easypay.by/');
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_USERAGENT, 'Googlebot/2.1 (+http://www.google.com/bot.html)');
curl_setopt($ch, CURLOPT_POSTFIELDS, 'login='.$login.'&password='.$pass.'&mode=enter');
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
$str = curl_exec($ch);
curl_close($ch);
preg_match("/request_id=+[a-z,0-9]+/i",$str,$request_id);
preg_match_all('|Set-Cookie: (.*);|U', $str, $results);
$cookies = implode(';', $results[1]);
//после авторизации просят перейти по другому адресу... переходим
$ch = curl_init('https://ssl.easypay.by/pay/?'.$request_id[0]);
curl_setopt  ($ch, CURLOPT_HEADER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER,$headers);
curl_setopt($ch, CURLOPT_COOKIE, $cookies);
curl_setopt($ch, CURLOPT_REFERER, 'https://ssl.easypay.by/');
curl_setopt($ch, CURLOPT_USERAGENT, 'Googlebot/2.1 (+http://www.google.com/bot.html)');
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
$str = curl_exec($ch);
curl_close($ch);
if(preg_match("/Ошибка соединения с сервером./i",$str)) {
	$result = "ERROR_CONNECT_SERVER";
	return $result;
	exit();
}
//авторизаци прошла успешно, переходим на страницу истории

//$mode = 3;//тип истории(перевод от других пользователей)
$mon_one = $data_start[1]-1;
$mon_two = $data_finish[1]-1;
$req = 'b_d='.$data_start[2].'&b_m='.$mon_one.'&b_y='.$data_start[0].'&e_d='.$data_finish[2].'&e_m='.$mon_two.'&e_y='.$data_finish[0].'&mode='.$mode.'&bn_history_show=%CF%EE%EA%E0%E7%E0%F2%FC';
preg_match_all('|Set-Cookie: (.*);|U', $str, $results);
$cookies = implode(';', $results[1]);

$ch = curl_init('https://ssl.easypay.by/history/');
curl_setopt  ($ch, CURLOPT_HEADER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER,$headers);
curl_setopt($ch, CURLOPT_COOKIE, $cookies);
curl_setopt($ch, CURLOPT_REFERER, 'https://ssl.easypay.by/history/');
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_USERAGENT, 'Googlebot/2.1 (+http://www.google.com/bot.html)');
curl_setopt($ch, CURLOPT_POSTFIELDS, $req);
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
$str = curl_exec($ch); // выполняем запрос curl - обращаемся к сервера php.su
curl_close($ch);
preg_match("/request_id=+[a-z,0-9]+/i",$str,$request_id);
//после запроса на получение истории просят перейти на другую страницу, переходим
$ch = curl_init('https://ssl.easypay.by/history/?'.$request_id[0]);
curl_setopt  ($ch, CURLOPT_HEADER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER,$headers);
curl_setopt($ch, CURLOPT_COOKIE, $cookies);
curl_setopt($ch, CURLOPT_REFERER, 'https://ssl.easypay.by/history/?'.$request_id[0]);
curl_setopt($ch, CURLOPT_USERAGENT, 'Googlebot/2.1 (+http://www.google.com/bot.html)');
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
$str = curl_exec($ch);
curl_close($ch);
return $str;
}

function parser_sum_NAL($summa,$str) {
		$s = "/<td class=\"td1\">Пополнение<\/td><td class=\"td1 text_right\">".$summa."<\/td>+/i";
	if(preg_match($s,$str)) {$result = 1;}
return $result;
}
/////////////проверка платежа для магазина/////////////////////
function parser_history_sum_shop($summa,$did,$str) {
		$s = "/<td class=\"td1\">[0-9]*<\/td><td class=\"td1 text_right\">".$summa."<\/td><td class=\"td1\">[а-яА-Яa-zA-Z0-9\.\ \_\-#$@!%№,]*".$did."[а-яА-Яa-zA-Z0-9\.\ \_\-#$@!%№,]*<\/td>+/i";
	if(preg_match($s,$str)) {$result = "AMOUNT_CORRESPONDS";}
return $result;
}
/////////////для обмена с проверкой счета отправителя/////////////////////
function parser_history_sum($summa,$did,$str) {
		$s = "/<td class=\"td1\">[0-9]*<\/td><td class=\"td1 text_right\">([0-9\ ]*)<\/td><td class=\"td1\">[а-яА-Яa-zA-Z0-9\.\ \_\-#$@!%№,]*".$did."[а-яА-Яa-zA-Z0-9\.\ \_\-#$@!%№,]*<\/td>+/i";
	if(preg_match($s,$str,$ar)) {if(ereg_replace(' ','',$ar[1])>=ereg_replace(' ','',$summa)) {$result = "AMOUNT_CORRESPONDS";}}
return $result;
}

public static function direct_translation($login,$pass,$pp,$purse,$summa,$did) {
$headers = array
(   'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*;q=0.8',
    'Accept-Language: ru,en-us;q=0.7,en;q=0.3',
    'Accept-Encoding: deflate',
    'Accept-Charset: windows-1251,utf-8;q=0.7,*;q=0.7');

$data_tom = date( "Y-m-d",mktime(0,0,0,date("m")-1,date("d")-1,date("Y")) );
$data_today = date("Y-m-d",mktime(0,0,0,date("m"),date("d"),date("Y")) );

$data_start = explode('-',$data_tom);
$data_finish = explode('-',$data_today);
//делаем запрос на авторизацию
$ch = curl_init('https://ssl.easypay.by/pay/');
curl_setopt  ($ch, CURLOPT_HEADER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER,$headers);
curl_setopt($ch, CURLOPT_REFERER, 'https://ssl.easypay.by/');
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_USERAGENT, 'Googlebot/2.1 (+http://www.google.com/bot.html)');
curl_setopt($ch, CURLOPT_POSTFIELDS, 'login='.$login.'&password='.$pass.'&mode=enter');
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
$str = curl_exec($ch);
curl_close($ch);
preg_match("/request_id=+[a-z,0-9]+/i",$str,$request_id);
preg_match_all('|Set-Cookie: (.*);|U', $str, $results);
$cookies = implode(';', $results[1]);
//после авторизации просят перейти по другому адресу... переходим
$ch = curl_init('https://ssl.easypay.by/pay/?'.$request_id[0]);
curl_setopt  ($ch, CURLOPT_HEADER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER,$headers);
curl_setopt($ch, CURLOPT_COOKIE, $cookies);
curl_setopt($ch, CURLOPT_REFERER, 'https://ssl.easypay.by/');
curl_setopt($ch, CURLOPT_USERAGENT, 'Googlebot/2.1 (+http://www.google.com/bot.html)');
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
$str = curl_exec($ch);
curl_close($ch);
if(preg_match("/Ошибка соединения с сервером./i",$str)) {
	$result = "ERROR_CONNECT_SERVER";
	return $result;
	exit();
}
//авторизаци прошла успешно
$req_one = 'card_no='.$purse.'&money='.$summa.'&desc='.$did.'&ch_commerce=on&bn_transfer_next=%C4%E0%EB%E5%E5+%3E%3E';
preg_match_all('|Set-Cookie: (.*);|U', $str, $results);
$cookies = implode(';', $results[1]);
//делаем запрос на перевод денег
$ch = curl_init('https://ssl.easypay.by/transfer/');
curl_setopt  ($ch, CURLOPT_HEADER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER,$headers);
curl_setopt($ch, CURLOPT_COOKIE, $cookies);
curl_setopt($ch, CURLOPT_REFERER, 'https://ssl.easypay.by/transfer/');
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_USERAGENT, 'Googlebot/2.1 (+http://www.google.com/bot.html)');
curl_setopt($ch, CURLOPT_POSTFIELDS, $req_one);
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
$str = curl_exec($ch);
curl_close($ch);
preg_match("/request_id=+[a-z,0-9]+/i",$str,$request_id);
//после запроса на получение истории просят перейти на другую страницу, переходим
$ch = curl_init('https://ssl.easypay.by/transfer/?'.$request_id[0]);
curl_setopt  ($ch, CURLOPT_HEADER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER,$headers);
curl_setopt($ch, CURLOPT_COOKIE, $cookies);
curl_setopt($ch, CURLOPT_REFERER, 'https://ssl.easypay.by/transfer/');
curl_setopt($ch, CURLOPT_USERAGENT, 'Googlebot/2.1 (+http://www.google.com/bot.html)');
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
$str = curl_exec($ch);
curl_close($ch);

if(preg_match("/Для проведения этой операции требуется более высокий статус кошелька/i",$str)) {
	$result = "ERROR_RECIPIENT";
	return $result;
	exit();
} elseif(preg_match("/Несуществующий Идентификатор (номер) электронного кошелька EasyPay (кошелек получателя)/i",$str)) {
	$result = "ERROR_PURSE";
	return $result;
	exit();
} elseif(preg_match("/Превышено месячное ограничение по сумме операций пользователя для данного типа операций (Ваш кошелек)/i",$str)) {
	$result = "ERROR_EXCESS_S";
	return $result;
	exit();
} elseif(preg_match("/Превышено месячное ограничение по сумме операций пользователя для данного типа операций (кошелек получателя)/i",$str)) {
	$result = "ERROR_EXCESS_U";
	return $result;
	exit();
} elseif(preg_match("/Превышено дневное ограничение/i",$str)) {
	$result = "MAX_LIMIT_DAY";
	return $result;
	exit();
} elseif(preg_match("/Недостаточно средств в электронном кошельке./i",$str)) {
	$result = "ERROR_BALANCE";
	return $result;
	exit();
} elseif(preg_match("/Несуществующий Идентификатор (номер) электронного кошелька EasyPay (кошелек получателя)/i",$str)) {
    $result = "UNDEFINED_ACCOUNT";
    return $result;
    exit();
}
else {
preg_match("/(<input type=\"hidden\" name=\"test\" value=\")([a-z,0-9]+)(\">)/i",$str,$pay_id);
$req_two = 'card_no='.$purse.'&money='.$summa.'&desc='.$did.'&ch_commerce=1&test='.$pay_id[2].'&pswd='.$pp.'&bn_transfer_pay=%CF%E5%F0%E5%E2%E5%F1%F2%E8';
preg_match_all('|Set-Cookie: (.*);|U', $str, $results);
$cookies = implode(';', $results[1]);
//делаем запрос на перевод денег
$ch = curl_init('https://ssl.easypay.by/transfer/?'.$request_id[0]);
curl_setopt  ($ch, CURLOPT_HEADER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER,$headers);
curl_setopt($ch, CURLOPT_COOKIE, $cookies);
curl_setopt($ch, CURLOPT_REFERER, 'https://ssl.easypay.by/transfer/?'.$request_id[0]);
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_USERAGENT, 'Googlebot/2.1 (+http://www.google.com/bot.html)');
curl_setopt($ch, CURLOPT_POSTFIELDS, $req_two);
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
$str = curl_exec($ch);
curl_close($ch);
preg_match("/request_id=+[a-z,0-9]+/i",$str,$request_id);
//после запроса на получение истории просят перейти на другую страницу, переходим
$ch = curl_init('https://ssl.easypay.by/transfer/?'.$request_id[0]);
curl_setopt  ($ch, CURLOPT_HEADER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER,$headers);
curl_setopt($ch, CURLOPT_COOKIE, $cookies);
curl_setopt($ch, CURLOPT_REFERER, 'https://ssl.easypay.by/transfer/');
curl_setopt($ch, CURLOPT_USERAGENT, 'Googlebot/2.1 (+http://www.google.com/bot.html)');
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
$str = curl_exec($ch);
curl_close($ch);
	if(preg_match("/Перевод прошел успешно/i",$str)) {$result = "TRANSFER_OK";}
	else {$result = "TRANSFER_ERROR";}

}
return $result;
}
//автомат по оплате услуг(мобильная связь)
function pay_usluga($login,$pass,$pass_pay,$number,$amount,$operator) {
$headers = array
(	'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Accept-Language: ru',
    'Accept-Charset: windows-1251,utf-8;q=0.7,*;q=0.7',
	'Connection: keep-alive');
//делаем запрос на авторизацию
$ch = curl_init('https://ssl.easypay.by/pay/');
curl_setopt  ($ch, CURLOPT_HEADER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER,$headers);
curl_setopt($ch, CURLOPT_REFERER, 'https://ssl.easypay.by/');
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_USERAGENT, 'Googlebot/2.1 (+http://www.google.com/bot.html)');
curl_setopt($ch, CURLOPT_POSTFIELDS, 'login='.$login.'&password='.$pass.'&mode=enter');
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
$str = curl_exec($ch);
curl_close($ch);
preg_match("/request_id=+[a-z,0-9]+/i",$str,$request_id);
preg_match_all('|Set-Cookie: (.*);|U', $str, $results);
$cookies = implode(';', $results[1]);
//после авторизации просят перейти по другому адресу... переходим
$ch = curl_init('https://ssl.easypay.by/pay/?'.$request_id[0]);
curl_setopt  ($ch, CURLOPT_HEADER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER,$headers);
curl_setopt($ch, CURLOPT_COOKIE, $cookies);
curl_setopt($ch, CURLOPT_REFERER, 'https://ssl.easypay.by/');
curl_setopt($ch, CURLOPT_USERAGENT, 'Googlebot/2.1 (+http://www.google.com/bot.html)');
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
$str = curl_exec($ch);
curl_close($ch);
if(preg_match("/Ошибка соединения с сервером./i",$str)) {
	$result = "ERROR_CONNECT_SERVER";
	return $result;
	exit();
}
//авторизаци прошла успешно

//переходим на страницу для ввода телефона например для оплаты Velcom https://ssl.easypay.by/sou/service/velcom/
preg_match_all('|Set-Cookie: (.*);|U', $str, $results);
$cookies = implode(';', $results[1]);
$ch = curl_init('https://ssl.easypay.by/sou/service/'.$operator.'/');
curl_setopt  ($ch, CURLOPT_HEADER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER,$headers);
curl_setopt($ch, CURLOPT_COOKIE, $cookies);
curl_setopt($ch, CURLOPT_REFERER, 'https://ssl.easypay.by/pay/?'.$request_id[0]);
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_USERAGENT, 'Googlebot/2.1 (+http://www.google.com/bot.html)');
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
$str = curl_exec($ch);
curl_close($ch);
//просят перейти по другому адресу... переходим
preg_match("/request_id=+[a-z,0-9]+/i",$str,$request_id);
preg_match_all('|Set-Cookie: (.*);|U', $str, $results);
$cookies = implode(';', $results[1]);
$ch = curl_init('https://ssl.easypay.by/pay/?'.$request_id[0]);
curl_setopt  ($ch, CURLOPT_HEADER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER,$headers);
curl_setopt($ch, CURLOPT_COOKIE, $cookies);
curl_setopt($ch, CURLOPT_REFERER, 'https://ssl.easypay.by/');
curl_setopt($ch, CURLOPT_USERAGENT, 'Googlebot/2.1 (+http://www.google.com/bot.html)');
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
$str = curl_exec($ch);
curl_close($ch);

//отправляем форму с номером телефона(нажимаем кнопку далее)
preg_match("/(<input type=\"hidden\" name=\"uid\" value=\")([a-zA-Z,0-9]+)(\">)/i",$str,$uid_hesh);
$req = 'sou_mode=info&firstform=1&uid='.$uid_hesh[2].'&Idx1='.$number.'&status=complete';
$ch = curl_init('https://ssl.easypay.by/sou/service/'.$operator.'/?'.$request_id[0]);
curl_setopt  ($ch, CURLOPT_HEADER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER,$headers);
curl_setopt($ch, CURLOPT_COOKIE, $cookies);
curl_setopt($ch, CURLOPT_REFERER, 'https://ssl.easypay.by/sou/service/'.$operator.'/');
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_USERAGENT, 'Googlebot/2.1 (+http://www.google.com/bot.html)');
curl_setopt($ch, CURLOPT_POSTFIELDS, $req);
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
$str = curl_exec($ch);
curl_close($ch);
//preg_match_all('|Set-Cookie: (.*);|U', $str, $results);
//$cookies = implode(';', $results[1]);
preg_match("/request_id=+[a-z,0-9]+/i",$str,$request_id);
//просят перейти на другую страницу, переходим
$ch = curl_init('https://ssl.easypay.by/sou/service/'.$operator.'/?'.$request_id[0]);
curl_setopt  ($ch, CURLOPT_HEADER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER,$headers);
curl_setopt($ch, CURLOPT_COOKIE, $cookies);
curl_setopt($ch, CURLOPT_REFERER, 'https://ssl.easypay.by/sou/service/'.$operator.'/?'.$request_id[0]);
curl_setopt($ch, CURLOPT_USERAGENT, 'Googlebot/2.1 (+http://www.google.com/bot.html)');
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
$str = curl_exec($ch);
curl_close($ch);

//отправляем форму с суммой платежа, нажимаем кнопку далее
preg_match("/(<input type=\"hidden\" name=\"uid\" value=\")([a-zA-Z,0-9]+)(\">)/i",$str,$uid_hesh);
$req = 'sou_mode=pay&uid='.$uid_hesh[2].'&amount='.$amount.'&status=complete';
$ch = curl_init('https://ssl.easypay.by/sou/service/'.$operator.'/?'.$request_id[0]);
curl_setopt  ($ch, CURLOPT_HEADER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER,$headers);
curl_setopt($ch, CURLOPT_COOKIE, $cookies);
curl_setopt($ch, CURLOPT_REFERER, 'https://ssl.easypay.by/sou/service/'.$operator.'/?'.$request_id[0]);
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_USERAGENT, 'Googlebot/2.1 (+http://www.google.com/bot.html)');
curl_setopt($ch, CURLOPT_POSTFIELDS, $req);
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
$str = curl_exec($ch);
curl_close($ch);
preg_match("/request_id=+[a-z,0-9]+/i",$str,$request_id);
//после запроса на получение истории просят перейти на другую страницу, переходим
$ch = curl_init('https://ssl.easypay.by/sou/service/'.$operator.'/?'.$request_id[0]);
curl_setopt  ($ch, CURLOPT_HEADER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER,$headers);
curl_setopt($ch, CURLOPT_COOKIE, $cookies);
curl_setopt($ch, CURLOPT_REFERER, 'https://ssl.easypay.by/sou/service/'.$operator.'/?'.$request_id[0]);
curl_setopt($ch, CURLOPT_USERAGENT, 'Googlebot/2.1 (+http://www.google.com/bot.html)');
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
$str = curl_exec($ch);
curl_close($ch);

//отправляем форму с платежным паролем, нажимаем кнопку оплатить
preg_match("/(<input type=\"hidden\" name=\"uid\" value=\")([a-zA-Z,0-9]+)(\">)/i",$str,$uid_hesh);
$req = 'sou_mode=payresult&uid='.$uid_hesh[2].'&pswd='.$pass_pay.'&status=complete';
$ch = curl_init('https://ssl.easypay.by/sou/service/'.$operator.'/?'.$request_id[0]);
curl_setopt  ($ch, CURLOPT_HEADER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER,$headers);
curl_setopt($ch, CURLOPT_COOKIE, $cookies);
curl_setopt($ch, CURLOPT_REFERER, 'https://ssl.easypay.by/sou/service/'.$operator.'/?'.$request_id[0]);
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_USERAGENT, 'Googlebot/2.1 (+http://www.google.com/bot.html)');
curl_setopt($ch, CURLOPT_POSTFIELDS, $req);
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
$str = curl_exec($ch);
curl_close($ch);
preg_match("/request_id=+[a-z,0-9]+/i",$str,$request_id);
//просят перейти на другую страницу, переходим
$ch = curl_init('https://ssl.easypay.by/sou/service/'.$operator.'/?'.$request_id[0]);
curl_setopt  ($ch, CURLOPT_HEADER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER,$headers);
curl_setopt($ch, CURLOPT_COOKIE, $cookies);
curl_setopt($ch, CURLOPT_REFERER, 'https://ssl.easypay.by/sou/service/'.$operator.'/?'.$request_id[0]);
curl_setopt($ch, CURLOPT_USERAGENT, 'Googlebot/2.1 (+http://www.google.com/bot.html)');
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
$str = curl_exec($ch);
curl_close($ch);
	if(preg_match("/Оплата успешно завершена/i",$str)) {$result = "TRANSFER_OK";}
	else {$result = "TRANSFER_ERROR";}
if(preg_match("/Недостаточно средств в электронном кошельке./i",$str)) {
	$result = "ERROR_BALANCE";
	return $result;	exit();
}
return $result;
}

function connect_history_easypay_data($login,$pass,$mode,$data_s,$data_e) {
$headers = array
(	'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Accept-Language: ru',
    'Accept-Charset: windows-1251,utf-8;q=0.7,*;q=0.7');
$days = date("d");
$mon = date("m");
$yaer = date("Y");

$data_tom = date( "Y-n-j",mktime(0,0,0,$mon,$days-1,$yaer) );
$data_today = date( "Y-n-j",mktime(0,0,0,$mon,$days,$yaer) );

$data_start = explode('-',$data_tom);
$data_finish = explode('-',$data_today);
//делаем запрос на авторизацию
$ch = curl_init('https://ssl.easypay.by/pay/');
curl_setopt  ($ch, CURLOPT_HEADER, 1);
curl_setopt($ch, CURLOPT_HTTPHEADER,$headers);
curl_setopt($ch, CURLOPT_REFERER, 'https://ssl.easypay.by/');
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_USERAGENT, 'Googlebot/2.1 (+http://www.google.com/bot.html)');
curl_setopt($ch, CURLOPT_POSTFIELDS, 'login='.$login.'&password='.$pass.'&mode=enter');
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
$str = curl_exec($ch);
curl_close($ch);
preg_match("/request_id=+[a-z,0-9]+/i",$str,$request_id);
preg_match_all('|Set-Cookie: (.*);|U', $str, $results);
$cookies = implode(';', $results[1]);
//после авторизации просят перейти по другому адресу... переходим
$ch = curl_init('https://ssl.easypay.by/pay/?'.$request_id[0]);
curl_setopt  ($ch, CURLOPT_HEADER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER,$headers);
curl_setopt($ch, CURLOPT_COOKIE, $cookies);
curl_setopt($ch, CURLOPT_REFERER, 'https://ssl.easypay.by/');
curl_setopt($ch, CURLOPT_USERAGENT, 'Googlebot/2.1 (+http://www.google.com/bot.html)');
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
$str = curl_exec($ch);
curl_close($ch);
if(preg_match("/Ошибка соединения с сервером./i",$str)) {
	$result = "ERROR_CONNECT_SERVER";
	return $result;
	exit();
}
//авторизаци прошла успешно, переходим на страницу истории

//$mode = 3;//тип истории(перевод от других пользователей)
$mon_one = $data_start[1]-1;
$mon_two = $data_finish[1]-1;
$req = 'b_d='.$data_start[2].'&b_m='.$mon_one.'&b_y='.$data_start[0].'&e_d='.$data_finish[2].'&e_m='.$mon_two.'&e_y='.$data_finish[0].'&mode='.$mode.'&bn_history_show=%CF%EE%EA%E0%E7%E0%F2%FC';
preg_match_all('|Set-Cookie: (.*);|U', $str, $results);
$cookies = implode(';', $results[1]);

$ch = curl_init('https://ssl.easypay.by/history/');
curl_setopt  ($ch, CURLOPT_HEADER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER,$headers);
curl_setopt($ch, CURLOPT_COOKIE, $cookies);
curl_setopt($ch, CURLOPT_REFERER, 'https://ssl.easypay.by/history/');
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_USERAGENT, 'Googlebot/2.1 (+http://www.google.com/bot.html)');
curl_setopt($ch, CURLOPT_POSTFIELDS, $req);
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
$str = curl_exec($ch); // выполняем запрос curl - обращаемся к сервера php.su
curl_close($ch);
preg_match("/request_id=+[a-z,0-9]+/i",$str,$request_id);
//после запроса на получение истории просят перейти на другую страницу, переходим
$ch = curl_init('https://ssl.easypay.by/history/?'.$request_id[0]);
curl_setopt  ($ch, CURLOPT_HEADER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER,$headers);
curl_setopt($ch, CURLOPT_COOKIE, $cookies);
curl_setopt($ch, CURLOPT_REFERER, 'https://ssl.easypay.by/history/?'.$request_id[0]);
curl_setopt($ch, CURLOPT_USERAGENT, 'Googlebot/2.1 (+http://www.google.com/bot.html)');
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
$str = curl_exec($ch);
curl_close($ch);
return $str;
}
}
?>