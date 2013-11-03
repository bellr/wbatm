<?php

	# ��������� �����
	define("DOC_ENCODING", "windows-1251");

	# ���������� ����������, ���������� �� ����������
	# �������� �� ������ � ���� �������
	include("wmxi.php");

	# ������ ������ ������ WMXI. ������������ ���������:
	# - ���� � �����������, ������������� ��� ������ �� ����� � �������� ���
	# - ���������, ������������ �� �����. �� ��������� ������������ UTF-8
	$wmxi = new WMXI(realpath("WebMoneyCA.crt"), DOC_ENCODING);

	# ������������� � ������� ��������� ����� ������
	# �� Webmoney Keeper Classic. ������������ ���������:
	# - WMID - ������������� ������������
	# - ������ ������������ �� ��������� ����� ����� ������
	# - ���� � ��������� ����� ����� ������ �������� 164 �����
	#   ��� �������� ���������� ����� �����
	#$wmxi->Classic("425196311120", "DsT607", "/home/wmrb/data/datawm/425196311120.kwm");
	#$kwm = file_get_contents("/home/data/wmrb/datamw/409306109446.kwm");
	#$wmxi->Classic("409306109446", "Dst628", $kwm);

	# ������������� � ������� �����������
	# �� Webmoney Keeper Lite. ������������ ���������:
	# - ���� � ����� ���������� �����
	# - ���� � ����� �����������
	# - ������ �� ���������� �����
	$wmxi->Lite("/home/wmrb/data/datawm/156413310416.key", "/home/wmrb/data/datawm/156413310416.cer", "156413310416");

?>