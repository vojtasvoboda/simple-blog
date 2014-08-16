<?php

namespace App\Forms;

use Nette\Application\UI\Form,
    Nette\ComponentModel\IContainer;

class SearchForm extends Form {

    public function __construct(IContainer $parent = NULL, $name = NULL) {

        parent::__construct($parent, $name);

        // formulář bude GET
        $this->setMethod(Form::GET);

        // inline
        $this->getElementPrototype()->class('inline');

        // prvky
        $this->addText('q', '')
            ->setAttribute('class', 'q')
            ->setAttribute('placeholder', 'Vyhledávání');
        $this->addSubmit('submit', 'Ok')
            ->setAttribute('class', 'btn btn-primary');
    }

}