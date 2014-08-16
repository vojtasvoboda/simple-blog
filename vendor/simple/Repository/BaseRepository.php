<?php

namespace Simple\Repository;

use Nette\Database\SqlLiteral,
    Nette\Utils\Strings;

/**
 * Základní repozitář implementující základní funkce nad repozitářem:
 * - a) nadstavba nad základní abstraktní repozitář Simple\Repository\Repository (který je pouze obálka nad tabulkou)
 * - b) implementuje základní ukládání, editaci a mazání položek dané tabulky
 * - c) může používat tyto sloupce: id, name, active, modified_user_id, created, modified
 * - d) tzn. jedná se o funkce, které jsou již nějakým způsobem závislé na jednotném pojmenování sloupců v tabulce
 *
 * @author Vojtěch Svoboda <www.vojtasvoboda.cz>
 */
abstract class BaseRepository extends Repository
{

    /**
     * Vložení nové položky
     * Připraví položky pro vložení a vloží položku
     *
     * @param array data pro vložení
     *
     * @return string|int - chyba, nebo id vloženého řádku
     */
    public function createItem($data)
    {
        // kontrola duplicitní URL
        if (isset($data->url)) {
            // pokud se nepodařila URL vygenerovat přes getUniqueUrl, tak je FALSE
            if ($data->url === FALSE || $this->isUrlExist($data->url)) return "Tato URL, nebo název stránky již existuje, zvolte prosím jiný!";
        }
        // uložíme záznam
        $response = $this->insertItem($data);
        // musí se vložit právě jeden řádek, který dostane nějaké ID
        return ($response === false) ? "Záznam se nepodařilo uložit." : $response->id;
    }

    /**
     * Připraví data pro vložení a vloží položku
     *
     * @param array $data
     *
     * @return response
     */
    protected function insertItem($data)
    {
        // přidáme datum vytvoření
        if (is_array($data)) {
            $data['created'] = new SqlLiteral("NOW()");
        } else {
            $data->created = new SqlLiteral("NOW()");
        }
        $response = $this->insert($data);
        return $response;
    }

    /**
     * Úprava položky
     *
     * @param type $id ID položky
     * @param type $data Nová data
     *
     * @return FALSE|int - chyba, nebo počet ovlivněných řádků
     */
    public function updateItem($id, $data)
    {

        // kontrola parametrů
        if (empty($id) OR !is_numeric($id)) {
            throw new BadMethodCallException("Metoda updateItem musí být volána s parametrem ID.");
        }

        // kontrola duplicitní URL
        if (isset($data->url)) {
            $url = $data->url;
            if ($this->isUrlExist($url, $id)) return "Tato URL již existuje, zvolte prosím jinou!";
        }

        // přidáme datum úpravy
        if (is_array($data)) {
            $data['modified'] = new SqlLiteral("NOW()");
        } else {
            $data->modified = new SqlLiteral("NOW()");
        }
        $response = $this->update($id, $data);

        // vrací počet upravených řádků, nebo FALSE v případě chyby
        return ($response === false) ? "Záznam se nepodařilo upravit." : $response;
    }

    /**
     * Vymazání položky
     *
     * @param int ID polozky
     *
     * @return string|boolean - chyba, nebo počet smazaných řádků
     */
    public function deleteItem($id, $parentId = 0)
    {
        // kontrola jestli existuje
        $item = $this->findOneBy(array("id" => $id));
        if (!$item) return "Tato položka nelze smazat, protože neexistuje.";
        // smažeme položku
        $response = $this->delete($id);
        // vrací počet ovlivněných řádků, nebo FALSE v případě chyby
        return ($response === false) ? "Záznam se nepodařilo smazat." : $response;
    }

    /**
     * Vrátí všechny aktivní položky
     * @return type
     */
    public function findAllActive() {
        return $this->findBy(array("active" => true));
    }

    /**
     * Vygeneruje unikátní URL
     *
     * @param type $name
     */
    public function getUniqueUrl($name, $limit = 100)
    {
        if (empty($name)) return false;
        $loops = 0;
        $name_tmp = $name;
        do {
            $url = Strings::webalize($name);
            $loops++;
            $name = $name_tmp . "-" . $loops;
        } while ($this->isUrlExist($url) AND ($loops <= $limit));
        // pokud bylo průchodů více jak limit, tak vrátíme false
        if ($loops > $limit) return false;
        return $url;
    }

    /**
     * Zjistí, jestli existuje záznam s daným URL
     *
     * @param string $url - kontrolovaná URL
     * @param string $key - název sloupce podle kterého se kontroluje URL
     * @param int $id - id které chceme z hledání vyloučit (např. při úpravě položky)
     *
     * @return boolean
     */
    public function isUrlExist($url, $id = NULL, $key = "url")
    {
        if ($id !== NULL AND $id > 0 AND is_numeric($id)) {
            return !!$this->findOneBy(array($key => $url, "id <> ?" => $id));
        } else {
            return !!$this->findOneBy(array($key => $url));
        }
    }

}
