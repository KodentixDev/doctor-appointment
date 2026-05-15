# Appointments API

Base URL mobil tətbiqdə `.env` faylındakı `BASE_URL` dəyərindən oxunur.
Cari layihədə:

```env
BASE_URL=https://api.testgrelo.online
```

Base path: `/api/appointments/`

Bütün endpointlər JWT authentication tələb edir. Tətbiq access tokeni bu başlıqla göndərir:

```http
Authorization: Bearer <access_token>
```

## Mobil tətbiqdə randevu axını

Vətəndaş randevunu bu ardıcıllıqla götürür:

1. Şəhər seçir.
2. Xəstəxana seçir.
3. Bölmə seçir.
4. Həkim seçir.
5. Həkimin boş günlərini və saatlarını görür.
6. Seçilmiş `doctor`, `appointment_date`, `start_time` ilə `/api/appointments/citizen/book/` endpointinə sorğu göndərir.

Bu seçimlər statik deyil, backend-dən gəlir:

- `GET /api/hospitals/cities/` - aktiv şəhərlər
- `GET /api/hospitals/hospitals/?city={city_id}` - seçilmiş şəhərin aktiv xəstəxanaları
- `GET /api/hospitals/departments/?hospital={hospital_id}` - seçilmiş xəstəxananın aktiv bölmələri
- `GET /api/hospitals/doctors/?hospital={hospital_id}&department={department_id}` - seçilmiş xəstəxana və bölmədə aktiv həkimlər

Həkim hesabı randevu götürmür; yalnız özünə təyin olunmuş randevuları və dashboard statistikalarını görür.

List endpointləri sənəddə array (`[...]`) qaytarır. Tətbiq uyğunluq üçün həm array cavabı, həm də paginated `{ "results": [...] }` cavabını oxuya bilir.

## Citizen Endpoints

### GET `/api/appointments/citizen/`

Authenticated vətəndaşın randevularını qaytarır.

**Permission:** Citizen only

**Flutter istifadəsi:** `AppointmentsApi.citizenAppointments(tab: ...)`

**Query Parameters:**

- `tab` - `upcoming` (default) | `past`

**Response (200 OK):**

```json
[
  {
    "id": 101,
    "citizen": 42,
    "citizen_name": "Aysel Mammadova",
    "doctor": 7,
    "doctor_name": "Dr. Anar Mammadov",
    "hospital_id": 5,
    "hospital_name": "Respublika Klinik Xəstəxanası",
    "department_name": "Kardioloji",
    "appointment_date": "2026-05-22",
    "start_time": "09:00:00",
    "end_time": "09:30:00",
    "status": "pending",
    "status_display": "Gözlənilir",
    "notes": "",
    "cancellation_reason": "",
    "is_cancellable": true,
    "created_at": "2026-05-15T10:30:00Z",
    "updated_at": "2026-05-15T10:30:00Z"
  }
]
```

### GET `/api/appointments/citizen/{id}/`

Vətəndaşa məxsus konkret randevunun detallarını qaytarır.

**Permission:** Citizen only

**Flutter istifadəsi:** `AppointmentsApi.citizenAppointmentDetail(id)`

### POST `/api/appointments/citizen/book/`

Yeni randevu yaradır. Tarix gələcəkdə olmalı, saat slotu həkimin qrafikində mövcud olmalı və tutulmamış olmalıdır.

**Permission:** Citizen only

**Flutter istifadəsi:** `AppointmentsApi.bookAppointment(...)`

**Request Body:**

```json
{
  "doctor": 7,
  "appointment_date": "2026-05-22",
  "start_time": "09:00"
}
```

**Response (201 Created):**

```json
{
  "id": 101,
  "citizen": 42,
  "citizen_name": "Aysel Mammadova",
  "doctor": 7,
  "doctor_name": "Dr. Anar Mammadov",
  "hospital_id": 5,
  "hospital_name": "Respublika Klinik Xəstəxanası",
  "department_name": "Kardioloji",
  "appointment_date": "2026-05-22",
  "start_time": "09:00:00",
  "end_time": "09:30:00",
  "status": "pending",
  "status_display": "Gözlənilir",
  "is_cancellable": true,
  "created_at": "2026-05-15T10:30:00Z",
  "updated_at": "2026-05-15T10:30:00Z"
}
```

