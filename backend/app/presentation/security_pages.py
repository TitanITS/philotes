from html import escape


def philotes_security_page(
    *,
    title: str,
    message: str,
    body_html: str = "",
    tone: str = "standard",
) -> str:
    safe_title = escape(title)
    safe_message = escape(message)

    status_icon = "✓" if tone == "success" else "✦"

    return f"""<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta
    name="viewport"
    content="width=device-width, initial-scale=1"
  >
  <title>{safe_title} | Philotes</title>
  <style>
    :root {{
      --philotes-navy: #0b2545;
      --philotes-gold: #c89b3c;
      --philotes-ivory: #f7f2e8;
      --philotes-white: #ffffff;
      --philotes-silver: #7a8796;
      --philotes-line: #d6c7a3;
      --philotes-success: #2f6f57;
    }}

    * {{
      box-sizing: border-box;
    }}

    html,
    body {{
      margin: 0;
      min-height: 100%;
      background: var(--philotes-ivory);
      color: var(--philotes-navy);
      font-family:
        Inter,
        ui-sans-serif,
        system-ui,
        -apple-system,
        BlinkMacSystemFont,
        "Segoe UI",
        sans-serif;
    }}

    body {{
      min-height: 100vh;
      display: grid;
      place-items: center;
      padding: 24px;
    }}

    .page-shell {{
      width: min(100%, 720px);
    }}

    .brand {{
      text-align: center;
      margin-bottom: 20px;
    }}

    .brand-mark {{
      width: 64px;
      height: 64px;
      margin: 0 auto 12px;
      border: 2px solid var(--philotes-gold);
      border-radius: 50%;
      display: grid;
      place-items: center;
      background: var(--philotes-white);
      color: var(--philotes-navy);
      font-size: 28px;
      font-weight: 800;
      box-shadow: 0 8px 24px rgba(11, 37, 69, 0.08);
    }}

    .brand-name {{
      margin: 0;
      font-size: clamp(28px, 5vw, 40px);
      letter-spacing: 0.04em;
      font-weight: 800;
    }}

    .tagline {{
      margin: 6px 0 0;
      color: var(--philotes-silver);
      font-size: 15px;
    }}

    .card {{
      background: var(--philotes-white);
      border: 1.5px solid var(--philotes-gold);
      border-radius: 24px;
      padding: clamp(24px, 5vw, 42px);
      box-shadow: 0 18px 50px rgba(11, 37, 69, 0.10);
    }}

    .status-icon {{
      width: 52px;
      height: 52px;
      border-radius: 50%;
      margin-bottom: 20px;
      display: grid;
      place-items: center;
      background: #f3ead6;
      color: var(--philotes-navy);
      font-size: 26px;
      font-weight: 800;
    }}

    .status-icon.success {{
      background: #e6f3ec;
      color: var(--philotes-success);
    }}

    h1 {{
      margin: 0 0 12px;
      font-size: clamp(28px, 5vw, 38px);
      line-height: 1.15;
    }}

    .message {{
      margin: 0 0 26px;
      color: #425466;
      font-size: 17px;
      line-height: 1.65;
    }}

    .primary-action {{
      display: inline-flex;
      align-items: center;
      justify-content: center;
      width: 100%;
      min-height: 52px;
      border: 0;
      border-radius: 14px;
      background: var(--philotes-navy);
      color: var(--philotes-white);
      font: inherit;
      font-weight: 700;
      font-size: 16px;
      cursor: pointer;
      text-decoration: none;
      transition:
        transform 120ms ease,
        box-shadow 120ms ease;
    }}

    .primary-action:hover {{
      transform: translateY(-1px);
      box-shadow: 0 8px 18px rgba(11, 37, 69, 0.18);
    }}

    .primary-action:focus-visible {{
      outline: 3px solid rgba(200, 155, 60, 0.45);
      outline-offset: 3px;
    }}

    .help-text {{
      margin: 22px 0 0;
      color: var(--philotes-silver);
      font-size: 14px;
      line-height: 1.55;
      text-align: center;
    }}

    .footer {{
      margin-top: 18px;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 0;
      color: var(--philotes-navy);
      font-size: 12px;
      font-weight: 600;
      letter-spacing: 3px;
      line-height: 1;
      white-space: nowrap;
    }}

    .footer-prefix {{
      margin-right: 6px;
    }}

    .titan-logo {{
      width: 22px;
      height: 22px;
      object-fit: contain;
      flex: 0 0 22px;
    }}

    .footer-titan {{
      margin-left: 4px;
    }}

    @media (max-width: 430px) {{
      .footer {{
        font-size: 10px;
        letter-spacing: 2px;
      }}

      .titan-logo {{
        width: 20px;
        height: 20px;
        flex-basis: 20px;
      }}
    }}

    @media (max-width: 520px) {{
      body {{
        padding: 16px;
      }}

      .card {{
        border-radius: 18px;
      }}
    }}
  </style>
</head>
<body>
  <main class="page-shell">
    <header class="brand" aria-label="Philotes">
      <div class="brand-mark" aria-hidden="true">Φ</div>
      <h2 class="brand-name">PHILOTES</h2>
      <p class="tagline">A Community for Friendship</p>
    </header>

    <section class="card">
      <div class="status-icon {"success" if tone == "success" else ""}">
        {status_icon}
      </div>
      <h1>{safe_title}</h1>
      <p class="message">{safe_message}</p>
      {body_html}
    </section>

    <footer class="footer" aria-label="Brought to you by Titan">
      <span class="footer-prefix">BROUGHT TO YOU BY</span>
      <img
        class="titan-logo"
        src="/api/v1/auth/security-assets/titan-logo.png"
        alt=""
        aria-hidden="true"
      >
      <span class="footer-titan">TITAN</span>
    </footer>
  </main>
</body>
</html>
"""


def verification_confirmation_page(*, token: str) -> str:
    safe_token = escape(token, quote=True)

    body = f"""
<form method="post" action="/api/v1/auth/verify-email-link">
  <input type="hidden" name="token" value="{safe_token}">
  <button class="primary-action" type="submit">
    Verify Email Address
  </button>
</form>
<p class="help-text">
  This confirmation protects your account from automated link scanners.
  If you did not create a Philotes account, you can close this window.
</p>
"""

    return philotes_security_page(
        title="Verify your email",
        message=(
            "Confirm your email address to finish securing your "
            "Philotes account."
        ),
        body_html=body,
    )


def verification_success_page() -> str:
    body = """
<p class="help-text">
  You may close this window and return to Philotes.
</p>
"""

    return philotes_security_page(
        title="Email verified",
        message=(
            "Your Philotes email address has been successfully verified."
        ),
        body_html=body,
        tone="success",
    )


def verification_error_page() -> str:
    body = """
<p class="help-text">
  Request a new verification email from Philotes and try again.
</p>
"""

    return philotes_security_page(
        title="Verification link unavailable",
        message=(
            "This verification link is invalid, expired, or has "
            "already been used."
        ),
        body_html=body,
    )
