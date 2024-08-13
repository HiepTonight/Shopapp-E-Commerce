-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th7 07, 2024 lúc 12:47 PM
-- Phiên bản máy phục vụ: 10.4.28-MariaDB
-- Phiên bản PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `shopapp`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT 'T?n danh m?c'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `categories`
--

INSERT INTO `categories` (`id`, `name`) VALUES
(1, 'Đồ điện tử'),
(2, 'Đồ gia dụng'),
(3, 'Thực phẩm'),
(4, 'Phụ kiện'),
(5, 'Đồ nội thất'),
(7, 'Đồ chơi'),
(8, 'Đồ chơi'),
(9, 'Đồ chơi');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `fullname` varchar(100) DEFAULT '',
  `email` varchar(100) DEFAULT '',
  `phone_number` varchar(20) NOT NULL,
  `address` varchar(200) NOT NULL,
  `note` varchar(100) DEFAULT '',
  `order_date` datetime DEFAULT current_timestamp(),
  `status` enum('pending','processing','shipped','delivered','cancelled') DEFAULT NULL COMMENT 'Tr?ng th?i don h?ng',
  `total_money` float DEFAULT NULL CHECK (`total_money` >= 0),
  `shipping_method` varchar(100) DEFAULT NULL,
  `shipping_address` varchar(200) DEFAULT NULL,
  `shipping_date` date DEFAULT NULL,
  `tracking_number` varchar(100) DEFAULT NULL,
  `payment_method` varchar(100) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `fullname`, `email`, `phone_number`, `address`, `note`, `order_date`, `status`, `total_money`, `shipping_method`, `shipping_address`, `shipping_date`, `tracking_number`, `payment_method`, `active`) VALUES
