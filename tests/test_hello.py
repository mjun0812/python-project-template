from my_package import hello


def test_hello() -> None:
    """Test that hello returns the project greeting."""
    result = hello()
    expected = "Hello from Python-Project-Template!"
    assert result == expected


def test_hello_return_type() -> None:
    """Test that hello returns a string."""
    result = hello()
    assert isinstance(result, str)
