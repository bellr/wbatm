<?php
################################################################################
#                                                                              #
# Webmoney XML Interfaces by DKameleon (http://dkameleon.com)                  #
#                                                                              #
# Updates and new versions: http://my-tools.net/wmxi/                          #
#                                                                              #
# Server requirements:                                                         #
#  - CURL                                                                      #
#  - MBString                                                                  #
#                                                                              #
# History of changes:                                                          #
# 2007.02.14                                                                   #
# - initial release of X1 - X11 interfaces                                     #
# 2007.03.02                                                                   #
# - some technical fixes of X7 interface                                       #
# 2007.04.19                                                                   #
# - enchanced special chars correction                                         #
# 2007.08.26                                                                   #
# - added certificate existance check                                          #
# 2007.12.05                                                                   #
# - added X13 - X16 interfaces                                                 #
# 2009.03.17                                                                   #
# - added wm login authorization check interface (LX1)                         #
# - added wm.exchanger interfaces (EX1 - EX9) (Alex Polushin)                  #
# 2010.04.07                                                                   #
# - added X19 interfaces (dr.Drunk)                                            #
#                                                                              #
################################################################################


# WMXI constants
define("WMXI_URL_CLASSIC_X1", "https://w3s.webmoney.ru/asp/XMLInvoice.asp");
define("WMXI_URL_LITE_X1", "https://w3s.wmtransfer.com/asp/XMLInvoiceCert.asp");

define("WMXI_URL_CLASSIC_X2", "https://w3s.webmoney.ru/asp/XMLTrans.asp");
define("WMXI_URL_LITE_X2", "https://w3s.wmtransfer.com/asp/XMLTransCert.asp");

define("WMXI_URL_CLASSIC_X3", "https://w3s.webmoney.ru/asp/XMLOperations.asp");
define("WMXI_URL_LITE_X3", "https://w3s.wmtransfer.com/asp/XMLOperationsCert.asp");

define("WMXI_URL_CLASSIC_X4", "https://w3s.webmoney.ru/asp/XMLOutInvoices.asp");
define("WMXI_URL_LITE_X4", "https://w3s.webmoney.ru/asp/XMLOutInvoicesCert.asp");

define("WMXI_URL_CLASSIC_X5", "https://w3s.webmoney.ru/asp/XMLFinishProtect.asp");
define("WMXI_URL_LITE_X5", "https://w3s.wmtransfer.com/asp/XMLFinishProtectCert.asp");

define("WMXI_URL_CLASSIC_X6", "https://w3s.webmoney.ru/asp/XMLSendMsg.asp");
define("WMXI_URL_LITE_X6", "https://w3s.wmtransfer.com/asp/XMLSendMsgCert.asp");

define("WMXI_URL_CLASSIC_X7", "https://w3s.webmoney.ru/asp/XMLClassicAuth.asp");
define("WMXI_URL_LITE_X7", "https://w3s.wmtransfer.com/asp/XMLClassicAuthCert.asp");

define("WMXI_URL_CLASSIC_X8", "https://w3s.webmoney.ru/asp/XMLFindWMPurse.asp");
define("WMXI_URL_LITE_X8", "https://w3s.wmtransfer.com/asp/XMLFindWMPurseCert.asp");

define("WMXI_URL_CLASSIC_X9", "https://w3s.webmoney.ru/asp/XMLPurses.asp");
define("WMXI_URL_LITE_X9", "https://w3s.wmtransfer.com/asp/XMLPursesCert.asp");

define("WMXI_URL_CLASSIC_X10", "https://w3s.webmoney.ru/asp/XMLInInvoices.asp");
define("WMXI_URL_LITE_X10", "https://w3s.webmoney.ru/asp/XMLInInvoicesCert.asp");

define("WMXI_URL_CLASSIC_X11", "https://passport.webmoney.ru/asp/XMLGetWMPassport.asp");
define("WMXI_URL_LITE_X11", "https://passport.webmoney.ru/asp/XMLGetWMPassport.asp");

define("WMXI_URL_CLASSIC_X13", "https://w3s.webmoney.ru/asp/XMLRejectProtect.asp");
define("WMXI_URL_LITE_X13", "https://w3s.wmtransfer.com/asp/XMLRejectProtectCert.asp");

define("WMXI_URL_CLASSIC_X14", "https://w3s.webmoney.ru/asp/XMLTransMoneyback.asp");
define("WMXI_URL_LITE_X14", "https://w3s.wmtransfer.com/asp/XMLTransMoneybackCert.asp");

