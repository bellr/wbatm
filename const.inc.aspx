<?php
define('PROJECT','ATM');
define('PROJECT_ROOT',dirname(__FILE__));
define('VS_DEBUG',true);
require_once(dirname(PROJECT_ROOT)."/core/vs.php");

Vitalis::RouterAdmin();

											//!!!!!!!!!!!ВНИМАНИЕ!!! ПРОВЕРЬ ПРАВИЛЬНОСТЬ ПУТЕЙ ПРИ ЗАКАЧКЕ НА СЕРВЕР!!!!!!!!!!!
//$home_dir = "Z:/home/wm-rb.net/www/";
$home_dir = Config::$base['HOME']['ROOT']."/";

//$atm_dir = "Z:/home/wm-rb.net/atm/";
$atm_dir = Config::$base[PROJECT]['ROOT']."/";

											//!!!!!!!!!!!ВНИМАНИЕ!!! ПРОВЕРЬ ПРАВИЛЬНОСТЬ ПУТЕЙ ПРИ ЗАКАЧКЕ НА СЕРВЕР!!!!!!!!!!!
$support = "support@wm-rb.net";
$icq = "562-718-741";
$date_pay = date("Y-m-d");
$time_pay = date("H:i:s");
$year = date("Y");
//комиссии платежных систем
$WMZ = "0.008";
$WMR = "0.008";
$WME = "0.008";
$WMG = "0.008";
$WMY = "0.008";
$WMU = "0.008";
$WMB = "0.008";
$EasyPay = "0.02";
$refresh = 600; //время обновления страниц
$mass_day = array("01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31");
$mass_mount = array("(01) Январь","(02) Февраль","(03) Март","(04) Апрель","(05) Май","(06) Июнь","(07) Июль","(08) Август","(09) Сентябрь","(10) Октябрь","(11) Ноябрь","(12) Декабрь",);
$PP = Extension::Payments()->getParam('payments','easypay');
$limitday = $PP->limits['EP_day'];
$limitmouth = $PP->limits['EP_mouth'];


?>
