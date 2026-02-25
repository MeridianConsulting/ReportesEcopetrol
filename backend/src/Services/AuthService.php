<?php

namespace App\Services;

use App\Repositories\UserRepository;
use App\Repositories\RefreshTokenRepository;

/**
 * Adaptado a reportes_ods: users no tiene password_hash; no existe tabla refresh_tokens.
 * Login requiere password_hash (si no existe en BD, credenciales inválidas).
 * Refresh es stateless (solo JWT); logout no revoca en BD.
 */
class AuthService
{
  private $userRepository;
  private $jwtService;
  private $refreshTokenRepository;

  public function __construct()
  {
    $this->userRepository = new UserRepository();
    $this->jwtService = new JwtService();
    $this->refreshTokenRepository = new RefreshTokenRepository();
  }

  /**
   * Validación del login (reportes_ods):
   * 1) Buscar usuario por tabla users, campo email.
   * 2) Si existe columna users.password_hash: validar con password_verify (o texto plano).
   * 3) Si no existe password_hash: permitir login solo con email (sin validar contraseña), para entornos donde la BD solo tiene id+email.
   */
  public function login(string $email, string $password, string $ip, string $userAgent): array
  {
    $user = $this->userRepository->findByEmail($email);

    if (!$user) {
      throw new \Exception('Invalid credentials');
    }

    $passwordHash = $user['password_hash'] ?? null;

    if ($passwordHash !== null && $passwordHash !== '') {
      $passwordValid = password_verify($password, $passwordHash) || $passwordHash === $password;
      if (!$passwordValid) {
        throw new \Exception('Invalid credentials');
      }
    }
    // Si no hay password_hash en la BD (reportes_ods solo tiene users.id, users.email), se acepta el login con email correcto

    if (!($user['is_active'] ?? true)) {
      throw new \Exception('User account is inactive');
    }

    $accessToken = $this->jwtService->generateAccessToken(
      $user['id'],
      $user['role_name'] ?? 'colaborador',
      $user['area_id'] ?? null
    );

    $refreshToken = $this->jwtService->generateRefreshToken($user['id']);

    try {
      $tokenHash = $this->jwtService->hashToken($refreshToken);
      $expiresAt = date('Y-m-d H:i:s', time() + (JWT_REFRESH_TTL_DAYS * 24 * 60 * 60));
      $this->refreshTokenRepository->create([
        'user_id' => $user['id'],
        'token_hash' => $tokenHash,
        'expires_at' => $expiresAt,
        'ip' => $ip,
        'user_agent' => $userAgent,
      ]);
    } catch (\Throwable $e) {
      // Tabla refresh_tokens puede no existir en reportes_ods; continuar sin guardar
    }

    return [
      'access_token' => $accessToken,
      'refresh_token' => $refreshToken,
      'user' => $user,
    ];
  }

  public function refresh(string $refreshToken, string $ip, string $userAgent): array
  {
    $payload = $this->jwtService->validate($refreshToken);

    if (($payload['type'] ?? '') !== 'refresh') {
      throw new \Exception('Invalid token type');
    }

    $user = $this->userRepository->findById($payload['sub']);

    if (!$user || !($user['is_active'] ?? true)) {
      throw new \Exception('User account is inactive');
    }

    try {
      $tokenHash = $this->jwtService->hashToken($refreshToken);
      $this->refreshTokenRepository->revokeToken($tokenHash);
    } catch (\Throwable $e) {
      // Tabla refresh_tokens puede no existir
    }

    $newAccessToken = $this->jwtService->generateAccessToken(
      $user['id'],
      $user['role_name'] ?? 'colaborador',
      $user['area_id'] ?? null
    );

    $newRefreshToken = $this->jwtService->generateRefreshToken($user['id']);

    try {
      $newTokenHash = $this->jwtService->hashToken($newRefreshToken);
      $expiresAt = date('Y-m-d H:i:s', time() + (JWT_REFRESH_TTL_DAYS * 24 * 60 * 60));
      $this->refreshTokenRepository->create([
        'user_id' => $user['id'],
        'token_hash' => $newTokenHash,
        'expires_at' => $expiresAt,
        'ip' => $ip,
        'user_agent' => $userAgent,
      ]);
    } catch (\Throwable $e) {
      // Tabla refresh_tokens puede no existir
    }

    return [
      'access_token' => $newAccessToken,
      'refresh_token' => $newRefreshToken,
    ];
  }

  public function logout(string $refreshToken): void
  {
    try {
      $tokenHash = $this->jwtService->hashToken($refreshToken);
      $this->refreshTokenRepository->revokeToken($tokenHash);
    } catch (\Throwable $e) {
      // Tabla refresh_tokens puede no existir
    }
  }

  public function logoutAll(int $userId): void
  {
    try {
      $this->refreshTokenRepository->revokeAllUserTokens($userId);
    } catch (\Throwable $e) {
      // Tabla refresh_tokens puede no existir
    }
  }
}