define("WMXI_URL_CLASSIC_X15a", "https://w3s.webmoney.ru/asp/XMLTrustList.asp");
define("WMXI_URL_LITE_X15a", "https://w3s.webmoney.ru/asp/XMLTrustListCert.asp");

define("WMXI_URL_CLASSIC_X15b", "https://w3s.webmoney.ru/asp/XMLTrustList2.asp");
define("WMXI_URL_LITE_X15b", "https://w3s.webmoney.ru/asp/XMLTrustList2Cert.asp");

define("WMXI_URL_CLASSIC_X15c", "https://w3s.webmoney.ru/asp/XMLTrustSave2.asp");
define("WMXI_URL_LITE_X15c", "https://w3s.webmoney.ru/asp/XMLTrustSave2Cert.asp");

define("WMXI_URL_CLASSIC_X16", "https://w3s.webmoney.ru/asp/XMLCreatePurse.asp");
define("WMXI_URL_LITE_X16", "https://w3s.wmtransfer.com/asp/XMLCreatePurseCert.asp");

define("WMXI_URL_CLASSIC_X17a", "https://arbitrage.webmoney.ru/xml/X17_CreateContract.aspx");
define("WMXI_URL_LITE_X17a", "https://arbitrage.webmoney.ru/xml/X17_CreateContract.aspx");

define("WMXI_URL_CLASSIC_X17b", "https://arbitrage.webmoney.ru/xml/X17_GetContractInfo.aspx");
define("WMXI_URL_LITE_X17b", "https://arbitrage.webmoney.ru/xml/X17_GetContractInfo.aspx");

define("WMXI_URL_X18", "https://merchant.webmoney.ru/conf/xml/XMLTransGet.asp");

define("WMXI_URL_LOGIN_AUTHORIZE", "https://login.wmtransfer.com/ws/authorize.xiface");

define("WMXI_URL_CLASSIC_EX1", "https://wm.exchanger.ru/asp/XMLbestRates.asp");
define("WMXI_URL_CLASSIC_EX2", "https://wm.exchanger.ru/asp/XMLWMList.asp");
define("WMXI_URL_CLASSIC_EX3", "https://wm.exchanger.ru/asp/XMLWMList2.asp");
define("WMXI_URL_CLASSIC_EX4", "https://wm.exchanger.ru/asp/XMLWMList3.asp");
define("WMXI_URL_CLASSIC_EX5", "https://wm.exchanger.ru/asp/XMLTransDel.asp");
define("WMXI_URL_CLASSIC_EX6", "https://wm.exchanger.ru/asp/XMLTransIzm.asp");
define("WMXI_URL_CLASSIC_EX7", "https://wm.exchanger.ru/asp/XMLTransUnion.asp");
define("WMXI_URL_CLASSIC_EX8", "https://wm.exchanger.ru/asp/XMLTrustPay.asp");
define("WMXI_URL_CLASSIC_EX9", "https://wm.exchanger.ru/asp/XMLQrFromTrIns.asp");

define("WMXI_URL_LIGHT_EX1", "https://wm.exchanger.ru/asp/XMLbestRates.asp");
define("WMXI_URL_LIGHT_EX2", "https://wm.exchanger.ru/asp/XMLWMList.asp");
define("WMXI_URL_LIGHT_EX3", "https://wm.exchanger.ru/asp/XMLWMList2.asp");
define("WMXI_URL_LIGHT_EX4", "https://wm.exchanger.ru/asp/XMLWMList3.asp");
define("WMXI_URL_LIGHT_EX5", "https://wm.exchanger.ru/asp/XMLTransDel.asp");
define("WMXI_URL_LIGHT_EX6", "https://wm.exchanger.ru/asp/XMLTransIzm.asp");
define("WMXI_URL_LIGHT_EX7", "https://wm.exchanger.ru/asp/XMLTransUnion.asp");
define("WMXI_URL_LIGHT_EX8", "https://wm.exchanger.ru/asp/XMLTrustPay.asp");
define("WMXI_URL_LIGHT_EX9", "https://wm.exchanger.ru/asp/XMLQrFromTrIns.asp");

define("WMXI_URL_CLASSIC_X19", "https://passport.webmoney.ru/XML/XMLCheckUser.aspx");
define("WMXI_URL_LITE_X19", "https://passport.webmoney.ru/XML/XMLCheckUserCert.aspx");

