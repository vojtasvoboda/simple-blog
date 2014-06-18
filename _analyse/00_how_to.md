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

Protože chci co nejjednodušší aplikaci a nechi prozatím řešit nastavení [virtuálního serveru](http://blog.vojtasvoboda.cz/nastaveni-serveru-apache-na-macos) přesunu si veřejné soubory do rootu projektu. Styly a Javascript soubory si dám pro přehlednost do složky assets. Projekt je nyní dostupný hezky na adrese http://localhost/SimpleBlog/. Viz commit ‘Copy public files to root’.

## Požadavky na aplikaci

Dále si sepíši požadavky na naší aplikaci a dáme rovnou také do repozitáře, viz commit 'Aplication requirements'.

Z požadavků si sestavím případy užití, abych věděl jakou funkcionalitu musím pokrýt a jaké objekty (článek, uživatel, tag) musím vytvořit, viz commit 'Aplication use-cases'.

## Návrh aplikace

### Databáze
Vytvoříme si databázi s názvem 'simpleblog' a nastavíme jí do projektu pomocí souboru /app/config.neon.

Z požadavků a případů užití si vypíši základní entity které chci spravovat (článek, uživatel, tag) a vytvořím databázové tabulky s příslušnýmy atributy.
Vzhledem k tomu, že článek může mít více tagů a jeden tag může odkazovat na více článků, vytvořím také relační tabulku pro vazbu mezi články a tagy. Protože používám InnoDB nastavím také relace mezi klíči a všechny parametry nastavím na CASCADE, protože když se smaže tag, nebo článek, musí se odstranit i příslušná vazba.
Viz soubor _analyse/02_app_draft.md.

Databázovou tabulku uložím do složky 'sql' jako skript 'simpleblog.sql'. Viz commit 'Entities and database'.

### Model aplikace

Dále je potřeba vytvořit model aplikace, kde budou dostupné data z databáze. Návrh modelu sepíši do souboru _analyse/02_app_draft.md jako sekci Návrh modelu.

Nejdříve si vytvoříme třídu Repository, která nám bude zastřešovat práci s jednou databázovou tabulkou. Tato třída bude absolutně nezávislá na obsahu databázových tabulek.
Bude nám implementovat metody jako findAll() pro získání všech záznamů, findOne($id) pro získání jednoho záznamu dle primárního klíče, vytváření a mazání záznamů.
Protože se bude do budoucna jednat o znovupoužitelnou třídu, umístíme si jí ven z aktuální aplikace do vlastní vendor složky, kterou si vytvoříme v /vendor/simple/.
Musíme rovněž nastavit autoloading souborů, aby nám viděl i do naší nové složky /simple/, což provedeme v souboru bootstrap.php přidáním řádku:

$configurator->createRobotLoader()
	->addDirectory(__DIR__)
	->addDirectory(__DIR__ . '/../vendor/others')
    ->addDirectory(__DIR__ . '/../vendor/simple')
	->register();

Tato třída rovněž dokáže rozpoznat název tabulky podle názvu třídy a automaticky nastavit databázové spojení (viz funkce Repository->getTable() a příslušný komentář).

Dále si stejným způsobem vytvoříme třídu BaseRepository, která nám bude zastřešovat základní operace s jedním repozitářem, ale již bude vyžadovat nějaké určité sloupce v databázi,
např. sloupec active (značí jestli je položka aktivní), name (název položky), created (datum vytvoření), updated (datum poslední změny).

Implementováno je automatické vytvoření URL pokud existuje sloupec s názvem 'url' a dále se bude vkládat datum vytvoření, nebo úpravy dané položky.
Tato funkcionalita není pro běh blogu potřeba (funkce pro vytváření URL bychom mohli dát pouze do repozitáře s článkama a sloupce created/updated bychom mohli úplně vyloučit), ale ušetří nám práci pro budoucí rozšiřování.

Posledním krokem bude už finální vytvoření požadovaných repozitářů pro jednotlivé databázové tabulky, tzn ArticlesRepository, TagsRepository a UsersRepository.
Repozitáře jsou prázdné, protože veškerou potřebnou funkcionalitu pokryjí základní Repository a BaseRepository. Repozitáře zavedeme do aplikace v souboru config.neon v sekci Services.

### Zkouška základní aplikace

Nyní si vypíšeme vložené články. Do databáze vložím dva testovací články a upravím přiložený SQL skript. Model již máme připravený a zaregistrovaný, stačí tedy upravit HomepagePresenter a získat všechny uložené články.

Přes kontruktor si zavedeme do třídy repozitář článků, který se nám díky autowiringu v Nette zavede automaticky. Na repozitáři vytáhneme všechny články pomocí findAll() a rovnou předáme do šablony.
V šabloně si články vypíšeme pomocí foreach() cyklu a to je vše. Základní blog funguje :-)
