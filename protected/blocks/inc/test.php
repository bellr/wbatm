<?
class test extends Template {
    function __construct($action_method,$vars='') {
        $this->$action_method();
    }

    private function block() {

        //echo self::direct_translation('17086291','05609781',trim(sprintf("%8.0f ",'1000000')),'1366445225');
		//echo 'asdas';
		//echo eEasyPay::direct_translation('17086291','05609781',trim(sprintf("%8.0f ",'1000000')),'1366445225');
		//echo gcCheckPayment::toEasyPay(array('purse_type'=>'EasyPay','in_val'=>100,'purse_in'=>'05609781','did'=>1366445225));
		//echo $res;

        //return $this->vars;
    }
	
	
	
	
	public static function direct_translation($login,$purse,$summa,$did) {

        $PP = Extension::Payments()->getParam('payments','easypay');
		$pass = $PP->$login['pass'];
		$pp = $PP->$login['pay_pass'];

	$headers = array(
        'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*;q=0.8',
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
	echo '111dasdadsasd';
	//$str = iconv("windows-1251", "UTF-8", $str);
	echo 'dasdadsasd';
	curl_close($ch);
//echo $str;
if(preg_match("/Превышено ограничение по сумме операций пользователя за 30 дней для данного типа операций/i",$str)) {
echo 'OK';
}
exit;
	if(preg_match("/Для проведения этой операции требуется более высокий статус кошелька/i",$str)) {
		$result = "ERROR_RECIPIENT";
		return $result;
		exit();
	} elseif(preg_match("/Несуществующий Идентификатор (номер) электронного кошелька EasyPay (кошелек получателя)/i",$str)) {
		$result = "ERROR_PURSE";
		return $result;
		exit();
	} elseif(preg_match("/Превышено ограничение по сумме операций пользователя за 30 дней для данного типа операций \(Ваш кошелек\)/i",$str)) {

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
	//exit('1234');
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
}

?>