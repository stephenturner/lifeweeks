import re
import os


def validate_date(date_str):
    """Validate the date format (YYYY-MM-DD)."""
    if not re.match(r"^\d{4}-\d{2}-\d{2}$", date_str):
        raise ValueError("Date must be in YYYY-MM-DD format.")
    year, month, day = map(int, date_str.split("-"))
    if not (1 <= month <= 12 and 1 <= day <= 31):
        raise ValueError("Invalid date.")


def process_filename(filename):
    """Ensure the output filename ends with .pdf."""
    if not filename.lower().endswith(".pdf"):
        filename += ".pdf"
    return filename
