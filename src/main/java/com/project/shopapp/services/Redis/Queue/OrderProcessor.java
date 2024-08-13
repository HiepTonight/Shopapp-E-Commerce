package com.project.shopapp.services.Redis.Queue;

import com.project.shopapp.dtos.OrderDTO;
import com.project.shopapp.services.IOrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@EnableScheduling
public class OrderProcessor {
    private final IRedisQueueService redisQueueService;
    private final IOrderService orderService;

    @Scheduled(fixedRate = 5000)
    public void processQueue() throws Exception {
        OrderDTO orderDTO = redisQueueService.popFromQueue();
        if (orderDTO != null) {
//            System.out.println(orderDTO);
            orderService.createOrder(orderDTO);
//            orderDTO = redisQueueService.popFromQueue();
        } else {
            return;
        }
    }
}
