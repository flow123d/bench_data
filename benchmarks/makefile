# this makefile will download larges meshed from external source, saving repositry size


bacula=http://bacula.nti.tul.cz/~jan.hybs/benchmarks/
	
all: download



download: 04_kravi_hora/1_212773_el/KH__mesh.msh 04_kravi_hora/1_212773_el/KH__data_okp.msh 04_kravi_hora/1_212773_el/KH__data_vodivost.msh

04_kravi_hora/1_212773_el/KH__data_okp.msh:
	wget $(bacula)/04_kravi_hora/1_212773_el/KH__data_okp.msh      -P 04_kravi_hora/1_212773_el

04_kravi_hora/1_212773_el/KH__data_vodivost.msh:
	wget $(bacula)/04_kravi_hora/1_212773_el/KH__data_vodivost.msh -P 04_kravi_hora/1_212773_el

04_kravi_hora/1_212773_el/KH__mesh.msh:
	wget $(bacula)/04_kravi_hora/1_212773_el/KH__mesh.msh          -P 04_kravi_hora/1_212773_el
