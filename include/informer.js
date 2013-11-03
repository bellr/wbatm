
var informer_arr=new Array('exch','pay','eshop','cash','cash_out');

function set_informer(n) {
	var _i=null;
	var _selected=0;
	for (i=1;i<=informer_arr.length;i++) {
		if (_i=document.getElementById(informer_arr[i-1])) {
			if (i!=n) _i.style.display='none';
			else {
				_i.style.display='block';
				_selected=i;
			}
		}
	}
	if (!_selected) _selected=1;
	document.cookie="info="+escape(_selected)+"; expires=Sat, 13 Dec 2010 15:58:50 GMT; path=/";
}
