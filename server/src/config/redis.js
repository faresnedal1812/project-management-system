import Redis from "ioredis";
import logger from "./logger.js";
import env from "./env.js";

// If there is a REDIS_URL, we use it; otherwise, we rely on the local Host/Port.
const redisOptions = {
  enableReadyCheck: false,
  lazyConnect: env.isTesting,
};

const getRedisClient = (extraOptions = {}) => {
  const options = { ...redisOptions, ...extraOptions };

  if (env.redisUrl) {
    return new Redis(env.redisUrl, options);
  }

  return new Redis({
    host: env.redisHost,
    port: env.redisPort,
    password: env.redisPassword || undefined,
    ...options,
  });
};

export const workerRedisConnection = getRedisClient({
  maxRetriesPerRequest: null,
});

export const queueRedisConnection = getRedisClient({
  maxRetriesPerRequest: 3,
});

workerRedisConnection.on("connect", () =>
  logger.info("Worker Redis connected"),
);

workerRedisConnection.on("error", (err) =>
  logger.error({ err }, "Worker Redis connection error"),
);

queueRedisConnection.on("connect", () => logger.info("Queue Redis connected"));

queueRedisConnection.on("error", (err) =>
  logger.error({ err }, "Queue Redis connection error"),
);
