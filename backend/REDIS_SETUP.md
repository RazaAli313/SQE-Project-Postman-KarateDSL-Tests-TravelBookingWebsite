# Redis Setup Guide - Local on Mac

This guide explains how to set up and use local Redis on Mac for the Travel Booking Website.

## Why Local Redis?

- ✅ No cloud service needed for development
- ✅ Faster (no network latency)
- ✅ Free (no cloud costs)
- ✅ Easy to test and debug
- ✅ Works offline

## Installation

### Step 1: Install Redis

```bash
# Using Homebrew (recommended)
brew install redis
```

### Step 2: Start Redis

**Option A: Start as a service (recommended)**
```bash
brew services start redis
```

This starts Redis automatically on system boot.

**Option B: Start manually**
```bash
redis-server
```

This starts Redis in the foreground (press Ctrl+C to stop).

### Step 3: Verify Redis is Running

```bash
redis-cli ping
```

Expected output: `PONG`

## Configuration

### Environment Variables

In your `backend/.env` file, set:

```env
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=
```

**Important Notes**:
- `REDIS_HOST=localhost` - For local Redis
- `REDIS_PORT=6379` - Default Redis port
- `REDIS_PASSWORD=` - **Leave empty** for local Redis (no password required)

### How It Works

The backend code automatically detects if Redis password is set:
- **No password (empty)**: Connects to local Redis without authentication
- **Password set**: Connects to cloud Redis with authentication

## Testing Redis Connection

### Test from Command Line

```bash
# Connect to Redis CLI
redis-cli

# Test commands
127.0.0.1:6379> ping
PONG

127.0.0.1:6379> set test "Hello Redis"
OK

127.0.0.1:6379> get test
"Hello Redis"

127.0.0.1:6379> exit
```

### Test from Backend

When you start your backend server, you should see:
```
Connected to Redis!
```

If you see an error, check:
1. Redis is running: `redis-cli ping`
2. Environment variables are set correctly
3. Port 6379 is not blocked by firewall

## Common Commands

### Start/Stop Redis Service

```bash
# Start
brew services start redis

# Stop
brew services stop redis

# Restart
brew services restart redis

# Check status
brew services list
```

### Redis CLI Commands

```bash
# Connect to Redis
redis-cli

# List all keys
KEYS *

# Get a specific key
GET key_name

# Delete a key
DEL key_name

# Clear all keys (use with caution!)
FLUSHALL

# Check Redis info
INFO
```

## Troubleshooting

### Redis Not Starting

**Problem**: `brew services start redis` fails

**Solution**:
```bash
# Check if Redis is already running
redis-cli ping

# Kill existing Redis process
pkill redis-server

# Try starting again
brew services start redis
```

### Connection Refused

**Problem**: Backend can't connect to Redis

**Solution**:
1. Verify Redis is running: `redis-cli ping`
2. Check port: `lsof -i :6379`
3. Verify environment variables in `.env`
4. Restart backend server

### Port Already in Use

**Problem**: Port 6379 is already in use

**Solution**:
```bash
# Find process using port 6379
lsof -i :6379

# Kill the process (replace PID with actual process ID)
kill -9 PID

# Or change Redis port in redis.conf
```

### Permission Denied

**Problem**: Permission errors when starting Redis

**Solution**:
```bash
# Check Redis directory permissions
ls -la /usr/local/var/db/redis/

# Fix permissions if needed
sudo chown -R $(whoami) /usr/local/var/db/redis/
```

## Redis Data Location

Local Redis stores data at:
```
/usr/local/var/db/redis/
```

## Stopping Redis

```bash
# Stop Redis service
brew services stop redis

# Or if running manually, press Ctrl+C in the terminal
```

## Production vs Development

### Development (Local Redis)
- ✅ Use local Redis (localhost:6379)
- ✅ No password required
- ✅ Fast and easy to debug

### Production (Cloud Redis)
- Use Redis Cloud or AWS ElastiCache
- Set `REDIS_PASSWORD` in environment variables
- Use secure connection strings

## Security Notes

⚠️ **Important**: Local Redis has no password by default. This is fine for development but:
- Never expose local Redis to the internet
- Use cloud Redis with password in production
- Keep Redis only accessible from localhost in development

## Next Steps

1. ✅ Redis installed and running
2. ✅ Environment variables configured
3. ✅ Backend connects to Redis successfully
4. ✅ Test OTP functionality (uses Redis)

## Additional Resources

- [Redis Documentation](https://redis.io/documentation)
- [Homebrew Redis](https://formulae.brew.sh/formula/redis)
- [Redis Commands](https://redis.io/commands)

---

**Last Updated**: [Date]  
**For**: Travel Booking Website - Local Development

