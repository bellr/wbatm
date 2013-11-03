<?
set_time_limit(0);
require("customsql.inc.aspx");
$mtime1 = explode(" ", microtime());
$starttime = $mtime1[1] + $mtime1[0];
require_once($home_dir."mailer/smtp-func.aspx");

$db = new CustomSQL($DBName);
$sel_email = $db->sel_email();
/*
for($i=0;$i<10;$i++) {
	smtpmail('atomly@mail.ru',"Покупка товара в Интернет-магазине Shop.wm-rb.net",'Тело сообщения',"Интернет-магазин Shop.wm-rb.net");
	echo $i."<br>";

}

*/
foreach($sel_email as $ar) {
echo $ar[0].",";
}
		$mtime2 = explode(" ", microtime());
		$endtime = $mtime2[1] + $mtime2[0];
		$totaltime = ($endtime - $starttime);
		$totaltime = number_format($totaltime, 7);

		echo "Время загрузки: ".$totaltime." сек.";
?>
