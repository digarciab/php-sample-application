<?php

return new Service\UsersService(
    require(__DIR__ . "/../config-dev/db-connection.php")
);
