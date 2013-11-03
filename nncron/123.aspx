<?

include("../const.inc.aspx");
include("liqpay.aspx");

$class_LiqPAY = new LiqPAY();
//echo $answer = $class_LiqPAY->API_LiqPAY($did,'1',$card,$amount,$currency);
echo $answer = $class_LiqPAY->API_LiqPAY('1234567890','2','4809490034567733','10','USD','card');

//print_r($answer);
//$$class_LiqPAY->parser_answer_API_LiqPAY($answer);

		$fd = fopen("123.log","w");
		fputs($fd, $answer."<br />_______________________________________________________-");
                fflush($fd);
		fclose($fd);
?>
