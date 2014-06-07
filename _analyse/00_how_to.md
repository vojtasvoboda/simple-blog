# SimpleBlog

Celý projekt včetně jedlotlivých commitů je dostupný na GitHubu: [https://github.com/vojtasvoboda/SimpleBlog](https://github.com/vojtasvoboda/SimpleBlog)

## Základní aplikace

Vytvoříme si nový adresář který je dostupný pro běh na lokálním serveru a inicializujeme Git, kterým budeme projekt verzovat.

``
mkdir SimpleBlog  
cd SimpleBlog  
git init  
``

Vytvořím si základní soubor README.md a soubor .gitignore, protože některé složky, nebo soubory nebudeme chtít verzovat (např složku nbproject, kterou vytváří NetBeans). Vytvoříme první commit. V rámci celého článku budu uvádět název commitu na GitHubu.

``
touch README.md  
touch .gitignore  
git add .  
git commit -m “First commit”  
``

Ze stránek http://nette.org/cs/download zkopírujeme odkaz pro instalaci základní Nette aplikace.

``composer create-project nette/sandbox``

Projekt se nám rozbalí do složky sandbox, tak si ho vykopírujeme o úroveň výše a sloučíme si soubory .gitignore. Tím máme připravenou základní aplikaci, která je dostupná na adrese http://localhost/SimpleBlog/www/ viz commit ‘Nette sandbox app‘. Na MacOs nastavíme práva pro zápis do složek (i podsložek) log a temp.

Protože chci co nejjednodušší aplikaci bez nutnosti nastavovat [virtuální server](http://blog.vojtasvoboda.cz/nastaveni-serveru-apache-na-macos) přesunu si veřejné soubory do rootu projektu. Styly a Javascript soubory si dám pro přehlednost do složky assets. Projekt je nyní dostupný hezky na adrese http://localhost/SimpleBlog/. Viz commit ‘Copy public files to root’.

## Požadavky na aplikaci

Dále si sepíši požadavky na naší aplikaci a dáme rovnou také do repozitáře, viz commit 'Aplication requirements'.

Z požadavků si sestavím případy užití, abych věděl jakou funkcionalitu musím pokrýt a jaké objekty (článek, uživatel, tag) musím vytvořit, viz commit 'Aplication use-cases'.

## Návrh aplikace

Vytvoříme si databázi s názvem simpleblog a nastavíme jí do projektu pomocí souboru /app/config.neon.

Z požadavků a případů užití si vypíši základní entity které chci spravovat (článek, uživatel, tag) a vytvořím databázové tabulky s příslušnýmy atributy.
Vzhledem k tomu, že článek může mít více tagů a jeden tag může odkazovat na více článků, vytvořím také relační tabulku pro vazbu mezi články a tagy. Protože používám InnoDB nastavím také relace mezi klíči a všechny parametry nastavím na CASCADE, protože když se smaže tag, nebo článek, musí se odstranit i příslušná vazba.
Viz soubor _analyse/02_app_draft.md.
Databázovou tabulku uložím do složky 'sql' jako skript 'simpleblog.sql'. Viz commit 'Entities and database'.
