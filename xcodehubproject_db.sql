-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 09, 2024 at 12:58 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `xcodehubproject_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `carts`
--

CREATE TABLE `carts` (
  `cart_id` int(11) NOT NULL,
  `posted_by` varchar(300) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `user_id` varchar(300) DEFAULT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `cart_price` decimal(10,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `carts`
--

INSERT INTO `carts` (`cart_id`, `posted_by`, `product_id`, `user_id`, `quantity`, `cart_price`, `created_at`, `updated_at`) VALUES
(137, 'xcode', 17, 'xcode', 3, 119.97, '2024-09-25 13:22:11', '2024-09-25 13:22:45'),
(138, 'xcode', 11, 'xcode', 8, 799.92, '2024-09-25 13:22:21', '2024-09-25 14:05:00'),
(139, 'xcode', 13, 'xcode', 7, 1049.93, '2024-09-25 13:23:17', '2024-09-29 04:25:36');

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `id` int(11) NOT NULL,
  `name` varchar(300) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`id`, `name`, `created_at`) VALUES
(1, 'Clothing', '2024-10-23 09:59:54'),
(2, 'Shoes', '2024-10-23 09:59:54'),
(3, 'Electronics', '2024-10-23 09:59:54'),
(4, 'Beauty', '2024-10-23 09:59:54'),
(5, 'Gadget', '2024-10-23 09:59:54'),
(6, 'Food & Snacks', '2024-10-23 09:59:54'),
(7, 'Jewelry & Watches', '2024-10-23 09:59:54'),
(8, 'Baby & Toys', '2024-10-23 09:59:54'),
(9, 'Services', '2024-10-23 09:59:54');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `cart_id` int(11) DEFAULT NULL,
  `user_id` varchar(300) DEFAULT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `order_status` enum('processing','shipped','delivered','cancelled') DEFAULT 'processing',
  `payment_status` enum('pending','completed','failed') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `payment_id` int(11) NOT NULL,
  `order_id` int(11) DEFAULT NULL,
  `payment_method` varchar(50) DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_status` enum('pending','completed','failed') DEFAULT 'pending',
  `transaction_id` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `product_user_id` varchar(300) DEFAULT NULL,
  `ref_id` varchar(300) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  `currency` varchar(300) DEFAULT '₦',
  `price` decimal(10,2) NOT NULL,
  `old_price` decimal(10,2) DEFAULT NULL,
  `percentages` decimal(5,2) DEFAULT NULL,
  `view_count` int(11) DEFAULT 0,
  `posted_by` varchar(300) DEFAULT 'xcode',
  `status` enum('pending','active','suspended') NOT NULL DEFAULT 'pending',
  `post_status` varchar(300) NOT NULL DEFAULT 'normal' COMMENT 'normal, sponsored',
  `image_urls` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`image_urls`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `product_user_id`, `ref_id`, `name`, `description`, `category`, `currency`, `price`, `old_price`, `percentages`, `view_count`, `posted_by`, `status`, `post_status`, `image_urls`, `created_at`, `updated_at`) VALUES
