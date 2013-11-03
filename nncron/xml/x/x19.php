<?php
	require_once("_header.php");

	# Получение и обработка данных формы
	if (count($_POST) > 0) {
print_r($_POST);
		$response = $wmxi->X19(
			$_POST["operation_type"],				# operation_type
			$_POST["pursetype"],					# pursetype
			floatval($_POST["amount"]),				# Сумма
			$_POST["wmid"],							# WMID пользователя [userinfo/wmid]
			$_POST["pnomer"],
			$_POST["fname"],
			$_POST["iname"],
			$_POST["bank_name"],
			$_POST["bank_account"],
			$_POST["card_number"],
			$_POST["emoney_name"],
			$_POST["emoney_id"]


		);
		# Подключаем парсер ответа сервера
		include_once("../wmxiparser.php");

		# создаём объект парсера
		$parser = new WMXIParser();

		# Преобразовываем ответ сервера в структуру. Входные параметры:
		# - XML-ответ сервера
		# - кодировка, используемая на сайте. По умолчанию используется UTF-8
		$structure = $parser->Parse($response, DOC_ENCODING);

		# преобразуем индексы структуры к более удобным для доступа.
		# Не рекомендуется проводить такое преобразование с с результатом, если он содержит
		# множество однотипных строк (например, список транзакций)
		# если надобности в аттрибутах XML-тегов ответа нет, то второй параметр можно
		# установить в false - в таком случае структура выйдет более компактной
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
	Детальное описание параметров:
	<a href="http://wiki.webmoney.ru/wiki/show/Interfeys_X19">http://wiki.webmoney.ru/wiki/show/Interfeys_X19</a>
	<br />

	<form action="" method="post">

	<label>WMID пользователя [userinfo/wmid]:</label>
    <input type="text" name="wmid" value="" />
		<br/>

	<label>Тип операции [operation/type]:</label>
    <select name="operation_type">
        <option value="1">1. Ввод/вывод WM наличными в одном из обменных пунктов, operation/type=1</option>
        <option value="2">2. Ввод/вывод WM наличными через системы денежных переводов, operation/type=2</option>
        <option value="3">3. Ввод/вывод WM на банковский счет, operation/type=3</option>
        <option value="4">4. Ввод/вывод WM на банковскую карту, operation/type=4</option>
        <option value="5">5. Обмен WM на электронную валюту других систем, operation/type=5</option>
		<option value="7">7. Вывод на телефон, operation/type=5</option>
    </select>
    <br/>

	<label>направление операции [operation/direction]:</label>
    <select name="direction">
        <option value="1">Вывод средств из системы (значение по умолчанию), operation/direction=1</option>
        <option value="2">Ввод средств в систему, operation/direction=2</option>

    </select>
    <br/>

	<label>Сумма:</label>
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

	<label>Фамилия пользователя [userinfo/fname]:</label>
    <input maxlength="100" type="text" name="fname" value="">
    <br/>

	<label>Имя пользователя:[userinfo/iname]:</label>
    <input maxlength="100" type="text" name="iname" value="">
    <br/>

	<label>Номер паспорта [userinfo/pnomer]:</label>
    <input maxlength="100" type="text" name="pnomer" value="">
    <br/>

	<label>Название банка [userinfo/bank_name]:</label>
    <input maxlength="100" type="text" name="bank_name" value="">
    <br/>

	<label>Номер банковского счета [userinfo/bank_account]:</label>
    <input maxlength="100" type="text" name="bank_account" value="">
    <br/>

	<label>Номер банковской карты [userinfo/card_number]:</label>
    <input maxlength="100" type="text" name="card_number" value="">
    <br/>

	<label>Название платежной системы [emoney_name]:</label>
    <input maxlength="100" type="text" name="emoney_name" value="">
    <br/>

	<label>ID пользователя в платежной системе [emoney_id]:</label>
    <input maxlength="100" type="text" name="emoney_id" value="">
    <br/>

	<label>Номер телефона [phone]:</label>
    <input maxlength="100" type="text" name="phone" value="">
    <br/>		<input type="submit" value="Проверить" />
		<br/>

	</form>

	<pre><?=htmlspecialchars(@$response, ENT_QUOTES);?></pre>
	<!--pre><?=htmlspecialchars(print_r(@$structure, true), ENT_QUOTES);?></pre-->
	<!--pre><?=htmlspecialchars(print_r(@$transformed, true), ENT_QUOTES);?></pre-->

	<pre><!-- Читаем и отображаем элементы обработанного массива после получения ответа с сервера -->
		Имя: <b><?=htmlspecialchars(@$transformed["passport.response"]["userinfo"]["iname"], ENT_QUOTES); ?></b>
		Отчество: <b><?=htmlspecialchars(@$transformed["passport.response"]["userinfo"]["oname"], ENT_QUOTES); ?></b>

		Код ошибки: <b><?=htmlspecialchars(@$transformed["passport.response"]["retval"], ENT_QUOTES); ?></b>
		Описание ошибки: <b><?=htmlspecialchars(@$transformed["passport.response"]["retdesc"], ENT_QUOTES); ?></b>
	</pre>

</body>
</html>
