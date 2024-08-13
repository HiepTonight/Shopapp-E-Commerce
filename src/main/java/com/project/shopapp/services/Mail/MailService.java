package com.project.shopapp.services.Mail;

import com.project.shopapp.dtos.EmailDTO;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
@RequiredArgsConstructor
public class MailService implements IMailService{
    @Value("${spring.mail.username}")
    private String fromEmail;

    private final JavaMailSender javaMailSender;

    @Override
    public EmailDTO sendMail(EmailDTO email) {
        try {
            MimeMessage mimeMessage = javaMailSender.createMimeMessage();

            MimeMessageHelper mimeMessageHelper = new MimeMessageHelper(mimeMessage, true);

            mimeMessageHelper.setFrom(fromEmail);
            mimeMessageHelper.setTo(email.getToPerson());
            mimeMessageHelper.setCc(email.getCcPerson());
            mimeMessageHelper.setSubject(email.getSubject());
            mimeMessageHelper.setText(email.getBody());

            MultipartFile[] file = email.getFile();

            for (MultipartFile multipartFile : file) {
                mimeMessageHelper.addAttachment(
                        multipartFile.getOriginalFilename(),
                        new ByteArrayResource(multipartFile.getBytes())
                );
            }
            javaMailSender.send(mimeMessage);
            return null;
        } catch (Exception e){
            throw new RuntimeException(e);
        }
    }
}
