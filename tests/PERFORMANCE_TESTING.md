# Performance Testing Documentation

## Overview

This document outlines the performance testing strategy, scenarios, metrics, and execution procedures for the Travel Booking Website API.

## Performance Testing Objectives

1. **Load Testing**: Verify system behavior under expected load conditions
2. **Stress Testing**: Determine system breaking point and maximum capacity
3. **Endurance Testing**: Identify memory leaks and stability issues over time
4. **Spike Testing**: Test system response to sudden load increases

## Performance Benchmarks

### Target Metrics

| Metric | Target Value |
|--------|--------------|
| Average Response Time | < 500ms |
| P95 Response Time | < 1s |
| P99 Response Time | < 2s |
| Throughput | > 100 req/s |
| Error Rate | < 1% |
| Concurrent Users | 100+ |
| System Uptime | 99.9% |

## Performance Test Scenarios

### Scenario 1: User Registration Load Test

**Objective**: Test user registration endpoint under normal load

**Configuration**:
- Concurrent Users: 50
- Duration: 5 minutes
- Ramp-up Time: 1 minute
- Think Time: 2 seconds

**Expected Results**:
- Response Time (Avg): < 500ms
- Response Time (P95): < 1s
- Throughput: > 50 req/s
- Error Rate: < 1%

**Postman Collection**: `tests/postman/performance/UserRegistration_LoadTest.json`

**Execution Command**:
```bash
newman run tests/postman/performance/UserRegistration_LoadTest.json \
  --iteration-count 1000 \
  --delay-request 2000
```

---

### Scenario 2: Flight Search Stress Test

**Objective**: Determine maximum capacity of flight search endpoint

**Configuration**:
- Concurrent Users: 100
- Duration: 10 minutes
- Ramp-up Time: 2 minutes
- Think Time: 1 second

**Expected Results**:
- Response Time (Avg): < 1s
- Response Time (P95): < 2s
- Throughput: > 200 req/s
- Error Rate: < 0.5%

**Execution Command**:
```bash
newman run tests/postman/Travel_Booking_API.postman_collection.json \
  --folder "Flight Management" \
  --iteration-count 2000 \
  --delay-request 1000
```

---

### Scenario 3: Booking Flow Endurance Test

**Objective**: Test booking flow stability over extended period

**Configuration**:
- Concurrent Users: 25
- Duration: 1 hour
- Ramp-up Time: 5 minutes
- Think Time: 5 seconds

**Expected Results**:
- Response Time (Avg): < 2s
- Response Time (P95): < 3s
- Memory Leak: < 10% increase
- Error Rate: < 0.1%

**Monitoring**:
- Memory usage (should remain stable)
- CPU usage (should remain stable)
- Database connection pool (no leaks)
- Redis connection pool (no leaks)

---

### Scenario 4: Payment Processing Spike Test

**Objective**: Test system response to sudden load spike

**Configuration**:
- Initial Users: 10
- Spike Users: 100
- Spike Duration: 2 minutes
- Total Duration: 10 minutes

**Expected Results**:
- System should handle spike gracefully
- Response Time (P95): < 3s during spike
- Error Rate: < 2% during spike
- System should recover after spike

---

## Performance Testing Tools

### 1. Postman/Newman

**Setup**:
```bash
npm install -g newman newman-reporter-html
```

**Execution**:
```bash
newman run collection.json \
  --iteration-count 1000 \
  --delay-request 100 \
  --reporters cli,html,json \
  --reporter-html-export report.html
```

### 2. Apache JMeter (Alternative)

**Test Plan Location**: `tests/jmeter/Travel_Booking_API.jmx`

**Execution**:
```bash
jmeter -n -t tests/jmeter/Travel_Booking_API.jmx \
  -l results.jtl \
  -e -o reports/
```

### 3. k6 (Alternative)

**Script Location**: `tests/k6/load-test.js`

**Execution**:
```bash
k6 run tests/k6/load-test.js
```

---

## Performance Metrics Collection

### Response Time Metrics

- **Min**: Minimum response time
- **Max**: Maximum response time
- **Avg**: Average response time
- **Median**: 50th percentile
- **P90**: 90th percentile
- **P95**: 95th percentile
- **P99**: 99th percentile

