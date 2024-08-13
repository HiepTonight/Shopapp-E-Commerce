package com.project.shopapp.services.Redis.Queue;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.project.shopapp.dtos.OrderDTO;

public interface IRedisQueueService {
    void pushToQueue(OrderDTO order) throws JsonProcessingException;

    OrderDTO popFromQueue() throws JsonProcessingException;
}
