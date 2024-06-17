/* WebPanel */
CREATE DATABASE `webpanel`;
USE `webpanel`;

CREATE TABLE `accounts` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `accounts` (`id`, `username`, `password`, `email`) VALUES
(7, 'Test', '$2y$10$HuCtcQll7n4EK02RgaWm7uJRDtFggtw9oQkfphOGc9drAO.1dfOXa', 'Test@test.com');

ALTER TABLE `accounts`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
COMMIT;

/* ESX */
USE `essentialmode`;

ALTER TABLE `users`
	ADD COLUMN `id` int(11) NOT NULL AUTO_INCREMENT,
	ADD PRIMARY KEY `id` (`id`);