(11, 'xcode', '78JZ38', 'Product 1', 'Description of Product 1', 'Clothing', '₦', 99.99, 109.99, 10.00, 0, 'xcode', 'active', 'normal', '[\"b-product1_df1a761e-c3ce-40bc-b20e-55662bf332a5_grandefef8.jpg\", \"flycam_mediuma905.jpg\", \"b-product2_grandec816.jpg\", \"flycam_mediuma905.jpg\"]', '2025-07-02 00:00:24', '2024-10-23 03:44:12'),
(12, 'fred', '78JZ38', 'Product 2', 'Description of Product 2', 'Clothing', '₦', 49.99, 59.99, 20.00, 0, 'fred', 'active', 'normal', '[\"b-product3_grande5cfa.jpg\", \"b-product4_grande03a2.jpg\", \"flycam_mediuma905.jpg\"]', '2024-07-02 00:00:24', '2024-10-22 13:53:06'),
(13, 'xcode', '78JZ38', 'Product 3', 'Description of Product 3', 'Electronics', '₦', 149.99, 169.99, 12.00, 0, 'xcode', 'active', 'normal', '[\"b-product403a2.jpg\", \"fujifilm_grande85e9.jpg\", \"glass1_medium0189.jpg\"]', '2024-07-02 00:00:24', '2024-09-06 12:45:05'),
(14, 'james', '478JZ38', 'Product 4', 'Description of Product 4', 'Gadget', '₦', 29.99, 0.00, 0.00, 0, 'james', 'pending', 'sponsored', '[\"glass3_grande05f0.jpg\", \"glass222b1.jpg\", \"headphone_medium467c.jpg\"]', '2024-07-02 00:00:24', '2024-10-22 13:53:12'),
(15, 'xcode123', '78JZ38', 'Product 5', 'Description of Product 5', 'Gadget', '₦', 79.99, 89.99, 11.00, 0, 'xcode123', 'active', 'normal', '[\"headphone5_medium4c20.jpg\", \"iphone_2e77f.jpg\", \"b-product1_df1a761e-c3ce-40bc-b20e-55662bf332a5_grandefef8.jpg\"]', '2024-07-02 00:00:24', '2024-10-22 13:53:18'),
(16, 'facl', '78JZ38', 'Product 6', 'Description of Product 6', 'Gadget', '₦', 199.99, 219.99, 9.00, 0, 'facl', 'active', 'sponsored', '[\"b-product2_grandec816.jpg\", \"flycam_mediuma905.jpg\", \"b-product3_grande5cfa.jpg\"]', '2024-07-02 00:00:24', '2024-10-22 13:53:27'),
(17, 'xcode', '78JZ38', 'Product 7', 'Description of Product 7', 'Gadget', '₦', 39.99, 0.00, 0.00, 0, 'xcode', 'pending', 'normal', '[\"fujifilm_grande85e9.jpg\", \"glass1_medium0189.jpg\", \"glass3_grande05f0.jpg\"]', '2024-07-02 00:00:24', '2024-09-06 12:45:33'),
(18, 'xcode', '78JZ38', 'Product 8', ' neque sit, delectus quia blanditiis fugit sequi aperiam in quo? <b>Cumque</b> dicta sequi earum a quaerat! Aspernatur laboriosam id deserunt velit dolor eaque soluta animi iusto, nihil consequuntur quia vitae voluptatibus ducimus, veritatis consectetur accusantium suscipit minima error repudiandae ipsum ea molestiae! Aliquid voluptate repellendus doloremque nulla minus quis suscipit dolorem temporibus nemo ullam illo vero, odit quo amet dolorum modi deserunt ratione, accusantium debitis tempora veritatis? Eveniet saepe inventore sequi porro iusto laboriosam cumque.\n', 'Electronics', '₦', 119.99, 139.99, 14.00, 0, 'facl', 'active', 'sponsored', '[\"glass222b1.jpg\", \"headphone5_medium4c20.jpg\", \"headphone_medium467c.jpg\",\"headphone_medium467c.jpg\", \"headphone5_medium4c20.jpg\"]', '2024-07-02 00:00:24', '2024-09-06 12:45:21'),
(19, 'facl', '78JZ38', 'Product 9', 'Description of Product 9', 'Electronics', '₦', 69.99, 0.00, 0.00, 0, 'facl', 'pending', 'normal', '[\"iphone_2e77f.jpg\", \"b-product1_df1a761e-c3ce-40bc-b20e-55662bf332a5_grandefef8.jpg\", \"b-product2_grandec816.jpg\"]', '2024-07-02 00:00:24', '2024-10-22 13:53:23'),
(20, 'xcode', '78JZ38', 'Product 10', 'Description of Product 10', 'Electronics', '₦', 149.99, 0.00, 0.00, 0, 'xcode', 'pending', 'sponsored', '[\"flycam_mediuma905.jpg\", \"b-product3_grande5cfa.jpg\", \"b-product4_grande03a2.jpg\"]', '2024-07-02 00:00:24', '2024-09-06 12:45:27'),
(21, 'xcode', '78JZ38', 'Product 11', 'Description of Product 11', 'Category 2', '₦', 99.99, 0.00, 0.00, 0, 'xcode', 'pending', 'normal', '[\"flycam_mediuma905.jpg\", \"b-product1_df1a761e-c3ce-40bc-b20e-55662bf332a5_grandefef8.jpg\", \"fujifilm_grande85e9.jpg\"]', '2024-07-02 00:00:24', '2024-07-02 00:00:24'),
(22, 'xcode', '78JZ38', 'Product 12', 'Description of Product 12', 'Electronics', '₦', 179.99, 0.00, 0.00, 0, 'xcode', 'pending', 'sponsored', '[\"glass1_medium0189.jpg\", \"glass3_grande05f0.jpg\", \"glass222b1.jpg\"]', '2024-07-02 00:00:24', '2024-09-06 12:45:23'),
(23, 'xcode', '78JZ38', 'Product 13', 'Description of Product 13', 'Category 1', '₦', 59.99, 0.00, 0.00, 0, 'xcode', 'pending', 'normal', '[\"headphone_medium467c.jpg\", \"headphone5_medium4c20.jpg\", \"iphone_2e77f.jpg\"]', '2024-07-02 00:00:24', '2024-07-02 00:00:24');

-- --------------------------------------------------------

--
-- Table structure for table `ratings`
--