# WMXI class
class WMXI {

	var $classic = true;

	var $wm_cert = "";
	var $encoding = "UTF-8";

	var $kwm = ""; # classic
	var $wmid = ""; # classic
	var $pass = ""; # classic + lite
	var $rsa_key = "";  # lite
	var $rsa_cert = "";  # lite
        var $signer = NULL; # classic


	# constructor
	function WMXI($wm_cert = "", $encoding = "UTF-8") {
		if (($wm_cert != "") && !file_exists($wm_cert)) {
			die("Specified certificate $wm_cert not found.");
		}
		$this->wm_cert = $wm_cert;
		$this->encoding = $encoding;
	}


	# initialize classic
	function Classic($wmid, $pass, $kwm) {
		require_once("wmsigner.php");
		$this->classic = true;
		$this->wmid = $wmid;
		$this->pass = $pass;
		$this->kwm = $kwm;
	}


	# initialize lite
	function Lite($rsa_key, $rsa_cert, $pass) {
		$this->classic = false;
		$this->rsa_key = $rsa_key;
		$this->rsa_cert = $rsa_cert;
		$this->pass = $pass;
	}


	# change string encoding
	function _change_encoding($text, $encoding, $entities = false) {
		$text = $entities ? htmlspecialchars($text, ENT_QUOTES) : $text;
		return mb_convert_encoding($text, $encoding, $this->encoding);
	}


	# generate reqn
	function _reqn() {
		list($usec, $sec) = explode(" ", substr(microtime(), 2));
		return substr($sec.$usec, 0, 15);
	}


	# external sign function
	function _sign($data) {
		$text = $this->_change_encoding($data, "windows-1251");
		if (!$this->signer)
			$this->signer=new WMSigner($this->wmid, $this->pass, $this->kwm);
		return $this->signer->Sign($text);
	}


	# external request structure creator
	function _xml($data, $name = "w3s.request") {
		return $this->__xml(array($name => $data));
	}


	# internal request structure creator
	function __xml($data) {
		$result = "";

		foreach($data as $k => $v) {
			$value = is_array($v) ? "\n".$this->__xml($v) : $this->_change_encoding($v, "HTML-ENTITIES", true);
			$result .= "<$k>$value</$k>\n";
		}

		return $result;
	}


	# request to server
	function _request($url, $xml) {
		$ch = curl_init($url);
		curl_setopt($ch, CURLOPT_HEADER, 0);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
		if ($xml) {
			curl_setopt($ch, CURLOPT_POST, 1);
			curl_setopt($ch, CURLOPT_POSTFIELDS, $xml);
		}
		if ($this->wm_cert != "") {
			curl_setopt($ch, CURLOPT_CAINFO, $this->wm_cert);
		} else {
			curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
		}

		if(!$this->classic){
			curl_setopt($ch, CURLOPT_SSLKEY, $this->rsa_key);
			curl_setopt($ch, CURLOPT_SSLKEYPASSWD , $this->pass);
			curl_setopt($ch, CURLOPT_SSLCERT, $this->rsa_cert);
		};

		$result = curl_exec($ch);
		if(curl_errno($ch) != 0) {
			$result = "";
			$result .= "<errno>".curl_errno($ch)."</errno>\n";
			$result .= "<error>".curl_error($ch)."</error>\n";
		};
		curl_close($ch);
		return $result;
	}


	# interface X1
	function X1($orderid, $customerwmid, $storepurse, $amount, $desc, $address, $period, $expiration) {
		$data["reqn"] = $this->_reqn();
		if ($this->classic) { $data["wmid"] = $this->wmid; }
		if ($this->classic) { $data["sign"] = ""; }
		$data["invoice"] = array(
			"orderid" => $orderid,
			"customerwmid" => $customerwmid,
			"storepurse" => $storepurse,
			"amount" => $amount,
			"desc" => $desc,
			"address" => $address,
			"period" => $period,
			"expiration" => $expiration,
		);

		if ($this->classic) {
			$data["sign"] = $this->_sign(implode("", array_values($data["invoice"])).$data["reqn"]);
		}

		$xml = $this->_xml($data);
		$url = $this->classic ? WMXI_URL_CLASSIC_X1 : WMXI_URL_LITE_X1;
		$result = $this->_request($url, $xml);
		return $result;
	}


