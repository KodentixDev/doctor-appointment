# Accounts API

Base URL mobil tətbiqdə `.env` faylındakı `BASE_URL` dəyərindən oxunur.
Cari layihədə:

```env
BASE_URL=https://api.testgrelo.online
```

Base path: `/api/accounts/`

Authentication JWT əsaslıdır (SimpleJWT). Qorunan endpointlər üçün access token bu başlıqla göndərilir:

```http
Authorization: Bearer <access_token>
```

## Mobil tətbiqdə istifadə olunan rol axını

Tətbiq iki giriş növünü dəstəkləyir:

- `citizen` - vətəndaş hesabı
- `doctor` - həkim hesabı

Login zamanı istifadəçi ekranda `Vətəndaş` və ya `Həkim` seçir. Tətbiq əvvəlcə `/api/accounts/login/` endpointindən tokenləri alır, sonra `/api/accounts/me/` ilə real istifadəçi rolunu oxuyur. Seçilən rol backend-dən gələn `role` dəyəri ilə uyğun deyilsə, sessiya təmizlənir və istifadəçiyə səhv göstərilir.

Qeydiyyat yalnız vətəndaş üçündür. Həkim hesabları backend/admin tərəfindən yaradılmalıdır və həkimlər tətbiqə mövcud email/şifrə ilə daxil olmalıdır.

## Endpoints

### POST `/api/accounts/register/`

Yeni vətəndaş hesabı yaradır.

**Permission:** Public

**Flutter istifadəsi:** `AccountsApi.registerCitizen(...)`

**Request Body:**

```json
{
  "email": "aysel.huseynova@example.com",
  "first_name": "Aysel",
  "last_name": "Huseynova",
  "phone": "+994501234567",
  "fin_code": "ABC1234",
  "password": "SecurePass123!",
  "password2": "SecurePass123!"
}
```

**Response (201 Created):**

```json
{
  "id": 42,
  "email": "aysel.huseynova@example.com",
  "first_name": "Aysel",
  "last_name": "Huseynova",
  "role": "citizen",
  "phone": "+994501234567",
  "fin_code": "ABC1234"
}
```

### POST `/api/accounts/login/`

Email və şifrə ilə JWT access/refresh tokenləri qaytarır.

**Permission:** Public

**Flutter istifadəsi:** `AccountsApi.login(...)`

**Request Body:**

```json
{
  "email": "doctor@example.com",
  "password": "SecurePass123!"
}
```

**Response (200 OK):**

```json
{
  "access": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### GET `/api/accounts/me/`

Hazırkı access tokenə uyğun istifadəçi profilini qaytarır.

**Permission:** Authenticated

**Flutter istifadəsi:** login-dən sonra rol yoxlaması, splash sessiya bərpası, profil məlumatları.

**Response (200 OK):**

```json
{
  "id": 42,
  "email": "aysel.huseynova@example.com",
  "first_name": "Aysel",
  "last_name": "Huseynova",
  "role": "citizen",
  "phone": "+994501234567",
  "fin_code": "ABC1234"
}
```

`role` üçün gözlənilən dəyərlər:

- `citizen`
- `doctor`

### PATCH `/api/accounts/me/`

Hazırkı istifadəçinin profil məlumatlarını yeniləyir.

**Permission:** Authenticated

**Flutter istifadəsi:** `AccountsApi.updateMe(...)`

**Request Body:**

```json
{
  "first_name": "Aysel",
  "last_name": "Mammadova",
  "phone": "+994559876543",
  "fin_code": "ABC1234"
}
```

**Response (200 OK):**

```json
{
  "id": 42,
  "email": "aysel.huseynova@example.com",
  "first_name": "Aysel",
  "last_name": "Mammadova",
  "role": "citizen",
  "phone": "+994559876543",
  "fin_code": "ABC1234"
}
```

### POST `/api/accounts/change-password/`

Hazırkı istifadəçinin şifrəsini dəyişir.

**Permission:** Authenticated

**Flutter istifadəsi:** `AccountsApi.changePassword(...)`

**Request Body:**

```json
{
  "old_password": "SecurePass123!",
  "new_password": "NewSecurePass456!"
}
```

**Response (200 OK):**

```json
{
  "detail": "Şifrə dəyişdirildi."
}
```

### POST `/api/accounts/token/refresh/`

Refresh token ilə yeni access token alır.

**Permission:** Public

**Flutter istifadəsi:** `AccountsApi.refreshAccessToken()`

**Request Body:**

```json
{
  "refresh": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response (200 OK):**

```json
{
  "access": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### POST `/api/accounts/logout/`

Refresh tokeni blacklist edərək sessiyanı bitirir.

**Permission:** Authenticated

**Flutter istifadəsi:** `AccountsApi.logout()`

**Request Body:**

```json
{
  "refresh": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response (205 Reset Content):**

```json
{
  "detail": "Uğurla çıxış edildi."
}
```

## Admin endpoints

Bu Flutter tətbiqi admin panel ekranı implement etmir. Backend-də aşağıdakı endpointlər varsa, onlar yalnız `super_admin` roluna aid olmalıdır:

- `GET /api/accounts/admin/users/`
- `GET /api/accounts/admin/users/{id}/`
- `PATCH /api/accounts/admin/users/{id}/`
- `DELETE /api/accounts/admin/users/{id}/`

Mobil tətbiqin hazırkı login axını yalnız `citizen` və `doctor` rollarını istifadə edir.

## Web template endpoints

Bu Flutter tətbiqi template endpointləri çağırmır. Aşağıdakı URL-lər backend-in server-rendered HTML səhifələri üçündür:

| Method | URL | Description |
| --- | --- | --- |
| GET/POST | `/accounts/login/` | Login page |
| POST | `/accounts/logout/` | Logout redirect |
| GET/POST | `/accounts/register/` | Citizen registration page |
| GET/POST | `/accounts/profile/` | Edit own profile |
| GET | `/accounts/admin-panel/` | Admin dashboard |
