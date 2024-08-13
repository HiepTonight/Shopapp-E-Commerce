package com.project.shopapp.dtos;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotEmpty;
import lombok.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;

@Data
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class EmailDTO {
    @JsonProperty("file")
    private MultipartFile[] file;

    @NotEmpty(message = "toPerson is required")
    @JsonProperty("to_person")
    private String toPerson;

    @NotEmpty(message = "subject is required")
    @JsonProperty("subject")
    private String subject;

    @NotEmpty(message = "body is required")
    @JsonProperty("body")
    private String body;

    @JsonProperty("cc_person")
    private String ccPerson;
}
