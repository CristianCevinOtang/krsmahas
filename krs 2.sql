-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 27, 2026 at 03:17 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `krs`
--

-- --------------------------------------------------------

--
-- Table structure for table `dosen`
--

CREATE TABLE `dosen` (
  `id_dosen` int(11) NOT NULL,
  `nama_dosen` varchar(100) NOT NULL,
  `id_prodi` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dosen`
--

INSERT INTO `dosen` (`id_dosen`, `nama_dosen`, `id_prodi`) VALUES
(1, 'Dr. Budi Santoso, M.Kom', 1),
(2, 'Siti Rahayu, S.T., M.T.', 1),
(3, 'Ahmad Fauzi, M.Kom', 2),
(4, 'Dewi Lestari, M.SI', 2);

-- --------------------------------------------------------

--
-- Table structure for table `dosen_wali`
--

CREATE TABLE `dosen_wali` (
  `id_dosen_wali` int(11) NOT NULL,
  `nim` varchar(15) DEFAULT NULL,
  `id_dosen` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dosen_wali`
--

INSERT INTO `dosen_wali` (`id_dosen_wali`, `nim`, `id_dosen`) VALUES
(1, '2022001001', 1),
(2, '2022001002', 1),
(3, '2022002001', 3);

-- --------------------------------------------------------

--
-- Table structure for table `jadwal`
--

CREATE TABLE `jadwal` (
  `id_jadwal` int(11) NOT NULL,
  `id_kelas` int(11) DEFAULT NULL,
  `hari` enum('Senin','Selasa','Rabu','Kamis','Jumat','Sabtu') NOT NULL,
  `jam_mulai` time NOT NULL,
  `jam_selesai` time NOT NULL,
  `ruang` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `jadwal`
--

INSERT INTO `jadwal` (`id_jadwal`, `id_kelas`, `hari`, `jam_mulai`, `jam_selesai`, `ruang`) VALUES
(1, 1, 'Senin', '08:00:00', '10:30:00', 'Lab A101'),
(2, 2, 'Selasa', '10:00:00', '12:30:00', 'Lab B202'),
(3, 3, 'Rabu', '13:00:00', '14:40:00', 'Ruang 301'),
(4, 4, 'Kamis', '08:00:00', '10:30:00', 'Ruang 201'),
(5, 5, 'Jumat', '10:00:00', '11:40:00', 'Ruang 302');

-- --------------------------------------------------------

--
-- Table structure for table `kelas`
--

CREATE TABLE `kelas` (
  `id_kelas` int(11) NOT NULL,
  `kode_mk` varchar(10) DEFAULT NULL,
  `semester` int(11) NOT NULL,
  `tahun_ajaran` varchar(10) NOT NULL,
  `kapasitas` int(11) NOT NULL DEFAULT 40,
  `jumlah_peserta` int(11) NOT NULL DEFAULT 0,
  `id_dosen` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kelas`
--

INSERT INTO `kelas` (`id_kelas`, `kode_mk`, `semester`, `tahun_ajaran`, `kapasitas`, `jumlah_peserta`, `id_dosen`) VALUES
(1, 'TI101', 2, '2022/2023', 40, 2, 1),
(2, 'TI102', 2, '2022/2023', 35, 2, 2),
(3, NULL, 2, '2022/2023', 30, 1, 1),
(4, 'SI101', 2, '2022/2023', 40, 0, 3),
(5, 'SI102', 2, '2022/2023', 30, 0, 4);

-- --------------------------------------------------------

--
-- Table structure for table `krs`
--

CREATE TABLE `krs` (
  `id_krs` int(11) NOT NULL,
  `nim` varchar(15) DEFAULT NULL,
  `semester` int(11) NOT NULL,
  `tahun_ajaran` varchar(10) NOT NULL,
  `status` enum('Menunggu','Disetujui','Ditolak') DEFAULT 'Menunggu',
  `catatan` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `krs`
--

INSERT INTO `krs` (`id_krs`, `nim`, `semester`, `tahun_ajaran`, `status`, `catatan`, `created_at`, `updated_at`) VALUES
(2, '2022001002', 2, '2022/2023', 'Disetujui', NULL, '2026-04-09 01:52:06', '2026-04-26 13:48:26');

-- --------------------------------------------------------

--
-- Table structure for table `krs_detail`
--

CREATE TABLE `krs_detail` (
  `id_krs_detail` int(11) NOT NULL,
  `id_krs` int(11) NOT NULL,
  `id_kelas` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `krs_detail`
--

INSERT INTO `krs_detail` (`id_krs_detail`, `id_krs`, `id_kelas`) VALUES
(4, 2, 1),
(5, 2, 2);

--
-- Triggers `krs_detail`
--
DELIMITER $$
CREATE TRIGGER `trg_krs_detail_after_delete` AFTER DELETE ON `krs_detail` FOR EACH ROW BEGIN
  UPDATE `kelas`
  SET `jumlah_peserta` = `jumlah_peserta` - 1
  WHERE `id_kelas` = OLD.`id_kelas`;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_krs_detail_after_insert` AFTER INSERT ON `krs_detail` FOR EACH ROW BEGIN
  UPDATE `kelas`
  SET `jumlah_peserta` = `jumlah_peserta` + 1
  WHERE `id_kelas` = NEW.`id_kelas`;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_krs_detail_before_insert` BEFORE INSERT ON `krs_detail` FOR EACH ROW BEGIN
  DECLARE v_kapasitas      int;
  DECLARE v_jumlah_peserta int;

  SELECT `kapasitas`, `jumlah_peserta`
  INTO   v_kapasitas, v_jumlah_peserta
  FROM   `kelas`
  WHERE  `id_kelas` = NEW.`id_kelas`;

  IF v_jumlah_peserta >= v_kapasitas THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Kelas sudah penuh, tidak dapat mendaftar.';
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `mahasiswa`
--

CREATE TABLE `mahasiswa` (
  `nim` varchar(15) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `angkatan` year(4) NOT NULL,
  `id_prodi` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `mahasiswa`
--

INSERT INTO `mahasiswa` (`nim`, `nama`, `angkatan`, `id_prodi`) VALUES
('2022001001', 'Andi Pratama', '2022', 1),
('2022001002', 'Bela Safitri', '2022', 1),
('2022002001', 'Candra Wijaya', '2022', 2);

-- --------------------------------------------------------

--
-- Table structure for table `mata_kuliah`
--

CREATE TABLE `mata_kuliah` (
  `kode_mk` varchar(10) NOT NULL,
  `nama_mk` varchar(100) NOT NULL,
  `sks` int(11) NOT NULL,
  `id_prodi` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `mata_kuliah`
--

INSERT INTO `mata_kuliah` (`kode_mk`, `nama_mk`, `sks`, `id_prodi`) VALUES
('SI101', 'Sistem Informasi Manajemen', 2, 2),
('SI102', 'Analisis Sistem', 2, 2),
('ST103', 'JMK', 2, 1),
('TI101', 'Algoritma dan Pemrograman', 3, 1),
('TI102', 'Basis Data', 2, 1);

-- --------------------------------------------------------

--
-- Table structure for table `prodi`
--

CREATE TABLE `prodi` (
  `id_prodi` int(11) NOT NULL,
  `nama_prodi` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `prodi`
--

INSERT INTO `prodi` (`id_prodi`, `nama_prodi`) VALUES
(1, 'Teknik Informatika'),
(2, 'Sistem Informasi'),
(3, 'Manajemen Informatika');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id_user` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL COMMENT 'Simpan hash bcrypt, bukan plaintext',
  `role` enum('mahasiswa','dosen','admin') NOT NULL DEFAULT 'mahasiswa',
  `id_ref` varchar(15) DEFAULT NULL COMMENT 'nim jika mahasiswa, id_dosen jika dosen',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id_user`, `username`, `password`, `role`, `id_ref`, `created_at`) VALUES
(1, '2022001001', '$2y$10$contohHashBcrypt1234567890abcde', 'mahasiswa', '2022001001', '2026-04-09 01:52:06'),
(2, '2022001002', '$2y$10$contohHashBcrypt1234567890abcde', 'mahasiswa', '2022001002', '2026-04-09 01:52:06'),
(3, '2022002001', '$2y$10$contohHashBcrypt1234567890abcde', 'mahasiswa', '2022002002', '2026-04-09 01:52:06'),
(11, 'admin', '123', 'admin', NULL, '2026-04-26 12:33:35');

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_kelas_tersedia`
-- (See below for the actual view)
--
CREATE TABLE `v_kelas_tersedia` (
`id_kelas` int(11)
,`kode_mk` varchar(10)
,`nama_mk` varchar(100)
,`sks` int(11)
,`semester` int(11)
,`tahun_ajaran` varchar(10)
,`kapasitas` int(11)
,`jumlah_peserta` int(11)
,`sisa_kursi` bigint(12)
,`nama_dosen` varchar(100)
,`hari` enum('Senin','Selasa','Rabu','Kamis','Jumat','Sabtu')
,`jam_mulai` time
,`jam_selesai` time
,`ruang` varchar(20)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_krs_lengkap`
-- (See below for the actual view)
--
CREATE TABLE `v_krs_lengkap` (
`id_krs` int(11)
,`nim` varchar(15)
,`nama_mahasiswa` varchar(100)
,`semester` int(11)
,`tahun_ajaran` varchar(10)
,`status` enum('Menunggu','Disetujui','Ditolak')
,`catatan` text
,`kode_mk` varchar(10)
,`nama_mk` varchar(100)
,`sks` int(11)
,`dosen_pengampu` varchar(100)
,`hari` enum('Senin','Selasa','Rabu','Kamis','Jumat','Sabtu')
,`jam_mulai` time
,`jam_selesai` time
,`ruang` varchar(20)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_total_sks`
-- (See below for the actual view)
--
CREATE TABLE `v_total_sks` (
`nim` varchar(15)
,`nama` varchar(100)
,`semester` int(11)
,`tahun_ajaran` varchar(10)
,`status` enum('Menunggu','Disetujui','Ditolak')
,`total_sks` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Structure for view `v_kelas_tersedia`
--
DROP TABLE IF EXISTS `v_kelas_tersedia`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_kelas_tersedia`  AS SELECT `kl`.`id_kelas` AS `id_kelas`, `mk`.`kode_mk` AS `kode_mk`, `mk`.`nama_mk` AS `nama_mk`, `mk`.`sks` AS `sks`, `kl`.`semester` AS `semester`, `kl`.`tahun_ajaran` AS `tahun_ajaran`, `kl`.`kapasitas` AS `kapasitas`, `kl`.`jumlah_peserta` AS `jumlah_peserta`, `kl`.`kapasitas`- `kl`.`jumlah_peserta` AS `sisa_kursi`, `d`.`nama_dosen` AS `nama_dosen`, `j`.`hari` AS `hari`, `j`.`jam_mulai` AS `jam_mulai`, `j`.`jam_selesai` AS `jam_selesai`, `j`.`ruang` AS `ruang` FROM (((`kelas` `kl` join `mata_kuliah` `mk` on(`kl`.`kode_mk` = `mk`.`kode_mk`)) left join `dosen` `d` on(`kl`.`id_dosen` = `d`.`id_dosen`)) left join `jadwal` `j` on(`kl`.`id_kelas` = `j`.`id_kelas`)) WHERE `kl`.`jumlah_peserta` < `kl`.`kapasitas` ;

-- --------------------------------------------------------

--
-- Structure for view `v_krs_lengkap`
--
DROP TABLE IF EXISTS `v_krs_lengkap`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_krs_lengkap`  AS SELECT `k`.`id_krs` AS `id_krs`, `k`.`nim` AS `nim`, `m`.`nama` AS `nama_mahasiswa`, `k`.`semester` AS `semester`, `k`.`tahun_ajaran` AS `tahun_ajaran`, `k`.`status` AS `status`, `k`.`catatan` AS `catatan`, `mk`.`kode_mk` AS `kode_mk`, `mk`.`nama_mk` AS `nama_mk`, `mk`.`sks` AS `sks`, `d`.`nama_dosen` AS `dosen_pengampu`, `j`.`hari` AS `hari`, `j`.`jam_mulai` AS `jam_mulai`, `j`.`jam_selesai` AS `jam_selesai`, `j`.`ruang` AS `ruang` FROM ((((((`krs` `k` join `mahasiswa` `m` on(`k`.`nim` = `m`.`nim`)) join `krs_detail` `kd` on(`k`.`id_krs` = `kd`.`id_krs`)) join `kelas` `kl` on(`kd`.`id_kelas` = `kl`.`id_kelas`)) join `mata_kuliah` `mk` on(`kl`.`kode_mk` = `mk`.`kode_mk`)) left join `dosen` `d` on(`kl`.`id_dosen` = `d`.`id_dosen`)) left join `jadwal` `j` on(`kl`.`id_kelas` = `j`.`id_kelas`)) ;

-- --------------------------------------------------------

--
-- Structure for view `v_total_sks`
--
DROP TABLE IF EXISTS `v_total_sks`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_total_sks`  AS SELECT `k`.`nim` AS `nim`, `m`.`nama` AS `nama`, `k`.`semester` AS `semester`, `k`.`tahun_ajaran` AS `tahun_ajaran`, `k`.`status` AS `status`, sum(`mk`.`sks`) AS `total_sks` FROM ((((`krs` `k` join `mahasiswa` `m` on(`k`.`nim` = `m`.`nim`)) join `krs_detail` `kd` on(`k`.`id_krs` = `kd`.`id_krs`)) join `kelas` `kl` on(`kd`.`id_kelas` = `kl`.`id_kelas`)) join `mata_kuliah` `mk` on(`kl`.`kode_mk` = `mk`.`kode_mk`)) GROUP BY `k`.`id_krs` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `dosen`
--
ALTER TABLE `dosen`
  ADD PRIMARY KEY (`id_dosen`),
  ADD KEY `id_prodi` (`id_prodi`);

--
-- Indexes for table `dosen_wali`
--
ALTER TABLE `dosen_wali`
  ADD PRIMARY KEY (`id_dosen_wali`),
  ADD UNIQUE KEY `uq_dosen_wali_nim` (`nim`),
  ADD KEY `id_dosen` (`id_dosen`);

--
-- Indexes for table `jadwal`
--
ALTER TABLE `jadwal`
  ADD PRIMARY KEY (`id_jadwal`),
  ADD KEY `id_kelas` (`id_kelas`);

--
-- Indexes for table `kelas`
--
ALTER TABLE `kelas`
  ADD PRIMARY KEY (`id_kelas`),
  ADD KEY `kode_mk` (`kode_mk`),
  ADD KEY `id_dosen` (`id_dosen`);

--
-- Indexes for table `krs`
--
ALTER TABLE `krs`
  ADD PRIMARY KEY (`id_krs`),
  ADD UNIQUE KEY `uq_krs_periode` (`nim`,`semester`,`tahun_ajaran`);

--
-- Indexes for table `krs_detail`
--
ALTER TABLE `krs_detail`
  ADD PRIMARY KEY (`id_krs_detail`),
  ADD UNIQUE KEY `uq_krs_kelas` (`id_krs`,`id_kelas`),
  ADD KEY `id_kelas` (`id_kelas`);

--
-- Indexes for table `mahasiswa`
--
ALTER TABLE `mahasiswa`
  ADD PRIMARY KEY (`nim`),
  ADD KEY `id_prodi` (`id_prodi`);

--
-- Indexes for table `mata_kuliah`
--
ALTER TABLE `mata_kuliah`
  ADD PRIMARY KEY (`kode_mk`),
  ADD KEY `id_prodi` (`id_prodi`);

--
-- Indexes for table `prodi`
--
ALTER TABLE `prodi`
  ADD PRIMARY KEY (`id_prodi`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id_user`),
  ADD UNIQUE KEY `uq_username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `dosen`
--
ALTER TABLE `dosen`
  MODIFY `id_dosen` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `dosen_wali`
--
ALTER TABLE `dosen_wali`
  MODIFY `id_dosen_wali` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `jadwal`
--
ALTER TABLE `jadwal`
  MODIFY `id_jadwal` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `kelas`
--
ALTER TABLE `kelas`
  MODIFY `id_kelas` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `krs`
--
ALTER TABLE `krs`
  MODIFY `id_krs` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `krs_detail`
--
ALTER TABLE `krs_detail`
  MODIFY `id_krs_detail` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `prodi`
--
ALTER TABLE `prodi`
  MODIFY `id_prodi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id_user` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `dosen`
--
ALTER TABLE `dosen`
  ADD CONSTRAINT `dosen_ibfk_1` FOREIGN KEY (`id_prodi`) REFERENCES `prodi` (`id_prodi`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `dosen_wali`
--
ALTER TABLE `dosen_wali`
  ADD CONSTRAINT `dosen_wali_ibfk_1` FOREIGN KEY (`nim`) REFERENCES `mahasiswa` (`nim`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `dosen_wali_ibfk_2` FOREIGN KEY (`id_dosen`) REFERENCES `dosen` (`id_dosen`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `jadwal`
--
ALTER TABLE `jadwal`
  ADD CONSTRAINT `jadwal_ibfk_1` FOREIGN KEY (`id_kelas`) REFERENCES `kelas` (`id_kelas`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `kelas`
--
ALTER TABLE `kelas`
  ADD CONSTRAINT `kelas_ibfk_1` FOREIGN KEY (`kode_mk`) REFERENCES `mata_kuliah` (`kode_mk`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `kelas_ibfk_2` FOREIGN KEY (`id_dosen`) REFERENCES `dosen` (`id_dosen`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `krs`
--
ALTER TABLE `krs`
  ADD CONSTRAINT `krs_ibfk_1` FOREIGN KEY (`nim`) REFERENCES `mahasiswa` (`nim`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `krs_detail`
--
ALTER TABLE `krs_detail`
  ADD CONSTRAINT `krs_detail_ibfk_1` FOREIGN KEY (`id_krs`) REFERENCES `krs` (`id_krs`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `krs_detail_ibfk_2` FOREIGN KEY (`id_kelas`) REFERENCES `kelas` (`id_kelas`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `mahasiswa`
--
ALTER TABLE `mahasiswa`
  ADD CONSTRAINT `mahasiswa_ibfk_1` FOREIGN KEY (`id_prodi`) REFERENCES `prodi` (`id_prodi`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `mata_kuliah`
--
ALTER TABLE `mata_kuliah`
  ADD CONSTRAINT `mata_kuliah_ibfk_1` FOREIGN KEY (`id_prodi`) REFERENCES `prodi` (`id_prodi`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
