<?php
define('VS_DEBUG',true);
define('PROJECT_ROOT',dirname(dirname(__FILE__)));
define('PROJECT','ATM');

require_once(dirname(PROJECT_ROOT)."/core/vs.php");

//update rates in data base exchange service by bank rate
$bank_curency = array('UAH','USD','EUR','RUB');
$ch = curl_init();
curl_setopt($ch, CURLOPT_USERAGENT, "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1)");
curl_setopt($ch, CURLOPT_URL, 'http://nbrb.by/Services/XmlExRates.aspx');
curl_setopt($ch, CURLOPT_HEADER,0);
curl_setopt($ch, CURLOPT_RETURNTRANSFER,1);
curl_setopt($ch, CURLOPT_VERBOSE,0);
$fd = curl_exec($ch);

$xmlres = simplexml_load_string($fd);
$c=0;
if(!empty($xmlres->Currency)) {
    foreach($xmlres->Currency as $k=>$ar) {
        $kurs = $xmlres->Currency[$c]->Rate;
        switch ($xmlres->Currency[$c]->CharCode) {
            case 'UAH':
                dataBase::DBexchange()->query('kurs',"update kurs set konvers={$kurs} + {$kurs} * commission / 100 where indefined in ('WMU - WMB','WMB - WMU') and upd=1 and status=1 and f_exchange=0");
                dataBase::DBexchange()->update('baserate',array('rate'=>$kurs),"where direct in ('WMU - WMB','WMB - WMU')");
                break;
            case 'USD':
                dataBase::DBexchange()->query('kurs',"update kurs set konvers={$kurs} + {$kurs} * commission / 100 where indefined in ('WMZ - WMB','WMB - WMZ') and upd=1 and status=1 and f_exchange=0");
                dataBase::DBexchange()->update('baserate',array('rate'=>$kurs),"where direct in ('WMZ - WMB','WMB - WMZ')");
                break;
            case 'EUR':
                dataBase::DBexchange()->query('kurs',"update kurs set konvers={$kurs} + {$kurs} * commission / 100 where indefined in ('WME - WMB','WMB - WME') and upd=1 and status=1 and f_exchange=0");
                dataBase::DBexchange()->update('baserate',array('rate'=>$kurs),"where direct in ('WME - WMB','WMB - WME')");
                break;
            case 'RUB':
                dataBase::DBexchange()->query('kurs',"update kurs set konvers={$kurs} + {$kurs} * commission / 100 where indefined in ('WMR - WMB','WMB - WMR') and upd=1 and status=1 and f_exchange=0");
                dataBase::DBexchange()->update('baserate',array('rate'=>$kurs),"where direct in ('WMR - WMB','WMB - WMR')");
                break;
        };

        $c++;
    }
}
//update file export rates
$rate = dataBase::DBexchange()->select('kurs','direction,konvers,direct','where status=1');
$bal = dataBase::DBexchange()->select('balance','name,balance');

foreach($bal as $b) { $balance[$b['name']] = $b['balance']; }

$indentification = array('WMZ' => 'WMZ','WMR' => 'WMR','WME' => 'WME','WMB' => 'WMB','WMU' => 'WMU','EasyPay' => 'ESPBYR');

foreach($rate as $key => $r) {

    $path_rate = explode('_',$r['direction']);
    $amountin = $indentification[$path_rate[0]];
    $amountout = $indentification[$path_rate[1]];

    if(empty($amountin) || empty($amountout)) break;

    $rate_json[$key]['from'] = $amountin;
    $rate_json[$key]['to'] = $amountout;

    if($r['direct'] == "n") {

        $text .= "{$amountin} -> {$amountout}: rate={$r['konvers']}, reserve={$balance[$path_rate[1]]}\n";
        $rate_txt .= "{$amountin};{$amountout};{$r['konvers']};1;{$balance[$path_rate[1]]}\n";

        $rate_json[$key]['in'] = (float)$r['konvers'];
        $rate_json[$key]['out'] = 1;

    } else {

        $rates = 1/$r['konvers']+0.00001/100;
        $text .= "{$amountin} -> {$amountout}: rate={$rates}, reserve={$balance[$path_rate[1]]}\n";
        $rate_txt .= "{$amountin};{$amountout};1;{$r['konvers']};{$balance[$path_rate[1]]}\n";

        $rate_json[$key]['in'] = 1;
        $rate_json[$key]['out'] = (float)$r['konvers'];
    }

    $rate_json[$key]['amount'] = (int)$balance[$path_rate[1]];
}

$fd = fopen(Config::$base['HOME']['ROOT']."/out_rates_all.aspx","w+");
fputs($fd, $text);
fflush($fd);
fclose($fd);

$fd = fopen(Config::$base['HOME']['ROOT']."/rate_wmrb_txt.aspx","w+");
fputs($fd, $rate_txt);
fflush($fd);
fclose($fd);

$fd = fopen(Config::$base['HOME']['ROOT']."/rate_wmrb_json.aspx","w+");
fputs($fd, json_encode(array('rates' => $rate_json)));
fflush($fd);
fclose($fd);


exit;

