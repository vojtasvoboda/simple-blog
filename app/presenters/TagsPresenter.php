<?php

namespace App\Presenters;

use Nette,
    App\Model;

/**
 * Tag presenter.
 */
class TagsPresenter extends BasePresenter
{

    private $tagsRepository;

    public function __construct(\App\Model\TagsRepository $tagsRepository)
    {
        $this->tagsRepository = $tagsRepository;
    }

    public function renderDefault()
    {
        $this->template->tags = $this->tagsRepository->findAll();
    }

    public function renderDetail($slug)
    {
        $tag = $this->tagsRepository->findOneByUrl($slug);
        if (!$tag) {
            $this->setView('notfound');
        }
        $this->template->tag = $tag;
    }

}
