-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 31-12-2020 a las 18:36:45
-- Versión del servidor: 10.1.38-MariaDB
-- Versión de PHP: 5.6.40

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `gvot2`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_crearUsuario` (`_usrNom` VARCHAR(150), `_idUniAdmva` INT, `_correo` VARCHAR(100))  BEGIN
SET @maxId=ifnull((
		 SELECT MAX(id) AS maxId 
		 FROM( SELECT id,activo,1 num FROM usuario) AS T1
		 GROUP BY num
     ),0)+1
     ;
     SET @psw=fn_crearKey(_pwdUsu);
     
     INSERT INTO usuario(id,usrNombre,idUnidadAdmva,activo,correo,pwdUsuario)
     SELECT @maxId,_usrNom,_idUniAdmva,'S',_correo,@psw
     ; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete` (`_idHiperVinculo` INT)  BEGIN
DELETE FROM hipervinculo WHERE idHiperVinculo =_idHiperVinculo ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_inurl` (IN `_idHiperVinculo` INT, IN `_nombreArchivo` VARCHAR(1000), IN `_anio` TINYINT(4), IN `_fraccion` VARCHAR(100), IN `_idTrimestre` TINYINT(4), IN `_url` VARCHAR(1000), IN `_fechaCreacion` DATETIME, IN `_fechaUltActualizacion` DATETIME, IN `_idUnidadAdmva` INT(11), IN `_activo` CHAR(1), IN `_tipoUltimoMov` CHAR(1))  BEGIN

/*set @id=(select max(idHiperVinculo) from hipervinculo ); select @id+1;*/
INSERT INTO hipervinculo (idHiperVinculo,
    nombreArchivo,
    anio,
    fraccion,
    idTrimestre,
    url,
    fechaCreacion,
    fechaUltActualizacion,
    idUnidadAdmva,
    activo,
    tipoUltimoMov
    ) 
    VALUES (_idHiperVinculo,
        _nombreArchivo,
        _anio,
        _fraccion,
        _idTrimestre,
        CONCAT('https://infocdmx.org.mx/LTAIPRC-2016-OT', _url,_nombreArchivo),
        NOW(),
        null,
        _idUnidadAdmva,
       1,
        1
        );

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update` (`_nombreArchivo` VARCHAR(1000), `_url` VARCHAR(1000), `_fechaUltActualizacion` DATETIME, `_usuarioUltMov` VARCHAR(100), `_tipoUltimoMov` CHAR(1))  BEGIN
update hipervinculo set 
nombreArchivo= _nombreArchivo,
url=CONCAT('https://infocdmx.org.mx/LTAIPRC-2016-OT', _url,_nombreArchivo),
fechaUltActualizacion=now(),
usuarioUltMov=_usuarioUltMov,
tipoUltimoMov=2
where nombreArchivo= _nombreArchivo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_validarUsuario` (`_usuario` VARCHAR(100), `_psw` VARCHAR(200))  BEGIN
	#SELECT _usuario,_psw,fn_crearKey(_psw) ;
    SET @res=ifnull((
		Select concat('{"id":',id,',"user":"',usrNombre,'","id_uniAdmva":',idUnidadAdmva,',"email":"',correo,'"}') 
		#select *
        FROM usuario
		WHERE  correo COLLATE utf8mb4_general_ci =_usuario
			and pwdUsuario=fn_crearKey(_psw) 
            and activo=1
     ),'')
    ;
    
    IF @res='' THEN
		SELECT '{"error":true,"msg":"No se reconoce el Usuiro y/o la contraseña"}' AS RES;
    ELSE
		SELECT concat('{"error":false,"res":',@res,'}') AS RES;
    END IF;
END$$

--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_crearKey` (`_key` VARCHAR(200)) RETURNS VARCHAR(200) CHARSET utf8mb4 BEGIN
	SET @secret='INFO&CDMX';
	
RETURN MD5(concat(@secret,_key ));
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `anionormatividad`
--

