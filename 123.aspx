<?
 
 abstract class AbstractClass {
    // Данный метод должен быть определён в дочернем классе 
    abstract protected function getValue();
    // Общий метод 
    public function printt() {
        echo $this->getValue();
     }
}

class ConcreteClass1 extends AbstractClass {
    protected function getValue() {
        return "ConcreteClass1";
     }
}

class ConcreteClass2 extends AbstractClass {
    protected function getValue() {
        return "ConcreteClass2";
     }
}

$class1 = new ConcreteClass1;
$class1->printt();

$class2 = new ConcreteClass2;
$class2->printt();
 
 
 exit;
class MyException extends Exception {
    public function __construct($message, $errorLevel = 0, $errorFile = '', $errorLine = 0) {
        parent::__construct($message, $errorLevel);
        $this->file = $errorFile;
        $this->line = $errorLine;
      //  d($this);
        echo $this->file;
    }
}


function exception_error_handler($errno, $errstr, $errfile, $errline ) {

	echo $errstr;
  //throw new ErrorException($errstr, $errno, 0, $errfile, $errline);
}
set_error_handler("exception_error_handler");

/* вызываем ошибку */
echo 1/0;




exit;
define('PROJECT','ATM');
define('VS_DEBUG',true);
require_once(dirname($_SERVER['DOCUMENT_ROOT'])."/core/vs.php");

vsLog::add('dasddasd');

exit;
function inverse($x) {
    return 1/$x;

}
d(malloc());
try {
    inverse(0);
   // $o = new TestException(TestException::THROW_CUSTOM);
} catch (MyException $e) {      // Will be caught
   // echo "Поймано собственное переопределенное исключение\n", $e;
    //d($e);
    //echo $e->xdebug_message;
    //d($e);
    //$e->customFunction();
} catch (Exception $e) {        // Будет пропущено.
    echo "Поймано встроенное исключение\n", $e;
}
exit;


define('VS_DEBUG',true);


			if(strpos('WMB_WMR', 'WMB') === false) {
				$signer = 'slave_wmid';
			} else {
				$signer = 'exchange_wmb';
			}

echo $signer;


exit;
if(array_key_exists('debug',$_GET)) {
    defined('VS_DEBUG') or define('VS_DEBUG',true);
    error_reporting(E_ALL & ~E_NOTICE & ~E_DEPRECATED);
} else {
    defined('VS_DEBUG') or define('VS_DEBUG',false);
    error_reporting(0);
}

if(VS_DEBUG) {
Echo 'true';
} else {
echo 'false';
}

exit;
/*
define('ROOT',dirname((__FILE__)));

function __autoload($class_name) {
    require_once(dirname(ROOT).'/vs/'.$class_name.'.php');
}

        $mail = Vitalis::mailSender();
        //$mail->reply_to = $user->property->email;
        $mail->from_name = "От кого";
        $mail->to = "atomly@mail.ru";
        $mail->subject = "Тема";
		$mail->charset = "Windows-1251";
        $mail->to_name = "Ту найм";

        $mail->message = "message";
        $mail->smtpmail();

*/
///exit;
require_once("/var/www/wmrb/data/www/wm-rb.net/mailer/smtp-func.aspx");

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

smtpmail('atomly@mail.ru',$subject,$body,$from_name);

echo "fasfdsf";

exit;
//require("customsql.inc.aspx");
					//include($atm_dir."nncron/func_easypay.aspx");
					/*
function test() {
$ch = curl_init('http://wm-rb.net/history_easypay_input.html');
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
$str = curl_exec($ch);
curl_close($ch);
return $str;
}
*/
//$purse = '04910347';
//$summa = '6 002';
//$did = '1270047484';

//echo md5('4U10dIaGV1twQvMZ2fk5wAM8r2dH7VLE')

				//	$class_EasyPay = new EasyPay();

					//$str = $class_EasyPay->pay_usluga('05609781','dUCL6LMc','2464','8702634','100','mts');
					//$str = test();
					//$str = $class_EasyPay->connect_history_easypay('17089238','rdbfD46T','1');
					//$s =  $class_EasyPay->parser_history_sum('2 999','1234567890',$str);
					//print_r($s);
					//echo ereg_replace(' ','',$s);

//echo $str;
//echo base64_decode("0J3QtdC%2F0YDQsNCy0LjQu9GM0L3Ri9C5INC60L7QtCDRgtC%2B0LLQsNGA0LAuINCf0YDQvtCy0LXRgNGM0YLQtSDQutC%2B0LQg0Lgg0LLQstC10LTQuNGC0LUg0LXQs9C%2BICDQtdGJ0LUg0YDQsNC3INC40LvQuCDRgdCy0Y%2FQttC40YLQtdGB0Ywg0YEg0YHQvtGC0YDRg9C00L3QuNC60L7QvCDQvNCw0LPQsNC30LjQvdCwLg%3D%3D");
//echo $_POST[login];
include('/home/wmrb/data/www/atm.wm-rb.net/nncron/func_easypay.aspx');
$class_EasyPay = new EasyPay();
echo $str_result = $class_EasyPay->connect_history_easypay('14305736','256LqzSJ','4')
?>