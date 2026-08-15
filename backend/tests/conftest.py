import os


# Automated tests must never send real transactional email.
os.environ["PHILOTES_EMAIL_DELIVERY_ENABLED"] = "false"
