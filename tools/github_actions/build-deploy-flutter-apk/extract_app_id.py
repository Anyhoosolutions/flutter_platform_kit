import json
import sys
from pathlib import Path


def main() -> int:
    if len(sys.argv) != 3:
        print(
            "Usage: extract_app_id.py <firebase_json> <app_id_path>",
            file=sys.stderr,
        )
        return 1

    firebase_json = Path(sys.argv[1])
    app_id_path = sys.argv[2]

    if not firebase_json.is_file():
        print(f"Firebase JSON file not found: {firebase_json}", file=sys.stderr)
        return 1

    try:
        with firebase_json.open() as f:
            data = json.load(f)
    except Exception as e:  # noqa: BLE001
        print(f"Failed to read or parse {firebase_json}: {e}", file=sys.stderr)
        return 1

    current = data
    try:
        for key in app_id_path.split("."):
            current = current[key]
    except KeyError as e:
        print(
            f"Failed to traverse path '{app_id_path}'. Missing key: {e}",
            file=sys.stderr,
        )
        return 1

    # Expect the final value to be the app ID string
    if not isinstance(current, str):
        print(
            f"Value at path '{app_id_path}' is not a string: {current!r}",
            file=sys.stderr,
        )
        return 1

    print(current)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

