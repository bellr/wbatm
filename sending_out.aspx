<?
set_time_limit(0);
require("customsql.inc.aspx");
$mtime1 = explode(" ", microtime());
$starttime = $mtime1[1] + $mtime1[0];
require($home_dir."mailer/smtp-func.aspx");

$db = new CustomSQL($DBName);
$sel_email = $db->sel_email();

	$body = "<div style=\"FONT-SIZE: 12px; FONT-FAMILY: Verdana; COLOR: #676767; LINE-HEIGHT: 18px;\">
<center><b>Вас приветствует Сервис электронных платежей WM-RB.net</b></center><br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;При поддержке Обменного пункта WM-RB.net был создан интернет-магазин цифровых товаров Shop.wm-rb.net с мгновенной доставкой товаров.<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;В данный момент магазине представлены пин-коды карт экспресс оплаты интернет-провайдеров, сотовых операторов, дисконтные карты. В дальнейшем список будет увеличиваться.<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Для магазина была разработана система накопительных скидок, а именно дисконтные карты, которыми может воспользовать любой пользователь и накапливать скидки совместно. Карту можно продать или сообщить номер карты своему другу, при этом возможность использования картой у Вас остается и дальше. Справилами и условиями можете ознакомиться на <a href=\"http://shop.wm-rb.net/rules_diskont.aspx\">странице</a>.<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;А если Вы не желаете ждать пока собереться нужная сумма для получения скидки, на этот случай карту с уже накопленной скидкой Вы можете приобрести в нашем магазине на <a href=\"http://shop.wm-rb.net/goods.aspx?cat=diskont&company=wmrb\">странице</a>.<br />
<br />
<b>ЖДЕМ ВАС ЗА ПОКУПКАМИ!!!</b><br /><br />
Мы будем благодарны Вам за любые предложения, высказанные по поводу того,
какой Вы хотите видеть сервис WM-RB.net.<br /><br />

Благодарим Вас за использование нашего сервиса.<br />
Это письмо отправлено роботом, ответа не требует.<br />
<br />--<br />
С уважением,<br />
Администрация WM-RB.net<br />
<br />
<a href='http://wm-rb.net'>Сервис электронных платежей WM-RB.net<br />
Mail: <a href='mailto:support@wm-rb.net'>support@wm-rb.net</a><br />
ICQ: 562-718-741
</div>";
/*
for($i=0;$i<10;$i++) {
		smtpmail($ar[1],"Хорошая новость от WM-RB.net",$body,"Сервис электронных платежей WM-RB.net");
	echo $i."<br>";

}
*/

foreach($sel_email as $ar) {
		smtpmail($ar[1],"Хорошая новость от WM-RB.net",$body,"Сервис электронных платежей WM-RB.net");
$db->update_st_email($ar[0]);
echo $ar[1]." - Отправлено<br />";
}

		$mtime2 = explode(" ", microtime());
		$endtime = $mtime2[1] + $mtime2[0];
		$totaltime = ($endtime - $starttime);
		$totaltime = number_format($totaltime, 7);

		echo "Время загрузки: ".$totaltime." сек.";
?>
