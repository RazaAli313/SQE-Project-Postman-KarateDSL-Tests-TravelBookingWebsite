# Test Setup Guide

This guide will help you set up the testing environment for the Travel Booking Website API.

## Prerequisites

### 1. Node.js and npm
- **Required Version**: Node.js v16 or higher
- **Installation**: Download from [nodejs.org](https://nodejs.org/) or use Homebrew:
  ```bash
  brew install node
  ```

### 2. Java
- **Required Version**: Java 11 or higher
- **Installation** (Mac):
  ```bash
  brew install openjdk@11
  ```
- **Verify Installation**:
  ```bash
  java -version
  ```

### 3. Maven
- **Required Version**: Maven 3.6 or higher
- **Installation** (Mac):
  ```bash
  brew install maven
  ```
- **Verify Installation**:
  ```bash
  mvn -version
  ```

### 4. Redis (Local on Mac)
- **Installation**:
  ```bash
  brew install redis
  ```
- **Start Redis**:
  ```bash
  # Start as service (recommended)
  brew services start redis
  
  # Or start manually
  redis-server
  ```
- **Verify Redis is Running**:
  ```bash
  redis-cli ping
  # Should return: PONG
  ```
- **Stop Redis** (if needed):
  ```bash
  brew services stop redis
  ```

### 5. Postman (Optional)
- **Installation**: Download from [postman.com](https://www.postman.com/downloads/)
- **Or use Newman CLI** (recommended for automation):
  ```bash
  npm install -g newman newman-reporter-html
  ```

## Environment Setup

### 1. Backend Environment Variables

Create a `.env` file in the `backend/` directory:

```env
MONGODB_URI=your_mongodb_connection_string
PORT=8080
SECRET_KEY=your_jwt_secret_key
AUTH_MAIL_USER=your_email@gmail.com
AUTH_MAIL_PASS=your_email_password
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=
STRIPE_SECRET_KEY=your_stripe_secret_key
```

**Note**: For local Redis on Mac:
- `REDIS_HOST=localhost`
- `REDIS_PORT=6379` (default)
- `REDIS_PASSWORD=` (leave empty for local Redis without password)

### 2. Install Backend Dependencies

```bash
cd backend
npm install
```

### 3. Start Backend Server

```bash
cd backend
npm start
# Or for development with auto-reload
npm run server
```

The server should start on `http://localhost:8080`

### 4. Verify Backend is Running

```bash
curl http://localhost:8080/
# Should return: {"message":"Welcome to the world of Voyawander backend!"}
```

## Test Setup

### 1. Postman Collection Setup

1. **Import Collection**:
   - Open Postman
   - Click "Import"
   - Select `tests/postman/Travel_Booking_API.postman_collection.json`

2. **Import Environment**:
   - Click "Import" again
   - Select `tests/postman/environment.json`
   - Activate the environment from the dropdown

3. **Update Environment Variables** (if needed):
   - Click on the environment
   - Update `baseUrl` if testing against different environment
   - Update `testEmail` and `testPassword` if needed

### 2. Karate Tests Setup

1. **Navigate to Karate Directory**:
   ```bash
   cd tests/karate
   ```

2. **Install Dependencies**:
   ```bash
   mvn clean install
   ```

3. **Verify Setup**:
   ```bash
   mvn test -Dtest=TestRunner#testUserManagement
   ```

### 3. Test Execution Script Setup

The test execution script is already executable. You can use it directly:

```bash
# Interactive menu
./tests/run-tests.sh

# Or with options
./tests/run-tests.sh --postman
./tests/run-tests.sh --karate
./tests/run-tests.sh --all
```

## Running Tests

### Option 1: Using Test Script (Recommended)

```bash
# Interactive menu
./tests/run-tests.sh

# Or direct commands
./tests/run-tests.sh --all
```

### Option 2: Manual Execution

#### Postman Tests (Newman CLI):
```bash
newman run tests/postman/Travel_Booking_API.postman_collection.json \
  --environment tests/postman/environment.json \
  --reporters html,json \
  --reporter-html-export reports/postman-report.html
```

#### Karate Tests:
```bash
cd tests/karate
mvn test
```

## Troubleshooting

### Redis Connection Issues

**Problem**: Redis connection errors

**Solution**:
1. Check if Redis is running:
   ```bash
   redis-cli ping
   ```

2. Start Redis if not running:
   ```bash
   brew services start redis
   ```

3. Check Redis configuration in `backend/config/redis.js`:
   - Ensure `REDIS_HOST=localhost` for local Redis
   - Ensure `REDIS_PORT=6379` (default)
   - Leave `REDIS_PASSWORD` empty for local Redis

### Java/Maven Issues

**Problem**: Java or Maven not found

**Solution**:
1. Install Java:
   ```bash
   brew install openjdk@11
   ```

2. Install Maven:
   ```bash
   brew install maven
   ```

3. Verify installations:
   ```bash
   java -version
   mvn -version
   ```

### Newman Not Found

**Problem**: `newman: command not found`

**Solution**:
```bash
npm install -g newman newman-reporter-html
```

### Port Already in Use

**Problem**: Port 8080 already in use

**Solution**:
1. Find process using port 8080:
   ```bash
   lsof -i :8080
   ```

2. Kill the process or change PORT in `.env` file

### MongoDB Connection Issues

**Problem**: Cannot connect to MongoDB

**Solution**:
1. Verify MongoDB connection string in `.env`
2. Check if MongoDB is running (if local)
3. Verify network connectivity (if cloud)

## Next Steps

1. **Review Test Documentation**: Read `TEST_DOCUMENTATION.md` for detailed test cases
2. **Run Tests**: Execute tests using the test script or manually
3. **Review Reports**: Check test reports in `reports/` directory
4. **Customize Tests**: Update test cases as needed for your requirements

## Additional Resources

- [Postman Documentation](https://learning.postman.com/docs/)
- [Newman Documentation](https://github.com/postmanlabs/newman)
- [Karate DSL Documentation](https://karatelabs.github.io/karate/)
- [Redis Documentation](https://redis.io/documentation)
- [Maven Documentation](https://maven.apache.org/guides/)

---

**Last Updated**: [Date]  
**Maintained By**: SQE Project Team

