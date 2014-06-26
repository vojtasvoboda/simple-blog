<?php

namespace App\Presenters;

use Nette,
	App\Model;


/**
 * Base presenter for all application presenters.
 */
abstract class BasePresenter extends Nette\Application\UI\Presenter
{

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
