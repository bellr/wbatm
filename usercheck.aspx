<?php

//if($_GET['sk'] != 'atomly') exit;

session_start();
//include($atm_dir."nncron/protection.aspx");

//addIP();
if (!empty($_POST[logincheck])) {
	$db_admin = new CustomSQL_admin($DBName_admin);
	$checkuser = md5($_POST[user]);
	$checkpass = md5($_POST[pass]);
	$sql = "select username from useradmin where username='{$checkuser}' and password='{$checkpass}'";
	$results = $db_admin->select($sql);
	if (empty($results)) {
		//print "Error";
		exit;
		}else{
			$_SESSION['loginuser'] = $checkpass;

	}
}

if($_GET['action'] == 'logout') {

    session_unset();
    header("Location: http://billing87.wm-rb.net/");
    exit;
}

?>
<?php

if (!(isset($_SESSION['loginuser']))) {

    if ($_GET['skot'] != 'datm') exit;

?>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=win-1251">
<meta content="none" name="ROBOTS">
<link rel="stylesheet" href="/style/style.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0">
<form action="<?php print "$PHP_SELF"; ?>" method="POST">
<?
if (count($HTTP_POST_VARS)) {
       while (list($key, $val) = each($HTTP_POST_VARS)) {
       print "<input type=\"hidden\" name=\"$key\" value=\"$val\">\n";
      }
}

if (count($HTTP_GET_VARS)) {
       while (list($key, $val) = each($HTTP_GET_VARS)) {
       print "<input type=\"hidden\" name=\"$key\" value=\"$val\">\n";
      }
}
?>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="center" valign="top">
      <hr width="90%" size="1" noshade>
      <table width="90%" border="0" cellspacing="0" cellpadding="4" height="300">
        <tr>
          <td align="center">
            <p><?php print "$admin_login"; ?></p>
            <table width="300" border="0" cellspacing="1" cellpadding="4" bgcolor="#F2F2F2">
              <tr bgcolor="#FFFFFF">
                <td width="83">Name :</td>
                <td width="198"><input type="text" name="user"></td>
              </tr>
              <tr bgcolor="#FFFFFF">
                <td>Password :</td>
                <td><input type="password" name="pass"><input type="hidden" name="session_id" value="<?php echo session_id(); ?>" readonly></td>
              </tr>
              <tr bgcolor="#FFFFFF">
                <td>&nbsp;</td>
                <td><input type="submit" name="logincheck" value="Input"></td>
              </tr>
            </table>
          </td>
        </tr>
      </table>

    </td>
  </tr>
  <tr>
    <td align="center" valign="top" height="40">&nbsp;</td>
  </tr>
</table>
</form>
</body>
</html>
<?php
exit;
}
?>