	# interface X2
	function X2($tranid, $pursesrc, $pursedest, $amount, $period, $pcode, $desc, $wminvid) {
		$data["reqn"] = $this->_reqn();
		if ($this->classic) { $data["wmid"] = $this->wmid; }
		if ($this->classic) { $data["sign"] = ""; }
		$data["trans"] = array(
			"tranid" => $tranid,
			"pursesrc" => $pursesrc,
			"pursedest" => $pursedest,
			"amount" => $amount,
			"period" => $period,
			"pcode" => $pcode,
			"desc" => $desc,
			"wminvid" => $wminvid,
		);

		if ($this->classic) {
			$data["sign"] = $this->_sign($data["reqn"].implode("", array_values($data["trans"])));
		}

		$xml = $this->_xml($data);
		$url = $this->classic ? WMXI_URL_CLASSIC_X2 : WMXI_URL_LITE_X2;
		$result = $this->_request($url, $xml);
		return $result;
	}


	# interface X3
	function X3($purse, $wmtranid, $tranid, $wminvid, $orderid, $datestart, $datefinish) {
		$data["reqn"] = $this->_reqn();
		if ($this->classic) { $data["wmid"] = $this->wmid; }
		if ($this->classic) { $data["sign"] = ""; }
		$data["getoperations"] = array(
			"purse" => $purse,
			"wmtranid" => $wmtranid,
			"tranid" => $tranid,
			"wminvid" => $wminvid,
			"orderid" => $orderid,
			"datestart" => $datestart,
			"datefinish" => $datefinish,
		);

		if ($this->classic) {
			$data["sign"] = $this->_sign($data["getoperations"]["purse"].$data["reqn"]);
		}

		$xml = $this->_xml($data);
		$url = $this->classic ? WMXI_URL_CLASSIC_X3 : WMXI_URL_LITE_X3;
		$result = $this->_request($url, $xml);
		return $result;
	}


	# interface X4
	function X4($purse, $wminvid, $orderid, $datestart, $datefinish) {
		$data["reqn"] = $this->_reqn();
		if ($this->classic) { $data["wmid"] = $this->wmid; }
		if ($this->classic) { $data["sign"] = ""; }
		$data["getoutinvoices"] = array(
			"purse" => $purse,
			"wminvid" => $wminvid,
			"orderid" => $orderid,
			"datestart" => $datestart,
			"datefinish" => $datefinish,
		);

		if ($this->classic) {
			$data["sign"] = $this->_sign($data["getoutinvoices"]["purse"].$data["reqn"]);
		}

		$xml = $this->_xml($data);
		$url = $this->classic ? WMXI_URL_CLASSIC_X4 : WMXI_URL_LITE_X4;
		$result = $this->_request($url, $xml);
		return $result;
	}


	# interface X5
	function X5($wmtranid, $pcode) {
		$data["reqn"] = $this->_reqn();
		if ($this->classic) { $data["wmid"] = $this->wmid; }
		if ($this->classic) { $data["sign"] = ""; }
		$data["finishprotect"] = array(
			"wmtranid" => $wmtranid,
			"pcode" => $pcode,
		);

		if ($this->classic) {
			$data["sign"] = $this->_sign(implode("", array_values($data["finishprotect"])).$data["reqn"]);
		}

		$xml = $this->_xml($data);
		$url = $this->classic ? WMXI_URL_CLASSIC_X5 : WMXI_URL_LITE_X5;
		$result = $this->_request($url, $xml);
		return $result;
	}


	# interface X6
	function X6($receiverwmid, $msgsubj, $msgtext) {
		$data["reqn"] = $this->_reqn();
		if ($this->classic) { $data["wmid"] = $this->wmid; }
		if ($this->classic) { $data["sign"] = ""; }
		$data["message"] = array(
			"receiverwmid" => $receiverwmid,
			"msgsubj" => $msgsubj,
			"msgtext" => $msgtext,
		);

		if ($this->classic) {
			$data["sign"] = $this->_sign($data["message"]["receiverwmid"].$data["reqn"].$data["message"]["msgtext"].$data["message"]["msgsubj"]);
		}

		$xml = $this->_xml($data);
		$url = $this->classic ? WMXI_URL_CLASSIC_X6 : WMXI_URL_LITE_X6;
		$result = $this->_request($url, $xml);
		return $result;
	}


