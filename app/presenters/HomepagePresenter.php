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

    private $tagsRepository;

    public function __construct(\App\Model\ArticlesRepository $articlesRepository,
                                \App\Model\TagsRepository $tagsRepository)
    {
        $this->articlesRepository = $articlesRepository;
        $this->tagsRepository = $tagsRepository;
    }

    public function renderDefault()
    {
        $this->template->articles = $this->articlesRepository->findAllPublished();
        $this->template->tags = $this->tagsRepository->findAll();
    }

    public function renderDetail($slug)
    {
        $article = $this->articlesRepository->findOnePublished($slug);
        if (!$article) {
            $this->setView('notfound');
        }
        $this->template->article = $article;
    }

}
