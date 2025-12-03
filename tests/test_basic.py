"""Basic sanity tests for scaffold imports."""
from config import settings
from models import get_provider
from generation import generate_sql_query


def test_settings_defaults():
    assert settings.default_provider == "deepseek"
    assert settings.default_model == "deepseek-chat"


def test_provider_router():
    client = get_provider("deepseek")
    assert client.provider_name == "deepseek"


def test_generate_sql_query_placeholder():
    client = get_provider("gemini")
    result = generate_sql_query(
        question="What is the total number of students?",
        schema="{tables: []}",
        provider_client=client,
        model="gemini-pro",
        max_tokens=100,
    )
    assert "sql" in result
    assert result["provider"] == "gemini"