	# interface X7
	function X7($wmid, $plan, $sign) {
		if ($this->classic) { $data["wmid"] = $this->wmid; }
		if ($this->classic) { $data["sign"] = ""; }
		$data["testsign"] = array(
			"wmid" => $wmid,
			"plan" => $plan,
			"sign" => $sign,
		);

		if ($this->classic) {
			$data["sign"] = $this->_sign($data["wmid"].implode("", array_values($data["testsign"])));
		}

#		$data["testsign"]["plan"] = "<![CDATA[".$data["testsign"]["plan"]."]]>";

		$xml = $this->_xml($data);
		$url = $this->classic ? WMXI_URL_CLASSIC_X7 : WMXI_URL_LITE_X7;
		$result = $this->_request($url, $xml);
		return $result;
	}


	# interface X8
	function X8($wmid, $purse) {
		$data["reqn"] = $this->_reqn();
		if ($this->classic) { $data["wmid"] = $this->wmid; }
		if ($this->classic) { $data["sign"] = ""; }
		$data["testwmpurse"] = array(
			"wmid" => $wmid,
			"purse" => $purse,
		);

		if ($this->classic) {
			$data["sign"] = $this->_sign(implode("", array_values($data["testwmpurse"])));
		}

		$xml = $this->_xml($data);
		$url = $this->classic ? WMXI_URL_CLASSIC_X8 : WMXI_URL_LITE_X8;
		$result = $this->_request($url, $xml);
		return $result;
	}


	# interface X9
	function X9($wmid) {
		$data["reqn"] = $this->_reqn();
		if ($this->classic) { $data["wmid"] = $this->wmid; }
		if ($this->classic) { $data["sign"] = ""; }
		$data["getpurses"] = array(
			"wmid" => $wmid,
		);

		if ($this->classic) {
			$data["sign"] = $this->_sign(implode("", array_values($data["getpurses"])).$data["reqn"]);
		}

		$xml = $this->_xml($data);
		$url = $this->classic ? WMXI_URL_CLASSIC_X9 : WMXI_URL_LITE_X9;
		$result = $this->_request($url, $xml);
		return $result;
	}


	# interface X10
	function X10($wmid, $wminvid, $datestart, $datefinish) {
		$data["reqn"] = $this->_reqn();
		if ($this->classic) { $data["wmid"] = $this->wmid; }
		if ($this->classic) { $data["sign"] = ""; }
		$data["getininvoices"] = array(
			"wmid" => $wmid,
			"wminvid" => $wminvid,
			"datestart" => $datestart,
			"datefinish" => $datefinish,
		);

		if ($this->classic) {
			$data["sign"] = $this->_sign(implode("", array_values($data["getininvoices"])).$data["reqn"]);
		}

		$xml = $this->_xml($data);
		$url = $this->classic ? WMXI_URL_CLASSIC_X10 : WMXI_URL_LITE_X10;
		$result = $this->_request($url, $xml);
		return $result;
	}


	# interface X11
	function X11($passportwmid, $dict, $info, $mode) {

		# 2008.09.17 change made due bug report:
		# https://forum.webmoney.ru/Default.aspx?g=posts&m=66321#66321

		if ($this->classic) { $data["wmid"] = $this->wmid; } else { $data["wmid"] = ""; }
		$data["passportwmid"] = $passportwmid;
		/*if ($this->classic) {*/ $data["sign"] = ""; /*}*/
		$data["params"] = array(
			"dict" => $dict,
			"info" => $info,
			"mode" => $mode,
		);

		if ($this->classic) {
			$data["sign"] = $this->_sign($data["wmid"].$data["passportwmid"]);
		}

		$xml = $this->_xml($data, "request");
		$url = $this->classic ? WMXI_URL_CLASSIC_X11 : WMXI_URL_LITE_X11;
		$result = $this->_request($url, $xml);
		return $result;
	}


	# interface X13
	function X13($wmtranid) {
		$data["reqn"] = $this->_reqn();
		if ($this->classic) { $data["wmid"] = $this->wmid; }
		if ($this->classic) { $data["sign"] = ""; }
		$data["rejectprotect"] = array(
			"wmtranid" => $wmtranid,
		);

		if ($this->classic) {
			$data["sign"] = $this->_sign($data["rejectprotect"]["wmtranid"].$data["reqn"]);
		}

		$xml = $this->_xml($data);
		$url = $this->classic ? WMXI_URL_CLASSIC_X13 : WMXI_URL_LITE_X13;
		$result = $this->_request($url, $xml);
		return $result;
	}


