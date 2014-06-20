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
     * Najde jeden článek dle URL
     *
     * @param $url
     *
     * @return FALSE|\Nette\Database\Table\ActiveRow
     */
    public function findOne($url)
    {
        return $this->findOneBy(
            array(
                'url' => $url,
                'published' => true,
                'published_date <= ?' => new SqlLiteral('NOW()')
            ));
    }

}
