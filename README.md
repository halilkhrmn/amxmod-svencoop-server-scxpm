# EN: AMX Mod X + Metamod with SCXPM Plugin
I wanted to install svencoop on my server. I have done amxmod, metamod and other setups, but it is very difficult to find scxpm and find the scxpm plugin, so i am collectively putting all these files here. Maybe it might work for you.

Setup:
Put the files in the main directory of svencoop ex: svencoop/addons.
and add these codes as parameters when starting the server (-dll addons / metamod / dlls / metamod.so + localinfo mm_gamedll dlls / server.so).
Ex: "-game svencoop -strictportbind +ip xxx.xx.xx.xx -port 27015 +clientport xxx +map falanmap +maxplayers 18 -dll addons/metamod/dlls/metamod.so +localinfo mm_gamedll dlls/server.so"

# TR: AMX Mod X + Metamod ve SCXPM Eklentisi
Sunucuma svencoop kurulumu yapmak istiyordum. Amxmod,metamod ve diğer kurulumları yaptım ancak scxpm kurulumu yapabilmek ve scxpm eklentisini bulmak bir hayli zor oyüzden tüm bu dosyaları derli ve toplu bir şekilde buraya atıyorum. Belki işinize yarayabilir.

Kurulum:
Dosyaları svencoop ana dizinine atın örn:svencoop/addons.
ve sunucuyu başlatırken parametre olarak metamodun parametlerine ekleyin (-dll addons/metamod/dlls/metamod.so +localinfo mm_gamedll dlls/server.so).
Örn : -game svencoop -strictportbind +ip xxx.xx.xx.xx -port 27015 +clientport xxx +map falanmap  +maxplayers 18 -dll addons/metamod/dlls/metamod.so +localinfo mm_gamedll dlls/server.so"

