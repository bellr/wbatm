<?
Class WebMoney {

function direct_translation_X2($did,$sel_idpay,$purse_sender,$purse_grantee,$in_val,$desc_pay) {
//путь изменить
include("xml/conf.php");
include("xml/wmxiparser.php");
//include("../const.inc.aspx");
$parser = new WMXIParser();
	$response = $wmxi->X2(
			intval($sel_idpay),    # номер перевода в системе учета отправителя; любое целое число без знака, должно быть уникальным
			$purse_sender,          # номер кошелька с которого выполняется перевод (отправитель)
			$purse_grantee,         # номер кошелька, но который выполняется перевод (получатель)
			floatval($in_val),  # число с плавающей точкой без незначащих символов
			'0',    # целое от 0 до 255 символов; 0 - без протекции
			'',       # произвольная строка от 0 до 255 символов; пробелы в начале или конце не допускаются
			trim($desc_pay),        # произвольная строка от 0 до 255 символов; пробелы в начале или конце не допускаются
			intval('0'),    # целое число > 0; если 0 - перевод не по счету
			'1'    # если 0 – перевод будет выполняться без учета разрешает ли получатель перевод; 1 – перевод будет выполняться только если получатель разрешает перевод (в противном случае код возврата – 35)
		);
		$structure = $parser->Parse($response, DOC_ENCODING);
		$transformed = $parser->Reindex($structure, true);
		$kod_error = htmlspecialchars(@$transformed["w3s.response"]["retval"], ENT_QUOTES);

//echo "Ошибка ".$kod_error;
		if ($kod_error == "0") {
			//$bal_in = $balance_in - $in_val * 1.008;
			//$db_exchange->demand_update_bal($bal_in,$wmt_purse);
			//$db_exchange->demand_edit('y',$did);
			$result = "Payment_successfully";
		}
		else {
			//$db_exchange->demand_edit('er',$did);
			//$db_exchange->demand_add_coment('В связи с техническими неполадками, заявка была совершена некорректно. Сообщите администрации. ERROR='.$kod_error,$did);
			$result = $kod_error;
			}
return $result;
}

function return_translation_X14($sel_idpay,$out_val) {
include("xml/conf.php");
include("xml/wmxiparser.php");
//include("../const.inc.aspx");
$parser = new WMXIParser();
		$response = $wmxi->X14(
			intval($sel_idpay),    # целое число без знака
			floatval($out_val)     # число с плавающей точкой без незначащих символов
		);
		$structure = $parser->Parse($response, DOC_ENCODING);
		$transformed = $parser->Reindex($structure, true);
		$kod_error = htmlspecialchars(@$transformed["w3s.response"]["retval"], ENT_QUOTES);

return $kod_error;
}
function check_X19($oper_type,$pursetype,$out_val,$wmid,$nphone) {
include("xml/conf.php");
include("xml/wmxiparser.php");
$parser = new WMXIParser();

		$response = $wmxi->X19(
			$oper_type,				# operation_type
			$pursetype, 					# pursetype
			floatval($out_val),				# Сумма
			$wmid,							# WMID пользователя [userinfo/wmid]
			$pnomer,
			$_POST["fname"],
			$_POST["iname"],
			$_POST["bank_name"],
			$_POST["bank_account"],
			$_POST["card_number"],
			$_POST["emoney_name"],
			$_POST["emoney_id"],
			$nphone
		);


		$structure = $parser->Parse($response, DOC_ENCODING);
		$transformed = $parser->Reindex($structure, true);
		$kod_error = htmlspecialchars(@$transformed["w3s.response"]["retval"], ENT_QUOTES);

return $kod_error;
}



}
?>