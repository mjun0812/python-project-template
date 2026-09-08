"""Command-line entry point for Python-Project-Template."""

from my_package import hello


def main() -> None:
    """Print the greeting for the generated project."""
    print(hello())


if __name__ == "__main__":
    main()
