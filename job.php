<?php

$startMemory = memory_get_usage(TRUE);
$mtime1 = explode(" ", microtime());
$starttime = $mtime1[1] + $mtime1[0];

set_time_limit(0);
//ini_set('memory_limit','512M');

require_once('header.php');

spl_autoload_register(array('Autoloader','JobManager'));

$optionKeys = inputData::getArgvOptions();
$options = getopt(implode('',$optionKeys['short']), (array)$optionKeys['long']);

$className = $options['j'].'Job';
$methodName = $options['m'];
unset($options['j'], $options['m']);

$reflectionMethod = new ReflectionMethod($className, $methodName);
$reflectionMethod->invokeArgs(new $className(), $options);


$mtime2 = explode(" ", microtime());
$endtime = $mtime2[1] + $mtime2[0];
$totaltime = ($endtime - $starttime);
$totaltime = number_format($totaltime, 7);
$total_memory = (memory_get_usage(TRUE) - $startMemory)  / 1024;

if($totaltime > 1 || $total_memory > 1024) vsLog::add($methodName.'totaltime='.$totaltime.', \n total_memory='.$total_memory.'Kb','totaltimeJob');