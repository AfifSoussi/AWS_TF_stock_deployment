import requests
import json
import boto3
from datetime import datetime
import os

# Coinbase API configuration
API_URL = 'https://api.coinbase.com/v2/exchange-rates'
BASE_CURRENCY = 'USD'  # Base currency for exchange rates

# AWS S3 configuration
S3_BUCKET = os.getenv('S3_BUCKET')  # S3 bucket name from environment variables
JSON_FILE_KEY = 'exchange_rate_data.json'  # S3 key for JSON file
HTML_FILE_KEY = 'index.html'  # S3 key for HTML file

# Initialize S3 client
s3_client = boto3.client('s3')

def get_exchange_rate_data():
    """Fetch exchange rate data from Coinbase API."""
    try:
        response = requests.get(API_URL, params={'currency': BASE_CURRENCY})
        response.raise_for_status()
        return response.json()
    except requests.exceptions.HTTPError as err:
        print(f"HTTP error occurred: {err}")
        return None
    except Exception as err:
        print(f"Other error occurred: {err}")
        return None

def extract_relevant_data(data):
    """Extract relevant exchange rate information."""
    if not data or 'data' not in data:
        return None

    exchange_rates = data['data']['rates']
    extracted_data = {
        'base_currency': BASE_CURRENCY,
        'exchange_rates': exchange_rates,
        'timestamp': datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
    }
    return extracted_data

def generate_html(data):
    """Generate a simple HTML page with a table of exchange rates."""
    html_content = f"""
    <html>
    <head><title>Exchange Rates</title></head>
    <body>
        <h1>Exchange Rates for {data['base_currency']}</h1>
        <p>Data fetched at: {data['timestamp']}</p>
        <table border="1">
            <tr>
                <th>Currency</th>
                <th>Rate</th>
            </tr>
    """
    for currency, rate in data['exchange_rates'].items():
        html_content += f"<tr><td>{currency}</td><td>{rate}</td></tr>"

    html_content += """
        </table>
    </body>
    </html>
    """
    return html_content

def save_to_s3(data, html_content):
    """Save the extracted data and HTML page to S3."""
    try:
        # Save JSON data to S3
        s3_client.put_object(
            Bucket=S3_BUCKET,
            Key=JSON_FILE_KEY,
            Body=json.dumps(data, indent=4),
            ContentType='application/json'
        )
        print(f"JSON data successfully saved to S3 at {S3_BUCKET}/{JSON_FILE_KEY}")
        
        # Save HTML page to S3
        s3_client.put_object(
            Bucket=S3_BUCKET,
            Key=HTML_FILE_KEY,
            Body=html_content,
            ContentType='text/html'
        )
        print(f"HTML page successfully saved to S3 at {S3_BUCKET}/{HTML_FILE_KEY}")
    except Exception as e:
        print(f"Error saving files to S3: {e}")

def main():
    # Step 1: Download the dataset
    exchange_rate_data = get_exchange_rate_data()

    # Step 2: Extract relevant information
    relevant_data = extract_relevant_data(exchange_rate_data)
    if relevant_data:
        print("Extracted Data:", relevant_data)

        # Step 3: Generate an HTML table
        html_content = generate_html(relevant_data)

        # Step 4: Save the extracted data and HTML page to S3
        save_to_s3(relevant_data, html_content)
    else:
        print("No data to save.")

if __name__ == '__main__':
    main()
