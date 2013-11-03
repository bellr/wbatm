<?php
require("customsql.inc.aspx");
include("usercheck.aspx");

?>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<title>Админка</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="style/style.css" type="text/css">
<meta content="none" name="ROBOTS">
</head>
<frameset cols="180,*" frameborder="NO" rows="*">
  <frame name="leftFrame" scrolling="NO" noresize src="menu.aspx">
  <frame name="mainFrame" scrolling="yes" src="admin_index.aspx">
</frameset>
<noframes>
<body bgcolor="#FFFFFF" text="#000000">
</body>
</noframes>
</html>
