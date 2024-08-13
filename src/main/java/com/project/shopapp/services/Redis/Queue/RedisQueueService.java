package com.project.shopapp.services.Redis.Queue;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.project.shopapp.dtos.OrderDTO;
import com.project.shopapp.services.OrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class RedisQueueService implements IRedisQueueService{
    private static final String QUEUE = "orderQueue";
    private final RedisTemplate<String, Object> redisTemplate;
    private final ObjectMapper redisObjectMapper;
    @Override
    public void pushToQueue(OrderDTO order) throws JsonProcessingException {
        String json = redisObjectMapper.writeValueAsString(order);
        redisTemplate.opsForList().leftPush("orderQueue", json);
    }

    @Override
    public OrderDTO popFromQueue() throws JsonProcessingException {
        String json = (String) redisTemplate.opsForList().rightPop("orderQueue");
        if (json != null) {
            return redisObjectMapper.readValue(json, OrderDTO.class);
        } else {
            return null;
        }
//        OrderDTO order = redisObjectMapper.readValue(json, new TypeReference<OrderDTO>(){});

    }
}
