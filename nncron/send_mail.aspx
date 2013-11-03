<?

function badyMail($did,$type_goods,$name_goods,$pay_price,$pay_curr,$goods,$data,$time,$icq,$support) {
	$ed = explode("-",$data);
switch ($type_goods) :

	case ("pinkod") :
	$body = "<div style=\"FONT-SIZE: 12px; FONT-FAMILY: Verdana; COLOR: #676767; LINE-HEIGHT: 18px;\">
<center><b>Здравствуйте</b></center><br />
--------------------------------------------<br />
&nbsp;<b>Информация о Вашей покупке</b><br />
--------------------------------------------<br />
<br />
<b>Название товара :</b> &#34;{$name_goods}&#34;<br />
<b>Оплаченная сумма :</b> {$pay_price} {$pay_curr}<br />
<b>Дата покупки :</b> {$ed[2]}.{$ed[1]}.{$ed[0]} {$time}<br />
<b>Информация о товаре :</b><br />
	<blockquote>{$goods}</blockquote>
Дополнительно информацию о товаре можете посмотреть на <a href='http://shop.wm-rb.net/check_pay.aspx?d={$did}'>странице</a>
<br /><br />
Мы будем благодарны Вам за любые предложения, высказанные по поводу того,<br />
какой Вы хотите видеть сервис электронных платежей WM-RB.net.<br /><br />

Благодарим Вас за использование нашего сервиса.<br />
Это письмо отправлено роботом, ответа не требует.<br />
<br />--<br />
С уважением,<br />
Администрация WM-RB.net<br />
<br />
___________________________________<br />
<a href='http://wm-rb.net'>Сервис электронных платежей WebMoney<br />
Mail: <a href='mailto:$support'>$support</a><br />
ICQ: $icq
</div>";
	break;
	default:
endswitch;
	return $body;
}


?>