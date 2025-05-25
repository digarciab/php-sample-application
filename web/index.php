<?php

require_once __DIR__ . '/../vendor/autoload.php';

$usersService = require_once __DIR__ . '/../dic/users.php';

$requestUri = $_SERVER['REQUEST_URI'];

if ($requestUri !== '/') {
    $id = ltrim($requestUri, '/');
    $user = $usersService->getById($id);

    if ($user) {
        echo "<h1>{$user->name}</h1>";
        echo "<p>joined {$user->joined}</p>";
        exit;
    }

    http_response_code(404);
    echo "User not found";
    exit;
}

// Lógica original para mostrar listado
$lastJoinedUsers = $usersService->getLastJoined();

$format = require_once __DIR__ . '/../dic/negotiated_format.php';

switch ($format) {
    case "text/html":
        (new Views\Layout(
            "Twitter - Newcomers", new Views\Users\Listing($lastJoinedUsers), true
        ))();
        exit;

    case "application/json":
        header("Content-Type: application/json");
        echo json_encode($lastJoinedUsers);
        exit;
}

http_response_code(406);
