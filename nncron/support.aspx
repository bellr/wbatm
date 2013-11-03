<?php
require("customsql.inc.aspx");
$db = new CustomSQL($DBName);
$db_admin = new CustomSQL_admin($DBName_admin);
include("usercheck.aspx");
if(!empty($_POST['mail_send'])) {
$reply_mess = $_POST['reply_mes'];
$message = $_POST['message'];

	require("/home/wmrb/data/www/wm-rb.net/mailer/smtp-func.aspx");
	$from_name = "Support. Team, WM-RB.net";
	$subject = "Ответ по вашему запросу";
	$body = "<center>Здравствуйте.</center><br />
Вы писали :<br />
<blockquote>$message</blockquote><br />
{$reply_mess}<br />
<br />--<br />
С уважением,<br />
Администрация WM-RB.net<br />
<a href='http://wm-rb.net'>Сервис платежей WebMoney в Республике Беларусь</a><br />
Mail: <a href='mailto:$support'>$support</a><br />
ICQ: $icq
";

smtpmail($_POST['email'],$subject,$body,$from_name);
	$db_admin->support_del($_POST['id']);
	$send = "ok";
}
?>
<html>
<head>
<title>Просмотр новых сообщений</title>
<meta http-equiv="Content-Type" content="text/html; charset=win-1251">
<meta content="none" name="ROBOTS">
<link rel="stylesheet" href="style/style.css" type="text/css">
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0">
<div align="center">
<?
	include("include/top.aspx");
echo "</div><br>";
if($send == "ok"){
echo "<div align=center>
<font size=3 color=red><b><<<Сообщение отправлено>>></b></font>
</div><br />";
}
echo "<table width=\"100%\" cellspacing=\"0\" cellpadding=\"5\" border=1 align=\"center\">";
echo "<tr bgcolor=\"#CCCCCC\" align=\"center\">
	<td width=80%>Сообщение</td>
	<td width=10%>Дата</td>
	<td width=10%>&nbsp;</td>
	</tr>";

$result = $db_admin->support_mess('n');

		foreach ($result as $ar) {
			$id = $ar["0"];
	        $message = $ar["1"];
	        $date = $ar["2"];
	        $time = $ar["3"];

		echo "<tr bgcolor=\"#CCCCCC\">";
		echo "<td bgcolor=\"#ffffff\">".$message."</td>";
		echo "<td bgcolor=\"#ffffff\" align=center>".$date."</td>";
		echo "<td bgcolor=\"#ffffff\" align=center><a href=\"support.aspx?id=".$id."\">ответить</a></td>";
		echo "</tr>";

	}
echo "</table><br /><br />";
if ($_GET['id']) {
	$u = $db_admin->get_info_mess($_GET['id'],'n');
$message = $u[0]['message'];
echo "<div align=center>
	IP : {$u[0]['ip']}
</div><br />
<div align=center>
<div align=left>
	<b>Вопрос :</b><br />
	<blockquote>{$u[0]['message']}</blockquote>
</div>

<br />
	<form method=post action=support.aspx>
		<input type=hidden name=email value={$u[0]['email']} />
		<input type=hidden name=id value={$u[0]['id']} />
		<input type=hidden name=message value=\"$message\" size=250 />
<textarea name=reply_mes rows=15 cols=100></textarea><br /><br />
<input type=submit name=mail_send value=Отправить>

	</form>
</div>";
}
?>


</body>
</html>