	# interface X14
	function X14($inwmtranid, $amount) {
		$data["reqn"] = $this->_reqn();
		if ($this->classic) { $data["wmid"] = $this->wmid; }
		if ($this->classic) { $data["sign"] = ""; }
		$data["trans"] = array(
			"inwmtranid" => $inwmtranid,
			"amount" => $amount,
		);

		if ($this->classic) {
			$data["sign"] = $this->_sign($data["reqn"].implode("", array_values($data["trans"])));
		}

		$xml = $this->_xml($data);
		$url = $this->classic ? WMXI_URL_CLASSIC_X14 : WMXI_URL_LITE_X14;
		$result = $this->_request($url, $xml);
		return $result;
	}


	# interface X15a
	function X15a($wmid) {
		$data["reqn"] = $this->_reqn();
		if ($this->classic) { $data["wmid"] = $this->wmid; }
		if ($this->classic) { $data["sign"] = ""; }
		$data["gettrustlist"] = array(
			"wmid" => $wmid,
		);

		if ($this->classic) {
			$data["sign"] = $this->_sign(implode("", array_values($data["gettrustlist"])).$data["reqn"]);
		}

		$xml = $this->_xml($data);
		$url = $this->classic ? WMXI_URL_CLASSIC_X15a : WMXI_URL_LITE_X15a;
		$result = $this->_request($url, $xml);
		return $result;
	}


	# interface X15b
	function X15b($wmid) {
		$data["reqn"] = $this->_reqn();
		if ($this->classic) { $data["wmid"] = $this->wmid; }
		if ($this->classic) { $data["sign"] = ""; }
		$data["gettrustlist"] = array(
			"wmid" => $wmid,
		);

		if ($this->classic) {
			$data["sign"] = $this->_sign(implode("", array_values($data["gettrustlist"])).$data["reqn"]);
		}

		$xml = $this->_xml($data);
		$url = $this->classic ? WMXI_URL_CLASSIC_X15b : WMXI_URL_LITE_X15b;
		$result = $this->_request($url, $xml);
		return $result;
	}


	# interface X15c
	function X15c($masterwmid, $slavewmid, $purse, $ainv, $atrans, $apurse, $atranshist, $limit, $daylimit, $weeklimit, $monthlimit) {
		$data["reqn"] = $this->_reqn();
		if ($this->classic) { $data["wmid"] = $this->wmid; }
		if ($this->classic) { $data["sign"] = ""; }
		$data["trust"] = array(
			"masterwmid" => $masterwmid,
			"slavewmid" => $slavewmid,
			"purse" => $purse,
			"limit" => $limit,
			"daylimit" => $daylimit,
			"weeklimit" => $weeklimit,
			"monthlimit" => $monthlimit,
		);

		if ($this->classic) {
			$data["sign"] = $this->_sign($data["wmid"].$data["trust"]["purse"].$data["trust"]["masterwmid"].$data["reqn"]);
		}

		$xml = $this->_xml($data);
		$attr = '<trust inv="'
				.($ainv ? "1" : "0").'" trans="'
				.($atrans ? "1" : "0").'" purse="'
				.($apurse ? "1" : "0").'" transhist="'
				.($atranshist ? "1" : "0").'">';

		$xml = str_replace("<trust>", $attr, $xml);
		$url = $this->classic ? WMXI_URL_CLASSIC_X15c : WMXI_URL_LITE_X15c;
		$result = $this->_request($url, $xml);
		return $result;
	}


	# interface X16
	function X16($wmid, $pursetype, $desc) {
		$data["reqn"] = $this->_reqn();
		if ($this->classic) { $data["wmid"] = $this->wmid; }
		if ($this->classic) { $data["sign"] = ""; }
		$data["createpurse"] = array(
			"wmid" => $wmid,
			"pursetype" => $pursetype,
			"desc" => $desc,
		);

		if ($this->classic) {
			$data["sign"] = $this->_sign($data["createpurse"]["wmid"].$data["createpurse"]["pursetype"].$data["reqn"]);
		}

		$xml = $this->_xml($data);
		$url = $this->classic ? WMXI_URL_CLASSIC_X16 : WMXI_URL_LITE_X16;
		$result = $this->_request($url, $xml);
		return $result;
	}

