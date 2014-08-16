<?php

namespace Simple\Repository;

use Nette\Database\SqlLiteral;

/**
 * Předek repozitáře, který reprezentuje propojovací tabulku m:n
 * - a) např. photogaleries_categories (zařazení fotogalerií do kategorií)
 * -    nebo users_teams (zařazení hráčů do týmů)
 * - b) dědíme pouze od Repository, takže je to nezávislé na názvech sloupců
 * -    - jediné co se vyžaduje je sloupec created viz createItem()
 *
 * Použití:
 * a) Vytvořit propojovací repozitář a podědit BaseBindingRepository
 * b) nastavit $firstKey a $secondKey ideálně v pořadí dle názvu repozitáře
 *    - tj. pro propojovací repozitář UsersTeams nastavíme klíče
 *    - firstKey = users_id a secondKey = teams_id
 *
 * @author Vojtěch Svoboda <www.vojtasvoboda.cz>
 */
abstract class BaseBindingRepository extends Repository
{

    /** @var $firstKey První klíč */
    protected $firstKey;

    /** @var $secondKey Druhý klíč */
    protected $secondKey;

    /**
     * Vytvoření nové relace
     *
     * @param array data pro vložení
     *
     * @return string|int - chyba, nebo jednička (jako imitace správného vložení)
     */
    public function createItem($data)
    {
        // kontrola duplicit
        if ($this->isConnectionExist($data[$this->firstKey], $data[$this->secondKey])) return "Takové zařazení již existuje.";
        // přidáme datum vytvoření
        $data['created'] = new SqlLiteral("NOW()");
        $response = $this->insert($data);
        return ($response === false) ? "Záznam se nepodařilo zařadit." : 1;
    }

    /**
     * Vrátí jestli relace již existuje
     *
     * @param type $firstValue
     * @param type $secondValue
     *
     * @return boolean
     */
    public function isConnectionExist($firstValue, $secondValue)
    {
        return !!$this->findOneBy(array($this->firstKey => $firstValue,
            $this->secondKey => $secondValue));
    }

    /**
     * Vrátí seznam relací dle prvního klíče
     *
     * @param int $firstValue
     *
     * @return Selection|FALSE
     */
    public function getByFirstKey($firstValue)
    {
        return $this->findAll()->where(array($this->firstKey => $firstValue));
    }

    /**
     * Vrátí seznam relací dle druhého klíče
     *
     * @param int $secondValue
     *
     * @return Selection|FALSE
     */
    public function getBySecondKey($secondValue)
    {
        return $this->findAll()->where(array($this->secondKey => $secondValue));
    }

    /**
     * Vrátí seznam relací dle seznam prvních klíčů
     *
     * @param array $firstValues
     *
     * @return Selection|FALSE
     */
    public function getByFirstKeys($firstValues)
    {
        return $this->findAll()->where($this->firstKey, $firstValues);
    }

    /**
     * Vrátí seznam relací dle seznamu druhých klíčů
     *
     * @param array $secondValues
     *
     * @return Selection|FALSE
     */
    public function getBySecondKeys($secondValues)
    {
        return $this->findAll()->where($this->secondKey, $secondValues);
    }

    /**
     * Smazání relace
     *
     * @param int $firstValue
     * @param int $secondValue
     *
     * @return int|FALSE
     */
    public function disconnect($firstValue, $secondValue)
    {
        return $this->findAll()->where(
            array(
                $this->firstKey => $firstValue,
                $this->secondKey => $secondValue))
            ->delete();
    }

}
