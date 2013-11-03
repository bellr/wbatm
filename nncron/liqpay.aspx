<?
Class LiqPAY {

	function API_LiqPAY($did,$id_pay,$card,$amount,$currency,$type) {
		$sigh = "bOuzrHL6njZ8Id3gjikYruyBPasPpwlXvYiFVL";
     $str = '<request>
          <version>1.2</version>
          <action>send_money</action>
          <kind>'.$type.'</kind>
          <merchant_id>i7638623293</merchant_id>
          <order_id>'.$id_pay.'</order_id>
          <to>'.$card.'</to>
          <amount>'.$amount.'</amount>
          <currency>'.$currency.'</currency>
          <description>Translation on card number '.$card.', ID:'.$did.'</description>
        </request>';
     $operation_xml = base64_encode($str);
     $signature = base64_encode(sha1($sigh.$str.$sigh, 1));
     $operation_envelop = '<operation_envelope>
                              <operation_xml>'.$operation_xml.'</operation_xml>
                              <signature>'.$signature.'</signature>
                         </operation_envelope>';
     $post = '<?xml version=\"1.0\" encoding=\"UTF-8\"?>
                              <request>
                                   <liqpay>'.$operation_envelop.'</liqpay>
                              </request>';
     $url = "https://www.liqpay.com/?do=api_xml";
     $page = "/?do=api_xml";
     $headers = array("POST ".$page." HTTP/1.0",
                         "Content-type: text/xml;charset=\"utf-8\"",
                         "Accept: text/xml",
                         "Content-length: ".strlen($post));
     $ch = curl_init();
     curl_setopt($ch, CURLOPT_URL, $url);
     curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
     curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
     curl_setopt($ch, CURLOPT_TIMEOUT, 60);
     curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
     curl_setopt($ch, CURLOPT_POST, 1);
     curl_setopt($ch, CURLOPT_POSTFIELDS, $post);
     $result = curl_exec($ch);
     curl_close($ch);

$xmlres = simplexml_load_string($result);
$liqpay_xml = simplexml_load_string(base64_decode($xmlres->liqpay->operation_envelope->operation_xml));
if($liqpay_xml->status == 'success') {
     $liq_str = '<request>
          <version>'.$liqpay_xml->version.'</version>
          <action>'.$liqpay_xml->action.'</action>
          <kind>'.$liqpay_xml->kind.'</kind>
          <merchant_id>'.$liqpay_xml->merchant_id.'</merchant_id>
          <order_id>'.$liqpay_xml->order_id.'</order_id>
          <to>'.$liqpay_xml->to.'</to>
          <amount>'.$liqpay_xml->amount.'</amount>
          <currency>'.$liqpay_xml->currency.'</currency>
          <description>'.$liqpay_xml->description.'</description>
        </request>';
	$mysignature = base64_encode(sha1($sigh.$liq_str.$sigh, 1));
			if($mysignature == $signature) return 'success';
			else return 'Sign is error';
}
if($liqpay_xml->status == 'failure') return $liqpay_xml->code;
	}











	function parser_answer_API_LiqPAY($result) {
		$xmlres = simplexml_load_string(str_replace('\"','"',$result));
		//$xmlres = simplexml_load_string($result);
		$operation_xml = base64_decode($xmlres->liqpay->operation_envelope->operation_xml);
		$signature = base64_encode(sha1($sigh.$operation_xml.$sigh, 1));
			if($xmlres->liqpay->operation_envelope->signature == $signature){

echo $xmlres->liqpay->operation_envelope->signature."  -  ".$signature;
			}

	}
}
?>