CREATE TABLE `anionormatividad` (
  `idAnioNormatividad` tinyint(255) NOT NULL,
  `descripcion` char(4) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `anionormatividad`
--

INSERT INTO `anionormatividad` (`idAnioNormatividad`, `descripcion`) VALUES
(1, '2018'),
(2, '2019'),
(3, '2020'),
(4, '2012');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `articulo`
--

CREATE TABLE `articulo` (
  `idArticulo` int(11) NOT NULL,
  `nombre` varchar(150) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `articulo`
--

INSERT INTO `articulo` (`idArticulo`, `nombre`) VALUES
(1, '121'),
(2, '133'),
(3, '139'),
(4, '140'),
(5, '143'),
(6, '146'),
(7, '147'),
(8, '172');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `droptableurl`
--

CREATE TABLE `droptableurl` (
  `id` int(11) NOT NULL,
  `nombre_archi` varchar(255) COLLATE utf8_spanish_ci NOT NULL,
  `url` varchar(255) COLLATE utf8_spanish_ci NOT NULL,
  `feca_delete` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `fraccion`
--

CREATE TABLE `fraccion` (
  `idFraccion` int(11) NOT NULL,
  `nombreFrac` int(11) NOT NULL,
  `aplicabilidad` varchar(255) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `fraccion`
--

INSERT INTO `fraccion` (`idFraccion`, `nombreFrac`, `aplicabilidad`) VALUES
(1, 1, ''),
(2, 2, ''),
(3, 3, ''),
(4, 4, ''),
(5, 5, ''),
(6, 6, ''),
(7, 7, ''),
(8, 8, ''),
(9, 9, ''),
(10, 10, ''),
(11, 11, ''),
(12, 12, ''),
(13, 13, ''),
(14, 14, ''),
(15, 15, ''),
(16, 16, ''),
(17, 17, ''),
(18, 18, ''),
(19, 19, ''),
(20, 20, ''),
(21, 21, ''),
(22, 22, ''),
(23, 23, ''),
(24, 24, ''),
(25, 25, ''),
(26, 26, ''),
(27, 27, ''),
(28, 28, ''),
(29, 29, ''),
(30, 30, ''),
(31, 31, ''),
(32, 32, ''),
(33, 33, ''),
(34, 34, ''),
(35, 35, ''),
(36, 36, ''),
(37, 37, ''),
(38, 38, ''),
(39, 39, ''),
(40, 40, ''),
(41, 41, ''),
(42, 42, ''),
(43, 43, ''),
(44, 44, ''),
(45, 45, ''),
(46, 46, ''),
(47, 47, ''),
(48, 48, ''),
(49, 49, ''),
(50, 50, ''),
(51, 51, ''),
(52, 52, ''),
(53, 53, ''),
(54, 54, '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `hipervinculo`
--

CREATE TABLE `hipervinculo` (
  `idHiperVinculo` int(255) NOT NULL,
  `nombreArchivo` varchar(1000) COLLATE utf8_spanish_ci NOT NULL,
  `anio` int(4) NOT NULL,
  `articulo` int(4) NOT NULL,
  `fraccion` varchar(100) COLLATE utf8_spanish_ci DEFAULT NULL,
  `idTrimestre` int(4) NOT NULL,
  `url` varchar(1000) COLLATE utf8_spanish_ci NOT NULL,
  `fechaCreacion` datetime NOT NULL,
  `fechaUltActualizacion` datetime DEFAULT NULL,
  `idUnidadAdmva` int(11) NOT NULL,
  `activo` char(1) COLLATE utf8_spanish_ci NOT NULL,
  `usuarioUltMov` varchar(100) COLLATE utf8_spanish_ci NOT NULL,
  `tipoUltimoMov` char(1) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `hipervinculo`
--

INSERT INTO `hipervinculo` (`idHiperVinculo`, `nombreArchivo`, `anio`, `articulo`, `fraccion`, `idTrimestre`, `url`, `fechaCreacion`, `fechaUltActualizacion`, `idUnidadAdmva`, `activo`, `usuarioUltMov`, `tipoUltimoMov`) VALUES
(1, 'hola.php', 127, 0, '122', 0, 'https://infocdmx.org.mx/LTAIPRC-2016-OT/doc/fr122/hola.php', '2020-12-22 10:26:54', '2020-12-23 15:15:26', 0, '1', 'diego', '2'),
(2, 'dig.doc', 127, 0, '122', 0, 'https://infocdmx.org.mx/LTAIPRC-2016-OT/doc/fr122/dig.doc', '2020-12-22 17:39:15', NULL, 0, '1', '', '1'),
(3, 'hola.php', 127, 0, '122', 0, 'https://infocdmx.org.mx/LTAIPRC-2016-OT/doc/fr122/hola.php', '2020-12-23 15:12:57', '2020-12-23 15:15:26', 0, '1', 'diego', '2');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisos`
--

CREATE TABLE `permisos` (
  `idPermiso` int(11) NOT NULL,
  `idUnidadAdmva` int(11) NOT NULL,
  `activo` int(11) NOT NULL,
  `idArticulo` int(11) NOT NULL,
  `idFraccion` int(11) NOT NULL,
  `idAnioNormatividad` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `trimestre`
--

CREATE TABLE `trimestre` (
  `idTrimestre` int(11) NOT NULL,
  `nombre` varchar(100) COLLATE utf8_spanish_ci NOT NULL,
  `claveTrimestre` varchar(20) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `trimestre`
--

INSERT INTO `trimestre` (`idTrimestre`, `nombre`, `claveTrimestre`) VALUES
(1, 'T01', 'T01'),
(2, 'T02', 'T02'),
(3, 'T03', 'T03'),
(4, 'T04', 'T04'),
(5, 'T01-T03', 'T01/T03'),
(6, 'T01-T04', 'T01/T03'),
(7, 'T01-T02', 'T01/T03');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `unidadadmva`
--

CREATE TABLE `unidadadmva` (
  `idUnidadAdmva` int(11) NOT NULL,
  `nombreCorto` char(4) COLLATE utf8_spanish_ci NOT NULL,
  `nombre` varchar(200) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `unidadadmva`
--

INSERT INTO `unidadadmva` (`idUnidadAdmva`, `nombreCorto`, `nombre`) VALUES
(1, 'ti', 'tecnologías de la información');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `id` int(11) NOT NULL,
  `usrNombre` varchar(150) COLLATE utf8_spanish_ci NOT NULL,
  `idUnidadAdmva` int(11) NOT NULL,
  `activo` char(1) COLLATE utf8_spanish_ci NOT NULL,
  `correo` varchar(100) COLLATE utf8_spanish_ci NOT NULL,
  `pwdUsuario` varchar(255) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`id`, `usrNombre`, `idUnidadAdmva`, `activo`, `correo`, `pwdUsuario`) VALUES
(1, 'diego fulgencio', 1, '1', 'edsiodfr@hotmail.com', '2e49941b4a727c416d6f677703b37f7b');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `anionormatividad`
--
ALTER TABLE `anionormatividad`
  ADD PRIMARY KEY (`idAnioNormatividad`);

--
-- Indices de la tabla `articulo`
--
ALTER TABLE `articulo`
  ADD PRIMARY KEY (`idArticulo`);

--
-- Indices de la tabla `droptableurl`
--
ALTER TABLE `droptableurl`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `fraccion`
--
ALTER TABLE `fraccion`
  ADD PRIMARY KEY (`idFraccion`);

--
-- Indices de la tabla `hipervinculo`
--
ALTER TABLE `hipervinculo`
  ADD PRIMARY KEY (`idHiperVinculo`);

--
-- Indices de la tabla `permisos`
--
ALTER TABLE `permisos`
  ADD PRIMARY KEY (`idPermiso`);

--
-- Indices de la tabla `unidadadmva`
--
ALTER TABLE `unidadadmva`
  ADD PRIMARY KEY (`idUnidadAdmva`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `anionormatividad`
--
ALTER TABLE `anionormatividad`
  MODIFY `idAnioNormatividad` tinyint(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `articulo`
--
ALTER TABLE `articulo`
  MODIFY `idArticulo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `droptableurl`
--
ALTER TABLE `droptableurl`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `fraccion`
--
ALTER TABLE `fraccion`
  MODIFY `idFraccion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT de la tabla `hipervinculo`
--
ALTER TABLE `hipervinculo`
  MODIFY `idHiperVinculo` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `permisos`
--
ALTER TABLE `permisos`
  MODIFY `idPermiso` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `unidadadmva`
--
ALTER TABLE `unidadadmva`
  MODIFY `idUnidadAdmva` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
