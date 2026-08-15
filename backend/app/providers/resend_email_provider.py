import resend

from ..core.config import settings


class EmailDeliveryConfigurationError(RuntimeError):
    pass


class EmailDeliveryProviderError(RuntimeError):
    pass


class ResendEmailProvider:
    def send(
        self,
        *,
        to_email: str,
        subject: str,
        html: str,
        text: str,
    ) -> None:
        if not settings.resend_api_key:
            raise EmailDeliveryConfigurationError(
                "Resend API key is not configured."
            )

        resend.api_key = settings.resend_api_key

        params: resend.Emails.SendParams = {
            "from": settings.email_from_address,
            "to": [to_email],
            "subject": subject,
            "html": html,
            "text": text,
        }

        try:
            resend.Emails.send(params)
        except Exception as exc:
            # Provider-specific details stay behind this adapter. Never
            # include tokens or secrets in the public exception message.
            raise EmailDeliveryProviderError(
                "Transactional email delivery failed."
            ) from exc