CREATE TABLE `ratings` (
  `rating_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `user_id` varchar(300) NOT NULL,
  `rating_value` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ratings`
--

INSERT INTO `ratings` (`rating_id`, `product_id`, `user_id`, `rating_value`, `created_at`, `updated_at`) VALUES
(53, 23, 'xcode', 4, '2024-07-08 18:03:27', '2024-07-08 18:03:27'),
(54, 11, '2', 3, '2024-07-08 18:03:27', '2024-07-08 18:03:27'),
(55, 12, '3', 4, '2024-07-08 18:03:27', '2024-07-08 18:03:27'),
(56, 13, 'xcode', 5, '2024-07-08 18:03:27', '2024-07-08 18:03:27'),
(57, 14, 'xcode', 4, '2024-07-08 18:03:27', '2024-07-08 18:03:27'),
(58, 15, '2', 3, '2024-07-08 18:03:27', '2024-07-08 18:03:27'),
(59, 16, '3', 5, '2024-07-08 18:03:27', '2024-07-08 18:03:27'),
(60, 17, '2', 4, '2024-07-08 18:03:27', '2024-07-08 18:03:27');

-- --------------------------------------------------------

--
-- Table structure for table `recently_viewed`
--

CREATE TABLE `recently_viewed` (
  `id` int(11) NOT NULL,
  `user_id` varchar(300) NOT NULL,
  `product_id` varchar(300) NOT NULL,
  `date_created` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reports`
--

CREATE TABLE `reports` (
  `id` int(11) NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `issue_type` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `viewed` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reports`
--

INSERT INTO `reports` (`id`, `full_name`, `email`, `issue_type`, `description`, `created_at`, `viewed`) VALUES
(1, 'Fred James', 'admin@gmail.com', 'feedback', 'lormejadkfjl  adfsdf', '2024-09-17 13:20:45', 0),
(2, 'Frj Kd,ls', 'admin@gmail.com', 'technical', 'lormejadkfjl  adfsdf', '2024-09-17 13:21:06', 0),
(3, 'dasfa', 'adsf@dfa.f', 'account', 'asdf', '2024-09-17 13:21:28', 0);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `user_id` varchar(300) NOT NULL,
  `balance` decimal(10,2) DEFAULT 0.00,
  `username` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `pin` int(11) NOT NULL,
  `role` enum('customer','vendor') NOT NULL DEFAULT 'customer' COMMENT 'customer,vendor',
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `currency` varchar(300) NOT NULL DEFAULT '&#8358;',
  `profile_image` varchar(255) DEFAULT NULL,
  `bio` text DEFAULT NULL,
  `business_name` varchar(255) DEFAULT NULL,
  `business_address` varchar(255) DEFAULT NULL,
  `status` enum('pending','approved','suspended') NOT NULL DEFAULT 'pending' COMMENT 'pending, approved, suspended',
  `vendor_status` enum('pending','approved','','') DEFAULT 'pending' COMMENT 'pending, approved',
  `ip_address` varchar(45) DEFAULT NULL,
  `page_views` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `user_id`, `balance`, `username`, `email`, `password`, `pin`, `role`, `first_name`, `last_name`, `address`, `city`, `state`, `country`, `phone`, `currency`, `profile_image`, `bio`, `business_name`, `business_address`, `status`, `vendor_status`, `ip_address`, `page_views`, `created_at`, `updated_at`) VALUES
(1, 'xcode', 0.00, 'xcode', 'admin@gmail.com', 'Orji5997733', 1234, 'vendor', 'James', 'Fred', '123 Main St1', 'New York1', 'NY1', 'USA1', '+2349012527321', '&#8358;', 'file-1726516337686.jpg', '<b>@Lorem </b> ipsum dolor sit amet consectetur adipisicing elit. Consectetur tempore repellendus delectus, eligendi dicta quibusdam quidem adipisci ut, illum vero exercitationem. Cupiditate ad fugiat magnam esse eligendi at nostrum eaque!\n<script>\n    alert(\'hi\')\n    window.location.href= \"http://google.com\"\n</script>', 'Business 11', '456 Business Ave1', 'pending', 'approved', '102.89.82.210', 0, '2024-07-02 00:04:06', '2024-10-31 00:36:06'),
(2, 'fred', 0.00, 'fred', 'admin123@gmail.com', 'Orji5997733@', 0, 'vendor', 'User', 'Two', '456 Elm St', 'Los Angeles', 'CA', 'USA', '+1987654321', '&#8358;', 'istockphoto-1072528872-612x612.jpg', 'This is the bio for User Two.', 'Business 2', '789 Enterprise Blvd', 'pending', 'pending', '138.199.7.226', 0, '2024-07-02 00:04:06', '2024-09-29 04:12:16'),
(3, 'facl', 0.00, 'facl', 'user3@example.com', 'password3', 0, 'vendor', 'User', 'Three', '789 Oak St', 'Chicago', 'IL', 'USA', '+1122334455', '&#8358;', 'baldx.png', 'This is the bio for User Three.', 'Business 3', '1010 Commerce St', 'pending', 'pending', '192.168.1.3', 0, '2024-07-02 00:04:06', '2024-09-28 17:51:28');

-- --------------------------------------------------------

--
-- Table structure for table `user_login_activity`
--

CREATE TABLE `user_login_activity` (
  `id` int(11) NOT NULL,
  `user_id` varchar(300) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `ip_address2` varchar(300) NOT NULL,
  `device` varchar(255) NOT NULL,
  `browser` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_login_activity`
--

INSERT INTO `user_login_activity` (`id`, `user_id`, `ip_address`, `ip_address2`, `device`, `browser`, `created_at`) VALUES
(31, 'xcode', '149.22.84.143', '10.240.0.69', 'Generic Smartphone 0.0.0', 'Chrome Mobile 128.0.0', '2024-09-19 16:40:53'),
(32, 'xcode', '185.177.124.191', '::1', 'iPhone 0.0.0', 'Mobile Safari 15.0.0', '2024-09-19 16:46:13'),
(33, 'xcode', '185.177.124.191', '::1', 'iPhone 0.0.0', 'Mobile Safari 15.0.0', '2024-09-19 16:48:07'),
(34, 'xcode', '149.22.84.143', '10.240.3.196', 'Generic Smartphone 0.0.0', 'Chrome Mobile 128.0.0', '2024-09-19 16:48:50'),
(35, '2', '149.22.84.143', '10.240.3.196', 'Generic Smartphone 0.0.0', 'Chrome Mobile 128.0.0', '2024-09-19 16:50:06'),
(36, 'xcode', '185.177.124.191', '::1', 'iPhone 0.0.0', 'Mobile Safari 15.0.0', '2024-09-19 16:57:02'),
(37, 'xcode', '185.177.124.191', '::1', 'iPhone 0.0.0', 'Mobile Safari 15.0.0', '2024-09-19 16:57:36'),
(38, 'xcode', '185.177.124.191', '::1', 'iPhone 0.0.0', 'Mobile Safari 15.0.0', '2024-09-19 16:57:59'),
(39, 'xcode', '185.177.124.191', '::1', 'iPhone 0.0.0', 'Mobile Safari 15.0.0', '2024-09-19 16:58:45'),
(40, 'xcode', '185.177.124.191', '::1', 'iPhone 0.0.0', 'Mobile Safari 15.0.0', '2024-09-19 17:05:11'),
(41, 'xcode', '185.177.124.191', '::1', 'iPhone 0.0.0', 'Mobile Safari 15.0.0', '2024-09-19 17:06:01'),
(42, 'xcode', '185.177.124.191', '::1', 'iPhone 0.0.0', 'Mobile Safari 15.0.0', '2024-09-19 17:11:41'),
(43, '2', '149.22.84.143', '10.240.1.166', 'Generic Smartphone 0.0.0', 'Chrome Mobile 128.0.0', '2024-09-19 17:18:39'),
(44, '2', '149.22.84.143', '10.240.1.166', 'Generic Smartphone 0.0.0', 'Chrome Mobile 128.0.0', '2024-09-19 17:18:41'),
(45, 'xcode', '185.177.124.191', '::1', 'iPhone 0.0.0', 'Mobile Safari 15.0.0', '2024-09-19 17:21:23'),
(46, 'xcode', '185.177.124.191', '::1', 'iPhone 0.0.0', 'Mobile Safari 15.0.0', '2024-09-19 17:22:03'),
(47, 'xcode', '185.177.124.191', '::1', 'iPhone 0.0.0', 'Mobile Safari 15.0.0', '2024-09-19 17:25:36'),
(48, 'xcode', '185.177.124.191', '::1', 'iPhone 0.0.0', 'Mobile Safari 15.0.0', '2024-09-19 17:25:48'),
(49, 'xcode', '169.150.196.151', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-21 15:50:34'),
(50, 'xcode', '169.150.196.151', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-21 15:59:05'),
(51, 'xcode', '169.150.196.151', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-21 15:59:33'),
(52, 'xcode', '89.38.97.206', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-21 18:03:53'),
(53, 'xcode', '89.38.97.206', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-21 18:05:05'),
(54, 'xcode', '89.38.97.206', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-21 18:07:45'),
(55, 'xcode', '89.38.97.206', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-21 18:08:12'),
(56, 'xcode', '89.38.97.206', '::ffff:127.0.0.1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-21 18:08:51'),
(57, 'xcode', '89.38.97.206', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-21 18:09:22'),
(58, 'xcode', '212.102.51.116', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-21 20:30:17'),
(59, 'xcode', '212.102.51.116', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-21 20:32:16'),
(60, 'xcode', '212.102.51.116', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-21 20:39:20'),
(61, 'xcode', '212.102.51.116', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-21 20:40:48'),
(62, 'xcode', '212.102.51.116', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-21 20:49:16'),
(63, 'xcode', '212.102.51.116', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-21 20:54:37'),
(64, 'xcode', '212.102.51.116', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-21 21:07:54'),
(65, 'xcode', '212.102.51.116', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-21 21:18:21'),
(66, 'xcode', '212.102.51.116', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-21 21:31:38'),
(67, 'xcode', '138.199.7.227', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-22 15:56:51'),
(68, 'xcode', '138.199.7.227', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-22 16:04:34'),
(69, 'xcode', '138.199.7.227', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-22 16:05:59'),
(70, 'xcode', '45.14.71.9', '10.240.0.69', 'Generic Smartphone 0.0.0', 'Chrome Mobile 129.0.0', '2024-09-22 16:57:18'),
(71, 'xcode', '138.199.7.227', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-22 17:21:58'),
(72, 'xcode', '138.199.7.227', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-22 17:23:07'),
(73, 'xcode', '138.199.7.227', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-22 17:23:31'),
(74, 'xcode', '138.199.7.227', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-22 17:25:04'),
(75, 'xcode', '138.199.7.227', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-22 17:26:06'),
(76, 'xcode', '138.199.7.227', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-22 17:27:40'),
(77, 'xcode', '138.199.7.227', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-22 17:29:33'),
(78, 'xcode', '138.199.7.227', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-22 17:30:20'),
(79, 'xcode', '138.199.7.227', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-22 17:31:43'),
(80, 'xcode', '138.199.7.227', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-22 17:32:12'),
(81, 'xcode', '138.199.7.227', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-22 17:32:42'),
(82, 'xcode', '138.199.7.227', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-22 17:32:57'),
(83, 'xcode', '138.199.7.227', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-22 17:44:33'),
(84, 'xcode', '138.199.7.227', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-22 17:44:59'),
(85, 'xcode', '45.14.71.9', '10.240.1.166', 'Generic Smartphone 0.0.0', 'Chrome Mobile 129.0.0', '2024-09-22 17:46:16'),
(86, 'xcode', '45.14.71.9', '10.240.3.64', 'Generic Smartphone 0.0.0', 'Chrome Mobile 129.0.0', '2024-09-22 17:51:02'),
(87, 'xcode', '138.199.7.229', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-23 08:35:51'),
(88, 'xcode', '105.112.208.103', '10.240.4.3', 'Generic Smartphone 0.0.0', 'Chrome Mobile 129.0.0', '2024-09-23 08:37:34'),
(89, 'xcode', '105.112.208.103', '10.240.3.64', 'Generic Smartphone 0.0.0', 'Chrome Mobile 129.0.0', '2024-09-23 08:48:01'),
(90, 'xcode', '105.112.208.103', '10.240.3.64', 'Generic Smartphone 0.0.0', 'Chrome Mobile 129.0.0', '2024-09-23 08:48:04'),
(91, 'xcode', '138.199.7.229', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-23 08:49:05'),
(92, 'xcode', '105.112.208.103', '10.240.3.64', 'Generic Smartphone 0.0.0', 'Chrome Mobile 129.0.0', '2024-09-23 08:53:13'),
(93, 'xcode', '105.112.208.103', '10.240.3.64', 'Generic Smartphone 0.0.0', 'Chrome Mobile 129.0.0', '2024-09-23 08:54:05'),
(94, 'xcode', '105.112.208.103', '10.240.1.166', 'Generic Smartphone 0.0.0', 'Chrome Mobile 129.0.0', '2024-09-23 08:56:37'),
(95, 'xcode', '105.112.208.103', '10.240.3.196', 'Generic Smartphone 0.0.0', 'Chrome Mobile 129.0.0', '2024-09-23 08:57:50'),
(96, 'xcode', '105.112.208.103', '10.240.3.196', 'Generic Smartphone 0.0.0', 'Chrome Mobile 129.0.0', '2024-09-23 09:00:17'),
(97, 'xcode', '105.112.208.103', '10.240.4.3', 'Generic Smartphone 0.0.0', 'Chrome Mobile 129.0.0', '2024-09-23 09:02:56'),
(98, 'xcode', '105.112.208.103', '10.240.4.3', 'Generic Smartphone 0.0.0', 'Chrome Mobile 129.0.0', '2024-09-23 09:04:07'),
(99, 'xcode', '105.112.208.103', '10.240.0.69', 'Generic Smartphone 0.0.0', 'Chrome Mobile 129.0.0', '2024-09-23 09:07:47'),
(100, 'xcode', '138.199.7.226', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-23 12:45:56'),
(101, '2', '138.199.7.226', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-23 15:34:58'),
(102, 'xcode', '138.199.7.226', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-23 15:37:07'),
(103, 'xcode', '138.199.7.226', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-23 15:45:43'),
(104, 'xcode', '138.199.7.226', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-23 15:47:55'),
(105, 'xcode', '185.107.56.136', '10.240.2.131', 'Generic Smartphone 0.0.0', 'Chrome Mobile 129.0.0', '2024-09-23 15:51:44'),
(106, 'xcode', '102.89.75.39', '10.240.4.3', 'Generic Smartphone 0.0.0', 'Chrome Mobile 129.0.0', '2024-09-23 20:25:45'),
(107, 'xcode', '102.89.75.39', '10.240.3.196', 'Generic Smartphone 0.0.0', 'Chrome Mobile 129.0.0', '2024-09-23 20:31:35'),
(108, 'xcode', '102.89.75.39', '10.240.3.196', 'Generic Smartphone 0.0.0', 'Chrome Mobile 129.0.0', '2024-09-23 20:32:58'),
(109, 'xcode', '102.89.75.39', '10.240.3.196', 'Generic Smartphone 0.0.0', 'Chrome Mobile 129.0.0', '2024-09-23 20:41:15'),
(110, 'xcode', '102.89.75.39', '10.240.3.196', 'Generic Smartphone 0.0.0', 'Chrome Mobile 129.0.0', '2024-09-23 20:42:29'),
(111, 'xcode', '102.89.75.39', '10.240.3.196', 'Generic Smartphone 0.0.0', 'Chrome Mobile 129.0.0', '2024-09-23 20:43:22'),
(112, 'xcode', '102.89.75.39', '10.240.1.166', 'Generic Smartphone 0.0.0', 'Chrome Mobile 129.0.0', '2024-09-23 20:45:24'),
(113, 'xcode', '102.89.75.39', '10.240.1.166', 'Generic Smartphone 0.0.0', 'Chrome Mobile 129.0.0', '2024-09-23 20:47:17'),
(114, 'xcode', '102.89.75.39', '10.240.3.196', 'Generic Smartphone 0.0.0', 'Chrome Mobile 129.0.0', '2024-09-23 20:58:22'),
(115, 'xcode', '102.89.75.39', '10.240.4.3', 'Generic Smartphone 0.0.0', 'Chrome Mobile 129.0.0', '2024-09-23 21:00:50'),
(116, 'xcode', '102.89.75.39', '10.240.2.131', 'Generic Smartphone 0.0.0', 'Chrome Mobile 129.0.0', '2024-09-23 21:05:18'),
(117, 'xcode', '102.89.75.39', '10.240.2.131', 'Generic Smartphone 0.0.0', 'Chrome Mobile 129.0.0', '2024-09-23 21:06:40'),
(118, 'xcode', '102.89.75.39', '10.240.3.196', 'Generic Smartphone 0.0.0', 'Chrome Mobile 129.0.0', '2024-09-23 21:23:51'),
(119, 'xcode', '138.199.7.236', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-25 08:34:50'),
(120, 'xcode', '185.107.56.71', '10.240.3.64', 'Generic Smartphone 0.0.0', 'Chrome Mobile 129.0.0', '2024-09-25 09:30:26'),
(121, 'xcode', '185.107.56.71', '10.240.3.64', 'Generic Smartphone 0.0.0', 'Chrome Mobile 129.0.0', '2024-09-25 09:30:27'),
(122, 'xcode', '138.199.7.236', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-25 11:29:57'),
(123, 'xcode', '138.199.7.236', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-25 11:30:10'),
(124, 'xcode', '138.199.7.236', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-25 11:46:04'),
(125, 'xcode', '185.177.125.58', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-25 12:14:06'),
(126, 'xcode', '185.107.56.71', '10.240.2.131', 'Generic Smartphone 0.0.0', 'Chrome Mobile 129.0.0', '2024-09-25 12:26:09'),
(127, 'xcode', '185.107.56.71', '10.240.2.131', 'Generic Smartphone 0.0.0', 'Chrome Mobile 129.0.0', '2024-09-25 12:28:27'),
(128, 'xcode', '185.107.56.71', '10.240.2.131', 'Generic Smartphone 0.0.0', 'Chrome Mobile 129.0.0', '2024-09-25 13:30:22'),
(129, 'xcode', '185.107.56.71', '10.240.2.131', 'Generic Smartphone 0.0.0', 'Chrome Mobile 129.0.0', '2024-09-25 13:30:27'),
(130, 'xcode', '185.177.125.58', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-25 14:04:41'),
(131, 'xcode', '185.177.125.90', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-26 01:07:32'),
(132, 'xcode', '102.89.82.154', '10.240.0.69', 'iPhone 0.0.0', 'Mobile Safari 16.1.0', '2024-09-26 01:23:17'),
(133, 'xcode', '190.2.155.232', '::ffff:127.0.0.1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-28 14:15:58'),
(134, 'xcode', '190.2.155.232', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-28 14:31:07'),
(135, 'xcode', '190.2.155.232', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-28 14:45:28'),
(136, 'xcode', '190.2.155.232', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-28 14:47:36'),
(137, 'xcode', '190.2.155.232', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-28 15:52:23'),
(138, 'xcode', '190.2.155.232', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-28 15:59:58'),
(139, 'xcode', '190.2.155.232', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-28 16:00:40'),
(140, 'xcode', '190.2.155.232', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-28 16:24:22'),
(141, 'xcode', '190.2.155.232', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-28 16:30:04'),
(142, 'xcode', '190.2.155.232', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-28 16:30:33'),
(143, 'xcode', '190.2.155.232', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-28 16:31:26'),
(144, 'xcode', '190.2.155.232', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-28 16:45:32'),
(145, 'xcode', '190.2.155.232', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-28 17:04:35'),
(146, 'xcode', '190.2.155.232', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-28 17:17:18'),
(147, 'xcode', '190.2.155.232', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-28 17:18:51'),
(148, 'xcode', '190.2.155.232', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-28 17:25:40'),
(149, 'xcode', '190.2.155.232', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-28 17:44:07'),
(150, 'xcode', '190.2.155.232', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-28 17:45:20'),
(151, 'xcode', '190.2.155.232', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-28 17:50:03'),
(152, 'xcode', '190.2.155.232', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-28 17:52:40'),
(153, 'xcode', '190.2.155.232', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-28 17:54:37'),
(154, 'xcode', '190.2.155.232', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-28 17:57:03'),
(155, 'xcode', '190.2.155.232', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-28 18:07:48'),
(156, 'xcode', '190.2.155.232', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-28 18:13:10'),
(157, 'xcode', '190.2.155.232', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-28 19:19:45'),
(158, 'xcode', '190.2.155.232', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-28 19:20:27'),
(159, 'xcode', '212.8.250.218', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-28 21:07:50'),
(160, 'xcode', '212.8.250.218', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-28 21:09:12'),
(161, 'xcode', '212.8.250.218', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-28 21:13:02'),
(162, 'xcode', '212.8.250.218', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-28 21:35:56'),
(163, 'xcode', '212.8.250.218', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-28 21:44:43'),
(164, 'xcode', '185.183.33.218', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-29 03:21:50'),
(165, 'xcode', '185.183.33.218', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-29 03:25:20'),
(166, 'xcode', '185.183.33.218', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-29 03:26:15'),
(167, 'xcode', '185.183.33.218', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-29 03:27:19'),
(168, 'xcode', '185.183.33.218', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-29 03:31:10'),
(169, 'xcode', '185.183.33.218', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-29 03:33:22'),
(170, 'xcode', '185.183.33.218', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-29 03:35:16'),
(171, 'xcode', '185.183.33.218', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-29 03:36:12'),
(172, 'xcode', '185.183.33.218', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-29 03:37:09'),
(173, 'xcode', '185.183.33.218', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-29 03:37:38'),
(174, 'xcode', '185.183.33.218', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-29 03:43:03'),
(175, 'xcode', '185.183.33.218', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-29 03:43:33'),
(176, 'xcode', '185.183.33.218', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-29 03:44:09'),
(177, 'xcode', '185.183.33.218', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-29 03:44:38'),
(178, 'xcode', '185.183.33.218', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-29 03:56:34'),
(179, 'xcode', '185.183.33.218', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-29 04:00:01'),
(180, 'xcode', '185.183.33.218', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-29 04:02:52'),
(181, 'xcode', '185.183.33.218', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-09-29 04:11:43'),
(182, 'xcode', '149.102.244.68', '10.240.3.196', 'Generic Smartphone 0.0.0', 'Chrome Mobile 129.0.0', '2024-09-29 04:21:05'),
(183, 'xcode', '149.102.244.68', '10.240.3.196', 'Generic Smartphone 0.0.0', 'Chrome Mobile 129.0.0', '2024-09-29 04:21:07'),
(184, 'xcode', '149.36.51.5', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-08 14:24:03'),
(185, 'xcode', '149.36.51.11', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-09 06:46:48'),
(186, 'xcode', '149.36.51.13', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-09 08:00:17'),
(187, 'xcode', '149.36.51.13', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-09 08:00:25'),
(188, 'xcode', '149.36.51.13', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-09 08:02:08'),
(189, 'xcode', '149.36.51.13', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-09 08:04:51'),
(190, 'xcode', '149.36.51.13', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-09 08:17:33'),
(191, 'xcode', '149.36.51.13', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-09 08:18:21'),
(192, 'xcode', '149.36.51.13', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-09 08:22:15'),
(193, 'xcode', '149.36.51.13', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-09 08:22:30'),
(194, 'xcode', '149.36.51.13', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-09 08:23:06'),
(195, 'xcode', '149.36.51.13', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-09 08:23:55'),
(196, 'xcode', '149.36.51.13', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-09 08:27:22'),
(197, 'xcode', '149.36.51.13', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-09 08:38:53'),
(198, 'xcode', '149.36.51.13', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-09 08:39:49'),
(199, 'xcode', '149.36.51.13', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-09 08:43:00'),
(200, 'xcode', '149.36.51.13', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-09 08:44:07'),
(201, 'xcode', '149.36.51.13', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-09 08:47:59'),
(202, 'xcode', '149.36.51.13', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-09 08:48:17'),
(203, 'xcode', '149.36.51.13', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-09 08:48:36'),
(204, 'xcode', '149.36.51.13', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-09 08:49:00'),
(205, 'xcode', '149.36.51.13', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-09 08:50:30'),
(206, 'xcode', '149.36.51.13', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-09 08:50:58'),
(207, 'xcode', '149.36.51.13', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-09 08:51:10'),
(208, 'xcode', '149.36.51.13', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-09 09:04:03'),
(209, 'xcode', '149.36.51.13', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-09 09:05:49'),
(210, 'xcode', '212.8.243.130', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-09 11:29:25'),
(211, 'xcode', '212.8.243.130', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-09 11:35:37'),
(212, 'xcode', '212.8.243.130', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-09 11:36:11'),
(213, 'xcode', '212.8.243.130', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-09 11:36:45'),
(214, 'xcode', '212.8.243.130', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-09 11:37:36'),
(215, 'xcode', '212.8.243.130', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-09 11:38:42'),
(216, 'xcode', '212.8.243.130', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-09 11:50:41'),
(217, 'xcode', '212.8.243.130', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-09 11:54:15'),
(218, 'xcode', '212.8.243.130', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-09 11:55:41'),
(219, 'xcode', '212.8.243.130', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-09 11:59:09'),
(220, 'xcode', '89.39.107.197', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-15 04:44:56'),
(221, 'xcode', '89.39.107.195', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-15 05:35:39'),
(222, 'xcode', '89.39.107.195', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-15 05:36:36'),
(223, 'xcode', '89.39.107.195', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-15 05:37:32'),
(224, 'xcode', '89.39.107.195', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-15 05:48:52'),
(225, 'xcode', '89.39.107.195', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-15 05:55:02'),
(226, 'xcode', '89.39.107.195', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-15 05:57:02'),
(227, 'xcode', '89.39.107.195', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-15 06:04:37'),
(228, 'xcode', '89.39.107.195', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-15 06:09:41'),
(229, 'xcode', '89.39.107.195', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-15 06:11:02'),
(230, 'xcode', '89.39.107.195', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-15 06:15:44'),
(231, 'xcode', '89.39.107.195', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-15 06:17:56'),
(232, 'xcode', '89.39.107.195', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-15 06:19:52'),
(233, 'xcode', '89.39.107.195', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-15 06:20:34'),
(234, 'xcode', '89.39.107.195', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-15 06:21:17'),
(235, 'xcode', '89.39.107.195', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-15 06:22:25'),
(236, 'xcode', '89.39.107.195', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-15 06:23:22'),
(237, 'xcode', '89.39.107.195', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-15 06:25:24'),
(238, 'xcode', '89.39.107.195', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-15 06:26:02'),
(239, 'xcode', '89.39.107.195', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-15 06:36:23'),
(240, 'xcode', '185.107.56.136', '10.240.1.166', 'TECNO $2 KI7.0.0', 'Chrome Mobile WebView 129.0.6668', '2024-10-17 13:45:48'),
(241, 'xcode', '185.107.56.136', '10.240.0.69', 'TECNO $2 KI7.0.0', 'Chrome Mobile WebView 129.0.6668', '2024-10-17 13:49:57'),
(242, 'xcode', '185.107.56.136', '10.240.0.10', 'Generic Smartphone 0.0.0', 'Chrome Mobile 130.0.0', '2024-10-17 13:54:21'),
(243, 'xcode', '185.177.124.101', '::1', 'iPhone 0.0.0', 'Mobile Safari 17.5.0', '2024-10-21 16:25:34'),
(244, 'xcode', '102.89.68.63', '::1', 'Other 0.0.0', 'Chrome 129.0.0', '2024-10-22 10:56:27'),
(245, 'xcode', '102.89.68.63', '::1', 'Other 0.0.0', 'Chrome 129.0.0', '2024-10-22 10:57:09'),
(246, 'xcode', '102.89.68.63', '::1', 'Other 0.0.0', 'Chrome 129.0.0', '2024-10-22 10:58:05'),
(247, 'xcode', '102.89.68.63', '::1', 'Other 0.0.0', 'Chrome 129.0.0', '2024-10-22 11:04:20'),
(248, 'xcode', '102.89.68.63', '::1', 'Other 0.0.0', 'Chrome 129.0.0', '2024-10-22 11:04:25'),
(249, 'xcode', '102.89.68.63', '::1', 'Other 0.0.0', 'Chrome 129.0.0', '2024-10-22 11:04:31'),
(250, 'xcode', '102.89.68.63', '::1', 'Other 0.0.0', 'Chrome 129.0.0', '2024-10-22 11:05:15'),
(251, 'xcode', '149.34.244.137', '::1', 'Other 0.0.0', 'Chrome 129.0.0', '2024-10-22 13:24:47'),
(252, 'xcode', '212.8.252.183', '::1', 'Other 0.0.0', 'Chrome 129.0.0', '2024-10-23 02:45:35'),
(253, 'xcode', '212.8.252.183', '::1', 'Other 0.0.0', 'Chrome 129.0.0', '2024-10-23 03:27:18'),
(254, 'xcode', '149.34.244.143', '::1', 'Other 0.0.0', 'Chrome 129.0.0', '2024-10-23 08:48:39'),
(255, 'xcode', '102.89.82.45', '::1', 'Other 0.0.0', 'Chrome 129.0.0', '2024-10-30 18:45:03'),
(256, 'xcode', '102.89.82.210', '10.240.0.69', 'iPhone 0.0.0', 'Mobile Safari 18.0.0', '2024-10-31 00:36:06');

-- --------------------------------------------------------

--
-- Table structure for table `vendor_follows`
--

CREATE TABLE `vendor_follows` (
  `id` int(11) NOT NULL,
  `user_id` varchar(300) NOT NULL,
  `vendor_id` varchar(300) NOT NULL,
  `follow_date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `vendor_follows`
--

INSERT INTO `vendor_follows` (`id`, `user_id`, `vendor_id`, `follow_date`) VALUES
(69, 'xcode', 'xcode', '2024-09-29 04:45:52');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `carts`
--
ALTER TABLE `carts`
  ADD PRIMARY KEY (`cart_id`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ratings`
--
ALTER TABLE `ratings`
  ADD PRIMARY KEY (`rating_id`);

--
-- Indexes for table `recently_viewed`
--
ALTER TABLE `recently_viewed`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `reports`
--
ALTER TABLE `reports`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `user_login_activity`
--
ALTER TABLE `user_login_activity`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `vendor_follows`
--
ALTER TABLE `vendor_follows`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `carts`
--
ALTER TABLE `carts`
  MODIFY `cart_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=140;

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `ratings`
--
ALTER TABLE `ratings`
  MODIFY `rating_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT for table `recently_viewed`
--
ALTER TABLE `recently_viewed`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `reports`
--
ALTER TABLE `reports`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `user_login_activity`
--
ALTER TABLE `user_login_activity`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=257;

--
-- AUTO_INCREMENT for table `vendor_follows`
--
ALTER TABLE `vendor_follows`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=76;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
