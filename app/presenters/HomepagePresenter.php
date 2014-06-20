<?php

namespace App\Presenters;

use Nette,
    App\Model;

/**
 * Homepage presenter.
 */
class HomepagePresenter extends BasePresenter
{

    private $articlesRepository;

    public function __construct(\App\Model\ArticlesRepository $articlesRepository)
    {
        $this->articlesRepository = $articlesRepository;
    }

    public function renderDefault()
    {
        $this->template->articles = $this->articlesRepository->findAll();
    }

    public function renderDetail($slug)
    {
        $article = $this->articlesRepository->findOne($slug);
        if (!$article) {
            $this->setView('notfound');
        }
        $this->template->article = $article;
    }

}
