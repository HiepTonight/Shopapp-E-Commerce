package com.project.shopapp.controllers;

import com.project.shopapp.components.LocalizationUtils;
import com.project.shopapp.dtos.OrderDTO;
import com.project.shopapp.models.Order;
import com.project.shopapp.repositories.OrderRepository;
import com.project.shopapp.responses.OrderListResponse;
import com.project.shopapp.responses.OrderResponse;
import com.project.shopapp.services.IOrderService;
import com.project.shopapp.services.Redis.Queue.IRedisQueueService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("${api.prefix}/redisOrders")
@RequiredArgsConstructor
public class OrderWithRedisController {
    private final IOrderService orderService;
    private final LocalizationUtils localizationUtils;
    private final IRedisQueueService redisQueueService;

    //Thêm mới đơn hàng
    @PostMapping("")
    public ResponseEntity<?> createOrder(@RequestBody @Valid OrderDTO orderDTO,
                                         BindingResult result){
        try {
            if(result.hasErrors()){
                List<String> errorMessages = result.getFieldErrors()
                        .stream()
                        .map(fieldError -> fieldError.getDefaultMessage())
                        .toList();
                return ResponseEntity.badRequest().body(errorMessages);
            }
            redisQueueService.pushToQueue(orderDTO);
//            Order order = orderService.createOrder(orderDTO);
            return ResponseEntity.status(HttpStatus.OK).body("Order created successfully");
        } catch (Exception e){
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    //Lấy ra danh sách orders với userid
    @GetMapping("/user/{user_id}")
    public ResponseEntity<?> getOrders(@Valid @PathVariable("user_id") Long userId){
        try {
            List<Order> orders = orderService.findByUserId(userId);
            return ResponseEntity.status(HttpStatus.OK).body(orders);
        } catch (Exception e){
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getOrder(@Valid @PathVariable("id") Long orderId){
        try {
            Order existingOrder = orderService.getOrder(orderId);
            return ResponseEntity.status(HttpStatus.OK).body(OrderResponse.fromOrder(existingOrder));
        } catch (Exception e){
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    //Cập nhật chi tiết một order
    @PutMapping("/{id}")
    public ResponseEntity<?> updateOrder(
            @Valid @PathVariable long id,
            @Valid @RequestBody OrderDTO orderDTO
    ){
        try {
            Order order = orderService.updateOrder(id, orderDTO);
            return ResponseEntity.status(HttpStatus.OK).body(order);
        } catch (Exception e){
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    //Xóa một một order - xóa mềm
    @DeleteMapping("/{id}")
//    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<?> deleteOrder(@Valid @PathVariable Long id){
        orderService.deleteOrder(id);
        return ResponseEntity.status(HttpStatus.OK).body("Order deleted successfully!");
    }

    @GetMapping("/get-orders-by-keyword")
    public ResponseEntity<?> getOrdersByKeyword(@RequestParam(defaultValue = "", required = false)String keyword,
                                                @RequestParam(defaultValue = "0")int page,
                                                @RequestParam(defaultValue = "10")int limit
    ) {
        //Tạo pageable
        PageRequest pageRequest = PageRequest.of(
                page,limit,
                Sort.by("id").ascending()
        );

        Page<OrderResponse> orderPage = orderService
                .getOrdersByKeyWord(keyword, pageRequest)
                .map(OrderResponse::fromOrder);
        int totalPages = orderPage.getTotalPages();
        List<OrderResponse> orderResponses = orderPage.getContent();
        return ResponseEntity.ok(OrderListResponse
                .builder()
                .orders(orderResponses)
                .totalPages(totalPages)
                .build());
    }
}
