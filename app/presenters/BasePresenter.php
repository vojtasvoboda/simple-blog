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
        // perex Latte helper
        $template->getLatte()->addFilter('perex', function($s, $class = 'posthaven-more') {
            $startBreakpoint = strpos($s, '<hr class="' . $class);
            return mb_substr($s, 0, $startBreakpoint);
        });
        // remove perex divider Latte helper
        $template->getLatte()->addFilter('removeMoreClass', function($s, $class = 'posthaven-more') {
            return str_replace('<hr class="' . $class . '">', '', $s);
        });
        return $template;
    }

}
