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

    private $searchResults = null;

    private $searchQuery = '';

    private $searchResultsCount = 0;

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

    /**
     * RSS action render
     */
    public function renderRss()
    {
        $lastUpdated = "";
        // get all articles
        $articles = $this->articlesRepository->findAllPublished();
        // get date of last udpated article
        if (!empty($articles)) {
            foreach($articles as $a) {
                $lastUpdated = $a->published_date;
                break;
            }
        }
        // data to template
        $this->template->articles = $articles;
        $this->template->lastUpdated = $lastUpdated;
    }

    public function actionSearch($q = '')
    {
        // get query, fix array query
        if (is_array($q)) {
            if(!empty($q)) {
                $q = $q[0];
            }
        }
        // find articles by query
        $this->searchResults = $this->articlesRepository->findFulltext($q);
        $this->searchResultsCount = sizeof($this->searchResults);
        $this->searchQuery = $q;
    }

    public function renderSearch($q = '')
    {
        $this->template->query = $this->searchQuery;
        $this->template->articles = $this->searchResults;
        $this->template->searchResultsCount = $this->searchResultsCount;
        $this->template->tags = $this->tagsRepository->findAll();
    }

    protected function createComponentSearchForm()
    {
        // create form from factory
        $form = new \App\Forms\SearchForm();
        $form->setValues(array('q' => $this->searchQuery));
        $form->onSuccess[] = $this->searchFormSubmitted;

        return $form;
    }

    /**
     * Search form submitted method
     *
     * @param \App\Forms\SearchForm $form
     */
    public function searchFormSubmitted(\App\Forms\SearchForm $form) {
        $values = $form->getValues(TRUE);
        $this->redirect("Homepage:search", array('q' => $values['q']));
    }

}
