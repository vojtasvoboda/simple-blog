<?php

namespace App\Model;

use Simple\Repository\BaseRepository;

/**
 * Repozitář tagů
 *
 * @author Vojtěch Svoboda <www.vojtasvoboda.cz>
 */
class TagsRepository extends BaseRepository
{

    /**
     * Najde jeden tag dle URL
     *
     * @param $url
     *
     * @return FALSE|\Nette\Database\Table\ActiveRow
     */
    public function findOneByUrl($url) {
        return $this->findOneBy(array('url' => $url));
    }

}