	# interface X17a
	function X17a($name, $ctype, $text, $accesswmid) {

		if ($this->classic) { $data["sign_wmid"] = $this->wmid; }

		$data["name"] = $name;
		$data["ctype"] = $ctype;
		$data["text"] = $text;

		if ($this->classic) {
			$data["sign"] = $this->_sign($data["sign_wmid"].strlen($data["name"]).$data["ctype"]);
		}

		$data["accesslist"] = array("wmid" => $accesswmid);

		$xml = $this->_xml($data,"contract.request");
		$url = $this->classic ? WMXI_URL_CLASSIC_X17a : WMXI_URL_LITE_X17a;

		$result = $this->_request($url, $xml);
		return $result;
	}

	# interface X17b
	function X17b($contractid) {
		if ($this->classic) { $data["wmid"] = $this->wmid; }
		$data["contractid"] = $contractid;
		$data["mode"] = "acceptdate";

		if ($this->classic) {
			$data["sign"] = $this->_sign($data["contractid"].$data["mode"]);
		}

		$xml = $this->_xml($data,"contract.request");
		$url = $this->classic ? WMXI_URL_CLASSIC_X17b : WMXI_URL_LITE_X17b;
		$result = $this->_request($url, $xml);
		return $result;
	}

	# interface X18
	function X18($wmid, $purse, $payment_no, $secret_key = '') {
		$data["wmid"] = $wmid;
		$data["lmi_payee_purse"] = $purse;
		$data["lmi_payment_no"] = $payment_no;
		if ($secret_key) {
			$data["md5"] = strtoupper(md5($wmid . $purse . $payment_no . $secret_key));
		} else
		if ($this->classic) {
			$data["sign"] = $this->_sign($wmid . $purse . $payment_no);
		}

		$xml = $this->_xml($data,'merchant.request');
		$url = WMXI_URL_X18;
		$result = $this->_request($url, $xml);
		return $result;
	}

	# wm.exchanger x1
	function EX1() {
	        $result = $this->_request(WMXI_URL_CLASSIC_EX1,'');
		return $result;
	}

	# wm.exchanger x2
	function EX2($exchtype) {
	        $result = $this->_request(WMXI_URL_CLASSIC_EX2.'?exchtype='.$exchtype ,'');
		return $result;
	}

	# wm.exchanger x3
	function EX3($type,$queryid = -1) {
		if ($this->classic) {
			$data["wmid"] = $this->wmid;
			$data["signstr"] = $this->_sign($this->wmid.$type.$queryid);
		}
		$data["type"] = $type;
		$data["queryid"] = $queryid;
		$xml = $this->_xml($data,"wm.exchanger.request");

		$result = $this->_request($this->classic ? WMXI_URL_CLASSIC_EX3 : WMXI_URL_LIGHT_EX3, $xml);
		return $result;
	}

	# wm.exchanger x4
	function EX4($queryid = -1) {
		if ($this->classic) {
			$data["wmid"] = $this->wmid;
			$data["signstr"] = $this->_sign($this->wmid.'1'.$queryid);
		}
		$data["type"] = '1';
		$data["queryid"] = $queryid;
		$xml = $this->_xml($data,"wm.exchanger.request");
		$result = $this->_request($this->classic ? WMXI_URL_CLASSIC_EX4 : WMXI_URL_LIGHT_EX4, $xml);
		return $result;
	}

	# wm.exchanger x5
	function EX5($operid) {
		if ($this->classic) {
			$data["wmid"] = $this->wmid;
			$data["signstr"] = $this->_sign($this->wmid.$operid);
		}
		$data["operid"] = $operid;
		$xml = $this->_xml($data,"wm.exchanger.request");
		$result = $this->_request($this->classic ? WMXI_URL_CLASSIC_EX5 : WMXI_URL_LIGHT_EX5, $xml);
		return $result;
	}

	# wm.exchanger x6
	function EX6($operid,$cursamount,$curstype) {
		# round cursamount to 4 digits and replace '.' with ','
		$cursamount = strtr($cursamount,',','.');
		$cursamount = round($cursamount,4);
		$cursamount = strtr($cursamount,'.',',');
		if ($this->classic) {
			$data["wmid"] = $this->wmid;
			$data["signstr"] = $this->_sign($this->wmid.$operid.$curstype.$cursamount);
		}
		$data["operid"] = $operid;
		$data["curstype"] = $curstype;
		$data["cursamount"] = $cursamount;
		$xml = $this->_xml($data,"wm.exchanger.request");
		$result = $this->_request($this->classic ? WMXI_URL_CLASSIC_EX6 : WMXI_URL_LIGHT_EX6, $xml);
		return $result;
	}

