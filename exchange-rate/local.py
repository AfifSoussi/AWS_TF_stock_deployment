import requests
import json
from datetime import datetime

# Coinbase API configuration
API_URL = 'https://api.coinbase.com/v2/exchange-rates'
BASE_CURRENCY = 'USD'  # Base currency for exchange rates

# Local file configuration
LOCAL_JSON_FILE = 'exchange_rate_data.json'
LOCAL_HTML_FILE = 'exchange_rate_table.html'

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

def save_to_local(data, html_content):
    """Save the extracted data and HTML page locally."""
    try:
        # Save JSON data
        with open(LOCAL_JSON_FILE, 'w') as json_file:
            json.dump(data, json_file, indent=4)
        print(f"JSON data successfully saved locally at {LOCAL_JSON_FILE}")
        
        # Save HTML page
        with open(LOCAL_HTML_FILE, 'w') as html_file:
            html_file.write(html_content)
        print(f"HTML page successfully saved locally at {LOCAL_HTML_FILE}")
    except Exception as e:
        print(f"Error saving files locally: {e}")

def main():
    # Step 1: Download the dataset
    exchange_rate_data = get_exchange_rate_data()

    # Step 2: Extract relevant information
    relevant_data = extract_relevant_data(exchange_rate_data)
    if relevant_data:
        print("Extracted Data:", relevant_data)

        # Step 3: Generate an HTML table
        html_content = generate_html(relevant_data)

        # Step 4: Save the extracted data and HTML page locally
        save_to_local(relevant_data, html_content)
    else:
        print("No data to save.")

if __name__ == '__main__':
    main()
