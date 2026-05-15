# Hospitals API

Base URL mobil tətbiqdə `.env` faylındakı `BASE_URL` dəyərindən oxunur.

```env
BASE_URL=https://api.testgrelo.online
```

Base path: `/api/hospitals/`

Bu API şəhərlər, xəstəxanalar, bölmələr, həkim profilləri və həkim cədvəllərini idarə edir. Public endpointlər authentication tələb etmir. Doctor-panel və admin endpointləri JWT tələb edir.

List endpointləri backend-də paginated `{ "count": ..., "next": ..., "results": [...] }` formatında gələ bilər. Tətbiq uyğunluq üçün həm paginated cavabı, həm də birbaşa array cavabını oxuyur.

## Flutter İstifadəsi

Əsas client: `HospitalsApi`

- `cities()`
- `hospitals(cityId: ..., search: ...)`
- `departments(hospitalId: ...)`
- `doctors(hospitalId: ..., departmentId: ..., search: ...)`
- `doctor(id)`
- `doctorProfile()`
- `updateDoctorProfile(specialization: ..., bio: ...)`
- `doctorSchedules()`
- `createDoctorSchedule(weekday: ..., startTime: ..., endTime: ...)`
- `doctorSchedule(id)`
- `updateDoctorSchedule(id: ..., weekday: ..., startTime: ..., endTime: ...)`
- `deleteDoctorSchedule(id)`

## Public Endpoints

### GET `/api/hospitals/cities/`

Aktiv şəhərləri qaytarır.

**Permission:** Public

**Response (200 OK):**

```json
[
  { "id": 1, "name": "Bakı", "is_active": true },
  { "id": 2, "name": "Gəncə", "is_active": true }
]
```

### GET `/api/hospitals/hospitals/`

Aktiv xəstəxanaları qaytarır.

**Query Parameters:**

- `city` - şəhər ID-si
- `search` - xəstəxana adına görə axtarış

**Response (200 OK):**

```json
[
  {
    "id": 5,
    "city": 1,
    "city_name": "Bakı",
    "name": "Respublika Klinik Xəstəxanası",
    "address": "Bakı, Zülfüqar Əhmədov küç. 12",
    "phone": "+994124931234",
    "email": "info@rkx.az",
    "is_active": true,
    "created_at": "2024-01-15T08:00:00Z"
  }
]
```

### GET `/api/hospitals/departments/`

Aktiv bölmələri qaytarır.

**Query Parameters:**

- `hospital` - xəstəxana ID-si

**Response (200 OK):**

```json
[
  {
    "id": 3,
    "hospital": 5,
    "hospital_name": "Respublika Klinik Xəstəxanası",
    "name": "Kardioloji",
    "description": "Ürək-damar xəstəliklərinin müalicəsi",
    "is_active": true
  }
]
```

### GET `/api/hospitals/doctors/`

Aktiv həkimləri və onların həftəlik vaxt aralıqlarını qaytarır.

**Query Parameters:**

- `hospital` - xəstəxana ID-si
- `department` - bölmə ID-si
- `search` - ad, soyad və ya ixtisas üzrə axtarış

**Response (200 OK):**

```json
[
  {
    "id": 7,
    "user": {
      "id": 15,
      "email": "dr.anar.mammadov@hospital.az",
      "first_name": "Anar",
      "last_name": "Mammadov",
      "phone": "+994505559876"
    },
    "hospital": 5,
    "hospital_name": "Respublika Klinik Xəstəxanası",
    "department": 3,
    "department_name": "Kardioloji",
    "specialization": "Kardioloq",
    "bio": "20 ildən artıq klinik təcrübəsi olan mütəxəssis.",
    "is_active": true,
    "time_slots": [
      {
        "id": 12,
        "weekday": 0,
        "weekday_display": "Bazar ertəsi",
        "start_time": "09:00:00",
        "end_time": "09:30:00",
        "duration_minutes": 30
      }
    ]
  }
]
```

### GET `/api/hospitals/doctors/{id}/`

Həkimin public profilini qaytarır.

**Permission:** Public

**Response (200 OK):** `GET /api/hospitals/doctors/` list item ilə eyni formadadır.

## Doctor Panel Endpoints

> `role = doctor` olan authenticated istifadəçi tələb edir.

### GET `/api/hospitals/doctor/profile/`

Authenticated həkimin öz profilini qaytarır.

**Flutter istifadəsi:** `HospitalsApi.doctorProfile()`

### PATCH `/api/hospitals/doctor/profile/`

Həkimin `specialization` və ya `bio` sahəsini yeniləyir.

**Flutter istifadəsi:** `HospitalsApi.updateDoctorProfile(...)`

**Request Body:**

```json
{
  "specialization": "İnterventional Kardioloq",
  "bio": "Kateter əməliyyatları üzrə ixtisaslaşmış həkim."
}
```

### GET `/api/hospitals/doctor/schedules/`

Həkimin həftəlik vaxt aralıqlarını qaytarır.

**Flutter istifadəsi:** `HospitalsApi.doctorSchedules()`

### POST `/api/hospitals/doctor/schedules/`

Yeni həftəlik vaxt aralığı yaradır. `weekday`: `0=Monday ... 6=Sunday`.

**Flutter istifadəsi:** `HospitalsApi.createDoctorSchedule(...)`

**Request Body:**

```json
{
  "weekday": 1,
  "start_time": "10:00",
  "end_time": "10:30"
}
```

### GET `/api/hospitals/doctor/schedules/{id}/`

Konkret vaxt aralığını qaytarır.

**Flutter istifadəsi:** `HospitalsApi.doctorSchedule(id)`

### PATCH `/api/hospitals/doctor/schedules/{id}/`

Vaxt aralığını yeniləyir.

**Flutter istifadəsi:** `HospitalsApi.updateDoctorSchedule(...)`

### DELETE `/api/hospitals/doctor/schedules/{id}/`

Vaxt aralığını silir.

**Flutter istifadəsi:** `HospitalsApi.deleteDoctorSchedule(id)`

## Super Admin Endpoints

> Bütün `/admin/` endpointləri `super_admin` rolu tələb edir.

### Cities

- `GET /api/hospitals/admin/cities/`
- `POST /api/hospitals/admin/cities/`
- `GET /api/hospitals/admin/cities/{id}/`
- `PATCH /api/hospitals/admin/cities/{id}/`
- `DELETE /api/hospitals/admin/cities/{id}/`

### Hospitals

- `GET /api/hospitals/admin/hospitals/?city={id}&is_active=true|false`
- `POST /api/hospitals/admin/hospitals/`
- `GET /api/hospitals/admin/hospitals/{id}/`
- `PATCH /api/hospitals/admin/hospitals/{id}/`
- `DELETE /api/hospitals/admin/hospitals/{id}/`

### Departments

- `GET /api/hospitals/admin/departments/?hospital={id}`
- `POST /api/hospitals/admin/departments/`
- `GET /api/hospitals/admin/departments/{id}/`
- `PATCH /api/hospitals/admin/departments/{id}/`
- `DELETE /api/hospitals/admin/departments/{id}/`

### Doctors

- `GET /api/hospitals/admin/doctors/?hospital={id}&department={id}&is_active=true|false`
- `POST /api/hospitals/admin/doctors/create/`
- `GET /api/hospitals/admin/doctors/{id}/`
- `PATCH /api/hospitals/admin/doctors/{id}/`
- `DELETE /api/hospitals/admin/doctors/{id}/`