	# wm.exchanger x7
	function EX7($operid,$unionoperid) {
		if ($this->classic) {
			$data["wmid"] = $this->wmid;
			$data["signstr"] = $this->_sign($this->wmid.$operid.$unionoperid);
		}
		$data["operid"] = $operid;
		$data["unionoperid"] = $unionoperid;
		$xml = $this->_xml($data,"wm.exchanger.request");
		$result = $this->_request($this->classic ? WMXI_URL_CLASSIC_EX7 : WMXI_URL_LIGHT_EX7, $xml);
		return $result;
	}

	# wm.exchanger x8
	function EX8($inpurse,$outpurse,$inamount,$outamount) {
		if ($this->classic) {
			$data["wmid"] = $this->wmid;
			$data["signstr"] = $this->_sign($this->wmid.$inpurse.$outpurse.$inamount.$outamount);
		}
		$data["inpurse"] = $inpurse;
		$data["outpurse"] = $outpurse;
		$data["inamount"] = $inamount;
		$data["outamount"] = $outamount;
		$xml = $this->_xml($data,"wm.exchanger.request");
		$result = $this->_request($this->classic ? WMXI_URL_CLASSIC_EX8 : WMXI_URL_LIGHT_EX8, $xml);
		return $result;
	}

	# wm.exchanger x9
	function EX9($isxtrid,$desttrid,$deststamp = 1001) {
		if (!$this->classic) {
			$data["wmid"] = $this->wmid;
			$data["signstr"] = $this->_sign($this->wmid.$isxtrid.$desttrid);
		}
		$data["isxtrid"] = $isxtrid;
		$data["desttrid"] = $desttrid;
		$data["deststamp"] = $deststamp;
		$xml = $this->_xml($data,"wm.exchanger.request");
		$result = $this->_request($this->classic ? WMXI_URL_CLASSIC_EX9 : WMXI_URL_LIGHT_EX9, $xml);
		return $result;
	}

	# check wmlogin authorize
	function LX1($siteHolder_WMID, $WmLogin_WMID, $WmLogin_Ticket, $WmLogin_UrlID, $WmLogin_AuthType, $WmLogin_UserAddress) {
		$data=array('siteHolder' => $siteHolder_WMID,
        	    	'user' => $WmLogin_WMID,
            		'ticket' => $WmLogin_Ticket,
	            	'urlId' => $WmLogin_UrlID,
        	    	'authType' => $WmLogin_AuthType,
            		'userAddress' => $WmLogin_UserAddress);
        	$xml=$this->_xml($data,'request');
	        $result = $this->_request(WMXI_URL_LOGIN_AUTHORIZE,$xml);
		return $result;
	}

	# interface X19
	function X19($type, $pursetype, $amount, $UserWmid, $pnomer, $fname, $iname, $bank_name, $bank_account, $card_number, $emoney_name, $emoney_id)
	{
		$data["reqn"] = $this->_reqn();
		if ($this->classic) { $data["signerwmid"] = $this->wmid; }
		if ($this->classic) { $data["sign"] = ""; }
		$data["operation"] = array(
			"type" 		=> $type,
			"pursetype" => $pursetype,
			"amount" 	=> $amount,
		);
		$data["userinfo"] = array(
			"wmid" 		 	=> $UserWmid,
			"pnomer" 	 	=> $pnomer,
			"fname" 		=> $fname,
			"iname" 	 	=> $iname,
			"bank_name"	 	=> $bank_name,
			"bank_account"	=> $bank_account,
			"card_number" 	=> $card_number,
			"emoney_name" 	=> $emoney_name,
			"emoney_id" 	=> $emoney_id,
		);

		//print_r($data);


		if ($this->classic) {
			$data["sign"] = $this->_sign($data["reqn"].$data["operation"]["type"].$data["userinfo"]["wmid"]);
		}

		$xml = $this->_xml($data,"passport.request");
		$url = $this->classic ? WMXI_URL_CLASSIC_X19 : WMXI_URL_LITE_X19;
		$result = $this->_request($url, $xml, 1);
		return $result;
	}

}
# WMXI class

?>