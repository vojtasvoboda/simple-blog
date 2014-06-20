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
        $this->template->articles = $this->articlesRepository->findAllPublished();
    }

    public function renderDetail($slug)
    {
        $article = $this->articlesRepository->findOnePublished($slug);
        if (!$article) {
            $this->setView('notfound');
        }
        $this->template->article = $article;
    }

    protected function createTemplate($class = NULL)
    {
        $template = parent::createTemplate($class);
        // perex helper
        $template->getLatte()->addFilter('perex', function($s, $class = 'posthaven-more') {
            $startBreakpoint = strpos($s, '<hr class="' . $class);
            return mb_substr($s, 0, $startBreakpoint);
        });
        return $template;
    }

}