### Throughput Metrics

- **Requests per Second (RPS)**: Total requests / Total time
- **Transactions per Second (TPS)**: Successful transactions / Total time

### Error Metrics

- **Error Rate**: (Failed requests / Total requests) × 100
- **Error Types**: 4xx, 5xx errors breakdown

### Resource Metrics

- **CPU Usage**: Average, Peak
- **Memory Usage**: Average, Peak
- **Database Connections**: Active, Idle
- **Redis Connections**: Active, Idle
- **Network I/O**: Bytes sent/received

---

## Performance Test Execution

### Pre-requisites

1. **Environment Setup**:
   - API server running
   - MongoDB connected
   - Redis running locally (Mac)
   - Test data prepared

2. **Redis Setup (Local Mac)**:
   ```bash
   # Start Redis
   brew services start redis
   # Or manually
   redis-server
   
   # Verify Redis is running
   redis-cli ping
   # Should return: PONG
   ```

3. **Monitoring Tools**:
   - Application logs
   - Database monitoring
   - Redis monitoring
   - System resource monitoring

### Execution Steps

1. **Baseline Test**: Run single user test to establish baseline
2. **Load Test**: Gradually increase load to target
3. **Stress Test**: Continue increasing until system breaks
4. **Endurance Test**: Run at 80% capacity for extended period
5. **Spike Test**: Sudden load increase and recovery

### Post-Execution Analysis

1. **Collect Metrics**: Gather all performance data
2. **Identify Bottlenecks**: Database, API, network, etc.
3. **Analyze Errors**: Categorize and prioritize
4. **Generate Report**: Create performance test report
5. **Recommendations**: Provide optimization suggestions

---

## Performance Test Reports

### Report Template

**Location**: `reports/performance/performance-test-report-[date].html`

**Contents**:
- Executive Summary
- Test Configuration
- Results Summary
- Response Time Analysis
- Throughput Analysis
- Error Analysis
- Resource Utilization
- Bottleneck Identification
- Recommendations

### Sample Report Generation

```bash
# Generate HTML report from Newman
newman run collection.json \
  --reporters html \
  --reporter-html-export reports/performance/report-$(date +%Y%m%d).html
```

---

## Performance Optimization Recommendations

### Database Optimization

1. **Indexing**: Ensure proper indexes on frequently queried fields
2. **Query Optimization**: Review slow queries
3. **Connection Pooling**: Optimize connection pool size
4. **Caching**: Implement Redis caching for frequently accessed data

### API Optimization

1. **Response Compression**: Enable gzip compression
2. **Pagination**: Implement pagination for list endpoints
3. **Field Selection**: Allow clients to select required fields
4. **Rate Limiting**: Implement rate limiting to prevent abuse

### Infrastructure Optimization

1. **Load Balancing**: Distribute load across multiple servers
2. **CDN**: Use CDN for static assets
3. **Caching**: Implement multi-layer caching strategy
4. **Auto-scaling**: Configure auto-scaling based on load

---

## Continuous Performance Monitoring

### Key Metrics to Monitor

1. **Response Times**: Track P95, P99 response times
2. **Error Rates**: Monitor 4xx, 5xx error rates
3. **Throughput**: Track requests per second
4. **Resource Usage**: CPU, Memory, Database connections

### Monitoring Tools

- **Application Performance Monitoring (APM)**: New Relic, Datadog
- **Log Aggregation**: ELK Stack, Splunk
- **Metrics Collection**: Prometheus, Grafana
- **Real User Monitoring (RUM)**: Track actual user experience

---

## Performance Testing Checklist

- [ ] Performance test plan created
- [ ] Test environment configured
- [ ] Test data prepared
- [ ] Monitoring tools set up
- [ ] Baseline test executed
- [ ] Load test executed
- [ ] Stress test executed
- [ ] Endurance test executed
- [ ] Spike test executed
- [ ] Results analyzed
- [ ] Performance report generated
- [ ] Recommendations documented
- [ ] Optimization implemented
- [ ] Re-test after optimization

---

**Document Version**: 1.0  
**Last Updated**: [Date]  
**Maintained By**: SQE Project Team

