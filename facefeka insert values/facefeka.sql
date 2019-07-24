-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 3, 2019 at 05:29 PM
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
CREATE DATABASE IF NOT EXISTS `facefeka` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `facefeka`;

-- --------------------------------------------------------

--
-- Table structure for table `certificates`
--

CREATE TABLE `certificates` (
  `certIndex` int(11) NOT NULL,
  `usersID` int(4) NOT NULL,
  `certificate` varchar(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `certificates`
--

INSERT INTO `certificates` (`certIndex`, `usersID`, `certificate`) VALUES
(2, 22222, '$7DtCTXaTEVDk'),
(3, 33333, '$7tDYz5fOsOV6'),
(4, 44444, '$7hmTbIqIL8QQ'),
(5, 55555, '$7jObasqJ85.c'),
(6, 66666, '$7hLg0YYG3Ryw'),
(7, 99999, '$7jhuQKAFpkXk');

-- --------------------------------------------------------

--
-- Table structure for table `follow`
--

CREATE TABLE `follow` (
  `followIndex` int(11) NOT NULL,
  `followedID` int(11) NOT NULL,
  `followerID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `follow`
--

INSERT INTO `follow` (`followIndex`, `followedID`, `followerID`) VALUES
(1, 22222, 33333),
(2, 55555, 33333),
(3, 44444, 33333),
(5, 33333, 99999),
(6, 33333, 55555),
(7, 55555, 22222);

-- --------------------------------------------------------

--
-- Table structure for table `likes`
--

CREATE TABLE `likes` (
  `likesIndex` int(11) NOT NULL,
  `postID` int(11) NOT NULL,
  `usersID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

CREATE TABLE `posts` (
  `postsID` int(11) NOT NULL,
  `usersID` int(11) NOT NULL,
  `postsContent` text NOT NULL,
  `postsPic` varchar(256) DEFAULT NULL,
  `postsDateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `private` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `posts`
--

INSERT INTO `posts` (`postsID`, `usersID`, `postsContent`, `postsPic`, `postsDateCreated`, `private`) VALUES
(1, 22222, 'We are engineers, not robots', NULL, '2019-07-12 20:42:31', 0),
(2, 22222, 'my Own post TEST 1', 'https://www.picmonkey.com/_/static/images/index/picmonkey_twitter_02.24fd38f81e59.jpg', '2019-07-12 21:26:37', 0),
(3, 33333, 'time is 3:23', '', '2019-07-13 12:23:17', 1),
(4, 22222, 'time 15:27', '', '2019-07-13 12:27:55', 1),
(5, 33333, 'my Own post TEST2', 'https://www.picmonkey.com/_/static/images/index/picmonkey_twitter_02.24fd38f81e59.jpg', '2019-07-13 07:26:37', 0),
(6, 55555, 'asdsad', '', '2019-07-14 20:17:03', 0),
(7, 99999, 'Pretty #bad\nhttps://t.co/Qr4lp0a3ni\r\n sentiment:negative.', 'https://www.hallaminternet.com/assets/Bad-Reviews-Dislike-Netative-Reviews.jpg', '2019-07-14 20:25:30', 0);

-- --------------------------------------------------------

--
-- Table structure for table `reply`
--

CREATE TABLE `reply` (
  `replyIndex` int(11) NOT NULL,
  `postsID` int(11) NOT NULL,
  `usersID` int(11) NOT NULL,
  `replyContent` text NOT NULL,
  `replyCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `reply`
--

INSERT INTO `reply` (`replyIndex`, `postsID`, `usersID`, `replyContent`, `replyCreated`) VALUES
(1, 2, 22222, 'Reply 1 TEST', '2019-07-12 22:44:52'),
(2, 2, 44444, 'LOL.', '2019-07-12 22:46:55'),
(3, 2, 33333, 'We are engineers, not robots', '2019-07-12 23:06:52'),
(4, 2, 22222, 'I can never find a decent parking spot near the phickus', '2019-07-13 00:13:58'),
(5, 3, 99999, 'The answer is 42', '2019-07-13 00:15:35'),
(6, 2, 22222, 'Why do you go to there?', '2019-07-13 11:08:23'),
(7, 1, 33333, 'Did you quit?', '2019-07-13 11:12:02'),
(8, 2, 33333, 'Hahahahaha', '2019-07-13 11:13:18'),
(9, 2, 44444, 'Play Flappy Birds together!', '2019-07-13 11:13:48'),
(10, 4, 33333, 'Even my sixth year in Afeka is better', '2019-07-13 11:15:24'),
(11, 6, 55555, 'When is the release of Angular 9?', '2019-07-14 20:17:21'),
(12, 5, 66666, 'Trust me, I am an engineer', '2019-07-14 20:17:39');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `usersIndex` int(11) NOT NULL,
  `usersID` int(4) NOT NULL,
  `usersName` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `usersPass` varchar(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`usersIndex`, `usersID`, `usersName`, `usersPass`) VALUES
(2, 22222, 'avia', '$7Ssq34cARZQc'),
(3, 33333, 'nofar', '$7.pB1DRQ1iro'),
(4, 44444, 'mica', '$7htfyt1oxDZ2'),
(5, 55555, 'god', '$71mtWt2hSULA'),
(6, 66666, 'devil', '$7KFhFYVG4dH6'),
(7, 99999, 'bibi', '$7lYSi.3FuIRo');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `certificates`
--
ALTER TABLE `certificates`
  ADD PRIMARY KEY (`certIndex`);

--
-- Indexes for table `follow`
--
ALTER TABLE `follow`
  ADD PRIMARY KEY (`followIndex`);

--
-- Indexes for table `likes`
--
ALTER TABLE `likes`
  ADD PRIMARY KEY (`likesIndex`);

--
-- Indexes for table `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`postsID`);

--
-- Indexes for table `reply`
--
ALTER TABLE `reply`
  ADD PRIMARY KEY (`replyIndex`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`usersID`),
  ADD KEY `usersIndex` (`usersIndex`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `certificates`
--
ALTER TABLE `certificates`
  MODIFY `certIndex` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
--
-- AUTO_INCREMENT for table `follow`
--
ALTER TABLE `follow`
  MODIFY `followIndex` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT for table `likes`
--
ALTER TABLE `likes`
  MODIFY `likesIndex` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `posts`
--
ALTER TABLE `posts`
  MODIFY `postsID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT for table `reply`
--
ALTER TABLE `reply`
  MODIFY `replyIndex` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `usersIndex` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
