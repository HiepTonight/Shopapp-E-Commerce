package com.project.shopapp.services.Mail;

import com.project.shopapp.dtos.EmailDTO;

public interface IMailService {
    EmailDTO sendMail(EmailDTO email);
}
