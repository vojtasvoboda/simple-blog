-- phpMyAdmin SQL Dump
-- version 4.3.11.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jun 11, 2015 at 12:02 PM
-- Server version: 5.6.23
-- PHP Version: 5.5.22

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `simpleblog`
--

-- --------------------------------------------------------

--
-- Table structure for table `articles`
--

CREATE TABLE IF NOT EXISTS `articles` (
  `id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `text` text COLLATE utf8_czech_ci NOT NULL,
  `date` datetime NOT NULL,
  `url` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `published` tinyint(1) NOT NULL DEFAULT '0',
  `published_date` datetime NOT NULL,
  `master` tinyint(1) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;

--
-- Dumping data for table `articles`
--

INSERT INTO `articles` (`id`, `name`, `text`, `date`, `url`, `published`, `published_date`, `master`, `created`, `modified`) VALUES
(1, 'About me', 'Im Vojta', '2014-06-07 00:00:00', 'about-me', 1, '2014-06-07 00:00:00', 1, '2014-06-07 00:00:00', '2014-06-07 00:00:00'),
(3, 'Nastavení serveru Apache na MacOS', '<p><a href="http://httpd.apache.org/" target="_blank">Apache</a> je open-source webový/HTTP server, který je distribuovaný zdarma a pomocí kterého můžeme spouštět naše webové stránky a aplikace. Základní instalaci Apache, PHP a MySQL jsem popsal v článku:&nbsp;<a href="http://blog.vojtasvoboda.cz/instalace-php-na-mac-os-x-mountain-lion" target="_blank">Instalace PHP na Mac OS X (Mountain Lion)</a>.</p><p>Tento článek se bude věnovat pokročilé konfiguraci serveru Apache, konkrétně umístení konfiguračních souborů, ovládání serveru přes terminál a nastavení VirtualHosts.</p>\r\n<p></p><hr class="posthaven-more"><p></p>\r\n<h2>Základní ovládání serveru</h2>\r\n<p>Server ovládáme z terminálu pomocí příkazu <i>apachectl</i>. Některé příkazy je potřeba spouštět s root právy (např. <i>sudo apachectl restart</i>). Základní příkazy:</p><code>apachectl -v // vypíše verzi serveru (stejně tak httpd -v)<br>apachectl -V // vypíše verzi včetně nastavení kompilace<br>apachectl -L // seznam dostupných konfiguračních direktiv které pak používáme v konfiguračním souboru<br>apachectl start // spustí server<br>apachectl stop // zastaví server<br>apachectl restart // restart serveru<br>apachectl -D DUMP_VHOSTS // vypíše nastavení virtuální servery<br>apachectl -S // spustí kontrolu syntaxe konfiguračního souboru a vypíše nastavení VirtualHosts</code>\r\n<p>Hlavně přepínače -D a -S se nám budou hodit pro následovnou konfiguraci virtuálních serverů.</p>\r\n<h2>Konfigurační soubory serveru</h2>\r\n<p>Konfigurační soubor serveru zjistíme příkazem:</p><code>apachectl -V | grep SERVER_CONFIG_FILE</code>\r\n<p>Většinou je ale umístěn v souboru:</p><code>/etc/apache2/httpd.conf</code><p>Aby se nám správně směřovali požadavky na lokální server, je dobré také znát soubor:</p><code>/private/etc/hosts</code><p>Kde je potřeba mít nastavené alias pro localhost na lokální adresu:</p><code>127.0.0.1 &nbsp; &nbsp;&nbsp;&nbsp;	localhost<br>255.255.255.255	broadcasthost<br>::1 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; localhost<br>fe80::1%lo0 &nbsp; &nbsp;&nbsp;localhost</code><p>V konfiguračním souboru httpd.conf je kompletní nastavení serveru včetně všech modulů kterým rozšiřujeme funkce serveru např PHP, SSL, MemCache atd.</p>\r\n<h2>Konfigurace VirtualHosts</h2>\r\n<p>Virtuální servery se nám hodí pro oddělený běh naší webové aplikace, tak aby odpovídal co nejvíce produkčnímu prostředí, včetně samostatných nastavení parametrů serveru pro daný projekt. Také nemusíme z URL odstraňovat vnořený adresář /localhost/Nase-stranky/, jako při běhu bez VirtualHosts.&nbsp;VirtualHosts se konfigurují v základním konfiguračním souboru httpd.conf většinou úplně na konci souboru.</p><p>Základem je uvedení direktivy, která koresponduje s řádkem Listen 80 (číslo portu, na kterém server bude poslouchat)</p><code>NameVirtualHost *:80</code><p>Dále pak konfigurujeme konkrétní virtuální servery:</p><code>&lt;VirtualHost *:80&gt;<br>&nbsp; &nbsp; ServerName www.nase-stranky.cz.local<br>&nbsp; &nbsp; DocumentRoot "/Users/VojtaSvoboda/Www/nase-stranky.cz/www/"<br>&nbsp; &nbsp; LimitInternalRecursion 100<br>&nbsp; &nbsp; &lt;directory "/Users/VojtaSvoboda/Www"&gt;<br>&nbsp; &nbsp; &nbsp; &nbsp; AllowOverride all<br>&nbsp; &nbsp; &nbsp; &nbsp; Order Deny,Allow<br>&nbsp; &nbsp; &nbsp; &nbsp; Deny from all<br>&nbsp; &nbsp; &nbsp; &nbsp; Allow from localhost<br>&nbsp; &nbsp; &lt;/directory&gt;<br>&lt;/VirtualHost&gt;</code><p>Pojmenování je pak čistě na vás. Já to mám nastavené tak, že do prohlížeče zadávám adresu www.nase-stranky.cz.local (což koresponduje s produkční adresou www.nase-stranky.cz). Tato lokální adresa pak směřuje přímo do adresáře Www/nase-stranky.cz/www/ na mém disku. Je to vhodné především když máte více verzí projektu - www, beta, dev atd. Stejně tak lze nastavit VirtualHost pro beta.nase-stranky.cz.local směřující do adresáře beta.</p><p>Pro konkrétní VirtualHost pak můžeme i nastavit oddělený error log pomocí příkazů které umístíme hned pod ServerName:</p><code>ErrorLog "/private/var/log/apache2/nase-stranky.local-error_log"<br>CustomLog "/private/var/log/apache2/nase-stranky.local-access_log" common</code><p>V souboru hosts pak musíme nastavit směřování tohoto požadavku na lokální server:</p><code>127.0.0.1 www.nase-stranky.cz.local</code><p>Pokud se nám nechce nastavovat VirtualHosts pro každý projekt a dodržujeme pořád stejnou strukturu, můžeme si nastavit VirtualHost obecně:</p>\r\n<code>&lt;VirtualHost _default_:80&gt;<br>&nbsp; &nbsp; ServerName symfony<br>&nbsp; &nbsp; VirtualDocumentRoot "/Users/VojtaSvoboda/Www/%-3.0.%-2/%-4.0/web"<br>&nbsp; &nbsp; LimitInternalRecursion 20<br>&lt;/VirtualHost&gt;</code><p>Server se pak snaží najít na disku složku dle daného vzoru a pokud najde, tak na daný adresář nasměruje požadavek z prohlížeče.</p><p>Pro http://www.nase-stranky.cz.local/cokoli tak bude hledat adresář /User/VojtaSvoboda/nase-stranky.cz/www/web (s tím, že ‘/web’ je veřejný adresář vašeho projektu - může to být klidně /document_root (pro Nette), /web (pro Symfony), www, nebo nic).</p><p>Pro každou změnu konfiguračního souboru je potřeba restartovat server pomocí</p><code>apachectl restart</code>\r\n<h2>Řešení problémů s konfigurací</h2>\r\n<p>Pokud se něco nedaří, nejdříve se podíváme do souboru httpd.conf na řádek začínající ErrorLog, kde je cesta k chybovému logu:</p><code>/private/var/log/apache2/error_log</code><p>Zde se můžeme podívat na konec souboru a pokusit se odhalit nějakou chybu.</p><p>Dále nám může pomoct příkaz</p><code>apachectl -S</code><p>Který spustí kontrolu syntaxe konfiguračního souboru a rovněž vypíše nastavení VirtualHosts.</p><p>Také je dobré v httpd.conf mrknout na řádky které začínají Include - můžou se nám načítat nějaké externí soubory, které nám třeba aktuální konfigurací rozbíjejí.</p><p>Pokud by mohl být problém ve směrování, je dobré vymazat DNS cache pomocí:</p><code>dscacheutil -flushcache</code>', '2014-06-07 00:00:00', 'nastaveni-serveru-apache-na-macos', 1, '2014-05-07 00:00:00', 1, '2014-05-07 00:00:00', '2014-05-07 00:00:00'),
(4, 'Kompilace Sass a Compass souborů přes Grunt JS', '<p><a href="http://gruntjs.com/" target="_blank">Grunt</a> je nástroj napsaný v <a href="http://nodejs.org/" target="_blank">Node.js</a> a distribuovaný přes <a href="https://www.npmjs.org/" target="_blank">npm</a>. Grunt slouží ke spouštění jedné, nebo více úloh na straně front-endu, počínaje minifikace, kompilace CSS preprocesorů (<a href="http://lesscss.org/" target="_blank">Less</a>, <a href="http://sass-lang.com/" target="_blank">Sass</a>) až po spojování více souborů v jeden. Zároveň dokáže sledovat změny v upravovaných souborech a při každé změně spustit připravené úlohy, což se výborně hodí když potřebujeme průběžně překládat Sass soubory na CSS.</p><hr class="posthaven-more">\r\n<h2>Instalace Node.js a npm</h2>\r\n<p>Jako první potřebujeme mít nainstalovaný Node.js a dále npm což je balíčkovací systém Node.js, přes který se pak dostaneme k nástroji Grunt. Nainstalujeme si Node.js buď stažením PKG balíku ze stránek, nebo ideálně přes <a href="http://brew.sh/" target="_blank">Homebrew</a>:</p><code>brew install node</code><p>Tím se automaticky nainstaluje i npm. Pokud bude brew hlásit nějakou chybu, možná bude potřeba spustit příkaz jako root (<i>sudo brew install node</i>).</p><h2>package.json</h2>\r\n<p>Všechny nástroje distribuované přes Npm lze instalovat buď ručně, nebo si vytvořit soubor <i>package.json</i> v rámci našeho projektu, ze kterého se pak vše pomocí příkazu npm install nainstaluje automaticky včetně všech závislostí. Je to obdoba souboru <i>composer.json</i> pro nástroj <a href="https://getcomposer.org/" target="_blank">Composer</a>.</p><p>Vytvoříme soubor <i>package.json</i> pomocí <i>npm</i>:</p><code>npm init</code><p>Průvodce se nás zeptá na název projektu, verzi, popis a několik dalších parametrů. Nic z toho není prozatím důležité a lze kdykoli změnit přímo ve vygenerovaném <i>package.json</i> souboru. Nyní můžeme přidávat do projektu žádané nástroje.</p>\r\n<h2>Instalace Grunt</h2><p>Nainstalujeme do projektu nástroj Grunt:</p><code>npm install grunt --save-dev</code><p>Parametr save-dev nám upraví soubor <i>package.json</i> a přidá tam řádek s Gruntem, aby se příště nainstaloval již automaticky (obdoba příkazu <i>require</i> pro Composer). Suffix dev znamená, že se Grunt instaluje pouze pro development prostředí (kompilaci Sass souborů na produkci nepotřebujeme). Také si můžeme všimnout, že došlo k vytvoření složky <i>node_modules</i>, kam se Node.js moduly instalují (něco jako složka <i>vendor</i> pro Composer). Tuto složku můžeme klidně smazat a obnovit příkazem npm install. Stejně tak se složka node_modules ani nemusí verzovat.</p><p>Dále potřebujeme ještě nástroj <i><a href="http://gruntjs.com/getting-started#installing-the-cli" target="_blank">grunt-cli</a></i> pro spouštění příkazů v příkazové řádce:</p><code>npm intall grunt-cli --save-dev</code><p>Poznámka: Všechny nástroje lze instalovat také globálně pomocí přepínače <i>-g</i>.</p><h2>Instalace nástrojů pro Sass a Compass</h2>\r\n<p>Jenom v rychlosti doinstalujeme nástroje pro kompilaci Scss souborů s podporou frameworku <a href="http://compass-style.org/" target="_blank">Compass</a>:</p><code>npm install grunt-contrib-sass --save-dev<br>npm install grunt-contrib-compass --save-dev<br>npm install grunt-contrib-watch --save-dev<br>npm install grunt-notify --save-dev</code><p><a href="https://www.npmjs.org/package/watch" target="_blank">Watch</a> je nástroj, který sleduje změny v souborech a dokáže automaticky spustit kompilaci Scss souborů při změně. <a href="https://www.npmjs.org/package/grunt-notify" target="_blank">Grunt notify</a> slouží pro MacOs a dokáže zobrazit Growl informační box, pokud nastane chyba při kompilaci, protože pokud píšeme kód a na druhém monitoru máme prohlížeč s výstupem, ne vždy průběžně kontrolujeme příkazovou řádku, jestli nastala nějaká chyba, nebo ne.</p><h2>Konfigurace Gruntu</h2>\r\n<p>Pomocí <a href="http://gruntjs.com/sample-gruntfile" target="_blank">návodu pro vytvoření základního Gruntfile</a> vytvoříme konfiguraci pro Grunt, která nám říká, které úlohy budou pro daný projekt dostupné.</p><p>Soubor může vypadat například takto:</p><code>module.exports = function (grunt) {<br>&nbsp; &nbsp; var options = {<br>&nbsp; &nbsp; &nbsp; &nbsp; scss: {<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; root: ''scss/''<br>&nbsp; &nbsp; &nbsp; &nbsp; },<br>&nbsp; &nbsp; &nbsp; &nbsp; css: {<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; root: ''css/''<br>&nbsp; &nbsp; &nbsp; &nbsp; }<br>&nbsp; &nbsp; };<br>&nbsp; &nbsp; grunt.initConfig({<br>&nbsp; &nbsp; &nbsp; &nbsp; pkg: grunt.file.readJSON(''package.json''),<br>&nbsp; &nbsp; &nbsp; &nbsp; sass: {<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; dist: {<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; options: {<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; style: ''compressed'',<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; compass: true<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; },<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; files: {<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ''css/style.css'': options.scss.root + ''style.scss''<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>&nbsp; &nbsp; &nbsp; &nbsp; },<br>&nbsp; &nbsp; &nbsp; &nbsp; watch: {<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; views: {<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; files: ''*.html'',<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; options: {<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; livereload: true<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; },<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; sass: {<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; files: ''scss/**/*.scss'',<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; tasks: ''sass'',<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; options: {<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; compass: true,<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; livereload: true<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>&nbsp; &nbsp; &nbsp; &nbsp; }<br>&nbsp; &nbsp; });<br>&nbsp; &nbsp; grunt.loadNpmTasks(''grunt-contrib-watch'');<br>&nbsp; &nbsp; grunt.loadNpmTasks(''grunt-contrib-sass'');<br>&nbsp; &nbsp; grunt.loadNpmTasks(''grunt-contrib-compass'');<br>&nbsp; &nbsp; grunt.registerTask(''default'', [''watch'']);<br>&nbsp; &nbsp; grunt.registerTask(''build'', [''sass'']);<br>};</code>\r\n<p>V souboru nadefinujeme dvě úlohy, <i>watch</i> a <i>sass</i>. Watch úloha bude výchozí (default) a spustí se pokud zadáme příkaz <i>grunt</i> bez žádných parametrů. Bude dělat to, že sleduje změny v souborech (zde konkrétně ve všech HTML a Sass souborech). Direktiva</p><code>files: ''scss/**/*.scss''</code><p>znamená všechny soubory ve složce <i>scss</i> i podsložkách (lze to samé zapsat pro <i>templates/**/*.html</i>).</p><p>Úlohu ''<i>sass</i>''<i></i> přiřadíme k příkazu <i>''build''</i> a spustí se tedy po zadání příkazu <i>grunt build</i> a provede kompilaci Scss souborů na Css soubory.</p><p>Jednotlivé úlohy lze spouštět i samostatně: <i>grunt watch</i>, <i>grunt sass</i></p><h2>Ukázka workflow</h2><p>Nyní když máme Grunt připravený, ukážeme si jak s tím pracovat. Na GitHubu jsem připravil vzorový projekt <a href="https://github.com/vojtasvoboda/BasicHtmlTemplates/tree/master/BasicHtml5Grunt" target="_blank">BasicHtml5Grunt</a>, kde je již Grunt připraven dle návodu výše.</p><p>Stáhneme si tedy šablonu do nějaké vlastní složky, nainstalujeme Node.js a spustíme příkaz <i>npm install</i>, který se podívá do připraveného souboru <i>package.json</i> a nainstaluje všechny potřebné nástroje včetně Gruntu.</p><p>Spustíme příkaz <i>grunt build</i>, čímž by mělo dojít k úspěšnému překladu Scss souborů na Css a vypsání hlášky ''Done, without errors.''. Tím máme přeložené Scss soubory.</p><p>Dále spustíme příkaz <i>grunt</i>. V okně terminálu se spustí <i>watch</i> proces, který sleduje změny zdrojových souborů. Zkusíme udělat nějakou změnu v HTML, nebo Scss souboru, uložíme a v terminálu vidíme, že ihned došlo k překladu souboru. Proces <i>watch</i> ukončíme stiskem Ctrl+C.</p><h2>Live reload</h2><p>Vzhledem k tomu, že se nám soubory překládají automaticky, bylo by fajn, když by se nám i automaticky obnovovalo okno prohlížeče (které můžeme mít například na druhém monitoru), takže ihned po uložení změněného zdrojového souboru uvidíme změnu v prohlížeči. Slouží k tomu parametr livereload v <i>Gruntfile.js</i> nastavený na <i>true</i>.</p><p>Dále pak potřebujeme doplněk do prohlížeče, např. <a href="https://chrome.google.com/webstore/detail/livereload/jnihajbhpnppcggbcgedagnkighmdlei" target="_blank">plugin LiveReload do Chrome</a>, který si nainstalujeme a aktivujeme kliknutím na něj (musí již běžet <i>grunt watch</i> v terminálu).</p><p>LiveReload funguje na principu vložení dalšího extra javascriptu do našeho kódu v rámci prohlížeče. Zkuste si schválně otevřít zdrojový kód přes inspektor když je zapnutý LiveReload. Pro Symfony toto není potřeba, protože to vkládá livereload skript automaticky.</p>', '2014-06-08 00:00:00', 'kompilace-sass-a-compass-souboru-pres-grunt-js', 1, '2014-06-08 00:00:00', 1, '2014-06-08 00:00:00', '2014-06-08 00:00:00'),
(5, 'Doplňky a rozšíření do prohlížeče Chrome', '<p>Seznam užitečných doplňků do prohlížeče Chrome, jak obecných, tak i speciálně pro vývojáře.</p><hr class="posthaven-more"><p><a href="https://chrome.google.com/webstore/detail/adblock-plus/cfhdojbkjhnklbpkdaibdccddilifddb?hl=cs" target="_blank">AdBlock Plus</a>&nbsp;- blokování nepříjemného obsahu (reklamy, flash)</p><p><a href="https://chrome.google.com/webstore/detail/clearly/iooicodkiihhpojmmeghjclgihfjdjhj?hl=cs" target="_blank">Clearly</a>&nbsp;- přizpůsobení aktuálně zobrazené stránky pro jednodušší čtení (převede webovou stránku aby vypadala jako novinový sloupek, ostraní reklamy a flash)</p><p><a href="https://chrome.google.com/webstore/detail/save-to-pocket/niloccemoadcdkdjlinkgdfekeahmflj?hl=cs" target="_blank">Save to Pocket</a>&nbsp;- rozšíření pro službu Pocket, která umožňuje uchovávat webové stránky pro pozdější přečtení (dříve také známo jako Read It Later)</p><p><a href="https://chrome.google.com/webstore/detail/lastpass-free-password-ma/hdokiejnpimakedhajhdlcegeplioahd?hl=cs" target="_blank">LastPass</a>&nbsp;- doplněk pro synchronizaci hesel napříč více prohlížeči (Chrome, Firefox, IE) nezávisle na platformě (Windows, MacOs), navíc umí i generovat silná hesla pro každou stránku zvlášť a pamatovat si různé poznámky pod heslem</p><p><a href="https://chrome.google.com/webstore/detail/xmarks-bookmark-sync/ajpgkpeckebdhofmmjfgcjjiiejpodla?hl=cs" target="_blank">Xmarks Bookmark Sync</a>&nbsp;- doplněk pro synchronizaci záložek (stejný tvůrce jako LastPass)</p><p>Pozn.: LastPass i Xmarks jsou nástroje zdarma, existuje však <a href="https://lastpass.com/f?666426" target="_blank">premium verze</a> pro kombinaci obou produktů za 20$ na rok.</p><h2>Další zajímavé doplňky, které sice nepoužívám, ale mohou se hodit:</h2><p><a href="https://chrome.google.com/webstore/detail/clickable-links/mblbciejcodpealifnhfjbdlkedplodp" target="_blank">Clickable Links</a>&nbsp;- najde v textu odkazy které nejsou nastavené jako odkazy a umožní je proklikávat</p><p><a href="https://chrome.google.com/webstore/detail/evernote-web-clipper/pioclpoplcdbaefihamjohnefbikjilc" target="_blank">Evernote Web Clipper</a> - rychlé ukládání do Evernote (existuje také Evernote premium verze za 40EUR na rok)</p><p><a href="https://chrome.google.com/webstore/detail/googl-url-shortener/iblijlcdoidgdpfknkckljiocdbnlagk" target="_blank">goo.gl URL Shortener</a> - zrychlené vytváření krátkých URL a QR kódů</p><p><a href="https://chrome.google.com/webstore/detail/speed-dial/dgpdioedihjhncjafcpgbbjdpbbkikmi" target="_blank">Speed Dial</a>&nbsp;- při vyvolání nové záložky nabídne matici 12ti nejpoužívanějších stránek (nebo si je můžete navolit samostatně)</p><p><a href="https://chrome.google.com/webstore/detail/sourcekit/iieeldjdihkpoapgipfkeoddjckopgjg" target="_blank">SourceKit</a>&nbsp;- možnost psaní zdrojového kódu, který se pak ukládá do Dropboxu</p><p><a href="https://chrome.google.com/webstore/detail/google-keep/hmjkmjkepdijhoojdojkdfohbdgmmhki" target="_blank">Google Keep</a>&nbsp;- doplněk pro aplikaci Google Keep pro zaznamenávání drobných úkolů, nebo seznamů</p><p><a href="https://chrome.google.com/webstore/detail/google-tasks-panel/gmjdflobmjpeohnoefalpjeocgpdeffo" target="_blank">Google Task Panel</a>&nbsp;- doplněk pro aplikaci Google Tasks pro zaznamenávání úkolů</p><p><a href="https://chrome.google.com/webstore/detail/tasks-app/ndhalihfegegiohmkbjokknlaoeidpdl" target="_blank">Tasks App</a>&nbsp;- další doplněk pro aplikaci Google Tasks pro zaznamenávání úkolů</p><p><a href="https://chrome.google.com/webstore/detail/writebox/bbehjmjchoiaglkeboicbgkpfafcmhij" target="_blank">Writebox</a>&nbsp;- psaní textu bez rozptylování (vytvoří čistou plochu pouze s textem bez žádných ovládacích prvků)</p><div>\r\n<div>\r\n<img width="48" src="https://phaven-prod.s3.amazonaws.com/files/image_part/asset/1179304/kUCNn6DBFjA3UGRs6jMnOaE5cqM/thumb_writebox.jpg" height="48" data-posthaven-guid="JTt-UWgiTpjRSMXjkjZsJtHi7Sj0ZO3Cu6kz0V0_" data-posthaven-type="image" unselectable="on" class="posthaven-placeholder"><h2>Chrome doplňky pro vývojáře</h2>\r\n<p><a href="https://chrome.google.com/webstore/detail/chrome-logger/noaneddfkdjfnfdakjjmocngnfkfehhd?hl=cs" target="_blank">Chrome Logger</a>&nbsp;- logování a debugování server-side aplikací; možno využít API a napsat si vlastní logger, který pak přes tento doplněk zapisuje do konzole; viz <a href="https://github.com/Vitre/php-console-bundle" target="_blank">logger pro Symfony</a></p>\r\n<p><a href="https://chrome.google.com/webstore/detail/web-developer/bfbameneiokkgbdmiekhjnmfkcnldhhm?hl=cs" target="_blank">Web Developer</a>&nbsp;- sada doplňků pro webový vývoj (resize prohlížeče, kapátko, manipulace se styly, mazání cookies, zobrazení outline a další)</p>\r\n<p><a href="https://chrome.google.com/webstore/detail/clear-cache/cppjkneekbjaeellbfkmgnhonkkjfpdn" target="_blank">Clear Cache</a>&nbsp;- mazání cache jedním tlačítkem</p>\r\n<p><a href="https://github.com/mauricecruz/chrome-devtools-zerodarkmatrix-theme" target="_blank">ZeroDark Matrix theme</a>&nbsp;- tmavé téma pro ladící konzoli</p><img width="48" src="https://phaven-prod.s3.amazonaws.com/files/image_part/asset/1179305/8MaoTrTRiZODNb945PVpHQ48fn8/thumb_zerodark.jpg" height="48" data-posthaven-guid="SorIOSeoSn5UBEZq5aKbeuWVTMI1ZwXYAOr3MsM_" data-posthaven-type="image" unselectable="on" class="posthaven-placeholder"></div>\r\n<div><div>\r\n<p><a href="https://chrome.google.com/webstore/detail/google-analytics-debugger/jnkmfdileelhofjcijamephohjechhna" target="_blank">Google Analytics Debugger</a>&nbsp;- debuger pro Google Analytics, umí zobrazovat odesílané trackovací informace</p>\r\n<p><a href="https://chrome.google.com/webstore/detail/tag-assistant-by-google/kejbdjndbnbjgmefkgdddjlbokphdefk" target="_blank">Tag Assistant</a>&nbsp;- debuger pro Google Tag Manager</p>\r\n<p><a href="https://chrome.google.com/webstore/detail/http-headers/mhbpoeinkhpajikalhfpjjafpfgjnmgk" target="_blank">HTTP Headers</a>&nbsp;- zobrazení HTTP hlaviček jedním kliknutím</p>\r\n<p><a href="https://chrome.google.com/webstore/detail/postman-rest-client-packa/fhbjgbiflinjbdggehcddcbncdddomop" target="_blank">Postman - REST Client</a>&nbsp;- debuger pro REST API přímo jako doplněk do Chrome</p>\r\n<p><a href="https://chrome.google.com/webstore/detail/livereload/jnihajbhpnppcggbcgedagnkighmdlei" target="_blank">LiveReload</a>&nbsp;- automatická obnova stránky při změně zdrojových souborů, vhodné hlavně pro frontend kodéry při ladění HTML/CSS/JS, viz můj článek o Grunt</p>\r\n<p><a href="https://chrome.google.com/webstore/detail/speed-tracer-by-google/ognampngfcbddbfemdapefohjiobgbdl/related?hl=cs" target="_blank">Speed Tracer</a>&nbsp;- měření rychlosti načítání stránek</p>\r\n<p><a href="https://chrome.google.com/webstore/detail/page-eraser/ekofpchjmoalonajopdeegdappocgcmj?hl=cs" target="_blank">Page Eraser</a> - náhrada Nuke Anything Enhanced, umožňuje odstranění jakéhokoli HTML elementu ze stránek (i pro budoucí návštěvy stránky)</p>\r\n<h2>Další Chrome doplňky pro vývojáře</h2>\r\n<p>Opět se jedná o seznam doplňků, které sice nepoužívám, ale je vhodné o nich vědět.</p>\r\n<p><a href="https://chrome.google.com/webstore/detail/appspector/homgcnaoacgigpkkljjjekpignblkeae" target="_blank">Appspector</a>&nbsp;- ukáže, jaké technologie jsou na stránkách používány (JS pluginy, CMS)</p>\r\n<p><a href="https://chrome.google.com/webstore/detail/devtools-autosave/mlejngncgiocofkcbnnpaieapabmanfl" target="_blank">DevTools Autosave</a>&nbsp;- automatické ukládání změn CSS/JS provedených v ladící konzoli Chrome</p>\r\n<p><a href="https://chrome.google.com/webstore/detail/extensions-manager-aka-sw/lpleipinonnoibneeejgjnoeekmbopbc" target="_blank">Extension Maker</a>&nbsp;- prostředí pro spuštění uživatelských skriptů psaných v javascriptu</p>\r\n<p><a href="https://chrome.google.com/webstore/detail/tampermonkey/dhdgffkkebhmkfjojejmpbldmpobfkfo" target="_blank">Tampermonkey</a>&nbsp;- další nástroj pro spuštění uživatelských skriptů</p>\r\n<p><a href="https://chrome.google.com/webstore/detail/hide-my-ass-web-proxy/cmgnmcnlncejehjlnhaglpnoolgbflbd" target="_blank">Hide My Ass</a>&nbsp;- použití proxy pro prohlížení obsahu (skrytí IP adresy)</p>\r\n<p><a href="https://chrome.google.com/webstore/detail/javascript-errors-notifie/jafmfknfnkoekkdocjiaipcnmkklaajd" target="_blank">Javascript Errors Notifier</a>&nbsp;- zobrazení počtu javascript chyb přímo v adresním řádku</p>\r\n<p><a href="https://chrome.google.com/webstore/detail/validity/bbicmjjbohdfglopkidebfccilipgeif" target="_blank">Validity</a>&nbsp;- validace aktuálně načtené stránky</p>\r\n<p><a href="https://chrome.google.com/webstore/detail/lorem-ipsum-generator-def/mcdcbjjoakogbcopinefncmkcamnfkdb" target="_blank">Lorem Ipsum Generator</a>&nbsp;- generátor Lorem Ipsum textu</p>\r\n<p><a href="https://chrome.google.com/webstore/detail/live-http-headers/iaiioopjkcekapmldfgbebdclcnpgnlo" target="_blank">Live HTTP Headers</a>&nbsp;- monitoring HTTP hlaviček</p>\r\n<p><a href="https://github.com/callumlocke/json-formatter" target="_blank">JSON Formatter</a>&nbsp;- formátování JSON a JSONP formátu</p>\r\n<p><a href="https://chrome.google.com/webstore/detail/jetbrains-ide-support/hmhgeddbohgjknpmjagkdomcpobmllji" target="_blank">JetBrains IDE Support</a>&nbsp;- napojení na JetBrains IDE (PhpStorm, PyCharm, WebStorm) a okamžitá změna stránek při změně kódu</p>\r\n<p><a href="https://chrome.google.com/webstore/detail/session-manager/bbcnbpafconjjigibnhbfmmgdbbkcjfi" target="_blank">Session Manager</a> - správa aktivních session</p>\r\n<h2>Doplňky do Firefox, které jsem používal předtím:</h2>\r\n<p>Ná závěr seznam doplňků které jsem používal ve Firefox a při přechodu na Chrome jsem pro ně hledal náhradu.</p>\r\n<p>Adblock Plus - advertisement blocker</p>\r\n<p>Clearly - better long texts reading</p>\r\n<p>ColorZilla - color picker [css]</p>\r\n<p>feedly - some feedly snippet</p>\r\n<p>Firebug - tools for webdevelopment</p>\r\n<p>FirePHP - logging PHP to Firefox console</p>\r\n<p>FireLogger - server side logging</p>\r\n<p>FireQuery - doplněk pro jQuery</p>\r\n<p>FireShot - screenshots</p>\r\n<p>LastPass - password keeper</p>\r\n<p>LeechBlock - blocking sites for some time (facebook etc)</p>\r\n<p>Live HTTP Headers - view HTTP headers</p>\r\n<p>MeasureIt - draw a ruler across the page [css]</p>\r\n<p>Nuke Anything Enhanced - hidding HTML elements via context menu</p>\r\n<p>Operator - show microformats from page</p>\r\n<p>Pocket - read it later</p>\r\n<p>RESTClient - debugging REST APIs</p>\r\n<p>Web Developer - webdevelopers tools</p>\r\n<p>Xmarks - bookmarks sync</p>\r\n<p>Yslow - webpage performance analyse</p>\r\n<p><br></p>\r\n<p>Používáte nějaký doplněk, který chybí v seznamu výše? Pošlete mi ho do komentářů, já ho otestuji a vložím k ostatním.</p>\r\n</div></div>\r\n</div>', '2014-06-16 00:00:00', 'doplnky-a-rozsireni-do-prohlizece-chrome', 1, '2014-06-16 00:00:00', 1, '2014-06-16 00:00:00', '2014-06-16 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `articles_tags`
--

CREATE TABLE IF NOT EXISTS `articles_tags` (
  `id` int(11) NOT NULL,
  `articles_id` int(11) NOT NULL,
  `tags_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;

--
-- Dumping data for table `articles_tags`
--

INSERT INTO `articles_tags` (`id`, `articles_id`, `tags_id`, `created`, `modified`) VALUES
(1, 4, 1, '2014-06-20 00:00:00', '2014-06-20 00:00:00'),
(2, 4, 4, '2014-06-20 00:00:00', '2014-06-20 00:00:00'),
(3, 3, 10, '2014-06-20 00:00:00', '2014-06-20 00:00:00'),
(4, 3, 12, '2014-06-20 00:00:00', '2014-06-20 00:00:00'),
(5, 5, 1, '2014-06-26 00:00:00', '2014-06-26 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `tags`
--

CREATE TABLE IF NOT EXISTS `tags` (
  `id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `url` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `articles_count` int(11) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;

--
-- Dumping data for table `tags`
--

INSERT INTO `tags` (`id`, `name`, `url`, `articles_count`, `created`, `modified`) VALUES
(1, 'css', 'css', 0, '2014-06-20 00:00:00', '2014-06-20 00:00:00'),
(2, 'google app engine', 'google-app-engine', 0, '2014-06-20 00:00:00', '2014-06-20 00:00:00'),
(3, 'api', 'api', 0, '2014-06-20 00:00:00', '2014-06-20 00:00:00'),
(4, 'frontend', 'frontend', 0, '2014-06-20 00:00:00', '2014-06-20 00:00:00'),
(5, 'backend', 'backend', 0, '2014-06-20 00:00:00', '2014-06-20 00:00:00'),
(6, 'php', 'php', 0, '2014-06-20 00:00:00', '2014-06-20 00:00:00'),
(7, 'books', 'books', 0, '2014-06-20 00:00:00', '2014-06-20 00:00:00'),
(8, 'html', 'html', 0, '2014-06-20 00:00:00', '2014-06-20 00:00:00'),
(9, 'konference', 'konference', 0, '2014-06-20 00:00:00', '2014-06-20 00:00:00'),
(10, 'macos', 'macos', 0, '2014-06-20 00:00:00', '2014-06-20 00:00:00'),
(11, 'java', 'java', 0, '2014-06-20 00:00:00', '2014-06-20 00:00:00'),
(12, 'apache', 'apache', 0, '2014-06-20 00:00:00', '2014-06-20 00:00:00'),
(13, 'ui', 'ui', 0, '2014-06-20 00:00:00', '2014-06-20 00:00:00'),
(14, 'twitter', 'twitter', 0, '2014-06-20 00:00:00', '2014-06-20 00:00:00'),
(15, 'semantic', 'semantic', 0, '2014-06-20 00:00:00', '2014-06-20 00:00:00'),
(16, 'netbeans', 'netbeans', 0, '2014-06-20 00:00:00', '2014-06-20 00:00:00'),
(17, 'flickr', 'flickr', 0, '2014-06-20 00:00:00', '2014-06-20 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `email` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `password` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `last_access` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `articles`
--
ALTER TABLE `articles`
  ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `url` (`url`);

--
-- Indexes for table `articles_tags`
--
ALTER TABLE `articles_tags`
  ADD PRIMARY KEY (`id`), ADD KEY `articles_id` (`articles_id`), ADD KEY `tags_id` (`tags_id`);

--
-- Indexes for table `tags`
--
ALTER TABLE `tags`
  ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `articles`
--
ALTER TABLE `articles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `articles_tags`
--
ALTER TABLE `articles_tags`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `tags`
--
ALTER TABLE `tags`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=18;
--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `articles_tags`
--
ALTER TABLE `articles_tags`
ADD CONSTRAINT `articles_tags_ibfk_1` FOREIGN KEY (`articles_id`) REFERENCES `articles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `articles_tags_ibfk_2` FOREIGN KEY (`tags_id`) REFERENCES `tags` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
