<?php

namespace App\Controller;

use App\Entity\Order;
use App\Entity\OrderItem;
use App\Repository\ProductRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\RequestStack;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class OrderController extends AbstractController
{
    #[Route('/order/create', name: 'app_order_create')]
    public function create(
        RequestStack $requestStack, 
        ProductRepository $productRepository, 
        EntityManagerInterface $em
    ): Response
    {
        // On vérifie que l'utilisateur est connecté
        $user = $this->getUser();
        if (!$user) {
            // Si pas connecté, on renvoie vers la page de login
            return $this->redirectToRoute('app_login');
        }

        // On récupère le panier
        $session = $requestStack->getSession();
        $cart = $session->get('cart', []);

        // Si le panier est vide, on redirige vers la boutique
        if (empty($cart)) {
            return $this->redirectToRoute('app_home'); // ou app_product_index selon tes routes
        }

        // On crée la commande (Order)
        $order = new Order();
        $order->setUser($user);
        $order->setCreatedAt(new \DateTimeImmutable());
        $order->setReference(uniqid()); // Crée une réf unique (ex: 657a8b9c0d1e2)
        $order->setStatus('created'); // Statut par défaut

        // On dit à Doctrine de préparer la sauvegarde de la commande
        $em->persist($order);

        // On parcourt le panier pour créer les détails (OrderItem)
        foreach ($cart as $id => $quantity) {
            $product = $productRepository->find($id);

            if ($product) {
                $orderItem = new OrderItem();
                $orderItem->setProduct($product);
                $orderItem->setQuantity($quantity);
                $orderItem->setPrice($product->getPrice()); // On fige le prix du produit à l'instant T
                $orderItem->setMyOrder($order); // On lie l'article à la commande

                // On prépare la sauvegarde de l'article
                $em->persist($orderItem);
            }
        }

        //  On valide tout dans la base de données
        $em->flush();

        // On vide le panier de la session
        $session->remove('cart');

        //  On redirige vers une page de succès (ou la liste des commandes)
        // Pour l'instant on va juste afficher un message simple
        $this->addFlash('success', 'Votre commande a bien été enregistrée !');
        return $this->redirectToRoute('app_home');
    }

    #[Route('/my-orders', name: 'app_my_orders')]
    public function myOrders(EntityManagerInterface $em): Response
    {
        $user = $this->getUser();
        if (!$user) {
            return $this->redirectToRoute('app_login');
        }

        // On récupère les commandes de l'utilisateur
        // On les trie par date décroissante ('DESC') pour voir la dernière en premier
        $orders = $em->getRepository(Order::class)->findBy(
            ['user' => $user],
            ['createdAt' => 'DESC']
        );

        return $this->render('order/index.html.twig', [
            'orders' => $orders
        ]);
    }
}
