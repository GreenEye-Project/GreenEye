using GreenEye.Application.IServices;
using Microsoft.Extensions.Configuration;
using System.Net;
using System.Net.Mail;

namespace GreenEye.Application.Services
{
    public class EmailService(IConfiguration _configuration) : IEmailService
    {
        public async Task SendEmailAsync(string toEmail, string subject, string body)
        {
            var port = int.Parse(_configuration["SMTP:Port"]!);
            string host = _configuration["SMTP:Host"]!;
            var email = _configuration["SMTP:Email"];
            var password = _configuration["SMTP:Password"];

            using var smtp = new SmtpClient(host)
            {
                Port = port,
                Credentials = new NetworkCredential(email, password),
                EnableSsl = true
            };

            var mail = new MailMessage
            {
                From = new MailAddress(email!),
                Subject = subject,
                Body = body,
                IsBodyHtml = true,
            };
            mail.To.Add(toEmail);

            await smtp.SendMailAsync(mail);
        }
    }
}
