# SimpleBlog

Celý projekt včetně jedlotlivých commitů je dostupný na GitHubu: [https://github.com/vojtasvoboda/SimpleBlog](https://github.com/vojtasvoboda/SimpleBlog)

## Základní aplikace

Vytvoříme si nový adresář který je dostupný pro běh na lokálním serveru a inicializujeme Git, kterým budeme projekt verzovat.

``
mkdir SimpleBlog  
cd SimpleBlog  
git init  
``

Vytvořím si základní soubor README.md a soubor .gitignore, protože některé složky, nebo soubory nebudeme chtít verzovat (např složku .idea, kterou vytváří PhpStorm). Vytvoříme první commit. V rámci celého článku budu uvádět název commitu na GitHubu.

``
touch README.md  
touch .gitignore  
git add .  
git commit -m “First commit”  
``

Ze stránek http://nette.org/cs/download zkopírujeme odkaz pro instalaci základní Nette aplikace.

``composer create-project nette/sandbox``

Projekt se nám rozbalí do složky sandbox, tak si ho vykopírujeme o úroveň výše a sloučíme si soubory .gitignore. Tím máme připravenou základní aplikaci, která je dostupná na adrese http://localhost/SimpleBlog/www/ viz commit [Nette sandbox app](https://github.com/vojtasvoboda/SimpleBlog/commit/5b08a4f6289f8e0d28e066ac7ab666220ff13ec8). Na MacOs nastavíme práva pro zápis do složek (i podsložek) log a temp.

Protože chci co nejjednodušší aplikaci a nechci prozatím řešit nastavení [virtuálního serveru](http://blog.vojtasvoboda.cz/nastaveni-serveru-apache-na-macos) přesunu si veřejné soubory do rootu projektu. CSS styly a Javascript soubory si dám pro přehlednost do složky /assets. Projekt je nyní dostupný hezky na adrese http://localhost/SimpleBlog/. Viz commit ['Copy public files to root'](https://github.com/vojtasvoboda/SimpleBlog/commit/ca1347b3618673624f7f33df0e947f4e1f4f1db7).

## Požadavky na aplikaci

Dále si sepíši požadavky na naší aplikaci do souboru /_analyse/01_requirements.md, viz commit ['Aplication requirements'](https://github.com/vojtasvoboda/SimpleBlog/commit/15e88433c42454704e3629efa8a31aa5a810e59f).

Z požadavků si sestavím případy užití, abych věděl jakou funkcionalitu musím pokrýt a jaké objekty (článek, uživatel, tag) musím vytvořit, viz commit ['Aplication use-cases'](https://github.com/vojtasvoboda/SimpleBlog/commit/8e4376a02032679dee9728f1bbe4e099a79fae4c).

## Návrh aplikace

### Databáze
Vytvoříme si databázi s názvem 'simpleblog' a nastavíme jí do projektu pomocí souboru /app/config.neon.

Z požadavků a případů užití si vypíši základní entity které chci spravovat (článek, uživatel, tag) a vytvořím databázové tabulky s příslušnýmy atributy.
Vzhledem k tomu, že článek může mít více tagů a jeden tag může odkazovat na více článků, vytvořím také relační tabulku pro vazbu mezi články a tagy. Protože používám InnoDB nastavím také relace mezi klíči a všechny parametry nastavím na CASCADE, protože když se smaže tag, nebo článek, musí se odstranit i příslušná vazba.
Viz soubor '_analyse/02_app_draft.md'.

Databázovou tabulku uložím do složky 'sql' jako skript 'simpleblog.sql'. Viz commit ['Entities and database'](https://github.com/vojtasvoboda/SimpleBlog/commit/d4a6e1ca4fe652c2d2477ef916c4802f19b21a5a).

### Model aplikace

Dále je potřeba vytvořit model aplikace, kde budou dostupné data z databáze. Návrh modelu sepíši do souboru '_analyse/02_app_draft.md' jako sekci Návrh modelu.

Protože nechceme v každém repozitáři pro každou tabulku řešit základní operace, vytvoříme si třídu Repository, která nám bude zastřešovat práci s jednou databázovou tabulkou.
Tato třída bude absolutně nezávislá na obsahu databázových tabulek.
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
např. sloupec active (značí jestli je položka aktivní), name (název položky), created (datum vytvoření), updated (datum poslední změny). Tyto funkce využijeme ale až v administrační části.

Implementováno je automatické vytvoření URL pokud existuje sloupec s názvem 'url' a dále se bude vkládat datum vytvoření, nebo úpravy dané položky.
Tato funkcionalita není pro běh blogu potřeba (funkce pro vytváření URL bychom mohli dát pouze do repozitáře s článkama a sloupce created/updated bychom mohli úplně vyloučit), ale ušetří nám práci pro budoucí rozšiřování.

Posledním krokem bude už finální vytvoření požadovaných repozitářů pro jednotlivé databázové tabulky, tzn ArticlesRepository, TagsRepository a UsersRepository.
Repozitáře jsou prázdné, protože veškerou potřebnou funkcionalitu pokryjí základní Repository a BaseRepository od kterých dědíme. Repozitáře zavedeme do aplikace v souboru config.neon v sekci Services.

### Zkouška základní aplikace

Nyní si vypíšeme vložené články. Do databáze vložím dva testovací články a upravím přiložený SQL skript. Model již máme připravený a zaregistrovaný, stačí tedy upravit HomepagePresenter a získat všechny uložené články.

Přes kontruktor si zavedeme do třídy repozitář článků, který se nám díky autowiringu v Nette zavede automaticky. Na repozitáři vytáhneme všechny články pomocí findAll() a rovnou předáme do šablony.
V šabloně si články vypíšeme pomocí foreach() cyklu a to je vše. Základní blog funguje :-) Viz commit ['Basic blog application'](https://github.com/vojtasvoboda/SimpleBlog/commit/4a5ab9ed33178daff61b42dd7d5ae66ac72cfb82).

Nyní můžeme přidávat další doplňkovou funkcionalitu, která nám bude danou aplikaci rozvíjet.

### Detail článku

Dále potřebujeme detail článku. K tomu si upravíme i routování aplikace, v souboru /app/router/RouterFactory.php, protože
chceme mít hezké URL typu /nazev-clanku/. K tomu použijeme Apache modul mod_rewrite v kombinaci s konfigurací přepisu v souboru htaccess.
Nicméně pokud nám pro začátek nevadí používat URL ve tvaru:

www.simpleblog.cz/?slug=prvni-clanek&amp;action=detail

můžeme toto vše přeskočit.

Do RouterFactory.php tedy přidáme dvě routy - jednu pro všechny články a druhou pro detail článku:

$router[] = new Route('', 'Homepage:default');
$router[] = new Route('<slug>/', 'Homepage:detail');

Navíc přidáme podmínku, pokud by nebyl přítomen mod_rewrite, tak aby se použil základní SimpleRouter, který předává parametry přes GET, viz příklad URL výše.

Napíšeme si v HomepagePresenteru metodu pro detail článku, který se pouze pokusí najít daný článek podle URL a pokud nenajde, tak zobrazí šablonu notfound.latte.
Také si do repozitáře ArticlesRepository dopíšu metodu pro získání všech článků podle URL. Toto bych sice mohl napsat přímo do presenteru, ale protože chceme mít pěkné interní API
aplikace které půjde volat odkudkoli (třeba i přes Ajaxový požadavek), tak dáváme veškerou logiku do modelové části.
Navíc hledáme pouze publikované články, takže výsledná metoda pro nalezení článku vypadá takto:

public function findOne($url)
{
    return $this->findOneBy(
        array(
            'url' => $url,
            'published' => true,
            'published_date <= ?' => new SqlLiteral('NOW()')
        ));
}

V šabloně si všimněte použití vykřičníku pro výpis čistého HTML a dále použití helperu pro výpis datumu článku ve vlastním formátu.
Doplníme ještě odkaz pro návrat z detailu článku na homepage a máme hotovo.

Pozn.: V aktuálním stavu bychom mohli repozitář klidně dědit přímo z Repozitory a klidně BaseRepository přeskočit. Potřebujeme totiž pouze získání připojení do databáze a toť vše.

### Aktualizace Nette

Během vývoje tohoto blogu vyšla nová verze Nette 2.2.1, takže si můžeme rovnou aktualizovat. Naštěstí používáme Composer, takže vše lze vyřešit jedním příkazem:

composer update

Až budeme mít aplikaci hotovou, je dobré v souboru composer.json zafixovat verze jednotlivých komponent.
Znamená to, že přímo definujeme verzi s kterou máme aplikaci odzkoušenou a funguje. To je důležité, protože pokud bychom provedli update na novější verzi,
která by nebyla kompatibilní, mohla by se nám aplikace rozbít.

### Otagování verze

Protože naše aplikace umí vypsat všechny články a zobrazit jeho detail, označíme si aplikaci jako verzi 0.1 a přidáme do gitu ['příslušný tag'](https://github.com/vojtasvoboda/SimpleBlog/tree/v0.1).
Sice nevypadá pěkně a skoro nic neumí, svůj účel ale již splňuje.

Aktuální stav aplikace viz commit ['Article detail'](https://github.com/vojtasvoboda/SimpleBlog/commit/de86074625bf0d59a113c937aef1f457938de246).

## Rozšiřování blogu o další funkce

Základ blogu máme vytvořený, ale umí prakticky pouze zobrazit všechny články a konkrétní detail článku.
Funkcí které je potřeba doplnit a implementovat je hodně, ale já chci blog spustit co nejdříve a proto je potřeba přidělit úkolům priority.
Vytvořím proto soubor '_analyse/03_roadmap.md' kde seřadím funkčnost dle priority a podle nich začnu s rozšiřováním blogu.

### Výpis pouze úryvku článku ve výpisu všech článků

Pro zkrácení textu ve výpisu všech článků vytvoříme helper, který pak zavoláme v šabloně. Helper implementujeme jako anonymní funkci a zaregistrujeme v presenteru do Latte:

protected function createTemplate($class = NULL)
{
    $template = parent::createTemplate($class);
    // perex helper
    $template->getLatte()->addFilter('perex', function($s, $class = 'posthaven-more') {
        $startBreakpoint = strpos($s, '<hr class="' . $class);
        return mb_substr($s, 0, $startBreakpoint);
    });
    return $template;
}

V šabloně pro výpis všech článků už jenom aplikujeme vytvořený helper:

<p>{!$article->text|perex}</p>

Také jsem provedl pár dalších drobností: vypsání meta tagu description v detailu článku, dle názvu článku; vypsání pouze publikovaných článků atd.
Viz commit ['Article perexes'](https://github.com/vojtasvoboda/SimpleBlog/commit/905cbe13c9f8642746037f5e8c6127fe93edecfa)

### Výpis tagů v detailu článku

Do databáze si vložíme nějaké tagy a vypíšeme je v detailu článku:

<p class="tags">
    <span class="label">Tagy: </span>
    {foreach $article->related(articles_tags) as $tag}
    <span class="tag">{$tag->tags->name}</span><span class="separator">{if !$iterator->last}, {/if}</span>
    {/foreach}
</p>

Za posledním tagem čárku již nevypisujeme. Není třeba nijak modifikovat model, ani presenter článků.

To samé si uděláme u výpisu všech článků, ale zde vypíšeme úplně všechny tagy uložené v systému. Abychom to měli zobrazeno v levém sloupci vedle článků,
trošku upravíme layout celého webu a přidáme levý sloupec. Dále je potřeba získat všechny tagy v systému a to provedeme v HomepagePresenteru v akci renderDefault().
Model není potřeba upravit, protože voláme obecnou metodu findAll(). Viz commit ['Articles tags'](https://github.com/vojtasvoboda/SimpleBlog/commit/0c20b288584c2f4ffd9ef82e46ef5a372d8158d5)

### Proklik tagů a zobrazení souvisejících článků

Abychom mohli zobrazit všechny články daného tagu, uděláme si je proklikávací. Zde jsem si uvědomil, že jsem pro tagy zapomněl v databázi vytvořit sloupec 'url', jako unikátní identifikátor, protože chceme mít pro tagy URL ve formátu:

www.simpleblog.cz/tags/konference/

Protože chceme zobrazovat tagy na samostatné URL /tags/ musíme si již vytvořit nový presenter TagsPresenter a příslušnou šablonu templates/Tags/default.latte a detail.latte. Další postup bude už podobný jako u HomepagePresenteru a jeho šablon.
Vytvoříme metodu defaultAction(), která bude načítat seznam všech tagů a vypisovat je do šablony. Následovně vytvoříme detailAction(), která bude vypisovat detail jednoho článku a související články.
Rovněž je potřeba upravit routování pro cestu /tags/, aby nám směřovalo na presenter TagsPresenter.

$router[] = new Route('tags/', 'Tags:default');
$router[] = new Route('tags/<slug>', 'Tags:detail');

Vzhledem k tomu, že pro jednotlivé tagy vypisujeme související články a potřebujeme také helper perex, musíme si registraci tohoto helperu přesunout z HomepagePresenteru do BasePresenteru, aby byl dostupný všude.

TODO:
- projít jak se zavádějí služby/factories do konfigu
- semver
- do textu napsat, že jsem něco opravil a odkázat se na commit opravy