Backend `403` booking ban və `409` slot taken cavablarında `detail` qaytarır. Tətbiq həmin mesajı snackbar kimi göstərir və slot siyahısını yeniləyir.

### POST `/api/appointments/citizen/{id}/cancel/`

Randevunu ləğv edir. Randevuya 24 saatdan az qalıbsa backend ləğvə icazə vermir. Ləğvdən sonra 15 iş günü booking ban tətbiq olunur.

**Permission:** Citizen only

**Flutter istifadəsi:** `AppointmentsApi.cancelAppointment(id, reason: ...)`

**Request Body:**

```json
{
  "reason": "Şəxsi səbəblər üzündən iştirak edə bilmərəm."
}
```

**Response (200 OK):**

```json
{
  "detail": "Randevu ləğv edildi. 05.06.2026 tarixinə qədər yeni randevu götürə bilməzsiniz."
}
```

## Availability Endpoints

### GET `/api/appointments/doctor/{doctor_id}/available-days/`

Növbəti 60 gün ərzində həkimin boş slot olan günlərini qaytarır.

**Permission:** Authenticated

**Flutter istifadəsi:** `AppointmentsApi.availableDays(doctorId)`

**Response (200 OK):**

```json
{
  "dates": ["2026-05-19", "2026-05-21", "2026-05-26", "2026-05-28"]
}
```

### GET `/api/appointments/doctor/{doctor_id}/slots/?date=YYYY-MM-DD`

Seçilmiş tarix üçün boş saat slotlarını qaytarır.

**Permission:** Authenticated

**Flutter istifadəsi:** `AppointmentsApi.availableSlots(doctorId, date)`

**Query Parameters:**

- `date` - required, `YYYY-MM-DD`

**Response (200 OK):**

```json
{
  "slots": [
    { "start": "09:00", "end": "09:30" },
    { "start": "09:30", "end": "10:00" },
    { "start": "10:30", "end": "11:00" }
  ]
}
```

## Doctor Endpoints

### GET `/api/appointments/doctor/`

Authenticated həkimə təyin olunmuş randevuları qaytarır.

**Permission:** Doctor only

**Flutter istifadəsi:** `AppointmentsApi.doctorAppointments(tab: ..., date: ...)`

**Query Parameters:**

- `tab` - `upcoming` (default) | `past`
- `date` - optional, `YYYY-MM-DD`

### GET `/api/appointments/doctor/{id}/`

Həkimə aid konkret randevunun detallarını qaytarır.

**Permission:** Doctor only

**Flutter istifadəsi:** `AppointmentsApi.doctorAppointmentDetail(id)`

### GET `/api/appointments/doctor/dashboard/`

Həkim dashboard-u üçün statistikaları, bugünkü randevuları və yaxınlaşan randevuları qaytarır.

**Permission:** Doctor only

**Flutter istifadəsi:** `AppointmentsApi.doctorDashboard()`

**Response (200 OK):**

```json
{
  "stats": {
    "total": 248,
    "today": 6,
    "pending": 14,
    "confirmed": 32
  },
  "today_appointments": [
    {
      "id": 105,
      "citizen_name": "Rauf Əliyev",
      "appointment_date": "2026-05-15",
      "start_time": "09:00:00",
      "end_time": "09:30:00",
      "status": "confirmed"
    }
  ],
  "upcoming": [
    {
      "id": 106,
      "citizen_name": "Nigar Quliyeva",
      "appointment_date": "2026-05-16",
      "start_time": "10:00:00",
      "end_time": "10:30:00",
      "status": "pending"
    }
  ]
}
```

## Web template endpoints

Bu Flutter tətbiqi web template endpointlərini çağırmır. Onlar backend-in HTML booking wizard və həkim idarəetmə paneli üçündür.