/*
Webmoney USD,WMZ,001

Webmoney RUB,WMR,002

Webmoney EUR,WME,003

Webmoney BYR,WMB,004

Webmoney Gold,WMG,005

Webmoney UAH,WMU,006

Webmoney UZS,WMY,007

Webmoney Credit,WMC,008

E-Gold AU USD,EGAUUSD,010

E-Gold PD USD,EGPDUSD,011

E-Gold PT USD,EGPTUSD,012

E-Gold AG USD,EGAGUSD,013

Yandex.Money RUB,YAMRUB,020

RBKmoney RUB,RBKMRUB,030

RBKmoney USD,RBKMUSD,031

EasyPay,ESP,040

E-Bullion e-Currency,EBCUR,050

E-Bullion Gold,EBG,051

EDram,EDRM,060

Fethard USD,FETUSD,070

AlterGold USD,AGUSD,080

IMoney UAH,IMUAH,090

INOCard RUB,INCRUB,100

Liberty Reserve USD,LRUSD,110

Liberty Reserve EUR,LREUR,111

Liberty Reserve Gold,LRG,112

Emoney.md MDL,EMMDL,120

Mobile Wallet RUB,MWRUB,130

Moneybookers,MBKR,140 Skrill USD, SKLUSD, 140

MoneyMail EUR,MMLEUR,150

MoneyMail RUB,MMLRUB,151

MoneyMail USD,MMLUSD,152

PayPal AUD,PPAUD,160

PayPal CAD,PPCAD,161

PayPal EUR,PPEUR,162

PayPal GBP,PPGBP,163

PayPal USD,PPUSD,164

Pecunix USD,PXUSD,170

UA-Money USD,UAMUSD,180

UkrMoney EUR,UMEUR,190

UkrMoney RUB,UMRUB,191

UkrMoney UAH,UMUAH,192

UkrMoney USD,UMUSD,193

V-Money USD,VMUSD,200

W1 RUB,WORUB,210

W1 USD,WOUSD,211

W1 UAH,WOUAH,212

C-Gold USD,CGUSD,220

C-Gold EUR,CGEUR,221

DeltaKey EUR,DKEUR,230

DeltaKey RUB,DKRUB,231

DeltaKey USD,DKUSD,232

DeltaKey UAH,DKUAH,234

ICQMoney UNI,ICQM,233

Perfect Money USD,PMUSD,240

Perfect Money EUR,PMEUR,241

Perfect Money Gold,PMG,242

AlertPay USD,APUSD,250 Payza USD, PAUSD, 250

Numox USD,NXUSD,260

LiqPay USD,LQUSD,270

LiqPay UAH,LQUAH,271

LiqPay RUB,LQRUB,272

LiqPay EUR,LQEUR,273

Z-Payment RUB,ZPRUB,280

NN-Money USD,NNMUSD,290

Combats EKR,CBEKR,300

Star Trek USD,STUSD,310

Star Trek RUB,STRUB,311

Webcreds USD,WCUSD,320

Webcreds RUB,WCRUB,321

Webcreds EUR,WCEUR,322

Wire USD,WIREUSD,330

Wire EUR,WIREEUR,331

Wire RUB,WIRERUB,332

Wire UAH,WIREUAH,333

Wire KZT,WIREKZT,334

Wire GBP,WIREGBP,335

Card USD,CARDUSD,350

Card EUR,CARDEUR,351

Card RUB,CARDRUB,352

Card UAH,CARDUAH,353

Card KZT,CARDKZT,354

Cash USD,CASHUSD,370

Cash EUR,CASHEUR,371

Cash RUB,CASHRUB,372

Cash UAH,CASHUAH,373

Cash KZT,CASHKZT,374

PayPlat USD,PPTUSD,380

PayPlat RUB,PPTRUB,381

PayPlat EUR,PPTEUR,382

Moneta RUB,MNTRUB,390

Neteller USD,NTLRUSD,400

Telebank RUB,TBRUB,410

Alpha-Click RUB,ACRUB,420

Promsvyazbank RUB,PSBRUB,430

Privat24 USD,P24USD,440

Privat24 UAH,P24UAH,441

Privat24 EUR,P24EUR,442

GlobalDigitalPay USD,GDPUSD, 450

GlobalDigitalPay EUR,GDPEUR, 451

Telemoney RUB, TMRUB, 460

Qiwi RUB, QWRUB, 470

OKPay USD, OKUSD, 480

OKPay RUB, OKRUB, 481

OKPay EUR, OKEUR, 482

Western Union USD, WUUSD, 490

Western Union RUB, WURUB, 491

Moneygram USD, MGUSD, 500

Moneygram EUR, MGEUR, 501

EuroGoldCash USD, EGCUSD, 510

EuroGoldCash EUR, EGCEUR, 511

SberBank RUB, SBERRUB, 520

RusStandard RUB, RUSSTRUB, 530

Avangard RUB, AVBRUB, 540

Raiffeisen RUB, RFBRUB, 550

Trust RUB, TRBRUB, 560

Svyaznoy RUB, SVBRUB, 570

Cash4wm RUB, CWMRUB, 580

EgoPay USD, EPUSD, 590

SolidTrustPay USD, STPUSD, 600

SolidTrustPay EUR, STPEUR, 601

SolidTrustPay RUB, STPRUB, 602

PayWeb USD, PWUSD, 610

Ukash USD, UKUSD, 620

Ukash EUR, UKEUR, 621

Paxum USD, PXMUSD, 630

Redpass USD, RPUSD, 640

Epayments USD, EPMUSD, 650

BitCoin, BTCN, 660

Unionpay, UNP, 670
*/
?>