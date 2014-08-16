<?php

namespace App;

use Nette,
    Nette\Application\Routers\RouteList,
    Nette\Application\Routers\Route,
    Nette\Application\Routers\SimpleRouter;


/**
 * Router factory.
 */
class RouterFactory
{

    /**
     * @return \Nette\Application\IRouter
     */
    public function createRouter()
    {
        if (function_exists('apache_get_modules') && in_array('mod_rewrite', apache_get_modules())) {

            $router = new RouteList();
            $router[] = new Route('index.php', 'Front:Pages:default', Route::ONE_WAY);
            $router[] = new Route('', 'Homepage:default');
            $router[] = new Route('tags/', 'Tags:default');
            $router[] = new Route('tags/<slug>', 'Tags:detail');
            $router[] = new Route('<slug>', 'Homepage:detail');
            $router[] = new Route('<presenter>/<action>[/<id>]', 'Homepage:default');

        } else {
            $router = new SimpleRouter('Homepage:default');
        }

        return $router;
    }

}
