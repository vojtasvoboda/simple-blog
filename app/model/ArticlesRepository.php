<?php

namespace App\Model;

use Nette\Database\SqlLiteral;
use Simple\Repository\BaseRepository;

/**
 * Repozitář blogových článků
 *
 * @author Vojtěch Svoboda <www.vojtasvoboda.cz>
 */
class ArticlesRepository extends BaseRepository
{

    /**
     * Najde všechny publikované články
     *
     * @return \Nette\Database\Table\Selection
     */
    public function findAllPublished() {
        return $this->findBy(
            array(
                'published' => true,
                'published_date <= ?' => new SqlLiteral('NOW()')
            ))->order('id DESC');
    }

    /**
     * Najde jeden článek dle URL
     *
     * @param $url
     *
     * @return FALSE|\Nette\Database\Table\ActiveRow
     */
    public function findOnePublished($url)
    {
        return $this->findOneBy(
            array(
                'url' => $url,
                'published' => true,
                'published_date <= ?' => new SqlLiteral('NOW()')
            ));
    }

    /**
     * Find articles by query
     *
     * @param $query
     * @param $key
     *
     * @return \Nette\Database\Table\Selection
     */
    public function findFulltext($query, $key = 'text')
    {
        if ( empty($query) ) {
            return null;
        }
        return $this
            ->findAll()
            ->where(
                "(`name` LIKE ?) OR (LOWER(`" . $key . "`) LIKE ?)",
                "%" . strtolower($query) . "%",
                "%" . strtolower($query) . "%"
            );
    }

}
