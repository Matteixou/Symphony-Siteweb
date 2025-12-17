<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route; // <--- Note bien "Attribute"

class TestProductController extends AbstractController
{
    #[Route('/test-product', name: 'test_product')]
    public function index(): Response
    {
        return new Response('Ça marche ! Le routing est réparé.');
    }
}
