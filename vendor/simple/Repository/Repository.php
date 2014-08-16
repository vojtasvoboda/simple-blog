<?php

namespace Simple\Repository;

use Nette\Database\Context;

/**
 * Abstraktní předek všech repozitářů
 * - a) nejzákladnější obálka nad Db tabulkou
 * - b) konvence je, že jedna Db tabulka = jeden repozitář
 * - c) pokud je v názvu funkce "one" tak se vrací jeden řádek (ActiveRow),
 * -    jinak se vrací více řádků (Selection)
 *
 * @author Vojtěch Svoboda <www.vojtasvoboda.cz>
 */
abstract class Repository extends \Nette\Object
{

    /** @var \Nette\Database\Connection $connection */
    protected $connection;

    /**
     * Constructor
     *
     * @param \Nette\Database\Context $db
     *
     * @throws \Nette\InvalidStateException
     */
    public function __construct(Context $db)
    {
        $this->connection = $db;
    }

    /**
     * Vrací celou tabulku z databáze
     *
     * @return \Nette\Database\Table\Selection
     */
    protected function getTable()
    {
        $classname = join('', array_slice(explode('\\', get_class($this)), -1));
        $table = $this->getTableName($classname);
        return $this->connection->table($table);
    }

    /**
     * Vrací název databázové tabulky související s názvem třídy:
     * - odstraní slovo "Repository" a dále všechna velká písmena přepíše na malé oddělené podtržítkem:
     * - OffersProductsRepository -> offers_products, ProductsLogsRepository -> products_logs
     *
     * @param string $name Název repozitáře
     *
     * @return string Název databázové tabulky
     */
    private function getTableName($name)
    {
        // odstraníme "Repository" pokud je na konci názvu
        $name = strtr($name, array("Repository" => ""));
        // rozdělíme dle velkých písmen
        preg_match_all('/[A-Z][^A-Z]*/', $name, $m);
        // pokud se nepodařilo rozdělit dle velkých písmen, vrátíme
        if (empty($m[0])) return $name;
        // vrátíme název spojený podtržítkama
        return strtolower(implode("_", $m[0]));
    }

    /**
     * Vrací všechny záznamy z databáze
     *
     * @return \Nette\Database\Table\Selection
     */
    public function findAll()
    {
        return $this->getTable();
    }

    /**
     * Vrací vyfiltrované záznamy na základě vstupního pole
     * (pole array('name' => 'David') se převede na část SQL dotazu WHERE name = 'David')
     *
     * @param array $by
     *
     * @return \Nette\Database\Table\Selection
     */
    public function findBy(array $by)
    {
        return $this->getTable()->where($by);
    }

    /**
     * To samé jako findBy akorát vrací vždy jen jeden záznam
     *
     * @param array $by
     *
     * @return \Nette\Database\Table\ActiveRow|FALSE
     */
    public function findOneBy(array $by)
    {
        return $this->findBy($by)->limit(1)->fetch();
    }

    /**
     * Vrací záznam s daným primárním klíčem
     *
     * @param int $id
     * @param boolean $force Force to return all columns
     *
     * @return \Nette\Database\Table\ActiveRow|FALSE
     */
    public function find($id, $force = false)
    {
        if ($force) {
            return self::findAll()->select('*')->get($id);
        }
        return $this->getTable()->get($id);
    }

    /**
     * Vloží do tabulky jeden řádek
     *
     * @param mixed array($column => $value)|Traversable for single row insert or Selection|string for INSERT ... SELECT
     *
     * @return ActiveRow or FALSE in case of an error or number of affected rows for INSERT ... SELECT
     */
    public function insert($data)
    {
        return $this->getTable()->insert($data);
    }

    /**
     * Upraví záznam dle zadaného ID
     *
     * @param int $id ID záznamu který chceme upravit
     * @param array $data Data, která chceme nahradit
     *
     * @return int number of affected rows or FALSE in case of an error
     */
    public function update($id, $data)
    {
        return $this->getTable()->wherePrimary($id)->update($data);
    }

    /**
     * Smaže jeden řádek dle zadaného ID
     *
     * @param int $id ID mazaného řádku
     *
     * @return int number of affected rows or FALSE in case of an error
     */
    public function delete($id)
    {
        return $this->getTable()->wherePrimary($id)->delete();
    }

}
