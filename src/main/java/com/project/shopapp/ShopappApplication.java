package com.project.shopapp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.elasticsearch.repository.config.EnableElasticsearchRepositories;

@SpringBootApplication
@EnableElasticsearchRepositories
public class ShopappApplication {

	public static void main(String[] args) {
		SpringApplication.run(ShopappApplication.class, args);
	}

}
