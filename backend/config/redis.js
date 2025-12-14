const { createClient } = require("redis");
const { REDIS_HOST, REDIS_PASSWORD, REDIS_PORT } = require("../constants");

// Configure Redis client - only include password if it's set (for local Redis, password is empty)
const redisConfig = {
  socket: {
    host: REDIS_HOST || 'localhost',
    port: REDIS_PORT || 6379,
  },
};

// Only add password if it's provided (for cloud Redis)
if (REDIS_PASSWORD && REDIS_PASSWORD.trim() !== '') {
  redisConfig.password = REDIS_PASSWORD;
}

const redisClient = createClient(redisConfig);

const connectRedis = async () => {
  try {
    await redisClient.connect();
    console.log("Connected to Redis!");
  } catch (error) {
    console.error("Error while connecting to Redis!\n", error);
    process.exit(1); // Exit the process if Redis fails to connect
  }
};

module.exports = { redisClient, connectRedis };
