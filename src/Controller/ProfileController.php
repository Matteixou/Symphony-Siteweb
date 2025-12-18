<?php

namespace App\Controller;

use App\Entity\User;
use App\Form\ProfileType;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_USER')]
final class ProfileController extends AbstractController
{
    #[Route('/profile', name: 'app_profile', methods: ['GET', 'POST'])]
    public function index(
        Request $request,
        EntityManagerInterface $em,
        UserPasswordHasherInterface $passwordHasher
    ): Response {
        /** @var User $user */
        $user = $this->getUser();
        if (!$user) {
            return $this->redirectToRoute('app_login');
        }

        $form = $this->createForm(ProfileType::class, $user);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            // gestion du changement de mot de passe si les champs sont remplis
            $passwordData = $form->get('passwordChange');

            $oldPassword = $passwordData->get('oldPassword')->getData();
            $newPassword = $passwordData->get('newPassword')->getData();

            if ($oldPassword || $newPassword) {
                // si l'un est rempli, on vérifie tout
                if (empty($oldPassword) || empty($newPassword)) {
                    $this->addFlash('danger', 'Remplis tous les champs du mot de passe pour le modifier.');
                    return $this->redirectToRoute('app_profile');
                }

                if (!$passwordHasher->isPasswordValid($user, $oldPassword)) {
                    $this->addFlash('danger', 'Mot de passe actuel incorrect.');
                    return $this->redirectToRoute('app_profile');
                }

                $hashed = $passwordHasher->hashPassword($user, $newPassword);
                $user->setPassword($hashed);
            }

            // email déjà mis à jour via le formulaire (data_class User)
            $em->flush();
            $this->addFlash('success', 'Profil mis à jour.');

            return $this->redirectToRoute('app_profile');
        }

        return $this->render('profile/index.html.twig', [
            'form' => $form->createView(),
        ]);
    }
}
