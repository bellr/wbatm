<?
Class WebMoney {

function direct_translation_X2($did,$sel_idpay,$purse_sender,$purse_grantee,$in_val,$desc_pay) {
//���� ��������
include("xml/conf.php");
include("xml/wmxiparser.php");
//include("../const.inc.aspx");
$parser = new WMXIParser();
	$response = $wmxi->X2(
			intval($sel_idpay),    # ����� �������� � ������� ����� �����������; ����� ����� ����� ��� �����, ������ ���� ����������
			$purse_sender,          # ����� �������� � �������� ����������� ������� (�����������)
			$purse_grantee,         # ����� ��������, �� ������� ����������� ������� (����������)
			floatval($in_val),  # ����� � ��������� ������ ��� ���������� ��������
			'0',    # ����� �� 0 �� 255 ��������; 0 - ��� ���������
			'',       # ������������ ������ �� 0 �� 255 ��������; ������� � ������ ��� ����� �� �����������
			trim($desc_pay),        # ������������ ������ �� 0 �� 255 ��������; ������� � ������ ��� ����� �� �����������
			intval('0'),    # ����� ����� > 0; ���� 0 - ������� �� �� �����
			'1'    # ���� 0 � ������� ����� ����������� ��� ����� ��������� �� ���������� �������; 1 � ������� ����� ����������� ������ ���� ���������� ��������� ������� (� ��������� ������ ��� �������� � 35)
		);
		$structure = $parser->Parse($response, DOC_ENCODING);
		$transformed = $parser->Reindex($structure, true);
		$kod_error = htmlspecialchars(@$transformed["w3s.response"]["retval"], ENT_QUOTES);

//echo "������ ".$kod_error;
		if ($kod_error == "0") {
			//$bal_in = $balance_in - $in_val * 1.008;
			//$db_exchange->demand_update_bal($bal_in,$wmt_purse);
			//$db_exchange->demand_edit('y',$did);
			$result = "Payment_successfully";
		}
		else {
			//$db_exchange->demand_edit('er',$did);
			//$db_exchange->demand_add_coment('� ����� � ������������ �����������, ������ ���� ��������� �����������. �������� �������������. ERROR='.$kod_error,$did);
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
			intval($sel_idpay),    # ����� ����� ��� �����
			floatval($out_val)     # ����� � ��������� ������ ��� ���������� ��������
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
			floatval($out_val),				# �����
			$wmid,							# WMID ������������ [userinfo/wmid]
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