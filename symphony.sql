-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : ven. 19 déc. 2025 à 07:02
-- Version du serveur : 8.4.7
-- Version de PHP : 8.3.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `symphony`
--

-- --------------------------------------------------------

--
-- Structure de la table `doctrine_migration_versions`
--

DROP TABLE IF EXISTS `doctrine_migration_versions`;
CREATE TABLE IF NOT EXISTS `doctrine_migration_versions` (
  `version` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `executed_at` datetime DEFAULT NULL,
  `execution_time` int DEFAULT NULL,
  PRIMARY KEY (`version`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `doctrine_migration_versions`
--

INSERT INTO `doctrine_migration_versions` (`version`, `executed_at`, `execution_time`) VALUES
('DoctrineMigrations\\Version20251216200714', '2025-12-16 20:08:08', 23),
('DoctrineMigrations\\Version20251216201935', '2025-12-16 20:20:13', 43),
('DoctrineMigrations\\Version20251216203830', '2025-12-16 20:39:10', 58),
('DoctrineMigrations\\Version20251216205216', '2025-12-16 20:52:27', 76),
('DoctrineMigrations\\Version20251216214452', '2025-12-16 21:45:02', 140);

-- --------------------------------------------------------

--
-- Structure de la table `messenger_messages`
--

DROP TABLE IF EXISTS `messenger_messages`;
CREATE TABLE IF NOT EXISTS `messenger_messages` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `body` longtext NOT NULL,
  `headers` longtext NOT NULL,
  `queue_name` varchar(190) NOT NULL,
  `created_at` datetime NOT NULL,
  `available_at` datetime NOT NULL,
  `delivered_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_75EA56E0FB7336F0` (`queue_name`),
  KEY `IDX_75EA56E0E3BD61CE` (`available_at`),
  KEY `IDX_75EA56E016BA31DB` (`delivered_at`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `order`
--

DROP TABLE IF EXISTS `order`;
CREATE TABLE IF NOT EXISTS `order` (
  `id` int NOT NULL AUTO_INCREMENT,
  `reference` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `status` varchar(50) NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_F5299398A76ED395` (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `order`
--

INSERT INTO `order` (`id`, `reference`, `created_at`, `status`, `user_id`) VALUES
(1, '6941d6e818989', '2025-12-16 22:02:16', 'created', 1),
(2, '6941d8a214b79', '2025-12-16 22:09:38', 'created', 1),
(3, '6942802bbc044', '2025-12-17 10:04:27', 'created', 2),
(4, '69446a176929b', '2025-12-18 20:54:47', 'created', 3);

-- --------------------------------------------------------

--
-- Structure de la table `order_item`
--

DROP TABLE IF EXISTS `order_item`;
CREATE TABLE IF NOT EXISTS `order_item` (
  `id` int NOT NULL AUTO_INCREMENT,
  `quantity` int NOT NULL,
  `price` double NOT NULL,
  `my_order_id` int NOT NULL,
  `product_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_52EA1F09BFCDF877` (`my_order_id`),
  KEY `IDX_52EA1F094584665A` (`product_id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `order_item`
--

INSERT INTO `order_item` (`id`, `quantity`, `price`, `my_order_id`, `product_id`) VALUES
(1, 1, 25, 1, 2),
(2, 1, 25, 2, 2),
(3, 1, 59.99, 3, 1),
(4, 1, 59.99, 4, 1);

-- --------------------------------------------------------

--
-- Structure de la table `product`
--

DROP TABLE IF EXISTS `product`;
CREATE TABLE IF NOT EXISTS `product` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` longtext,
  `price` double NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `product`
--

INSERT INTO `product` (`id`, `name`, `description`, `price`, `image`) VALUES
(1, 'Jean Slim Bleu', 'Jean denim robuste et élégant. Parfait pour un look décontracté ou habillé.', 59.99, 'jean.jpg'),
(2, 'T-shirt Blanc Premium', 'Un t-shirt en coton bio ultra confortable, coupe ajustée. Indispensable dans votre garde-robe.', 25, 'tshirt.jpg'),
(3, 'Casquette Vintage', 'Casquette style rétro, taille unique réglable. Protégez-vous du soleil avec style.', 15.5, 'casquette.jpg'),
(4, 'Sweat à Capuche Noir Minimaliste', 'Sweat unisexe en coton bio, coupe droite, intérieur molletonné doux, cordons ton sur ton', 49.9, NULL),
(5, 'Veste Bomber Streetwear', 'Veste bomber légère, fermeture zippée, poche manche, finition bord-côtes, couleur kaki ou noire.', 79.9, NULL),
(6, 'Sneakers Blanches Classic Everyday', 'Baskets basses blanches, semelle confortable, design minimal qui va avec toutes les tenues.', 69.9, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `reset_password_request`
--

DROP TABLE IF EXISTS `reset_password_request`;
CREATE TABLE IF NOT EXISTS `reset_password_request` (
  `id` int NOT NULL AUTO_INCREMENT,
  `selector` varchar(20) NOT NULL,
  `hashed_token` varchar(100) NOT NULL,
  `requested_at` datetime NOT NULL,
  `expires_at` datetime NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_7CE748AA76ED395` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `user`
--

DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(180) NOT NULL,
  `roles` json NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_IDENTIFIER_EMAIL` (`email`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `user`
--

INSERT INTO `user` (`id`, `email`, `roles`, `password`) VALUES
(1, 'test@test.com', '[]', '$2y$13$zzGGZgyypa62inaiEnuyoeNNDfYC1skfMdII1C0l2YRW2PVMaDOeC'),
(2, 'matthieuf94@gmail.com', '[]', '$2y$13$4aLPC3pFRe2QHCmMbg9E8uXARgHL13cvu0zN60OG2wOfNwA/QmQgu'),
(3, 'matthieu94f@gmail.com', '[\"ROLE_ADMIN\"]', '$2y$13$ynHmzL2XXpmagSGS8mtX2etQ5QFf1MPlWGnqBPhRXNNKNAM3T7UJu'),
(4, 'matthieu.feracho@efrei.net', '[]', '$2y$13$IOy3td2FjuehJ9sj474K3eKbXebwMVXJTI4B5vJIy3BUGDM1QKzK6');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
