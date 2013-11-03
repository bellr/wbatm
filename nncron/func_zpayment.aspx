<?
Class ZPayment {

function PAY_ZP($ID_PAY,$DST_ACCOUNT,$SUMMA_OUT,$COMMENT) {

$PASSWORD = "917574a497c734a65668e862cd769a05";
$md5_hesh = md5("{$ID_PAY}81ZP22890643{$DST_ACCOUNT}{$SUMMA_OUT}{$COMMENT}PAY_ZP917574a497c734a65668e862cd769a05");
$req = "ID_PAY={$ID_PAY}&ID_INTERFACE=81&ZP_ACCOUNT=ZP22890643&DST_ACCOUNT={$DST_ACCOUNT}&SUMMA_OUT={$SUMMA_OUT}&COMMENT={$COMMENT}&TYPE_TRANSFER=PAY_ZP&HASH={$md5_hesh}";
$headers = array
(   'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*;q=0.8',
    'Accept-Language: ru,en-us;q=0.7,en;q=0.3',
    'Accept-Encoding: deflate',
    'Accept-Charset: windows-1251,utf-8;q=0.7,*;q=0.7');

$ch = curl_init('https://z-payment.ru/api/create_pay.php');
curl_setopt  ($ch, CURLOPT_HEADER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER,$headers);
curl_setopt($ch, CURLOPT_REFERER, 'https://ssl.easypay.by/');
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt ($ch, CURLOPT_USERAGENT, "Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.1.6) Gecko/20091201 Firefox/3.5.6 WebMoney Advisor");
curl_setopt($ch, CURLOPT_POSTFIELDS, $req);
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
$res = curl_exec($ch);
curl_close($ch);

return $res;
}
}
?>