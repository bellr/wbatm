<?php
	header("Content-Type: text/plain;");

	# defining global constants
	define("PASSED", "passed [+]");
	define("FAILED", "failed [-]");


	# testing requred classes
	$ci = function_exists("curl_init");
	print("> CURL: ".($ci ? PASSED : FAILED).".\n");

	$mb = function_exists("mb_convert_encoding");
	print("> MBString: ".($mb ? PASSED : FAILED).".\n");

	$xp = function_exists("xml_parse");
	print("> XML support: ".($xp ? PASSED : FAILED).".\n");


	# testing huge math existance
	print("> Looking for available huge math implementations:\n");

	$bc = function_exists("bcmod");
	print("  ".($bc ? "+" : "-")." BCMath\n");

	$gmp = function_exists("gmp_powm");
	print("  ".($gmp ? "+" : "-")." GMP\n");

	print("  Huge math summary: ".($bc || $gmp ? PASSED : FAILED).".\n");


	# testing md4 existance
	print("> Looking for available MD4 implementations:\n");

	if (file_exists("md4.php")) {
		include_once("md4.php");
		if (class_exists("MD4")) { $md = new MD4(); }
	}

	$mda = function_exists("mhash");
	print("  ".($mda ? "+" : "-")." MHash\n");

	$mdb = function_exists("hash");
	print("  ".($mdb ? "+" : "-")." Hash\n");

	$mdc = isset($md) && $md->SelfTest();
	print("  ".($mdc ? "+" : "-")." MD4 Class\n");

	print("  MD4 summary: ".($mda || $mdb || $mdc ? PASSED : FAILED).".\n");


	# summary
	print("--------------------------------------------\n");
	print("Overall: ".($ci && ($bc || $gmp) && $mb && $xp && ($mda || $mdb || $mdc) ? PASSED : FAILED).".\n");



?>