# Simple blog

Cílem je napsat aplikaci pro zveřejňování článků co nejjednodušší cestou, bez zbytečné míry komplexity. 
Aplikace by měl být i zároveň step-by-step návod pro naučení se tvorby základní aplikace v Nette. 
Chci se tak vyvarovat použití VirtualHosts, Nette modulů, migrací, entit, atd.

## 1. Základní požadavky

- správa článků (nadpis, text, datum)
- možnost vkládat obrázky
- tagy ke článkům
- možnost náhledu (draft)
- uživatelský profil (about me)
- nastavení data publikace
- označení části článku, která bude sloužit jako perex
- fulltextové vyhledávání
- sociální tlačítka pro sdílení
- komentáře pod článkem
- verzování článků
- vzhledově přibližně jako blog http://matschaffer.com/ nebo dle základního vzhledu Postheaven (http://blog.posthaven.com/)
- blog bude mít levý sloupec, kde bude vyhledávání, tagy a popis autora - posune to čtený text doprostřed monitoru

### 1.1. Technické požadavky

- aplikace musí bežet na klasickém prostředí Apache + PHP 5.3/5.4 + MySQL bez žádný speciálních doplňků (mcrypt, memcache).
- RSS kanál
- HTML5
- kód obohacený o sémantické informace (mikroformáty, mikrodata, RDF)
- mazání článku provede akorát nastavení příznaků smazáno
- firendly URL (e.g. blog.vojtasvoboda.cz/prvni-clanek)
- stránkování článků na homepage
- implementace Google Analytics

### 1.2. Uživatelské role

- uživatel bez přihlášení (zobrazení publikovaných článků a tagů)
- administrátor (bude moci vše)

### 1.3. Případy užití

- správa článků (vložení, editace, smazání, publikace, skrytí, zobrazení všech, zobrazení detailu, náhled bez publikace, přiřazení tagu, nastavení data publikace)
- zobrazit půjde pouze publikovaný článek, nebo pokud bude přihlášený administrátor
- správa tagů (vložení, editace, smazání, vypsání souvisejících článků, vypsání počtu souvisejících článků)
- správa administrátorů (vložení, editace, smazání, zablokování)
- přidání komentáře pod článek
- fulltextové vyhledávání článků
- zobrazení starší verze článku a porovnání s aktuální
- sdílení článku sociálním tlačítkem
- přihlášení do administrace
