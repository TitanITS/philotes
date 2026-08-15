from html import escape
from urllib.parse import urlencode

from ..core.config import settings
from ..providers.resend_email_provider import ResendEmailProvider


class EmailDeliveryService:
    def __init__(
        self,
        provider: ResendEmailProvider | None = None,
    ) -> None:
        self.provider = provider or ResendEmailProvider()

    @staticmethod
    def build_verification_url(raw_token: str) -> str:
        query = urlencode({"token": raw_token})
        separator = (
            "&"
            if "?" in settings.email_verification_url
            else "?"
        )
        return (
            f"{settings.email_verification_url}"
            f"{separator}{query}"
        )

    @staticmethod
    def build_password_reset_url(raw_token: str) -> str:
        query = urlencode({"token": raw_token})
        separator = "&" if "?" in settings.password_reset_url else "?"
        return f"{settings.password_reset_url}{separator}{query}"

    def send_verification_email(
        self,
        *,
        to_email: str,
        raw_token: str,
    ) -> None:
        verification_url = self.build_verification_url(raw_token)
        safe_url = escape(verification_url, quote=True)

        subject = "Verify your Philotes email"

        html = f"""<!doctype html>
<html>
  <body>
    <h2>Verify your Philotes email</h2>
    <p>
      Confirm that this email address belongs to you before
      using Philotes community features.
    </p>
    <p>
      <a href="{safe_url}">Verify my email</a>
    </p>
    <p>
      This verification link expires in
      {settings.email_verification_expire_hours} hours.
    </p>
    <p>
      If you did not create a Philotes account, you can ignore
      this message.
    </p>
  </body>
</html>
"""

        text = (
            "Verify your Philotes email\n\n"
            "Confirm your email address using this link:\n"
            f"{verification_url}\n\n"
            "This verification link expires in "
            f"{settings.email_verification_expire_hours} hours.\n\n"
            "If you did not create a Philotes account, "
            "you can ignore this message."
        )

        self.provider.send(
            to_email=to_email,
            subject=subject,
            html=html,
            text=text,
        )


    def send_password_reset_email(
        self,
        *,
        to_email: str,
        raw_token: str,
    ) -> None:
        reset_url = self.build_password_reset_url(raw_token)
        safe_url = escape(reset_url, quote=True)

        subject = "Reset your Philotes password"

        html = f"""<!doctype html>
<html>
  <body>
    <h2>Reset your Philotes password</h2>
    <p>
      We received a request to reset the password for your
      Philotes account.
    </p>
    <p>
      <a href="{safe_url}">Reset my password</a>
    </p>
    <p>
      This link expires in
      {settings.password_reset_expire_minutes} minutes.
    </p>
    <p>
      If you did not request a password reset, you can ignore
      this message and your password will remain unchanged.
    </p>
  </body>
</html>
"""

        text = (
            "Reset your Philotes password\n\n"
            "Use this link to choose a new password:\n"
            f"{reset_url}\n\n"
            "This link expires in "
            f"{settings.password_reset_expire_minutes} minutes.\n\n"
            "If you did not request a password reset, "
            "you can ignore this message."
        )

        self.provider.send(
            to_email=to_email,
            subject=subject,
            html=html,
            text=text,
        )