(19, 2, 'hieptran', 'ok@gmail.com', '123313', 'Nha a ngo b', 'hang de vo', '2024-03-25 04:55:35', 'pending', 123.231, 'express', NULL, '2024-03-25', NULL, 'cast on delivery', 1),
(20, 2, 'hieptran', 'ok@gmail.com', '123313', 'Nha a ngo b', 'hang de vo', '2024-03-28 08:02:40', 'pending', 123.231, 'express', NULL, '2024-03-28', NULL, 'cast on delivery', 1),
(21, 2, 'hieptran', 'ok@gmail.com', '123313', 'Nha a ngo b', 'hang de vo', '2024-03-28 08:06:51', 'pending', 123.231, 'express', NULL, '2024-03-28', NULL, 'cast on delivery', 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `order_details`
--

CREATE TABLE `order_details` (
  `id` int(11) NOT NULL,
  `order_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `price` float DEFAULT NULL CHECK (`price` >= 0),
  `number_of_products` int(11) DEFAULT NULL CHECK (`number_of_products` > 0),
  `total_money` float DEFAULT NULL CHECK (`total_money` >= 0),
  `color` varchar(20) DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `order_details`
--

INSERT INTO `order_details` (`id`, `order_id`, `product_id`, `price`, `number_of_products`, `total_money`, `color`) VALUES
(9, 20, 5, 61840600, 7, 0, NULL),
(10, 20, 8, 85358300, 3, 0, NULL),
(11, 20, 13, 7833620, 9, 0, NULL),
(12, 21, 5, 61840600, 7, 0, NULL),
(13, 21, 8, 85358300, 3, 0, NULL),
(15, 21, 1, 123.5, 2, 123.231, '#ff00ff'),
(16, 21, 1, 123.5, 2, 123.231, '#ff00ff');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `name` varchar(350) DEFAULT NULL COMMENT 'T?n s?n ph?m',
  `price` float NOT NULL CHECK (`price` >= 0),
  `thumbnail` varchar(300) DEFAULT NULL,
  `description` longtext DEFAULT '',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `products`
--

INSERT INTO `products` (`id`, `name`, `price`, `thumbnail`, `description`, `created_at`, `updated_at`, `category_id`) VALUES
(1, 'Macbook 15 inch', 942.2, NULL, NULL, '2024-03-14 09:21:42', '2024-03-14 09:21:42', 1),
(2, 'Macbook Pro 15 inch', 992.2, NULL, NULL, '2024-03-14 10:00:18', '2024-03-14 10:00:18', 1),
(3, 'Enormous Iron Bench', 16382600, '', 'Odit corporis unde praesentium provident eius ipsam.', '2024-03-14 10:30:58', '2024-03-14 10:30:58', 1),
(4, 'Small Iron Shoes', 47612500, '', 'Aliquid qui mollitia tempora totam.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(5, 'Small Iron Shirt', 61840600, '', 'Similique laborum iusto dolor a sint alias.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(6, 'Incredible Paper Gloves', 43432000, '', 'Accusantium rem eligendi accusamus.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(7, 'Mediocre Cotton Gloves', 81567800, '', 'Maxime eum maxime aut ea sit.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(8, 'Enormous Paper Wallet', 85358300, '', 'Saepe porro recusandae vel neque rerum ipsa repellendus.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(9, 'Awesome Concrete Computer', 59042000, '', 'Fugiat culpa error perferendis voluptatem.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(10, 'Sleek Rubber Bag', 69538900, '', 'Alias neque officiis libero magni ducimus.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(11, 'Enormous Linen Clock', 79093800, '', 'Eum fuga dolor quaerat.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(12, 'Mediocre Leather Bag', 69249100, '', 'Voluptatem cum soluta in vel nihil.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(13, 'Fantastic Cotton Plate', 7833620, '', 'Aut consequatur consequatur et recusandae voluptas temporibus neque.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 3),
(14, 'Fantastic Copper Lamp', 62546500, '', 'Molestiae porro libero reprehenderit illo possimus voluptatem voluptate.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 3),
(15, 'Incredible Linen Table', 83885300, '', 'Laborum quaerat similique nihil et ducimus fuga praesentium.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(16, 'Lightweight Concrete Table', 57160400, '', 'Molestiae numquam totam.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(17, 'Awesome Steel Hat', 53618700, '', 'Est aut corrupti sit mollitia.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 3),
(18, 'Sleek Linen Wallet', 21221300, '', 'Ad ipsum id saepe mollitia est incidunt maxime.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(19, 'Synergistic Plastic Plate', 6935690, '', 'Quaerat at nisi error.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(20, 'Aerodynamic Silk Shoes', 2742620, '', 'Rerum facilis est modi id voluptas.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(21, 'Enormous Silk Coat', 88361500, '', 'Quo dolorem non ad ab omnis consequuntur harum.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(22, 'Awesome Linen Shoes', 20905200, '', 'Nobis et eum molestiae aut quas ullam.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(23, 'Synergistic Cotton Car', 23277700, '', 'Iste reprehenderit cum itaque.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 3),
(24, 'Lightweight Paper Bench', 47260700, '', 'Et sint laboriosam.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(25, 'Intelligent Copper Keyboard', 68346600, '', 'Quod accusamus ipsam in ut ea.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(26, 'Sleek Wooden Wallet', 16214000, '', 'Facere molestiae modi dicta doloremque in.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(27, 'Practical Aluminum Gloves', 22646100, '', 'Totam autem temporibus.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(28, 'Gorgeous Aluminum Bench', 40455000, '', 'Autem ut quia aut veniam officiis eaque quasi.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(29, 'Aerodynamic Plastic Bottle', 8312110, '', 'Quisquam dicta modi et aut facere dolorem.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(30, 'Mediocre Paper Bottle', 53991200, '', 'Totam animi molestiae totam beatae et.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(31, 'Ergonomic Copper Knife', 52794100, '', 'Architecto fugit quae.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(32, 'Heavy Duty Bronze Lamp', 42633900, '', 'Ratione excepturi temporibus ipsum et enim.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(33, 'Intelligent Linen Coat', 24349200, '', 'Quasi alias unde rerum laboriosam.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(34, 'Lightweight Wooden Bottle', 33726100, '', 'Ipsam et nisi qui nesciunt.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 3),
(35, 'Mediocre Wooden Bottle', 86124300, '', 'Iste quae eligendi et sit deleniti et sunt.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(36, 'Intelligent Leather Shoes', 31633200, '', 'Id animi ut quia laborum voluptas.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(37, 'Enormous Granite Knife', 86407900, '', 'Esse suscipit sit id sed aut.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(38, 'Fantastic Bronze Chair', 71621900, '', 'Ad exercitationem amet aut error.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(39, 'Intelligent Paper Wallet', 42298400, '', 'Id incidunt et unde.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 3),
(40, 'Practical Cotton Bench', 11693700, '', 'Illum modi fugiat blanditiis placeat.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(41, 'Durable Iron Clock', 45114300, '', 'Sint omnis delectus odit et laudantium.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(42, 'Enormous Plastic Bottle', 22298700, '', 'Inventore qui repudiandae beatae ratione facilis occaecati.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(43, 'Enormous Cotton Shoes', 16730300, '', 'Quia distinctio perferendis natus sunt aut id.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 3),
(44, 'Gorgeous Copper Bag', 27942200, '', 'Consequatur non ut dolorum.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(45, 'Synergistic Iron Knife', 67569800, '', 'Et voluptatibus ipsa quos fuga autem.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(46, 'Aerodynamic Bronze Lamp', 38628400, '', 'Consectetur inventore temporibus veniam totam saepe id vero.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(47, 'Heavy Duty Cotton Hat', 82566300, '', 'Modi eius labore quas reprehenderit repellat est.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 3),
(48, 'Heavy Duty Paper Table', 11736800, '', 'Voluptatem quibusdam et architecto et.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 3),
(49, 'Enormous Bronze Table', 87263800, '', 'Et voluptatem sunt totam possimus voluptatem non.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(50, 'Gorgeous Aluminum Keyboard', 2324090, '', 'Perspiciatis dignissimos dolorum delectus et consequatur sit esse.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(51, 'Synergistic Copper Hat', 62894100, '', 'Suscipit quasi cum sapiente veniam atque quo eum.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(52, 'Enormous Marble Plate', 14435300, '', 'Et beatae autem iusto velit reprehenderit consequatur officiis.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(53, 'Lightweight Rubber Clock', 13607300, '', 'Dolorem nostrum qui exercitationem adipisci.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(54, 'Practical Aluminum Wallet', 72855000, '', 'Ut qui velit.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(55, 'Intelligent Steel Computer', 14990800, '', 'Ut aut qui illum qui.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(56, 'Mediocre Wool Computer', 52455700, '', 'Quidem quibusdam est nesciunt et.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(57, 'Fantastic Linen Knife', 61832000, '', 'Quo est aperiam et omnis ipsum at unde.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(58, 'Incredible Cotton Shirt', 17508800, '', 'Maiores ad aspernatur aperiam nam.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(59, 'Lightweight Plastic Gloves', 54124100, '', 'Excepturi consequatur et non sint voluptate maxime cupiditate.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(60, 'Incredible Rubber Chair', 33609100, '', 'Iste doloribus est ratione nesciunt voluptates officiis ad.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(61, 'Incredible Silk Table', 52572000, '', 'Rerum sed est nihil eos animi.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(62, 'Gorgeous Aluminum Chair', 43022500, '', 'Non iusto voluptatum consequatur.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(63, 'Gorgeous Iron Computer', 54861600, '', 'Necessitatibus officiis voluptates ipsum.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(64, 'Ergonomic Steel Lamp', 51856300, '', 'Ut voluptatem reiciendis.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(65, 'Enormous Copper Wallet', 53433300, '', 'Quia est ea.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 3),
(66, 'Ergonomic Wool Bottle', 69039900, '', 'Voluptatibus dolorem tempora ipsa.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(67, 'Synergistic Wool Chair', 81769800, '', 'Nihil molestiae et ad ipsa itaque beatae.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(68, 'Heavy Duty Marble Knife', 49074300, '', 'Cumque distinctio qui harum suscipit distinctio tempore laudantium.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(69, 'Practical Concrete Wallet', 21735000, '', 'Esse blanditiis illum dignissimos eum amet dolore.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(70, 'Durable Concrete Bag', 61169700, '', 'Labore vero ab et.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(71, 'Durable Wool Bag', 89518300, '', 'Quos earum illo voluptas fugiat est ut.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(72, 'Practical Bronze Watch', 84393600, '', 'Blanditiis autem porro perspiciatis explicabo.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(73, 'Intelligent Aluminum Computer', 55606900, '', 'Illo eveniet inventore error.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(74, 'Sleek Wool Bench', 58982900, '', 'Reprehenderit expedita nesciunt quibusdam alias expedita.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 3),
(75, 'Intelligent Steel Bench', 14492200, '', 'Officiis nam voluptatum nihil voluptatem quia incidunt veniam.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(76, 'Gorgeous Wool Shirt', 70076800, '', 'Qui ea dolor.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(77, 'Incredible Iron Bottle', 4480460, '', 'Molestias aspernatur aut ab.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(78, 'Sleek Copper Hat', 45948100, '', 'Numquam tenetur et veniam molestias.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(79, 'Intelligent Rubber Bottle', 79859800, '', 'Nisi ipsum sit est sunt.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(80, 'Lightweight Wool Table', 81916900, '', 'Neque laboriosam architecto.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(81, 'Fantastic Copper Shoes', 50093600, '', 'Qui tempora ut et.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(82, 'Fantastic Linen Pants', 74925100, '', 'Itaque consequatur hic.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(83, 'Lightweight Cotton Lamp', 42995700, '', 'Ipsa deserunt et amet est.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(84, 'Fantastic Wool Plate', 60037000, '', 'Non soluta eum aut odio eius.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(85, 'Practical Granite Hat', 25390900, '', 'Harum ducimus omnis magni et placeat doloremque quasi.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(86, 'Ergonomic Plastic Chair', 18882500, '', 'Numquam et ut quas sed molestiae dolor.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(87, 'Lightweight Paper Gloves', 26016300, '', 'Excepturi autem praesentium.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(88, 'Incredible Silk Gloves', 47730500, '', 'Ea quos voluptate ab.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(89, 'Lightweight Paper Computer', 64017100, '', 'Eos consequatur odit.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(90, 'Enormous Linen Bottle', 40234900, '', 'Atque qui dolorem omnis.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(91, 'Rustic Rubber Coat', 72150100, '', 'Aut hic aut vero.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(92, 'Fantastic Wooden Wallet', 71741400, '', 'Ex ea maiores sed impedit sapiente dolorum.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(93, 'Ergonomic Bronze Bench', 27355700, '', 'Molestiae qui laudantium veniam vero cumque esse.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(94, 'Fantastic Wooden Clock', 56387200, '', 'Voluptates ut aut.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(95, 'Intelligent Copper Pants', 6450670, '', 'Doloribus ratione molestiae aliquid facere.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(96, 'Aerodynamic Plastic Bag', 75987900, '', 'Ea voluptates perferendis autem.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 3),
(97, 'Awesome Silk Clock', 33246700, '', 'Fugit repellat dolorem accusamus.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(98, 'Heavy Duty Rubber Gloves', 17618000, '', 'Fugiat consectetur et quia qui rem.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(99, 'Heavy Duty Marble Wallet', 37247300, '', 'Aut qui similique.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(100, 'Rustic Steel Lamp', 12970600, '', 'Dolores hic ullam quae rerum sunt.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(101, 'Fantastic Silk Car', 55417500, '', 'Officia non eius tenetur amet nulla fugit atque.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 3),
(102, 'Synergistic Wooden Coat', 69665100, '', 'Qui incidunt est voluptatibus.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(103, 'Ergonomic Iron Table', 26534000, '', 'Quod a et atque sed corrupti.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(104, 'Synergistic Aluminum Car', 33207900, '', 'Dolores dolorem odit sint ut provident consequatur eum.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(105, 'Enormous Cotton Gloves', 32419900, '', 'Nemo velit occaecati voluptas aut dolores perspiciatis.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(106, 'Durable Paper Wallet', 32359400, '', 'Corporis non nemo.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(107, 'Intelligent Steel Plate', 86251600, '', 'Sequi et labore.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(108, 'Ergonomic Linen Chair', 68693100, '', 'Facilis quia veritatis nam commodi aperiam ipsam ducimus.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(109, 'Durable Wooden Gloves', 7111630, '', 'Non reiciendis et in dolores ipsum qui quos.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(110, 'Rustic Wool Shirt', 86737300, '', 'Aliquam quos alias non autem nisi.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(111, 'Ergonomic Linen Car', 87181600, '', 'Esse consequatur dolorum recusandae itaque qui doloremque.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 3),
(112, 'Synergistic Concrete Clock', 19043800, '', 'Consequatur repellendus voluptatem.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 3),
(113, 'Durable Aluminum Clock', 78630900, '', 'Iure autem quo et unde dolorem.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(114, 'Synergistic Linen Keyboard', 74566500, '', 'Fuga perferendis ea distinctio iure autem ut.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(115, 'Ergonomic Concrete Bottle', 14453900, '', 'Sapiente repudiandae porro rerum recusandae ea.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(116, 'Small Copper Coat', 88412700, '', 'Perferendis minima maiores voluptatem corporis quae in.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(117, 'Small Cotton Shoes', 70859300, '', 'Ad assumenda qui unde iure officia.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(118, 'Practical Wool Pants', 56936000, '', 'Fugit sed libero facere et consequuntur.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 3),
(119, 'Enormous Steel Computer', 64921200, '', 'Aliquam dolorem qui modi sint esse qui.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(120, 'Ergonomic Iron Coat', 28864800, '', 'Sed amet quis quia.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(121, 'Enormous Wooden Bottle', 53779300, '', 'Quo harum non velit optio itaque.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(122, 'Small Iron Car', 84240900, '', 'Atque fuga non commodi et.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(123, 'Fantastic Rubber Watch', 11789000, '', 'Facere fugit vitae explicabo nisi temporibus.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(124, 'Heavy Duty Paper Watch', 76555600, '', 'Eum voluptatibus expedita aut possimus.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 3),
(125, 'Intelligent Steel Bottle', 74303300, '', 'Odit consequuntur nihil officia enim labore nostrum nam.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(126, 'Fantastic Plastic Computer', 81221300, '', 'Libero sunt quia ea optio ea atque labore.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(127, 'Awesome Silk Car', 11136100, '', 'Laboriosam dolor aperiam rem reprehenderit aut.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(128, 'Mediocre Silk Bag', 54998300, '', 'Nesciunt sint velit assumenda et necessitatibus.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(129, 'Heavy Duty Concrete Hat', 80818100, '', 'Saepe est pariatur exercitationem.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(130, 'Mediocre Marble Bottle', 46962800, '', 'Voluptatem maxime voluptatum excepturi eius.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(131, 'Rustic Paper Keyboard', 28734100, '', 'Sapiente qui beatae qui quae sapiente.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(132, 'Practical Steel Bottle', 46000200, '', 'At temporibus debitis nemo est inventore.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(133, 'Enormous Granite Lamp', 32242000, '', 'Impedit facere illo et accusantium corporis.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(134, 'Incredible Bronze Chair', 76439000, '', 'Labore ea sit excepturi dolorum placeat.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(135, 'Incredible Copper Shoes', 5474900, '', 'Neque libero praesentium quidem.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 3),
(136, 'Synergistic Iron Table', 80901100, '', 'Aut quae in.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(137, 'Practical Steel Computer', 32336300, '', 'Cum quia quis suscipit perferendis et accusamus dolore.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(138, 'Rustic Cotton Bag', 57299800, '', 'Veritatis sed at incidunt quia officia.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 3),
(139, 'Gorgeous Wool Hat', 12947600, '', 'Doloribus deleniti ut nulla pariatur ut aliquid.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(140, 'Intelligent Rubber Pants', 5242390, '', 'Laudantium provident molestias totam debitis.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(141, 'Fantastic Iron Shirt', 920532, '', 'Minima dolor cum qui consequatur qui quasi.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(142, 'Intelligent Aluminum Clock', 63086700, '', 'Et consectetur quaerat voluptates dolores necessitatibus.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(143, 'Mediocre Rubber Car', 39254500, '', 'Aut dolorem in quas magnam.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 3),
(144, 'Ergonomic Aluminum Coat', 83125100, '', 'Exercitationem aut mollitia nam pariatur molestias ea nisi.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(145, 'Small Granite Car', 66708800, '', 'Maxime qui culpa veniam.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(146, 'Rustic Linen Gloves', 48311900, '', 'Blanditiis quae assumenda atque.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(147, 'Durable Copper Gloves', 2744480, '', 'Numquam eligendi sint dolorum pariatur.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 3),
(148, 'Durable Marble Bottle', 34938800, '', 'Est porro quia quia occaecati quas.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(149, 'Sleek Paper Table', 63960200, '', 'Dolor corporis dignissimos quaerat unde nesciunt.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(150, 'Awesome Plastic Car', 27453700, '', 'Est vel magnam.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 3),
(151, 'Ergonomic Plastic Knife', 88764600, '', 'Unde itaque est in veniam aut beatae corrupti.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(152, 'Small Steel Coat', 77849000, '', 'Recusandae ipsum occaecati aut nostrum mollitia.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 3),
(153, 'Rustic Paper Pants', 89718400, '', 'Est exercitationem aut quia nisi.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(154, 'Awesome Granite Computer', 15093000, '', 'Nihil aut aliquam ad delectus qui.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 2),
(155, 'Intelligent Iron Chair', 76672900, '', 'Consequatur beatae sed sed non.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(156, 'Heavy Duty Bronze Gloves', 29718500, '', 'Et ullam molestiae quia quisquam aut nostrum voluptatem.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(157, 'Sleek Rubber Computer', 52938200, '', 'Ad et ab praesentium.', '2024-03-14 10:34:01', '2024-03-14 10:34:01', 1),
(158, 'Synergistic Wool Wallet', 27251800, '', 'Dolorem autem modi quasi et repudiandae.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 2),
(159, 'Aerodynamic Linen Coat', 19632100, '', 'Ad similique alias enim.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 1),
(160, 'Small Plastic Lamp', 14562000, '', 'Dolores voluptas et.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 1),
(161, 'Lightweight Granite Bottle', 63390000, '', 'Aut totam quis asperiores.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 2),
(162, 'Enormous Wooden Bag', 28810400, '', 'Nihil quod velit.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 2),
(163, 'Intelligent Paper Computer', 66282500, '', 'Et aut rerum velit omnis dolore voluptate.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 2),
(164, 'Fantastic Plastic Bench', 33734700, '', 'Inventore assumenda magni amet est.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 2),
(165, 'Gorgeous Iron Watch', 63512400, '', 'Quia aperiam illum eos fugiat officiis.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 2),
(166, 'Aerodynamic Iron Coat', 54648800, '', 'Repellendus fugiat reiciendis.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 3),
(167, 'Enormous Copper Car', 18232800, '', 'Quia natus officia debitis architecto distinctio dolorem et.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 3),
(168, 'Synergistic Rubber Shirt', 25483000, '', 'Non pariatur id nam unde ab soluta voluptatem.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 2),
(169, 'Durable Copper Pants', 51041600, '', 'Exercitationem nihil praesentium quaerat et cupiditate.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 2),
(170, 'Sleek Iron Watch', 58418000, '', 'Inventore tempora velit ipsum fuga repudiandae.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 3),
(171, 'Durable Iron Keyboard', 6968670, '', 'Facilis tempora ratione.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 1),
(172, 'Fantastic Aluminum Hat', 6740890, '', 'Sunt et temporibus.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 3),
(173, 'Incredible Rubber Clock', 42267900, '', 'Adipisci nulla expedita modi esse blanditiis eum sit.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 2),
(174, 'Incredible Bronze Shoes', 36419000, '', 'Tempora impedit minus nam blanditiis.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 2),
(175, 'Aerodynamic Steel Knife', 62267300, '', 'Laudantium soluta enim error expedita.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 1),
(176, 'Durable Concrete Gloves', 8453930, '', 'Aut aut doloremque est voluptates.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 2),
(177, 'Fantastic Iron Wallet', 85117500, '', 'Ut eius aliquam excepturi nam.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 2),
(178, 'Small Concrete Plate', 59658100, '', 'Necessitatibus consequuntur delectus ipsa sit.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 2),
(179, 'Mediocre Steel Gloves', 41124300, '', 'Eaque porro quia consequatur.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 2),
(180, 'Mediocre Wool Pants', 57287800, '', 'Qui id delectus aspernatur.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 1),
(181, 'Enormous Aluminum Plate', 85689800, '', 'Autem enim quos nisi.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 2),
(182, 'Fantastic Plastic Chair', 54796900, '', 'Officiis eveniet libero.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 1),
(183, 'Durable Granite Bench', 14954500, '', 'Et aut itaque quae ex cumque quod blanditiis.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 2),
(184, 'Awesome Aluminum Watch', 55709900, '', 'Dolore consequatur nostrum culpa quod voluptatum autem.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 2),
(185, 'Ergonomic Steel Bag', 80723200, '', 'Repudiandae ipsam modi culpa voluptatem cumque.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 2),
(186, 'Gorgeous Marble Keyboard', 58459400, '', 'Debitis aut esse.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 2),
(187, 'Synergistic Rubber Computer', 50723400, '', 'Modi et doloremque pariatur illo est magni.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 2),
(188, 'Synergistic Aluminum Watch', 41396000, '', 'Consequatur hic suscipit excepturi.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 2),
(189, 'Heavy Duty Silk Coat', 47826500, '', 'Nulla eum molestiae expedita dicta saepe voluptatum sint.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 2),
(190, 'Mediocre Rubber Bench', 51508400, '', 'Tempora accusantium reiciendis quo.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 3),
(191, 'Gorgeous Aluminum Watch', 53700400, '', 'Molestiae ut fugit tempora aspernatur id voluptatem.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 1),
(192, 'Heavy Duty Concrete Plate', 8799940, '', 'Suscipit totam exercitationem veritatis nisi molestiae illum.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 3),
(193, 'Aerodynamic Rubber Clock', 25202400, '', 'Quisquam magni fugiat ipsa.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 1),
(194, 'Ergonomic Marble Wallet', 64564300, '', 'Dolorum aliquid magni omnis et.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 3),
(195, 'Aerodynamic Rubber Pants', 83464400, '', 'Sed dolor qui aut magni.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 1),
(196, 'Enormous Silk Lamp', 16254500, '', 'Iure voluptatem quo eligendi.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 3),
(197, 'Sleek Copper Shoes', 67545600, '', 'Beatae quam labore quisquam unde porro aliquam.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 2),
(198, 'Small Cotton Bench', 44458200, '', 'Pariatur facere qui.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 1),
(199, 'Heavy Duty Iron Bottle', 16804200, '', 'Optio reprehenderit non minus eum laudantium.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 1),
(200, 'Lightweight Linen Knife', 84899800, '', 'Ea dolores ducimus quis tenetur tempora.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 2),
(201, 'Practical Aluminum Hat', 15138100, '', 'Dolor quod quia.', '2024-03-14 10:34:02', '2024-03-14 10:34:02', 2);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `product_images`
--

CREATE TABLE `product_images` (
  `id` int(11) NOT NULL,
  `product_id` int(11) DEFAULT NULL,
  `image_url` varchar(300) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `product_images`
--

INSERT INTO `product_images` (`id`, `product_id`, `image_url`) VALUES
(1, 4, '6fb952f8-d040-44f1-aa01-fc7fbc7dba1a_qbKWx.jpg');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `name` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `roles`
--

INSERT INTO `roles` (`id`, `name`) VALUES
(1, 'user'),
(2, 'admin');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `social_accounts`
--

CREATE TABLE `social_accounts` (
  `id` int(11) NOT NULL,
  `provider` varchar(20) NOT NULL COMMENT 'T?n nh? social network',
  `provider_id` varchar(50) NOT NULL,
  `email` varchar(150) NOT NULL COMMENT 'Email t?i kho?n',
  `name` varchar(100) NOT NULL COMMENT 'T?n ngu?i d?ng',
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tokens`
--

CREATE TABLE `tokens` (
  `id` int(11) NOT NULL,
  `token` varchar(255) NOT NULL,
  `token_type` varchar(55) NOT NULL,
  `expiration_date` datetime DEFAULT NULL,
  `revoked` tinyint(1) DEFAULT NULL,
  `expired` tinyint(1) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `is_mobile` tinyint(1) DEFAULT 0,
  `refresh_token` varchar(255) DEFAULT '''',
  `refresh_expiration_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `tokens`
--

INSERT INTO `tokens` (`id`, `token`, `token_type`, `expiration_date`, `revoked`, `expired`, `user_id`, `is_mobile`, `refresh_token`, `refresh_expiration_date`) VALUES
(4, 'eyJhbGciOiJIUzI1NiJ9.eyJwaG9uZU51bWJlciI6IjAxMjM0NTY3NyIsInVzZXJJZCI6Niwic3ViIjoiMDEyMzQ1Njc3IiwiZXhwIjoxNzIwMjY4MTY0fQ.avJ5l_DTeLcR3u3ZuPeyHo5ekAMbI45TazZRNIkTUKc', 'Bearer', '2024-09-04 11:32:52', 0, 0, 6, 0, '1644bbff-8e5b-462d-a0c0-855086e5c513', '2024-09-04 11:32:52'),
(5, 'eyJhbGciOiJIUzI1NiJ9.eyJwaG9uZU51bWJlciI6IjAxMjM0NTY3NyIsInVzZXJJZCI6Niwic3ViIjoiMDEyMzQ1Njc3IiwiZXhwIjoxNzIwMjcwOTY4fQ.BhksvidjW0AZXG6dWoBV_hAfTiblB_2G3YGg3Gk4gKw', 'Bearer', '2024-09-04 12:19:36', 0, 0, 6, 0, '2d533f7d-4e3d-4df5-ae89-b035b01203e8', '2024-09-04 12:19:36');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `fullname` varchar(100) DEFAULT '',
  `phone_number` varchar(10) NOT NULL,
  `address` varchar(200) DEFAULT '',
  `password` varchar(100) NOT NULL DEFAULT '',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `date_of_birth` date DEFAULT NULL,
  `facebook_account_id` int(11) DEFAULT 0,
  `google_account_id` int(11) DEFAULT 0,
  `role_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `users`
--

INSERT INTO `users` (`id`, `fullname`, `phone_number`, `address`, `password`, `created_at`, `updated_at`, `is_active`, `date_of_birth`, `facebook_account_id`, `google_account_id`, `role_id`) VALUES
(2, 'Nguyeenx van A', '01231412', 'nha A ngo B', '$2a$10$J.GvWiRDDsHqdxMW4HLBGubI7/KVzwtEM2cPm.r10ZDVozK9jWquS', '2024-03-24 08:08:58', '2024-03-24 08:08:58', 0, NULL, 0, 0, 1),
(3, 'Tài khoản Admin 1', '011223344', 'Admin\'s house', '$2a$10$r.Jrx5B4TlZEqyjIoVYQCO/OX4Q2ljl3MdB4RJ9RENFRLxM7bOfTS', '2024-03-25 12:04:33', '2024-03-25 12:04:33', 0, NULL, 0, 0, 2),
(4, 'Tài khoản Admin 2', '012345678', 'Admin\'s house', '$2a$10$gDmPVOMVrXkPEyLhaz0cI.JAr1N2/KuE9c3D4OsOVbBUHe.UxRf/m', '2024-03-29 05:03:49', '2024-03-29 05:03:49', 0, NULL, 0, 0, 1),
(5, 'Tài khoản Admin 3', '0123456789', 'Admin\'s house', '$2a$10$LrMKuxHtM34/yeCxPqNT0uwn6l7D1HpFbRy.AdVDCbyEhkWAQPTya', '2024-03-29 05:08:03', '2024-03-29 05:08:03', 1, NULL, 0, 0, 2),
(6, 'Nguyeenx van A', '012345677', 'nha A ngo B', '$2a$10$gGIQTl00CLHTxl70C.dBpuH.dRTkavK39tLNGdkdvhhLKmAdyEIiK', '2024-07-05 08:29:35', '2024-07-05 08:29:35', 1, NULL, 0, 0, 1);

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Chỉ mục cho bảng `order_details`
--
ALTER TABLE `order_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Chỉ mục cho bảng `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `category_id` (`category_id`);

--
-- Chỉ mục cho bảng `product_images`
--
ALTER TABLE `product_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_product_images_product_id` (`product_id`);

--
-- Chỉ mục cho bảng `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `social_accounts`
--
ALTER TABLE `social_accounts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Chỉ mục cho bảng `tokens`
--
ALTER TABLE `tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `token` (`token`),
  ADD KEY `user_id` (`user_id`);

--
-- Chỉ mục cho bảng `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD KEY `role_id` (`role_id`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT cho bảng `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT cho bảng `order_details`
--
ALTER TABLE `order_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT cho bảng `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=202;

--
-- AUTO_INCREMENT cho bảng `product_images`
--
ALTER TABLE `product_images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `social_accounts`
--
ALTER TABLE `social_accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `tokens`
--
ALTER TABLE `tokens`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Các ràng buộc cho bảng `order_details`
--
ALTER TABLE `order_details`
  ADD CONSTRAINT `order_details_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  ADD CONSTRAINT `order_details_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

--
-- Các ràng buộc cho bảng `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`);

--
-- Các ràng buộc cho bảng `product_images`
--
ALTER TABLE `product_images`
  ADD CONSTRAINT `fk_product_images_product_id` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_images_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

--
-- Các ràng buộc cho bảng `social_accounts`
--
ALTER TABLE `social_accounts`
  ADD CONSTRAINT `social_accounts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Các ràng buộc cho bảng `tokens`
--
ALTER TABLE `tokens`
  ADD CONSTRAINT `tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Các ràng buộc cho bảng `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
