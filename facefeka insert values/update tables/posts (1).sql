-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 23, 2019 at 09:10 PM
-- Server version: 10.3.16-MariaDB
-- PHP Version: 7.3.7

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `facefeka`
--

-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

CREATE TABLE `posts` (
  `postsID` int(11) NOT NULL,
  `usersID` int(11) NOT NULL,
  `postsContent` text NOT NULL,
  `postsPic` varchar(256) DEFAULT NULL,
  `postsDateCreated` timestamp NOT NULL DEFAULT current_timestamp(),
  `private` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `posts`
--

INSERT INTO `posts` (`postsID`, `usersID`, `postsContent`, `postsPic`, `postsDateCreated`, `private`) VALUES
(0, 22222, 'drake', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSksb-npSRowVx-FwWVYRj3cHN6ReIkJ6vxphPmRoVsLj7JdLgX', '2019-07-23 15:50:26', 0),
(1, 22222, 'We are engineers, not robots', NULL, '2019-07-12 20:42:31', 0),
(2, 22222, 'my Own post TEST 1', 'https://www.picmonkey.com/_/static/images/index/picmonkey_twitter_02.24fd38f81e59.jpg', '2019-07-12 21:26:37', 0),
(3, 33333, 'time is 3:23', '', '2019-07-13 12:23:17', 1),
(4, 22222, 'time 15:27', '', '2019-07-13 12:27:55', 1),
(5, 33333, 'my Own post TEST2', 'https://www.picmonkey.com/_/static/images/index/picmonkey_twitter_02.24fd38f81e59.jpg', '2019-07-13 07:26:37', 0),
(6, 55555, 'what?', '', '2019-07-14 20:17:03', 0),
(7, 99999, 'Pretty #bad\nhttps://t.co/Qr4lp0a3ni\r\n sentiment:negative.', 'https://www.hallaminternet.com/assets/Bad-Reviews-Dislike-Netative-Reviews.jpg', '2019-07-14 20:25:30', 0),
(8, 22222, 'Pretty', 'https://images.pexels.com/photos/67636/rose-blue-flower-rose-blooms-67636.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500', '2019-07-23 15:45:59', 0);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
