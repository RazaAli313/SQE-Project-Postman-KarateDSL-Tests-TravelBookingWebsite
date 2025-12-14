# Environment Variables Guide

This document lists all required environment variables for the Travel Booking Website backend.

## Required Environment Variables

Create a `.env` file in the `backend/` directory with the following variables:

### 1. MongoDB Configuration

```env
MONGODB_URI=mongodb://localhost:27017
```

**Description**: MongoDB connection string  
**Required**: ✅ Yes  
**Options**:
- **Local MongoDB**: `mongodb://localhost:27017`
- **MongoDB Atlas**: `mongodb+srv://username:password@cluster.mongodb.net`
- **Other Cloud**: Your MongoDB connection string

**How to get**:
- Local: Install MongoDB locally or use Docker
- Atlas: Create free cluster at [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)

---

### 2. Server Port

```env
PORT=3000
```

**Description**: Port on which the backend server runs  
**Required**: ⚠️ Optional (defaults to 8080)  
**Note**: Frontend is configured for port 3000, so set this to 3000 to match

---

### 3. JWT Secret Key

```env
SECRET_KEY=your_super_secret_jwt_key_here
```

**Description**: Secret key for signing JWT tokens  
**Required**: ✅ Yes  
**Security**: Use a strong, random string (at least 32 characters)

**Generate a secure key**:
```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

**Example**: `a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6`

---

### 4. Email Configuration (for OTP)

```env
AUTH_MAIL_USER=your_email@gmail.com
AUTH_MAIL_PASS=your_app_password_here
```

**Description**: Email credentials for sending OTP and notifications  
**Required**: ✅ Yes (for email verification feature)

**For Gmail**:
1. Enable 2-Factor Authentication
2. Go to [Google App Passwords](https://myaccount.google.com/apppasswords)
3. Generate an App Password
4. Use the App Password (not your regular password)

**For other email providers**: Use your email service credentials

---

### 5. Redis Configuration (Local on Mac)

```env
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=
```

**Description**: Redis connection details for OTP storage  
**Required**: ✅ Yes

**For Local Redis (Mac) - Recommended for Development**:
- `REDIS_HOST=localhost`
- `REDIS_PORT=6379` (default Redis port)
- `REDIS_PASSWORD=` (leave empty or don't set this variable for local Redis without password)

**Setup Local Redis on Mac**:
```bash
# Install Redis (if not installed)
brew install redis

# Start Redis service
brew services start redis

# Or start manually
redis-server

# Verify Redis is running
redis-cli ping
# Should return: PONG
```

**For Cloud Redis** (if using Redis Cloud in production):
- `REDIS_HOST=your-redis-host.redis.cloud.redislabs.com`
- `REDIS_PORT=12345`
- `REDIS_PASSWORD=your_redis_password`

**Note**: The code automatically handles local Redis (no password) vs cloud Redis (with password)

---

### 6. Stripe Payment Configuration

```env
STRIPE_SECRET_KEY=sk_test_your_stripe_secret_key_here
```

**Description**: Stripe API secret key for payment processing  
**Required**: ✅ Yes (for payment feature)

**How to get**:
1. Sign up at [Stripe](https://stripe.com)
2. Go to [Stripe Dashboard > API Keys](https://dashboard.stripe.com/apikeys)
3. Copy your **Secret key** (starts with `sk_test_` for test mode)
4. Use test keys for development

**Note**: The application uses Stripe in test mode, so use test keys

---

## Complete .env File Template

Create `backend/.env` with all variables:

```env
# MongoDB Configuration
MONGODB_URI=mongodb://localhost:27017

# Server Configuration
PORT=3000

# JWT Secret Key
SECRET_KEY=your_super_secret_jwt_key_here_change_this_in_production

# Email Configuration
AUTH_MAIL_USER=your_email@gmail.com
AUTH_MAIL_PASS=your_app_password_here

# Redis Configuration (Local)
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=

# Stripe Payment Configuration
STRIPE_SECRET_KEY=sk_test_your_stripe_secret_key_here
```

---

## Setup Instructions

### Step 1: Create .env File

```bash
cd backend
cp .env.example .env
# Or create manually
touch .env
```

### Step 2: Fill in Environment Variables

Edit `backend/.env` and replace placeholder values with your actual credentials.

### Step 3: Verify Setup

```bash
# Check if all required variables are set
cd backend
node -e "require('dotenv').config(); console.log('MONGODB_URI:', process.env.MONGODB_URI ? '✅ Set' : '❌ Missing'); console.log('SECRET_KEY:', process.env.SECRET_KEY ? '✅ Set' : '❌ Missing'); console.log('AUTH_MAIL_USER:', process.env.AUTH_MAIL_USER ? '✅ Set' : '❌ Missing'); console.log('REDIS_HOST:', process.env.REDIS_HOST ? '✅ Set' : '❌ Missing'); console.log('STRIPE_SECRET_KEY:', process.env.STRIPE_SECRET_KEY ? '✅ Set' : '❌ Missing');"
```

---

## Environment Variables Summary

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `MONGODB_URI` | ✅ Yes | - | MongoDB connection string |
| `PORT` | ⚠️ Optional | 8080 | Server port (use 3000 to match frontend) |
| `SECRET_KEY` | ✅ Yes | - | JWT secret key |
| `AUTH_MAIL_USER` | ✅ Yes | - | Email for sending OTPs |
| `AUTH_MAIL_PASS` | ✅ Yes | - | Email password/app password |
| `REDIS_HOST` | ✅ Yes | - | Redis host (localhost for local) |
| `REDIS_PORT` | ✅ Yes | - | Redis port (6379 for local) |
| `REDIS_PASSWORD` | ⚠️ Optional | - | Redis password (empty for local) |
| `STRIPE_SECRET_KEY` | ✅ Yes | - | Stripe API secret key |

---

## Security Best Practices

1. **Never commit `.env` file** - It's already in `.gitignore`
2. **Use strong SECRET_KEY** - Generate a random 32+ character string
3. **Use App Passwords** - For Gmail, use App Passwords, not regular password
4. **Use Test Keys for Development** - Use Stripe test keys, not production keys
5. **Rotate Keys Regularly** - Change keys periodically, especially in production

---

## Troubleshooting

### MongoDB Connection Failed
- Check `MONGODB_URI` is correct
- Verify MongoDB is running (if local)
- Check network connectivity (if cloud)

### Redis Connection Failed
- Verify Redis is running: `redis-cli ping`
- Check `REDIS_HOST` and `REDIS_PORT`
- For local Redis, ensure `REDIS_PASSWORD` is empty

### Email Not Sending
- Verify `AUTH_MAIL_USER` and `AUTH_MAIL_PASS` are correct
- For Gmail, ensure you're using App Password, not regular password
- Check email service credentials

### Stripe Payment Failed
- Verify `STRIPE_SECRET_KEY` is correct
- Ensure you're using test keys (starts with `sk_test_`)
- Check Stripe dashboard for API key status

---

## Quick Setup Checklist

- [ ] MongoDB connection string configured
- [ ] PORT set to 3000 (to match frontend)
- [ ] SECRET_KEY generated and set
- [ ] Email credentials configured (Gmail App Password)
- [ ] Redis running locally (`brew services start redis`)
- [ ] Redis environment variables set (localhost, 6379, empty password)
- [ ] Stripe test API key obtained and set
- [ ] `.env` file created in `backend/` directory
- [ ] All variables filled in with actual values

---

**Last Updated**: [Date]  
**For**: Travel Booking Website Backend

