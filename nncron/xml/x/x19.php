<?php
	require_once("_header.php");

	# ��������� � ��������� ������ �����
	if (count($_POST) > 0) {
print_r($_POST);
		$response = $wmxi->X19(
			$_POST["operation_type"],				# operation_type
			$_POST["pursetype"],					# pursetype
			floatval($_POST["amount"]),				# �����
			$_POST["wmid"],							# WMID ������������ [userinfo/wmid]
			$_POST["pnomer"],
			$_POST["fname"],
			$_POST["iname"],
			$_POST["bank_name"],
			$_POST["bank_account"],
			$_POST["card_number"],
			$_POST["emoney_name"],
			$_POST["emoney_id"]


		);
		# ���������� ������ ������ �������
		include_once("../wmxiparser.php");

		# ������ ������ �������
		$parser = new WMXIParser();

		# ��������������� ����� ������� � ���������. ������� ���������:
		# - XML-����� �������
		# - ���������, ������������ �� �����. �� ��������� ������������ UTF-8
		$structure = $parser->Parse($response, DOC_ENCODING);

		# ����������� ������� ��������� � ����� ������� ��� �������.
		# �� ������������� ��������� ����� �������������� � � �����������, ���� �� ��������
		# ��������� ���������� ����� (��������, ������ ����������)
		# ���� ���������� � ���������� XML-����� ������ ���, �� ������ �������� �����
		# ���������� � false - � ����� ������ ��������� ������ ����� ����������
		$transformed = $parser->Reindex($structure, true);

	}

?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html>
<head>
	<title>X19</title>
	<meta http-equiv="Content-Type" content="text/html; charset=<?=DOC_ENCODING;?>" />
	<meta name="author" content="dr.Drunk" />
	<link rel="stylesheet" type="text/css" href="style.css" />
</head>
<body>
	��������� �������� ����������:
	<a href="http://wiki.webmoney.ru/wiki/show/Interfeys_X19">http://wiki.webmoney.ru/wiki/show/Interfeys_X19</a>
	<br />

	<form action="" method="post">

	<label>WMID ������������ [userinfo/wmid]:</label>
    <input type="text" name="wmid" value="" />
		<br/>

	<label>��� �������� [operation/type]:</label>
    <select name="operation_type">
        <option value="1">1. ����/����� WM ��������� � ����� �� �������� �������, operation/type=1</option>
        <option value="2">2. ����/����� WM ��������� ����� ������� �������� ���������, operation/type=2</option>
        <option value="3">3. ����/����� WM �� ���������� ����, operation/type=3</option>
        <option value="4">4. ����/����� WM �� ���������� �����, operation/type=4</option>
        <option value="5">5. ����� WM �� ����������� ������ ������ ������, operation/type=5</option>
		<option value="7">7. ����� �� �������, operation/type=5</option>
    </select>
    <br/>

	<label>����������� �������� [operation/direction]:</label>
    <select name="direction">
        <option value="1">����� ������� �� ������� (�������� �� ���������), operation/direction=1</option>
        <option value="2">���� ������� � �������, operation/direction=2</option>

    </select>
    <br/>

	<label>�����:</label>
    <input maxlength="12" type="text" name="amount" value="0">
    <select name="pursetype">
    	<option>WMZ</option>
        <option>WME</option>
        <option>WMR</option>
        <option>WMU</option>
        <option>WMB</option>
        <option>WMY</option>
        <option>WMG</option>
    </select>
    <br/>

	<label>������� ������������ [userinfo/fname]:</label>
    <input maxlength="100" type="text" name="fname" value="">
    <br/>

	<label>��� ������������:[userinfo/iname]:</label>
    <input maxlength="100" type="text" name="iname" value="">
    <br/>

	<label>����� �������� [userinfo/pnomer]:</label>
    <input maxlength="100" type="text" name="pnomer" value="">
    <br/>

	<label>�������� ����� [userinfo/bank_name]:</label>
    <input maxlength="100" type="text" name="bank_name" value="">
    <br/>

	<label>����� ����������� ����� [userinfo/bank_account]:</label>
    <input maxlength="100" type="text" name="bank_account" value="">
    <br/>

	<label>����� ���������� ����� [userinfo/card_number]:</label>
    <input maxlength="100" type="text" name="card_number" value="">
    <br/>

	<label>�������� ��������� ������� [emoney_name]:</label>
    <input maxlength="100" type="text" name="emoney_name" value="">
    <br/>

	<label>ID ������������ � ��������� ������� [emoney_id]:</label>
    <input maxlength="100" type="text" name="emoney_id" value="">
    <br/>

	<label>����� �������� [phone]:</label>
    <input maxlength="100" type="text" name="phone" value="">
    <br/>		<input type="submit" value="���������" />
		<br/>

	</form>

	<pre><?=htmlspecialchars(@$response, ENT_QUOTES);?></pre>
	<!--pre><?=htmlspecialchars(print_r(@$structure, true), ENT_QUOTES);?></pre-->
	<!--pre><?=htmlspecialchars(print_r(@$transformed, true), ENT_QUOTES);?></pre-->

	<pre><!-- ������ � ���������� �������� ������������� ������� ����� ��������� ������ � ������� -->
		���: <b><?=htmlspecialchars(@$transformed["passport.response"]["userinfo"]["iname"], ENT_QUOTES); ?></b>
		��������: <b><?=htmlspecialchars(@$transformed["passport.response"]["userinfo"]["oname"], ENT_QUOTES); ?></b>

		��� ������: <b><?=htmlspecialchars(@$transformed["passport.response"]["retval"], ENT_QUOTES); ?></b>
		�������� ������: <b><?=htmlspecialchars(@$transformed["passport.response"]["retdesc"], ENT_QUOTES); ?></b>
	</pre>

</body>
</html>
