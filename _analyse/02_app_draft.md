## 2. Návrh aplikace

Diagram tříd, seznam entit, databázový model.

### 2.1. Návrh databáze

Každá z entit má navíc atributy id, created a modified, které již neuvádím.

Administrátor (users)
- name, email, password, active, created, modified, last_access
- atribut 'email' má klíč UNIQUE

Článek (articles)
- name, text, date, url, published, published_date, master
- atribut 'url' má klíč UNIQUE
- atribut 'master' bude sloužit k určení hlavní verze článku v případě verzování

Tag (tags)
- name, articles_count
- atribut 'articles_count' bude redundantní kvůli snížení počtu dotazů při načítání stránek
- atribut 'name' má klíč UNIQUE

Tag-článek (articles_tags)
- id_článku, id_tagu
- relační tabulka pro navázání tagu na článek

### 2.2 Model aplikace

Základní třídy pro operaci s databází:
- Simple\Repository\Repository
- Simple\Repository\BaseRepository
- Simple\Repository\BaseBindingRepository

Repozitáře:
- ArticlesRepository
- TagsRepository
- UsersRepository
