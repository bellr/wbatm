<?
//include('../const.inc.aspx');
//require("dbsql.inc.aspx");
Class ProtectSQL extends DBSQL {
   // the constructor
   function ProtectSQL($DBName = "") {$this->DBSQL($DBName);}
   function addInfoUser($addr_remote,$proxy,$headers,$host,$url,$time) {
$sql = "insert into protect_ip (addr_remote,proxy,headers,host,url,time) values ('$addr_remote','$proxy','$headers','$host','$url','$time')";
$this->insert($sql);
   }
   function checkUser($addr_remote,$proxy,$host,$time) {
      $sql = "select id from protect_ip where addr_remote='$addr_remote' and proxy='$proxy' and host='$host' and (time>'$time' or time='$time' or time='$time-1')";
      $result = $this->select($sql);
      return $result;
   }
	function updateTime($id,$time) {
	$sql = "update protect_ip set time='$time' where id='$id'";
	$this->update($sql);
	}
 function delBlockUser($time) {
      $sql = "delete from protect_ip where time<'$time'";
      $this->insert($sql);
   }
}
function addIP() {
	global $DBName,$_SERVER;
$db = new ProtectSQL($DBName);
$cheack = $db->checkUser($_SERVER['REMOTE_ADDR'],$_SERVER['HTTP_X_FORWARDED_FOR'],$_SERVER['SERVER_NAME'],time());
if(!empty($cheack)) {
	$db->updateTime($cheack[0][id],time()+3600);
	exit("Вы не верно ввели логин или пароль. Данные о неудачной попытки входа отправлены Администрации.");
}
else {$headers = GetAllHeaders(); $s=''; foreach($headers as $key=>$ar) {$str .= "{$key}={$ar}";}
	$db->addInfoUser($_SERVER['REMOTE_ADDR'],$_SERVER['HTTP_X_FORWARDED_FOR'],$str,$_SERVER['SERVER_NAME'],$_SERVER['REQUEST_URI'],time());}
}
function delUser() {
	global $DBName;
$db = new ProtectSQL($DBName);
$db->delBlockUser(time()-3600);
}
?>