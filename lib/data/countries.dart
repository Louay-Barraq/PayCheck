/// Curated list of countries with their currency info.
class CountryData {
  final String code;           // ISO 3166-1 alpha-2
  final String flag;           // Emoji flag
  final String name;           // English name
  final String currencyCode;   // ISO 4217
  final String currencySymbol; // Display symbol
  final String currencyName;   // Full currency name

  const CountryData({
    required this.code,
    required this.flag,
    required this.name,
    required this.currencyCode,
    required this.currencySymbol,
    required this.currencyName,
  });
}

const List<CountryData> kCountries = [
  CountryData(code: 'TN', flag: '🇹🇳', name: 'Tunisia',           currencyCode: 'TND', currencySymbol: 'DT',   currencyName: 'Tunisian Dinar'),
  CountryData(code: 'DZ', flag: '🇩🇿', name: 'Algeria',           currencyCode: 'DZD', currencySymbol: 'DA',   currencyName: 'Algerian Dinar'),
  CountryData(code: 'MA', flag: '🇲🇦', name: 'Morocco',           currencyCode: 'MAD', currencySymbol: 'DH',   currencyName: 'Moroccan Dirham'),
  CountryData(code: 'EG', flag: '🇪🇬', name: 'Egypt',             currencyCode: 'EGP', currencySymbol: 'E£',   currencyName: 'Egyptian Pound'),
  CountryData(code: 'LY', flag: '🇱🇾', name: 'Libya',             currencyCode: 'LYD', currencySymbol: 'LD',   currencyName: 'Libyan Dinar'),
  CountryData(code: 'SA', flag: '🇸🇦', name: 'Saudi Arabia',      currencyCode: 'SAR', currencySymbol: 'SR',   currencyName: 'Saudi Riyal'),
  CountryData(code: 'AE', flag: '🇦🇪', name: 'United Arab Emirates', currencyCode: 'AED', currencySymbol: 'AED', currencyName: 'UAE Dirham'),
  CountryData(code: 'QA', flag: '🇶🇦', name: 'Qatar',             currencyCode: 'QAR', currencySymbol: 'QR',   currencyName: 'Qatari Riyal'),
  CountryData(code: 'KW', flag: '🇰🇼', name: 'Kuwait',            currencyCode: 'KWD', currencySymbol: 'KD',   currencyName: 'Kuwaiti Dinar'),
  CountryData(code: 'JO', flag: '🇯🇴', name: 'Jordan',            currencyCode: 'JOD', currencySymbol: 'JD',   currencyName: 'Jordanian Dinar'),
  CountryData(code: 'IQ', flag: '🇮🇶', name: 'Iraq',              currencyCode: 'IQD', currencySymbol: 'IQD',  currencyName: 'Iraqi Dinar'),
  CountryData(code: 'SN', flag: '🇸🇳', name: 'Senegal',           currencyCode: 'XOF', currencySymbol: 'CFA',  currencyName: 'West African CFA Franc'),
  CountryData(code: 'FR', flag: '🇫🇷', name: 'France',            currencyCode: 'EUR', currencySymbol: '€',    currencyName: 'Euro'),
  CountryData(code: 'DE', flag: '🇩🇪', name: 'Germany',           currencyCode: 'EUR', currencySymbol: '€',    currencyName: 'Euro'),
  CountryData(code: 'ES', flag: '🇪🇸', name: 'Spain',             currencyCode: 'EUR', currencySymbol: '€',    currencyName: 'Euro'),
  CountryData(code: 'IT', flag: '🇮🇹', name: 'Italy',             currencyCode: 'EUR', currencySymbol: '€',    currencyName: 'Euro'),
  CountryData(code: 'BE', flag: '🇧🇪', name: 'Belgium',           currencyCode: 'EUR', currencySymbol: '€',    currencyName: 'Euro'),
  CountryData(code: 'GB', flag: '🇬🇧', name: 'United Kingdom',    currencyCode: 'GBP', currencySymbol: '£',    currencyName: 'British Pound'),
  CountryData(code: 'CH', flag: '🇨🇭', name: 'Switzerland',       currencyCode: 'CHF', currencySymbol: 'CHF',  currencyName: 'Swiss Franc'),
  CountryData(code: 'US', flag: '🇺🇸', name: 'United States',     currencyCode: 'USD', currencySymbol: '\$',    currencyName: 'US Dollar'),
  CountryData(code: 'CA', flag: '🇨🇦', name: 'Canada',            currencyCode: 'CAD', currencySymbol: 'CA\$',  currencyName: 'Canadian Dollar'),
  CountryData(code: 'AU', flag: '🇦🇺', name: 'Australia',         currencyCode: 'AUD', currencySymbol: 'A\$',   currencyName: 'Australian Dollar'),
  CountryData(code: 'TR', flag: '🇹🇷', name: 'Turkey',            currencyCode: 'TRY', currencySymbol: '₺',    currencyName: 'Turkish Lira'),
  CountryData(code: 'NG', flag: '🇳🇬', name: 'Nigeria',           currencyCode: 'NGN', currencySymbol: '₦',    currencyName: 'Nigerian Naira'),
  CountryData(code: 'ZA', flag: '🇿🇦', name: 'South Africa',      currencyCode: 'ZAR', currencySymbol: 'R',    currencyName: 'South African Rand'),
  CountryData(code: 'KE', flag: '🇰🇪', name: 'Kenya',             currencyCode: 'KES', currencySymbol: 'KSh',  currencyName: 'Kenyan Shilling'),
  CountryData(code: 'MX', flag: '🇲🇽', name: 'Mexico',            currencyCode: 'MXN', currencySymbol: 'MX\$',  currencyName: 'Mexican Peso'),
  CountryData(code: 'BR', flag: '🇧🇷', name: 'Brazil',            currencyCode: 'BRL', currencySymbol: 'R\$',   currencyName: 'Brazilian Real'),
];
