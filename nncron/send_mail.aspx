<?

function badyMail($did,$type_goods,$name_goods,$pay_price,$pay_curr,$goods,$data,$time,$icq,$support) {
	$ed = explode("-",$data);
switch ($type_goods) :

	case ("pinkod") :
	$body = "<div style=\"FONT-SIZE: 12px; FONT-FAMILY: Verdana; COLOR: #676767; LINE-HEIGHT: 18px;\">
<center><b>������������</b></center><br />
--------------------------------------------<br />
&nbsp;<b>���������� � ����� �������</b><br />
--------------------------------------------<br />
<br />
<b>�������� ������ :</b> &#34;{$name_goods}&#34;<br />
<b>���������� ����� :</b> {$pay_price} {$pay_curr}<br />
<b>���� ������� :</b> {$ed[2]}.{$ed[1]}.{$ed[0]} {$time}<br />
<b>���������� � ������ :</b><br />
	<blockquote>{$goods}</blockquote>
������������� ���������� � ������ ������ ���������� �� <a href='http://shop.wm-rb.net/check_pay.aspx?d={$did}'>��������</a>
<br /><br />
�� ����� ���������� ��� �� ����� �����������, ����������� �� ������ ����,<br />
����� �� ������ ������ ������ ����������� �������� WM-RB.net.<br /><br />

���������� ��� �� ������������� ������ �������.<br />
��� ������ ���������� �������, ������ �� �������.<br />
<br />--<br />
� ���������,<br />
������������� WM-RB.net<br />
<br />
___________________________________<br />
<a href='http://wm-rb.net'>������ ����������� �������� WebMoney<br />
Mail: <a href='mailto:$support'>$support</a><br />
ICQ: $icq
</div>";
	break;
	default:
endswitch;
	return $body;
}


?>