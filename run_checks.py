import pandas as pd
from sqlalchemy import create_engine

def main():
    print("Checking runtime imports and data...")
    try:
        print("pandas:", pd.__version__)
    except Exception as e:
        print("pandas import error:", e)

    try:
        import sqlalchemy as sa
        print("sqlalchemy:", sa.__version__)
    except Exception as e:
        print("sqlalchemy import error:", e)

    csv_path = "netflix_titles.csv"
    try:
        df = pd.read_csv(csv_path)
        print(f"Read CSV '{csv_path}' ok — shape:", df.shape)
    except Exception as e:
        print(f"Error reading CSV '{csv_path}':", e)

    username = 'type-your-db-username'
    password = 'type-your-pwd'
    host = 'type-your-host-name'
    port = 'type-your-port-number'
    database = 'type-your-db-name'
    engine_url = f"postgresql+psycopg2://{username}:{password}@{host}:{port}/{database}"
    print("Constructed engine URL (not safe to print credentials in general):", engine_url)

    try:
        engine = create_engine(engine_url)
        with engine.connect() as conn:
            print("Successfully connected to the database.")
    except Exception as e:
        print("Database connection failed (this may be expected if Postgres is not running):", e)

if __name__ == '__main__':
    main()
