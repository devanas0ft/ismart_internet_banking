class ChatPrompts {
  static Map<String, dynamic> prompts = {
    'start': {
      'question':
          'Namaste! 🙏 I am Smart Fuche, your personal virtual assistant. Thank you for choosing us! How can I make your day smarter and brighter today?\n(Beta*)',
      'options': [
        'About Us',
        'Popular Services',
        'Top Up',
        'Security Concerns',
      ],
      'responses': {
        'About Us':
            'DevanaSoft Pvt. Ltd. is established to cater the growing needs in the space of FinTech with special focus on developing and deploying innovative products and services in the field of Digital Financial Services, Agriculture, Remittance Industry, Insurance Sector, Retail Payments, and Delivery and Distribution.',
        'Our Services':
            'We offer various services. Which one are you interested in?',
        'Top Up': 'Select your mobile network:',
        'Security Concerns':
            'At iSmart, we take security very seriously. To ensure your account is safe, we recommend you to keep your password confidential and avoid sharing it with anyone. Be Aware of Phishing Attempts. iSmart will never ask for your password or OTP. If you receive any suspicious messages or calls, please report it to us immediately.',
      },
      'nextPrompts': {
        'About Us': {
          'question': 'What would you like to know more about?',
          'options': ['Team', 'Vision', 'Contact'],
          'responses': {
            'Team':
                'Our team consists of dedicated professionals passionate about technology.',
            'Vision':
                'Become one of the leading Digital Financial Services Provider through Top Down and Bottom Up Approach targeting underdeveloped and developing countries.',
            'Contact':
                'You can reach us at devanasoftpvtltd@gmail.com, or know more about us at devanasoft.com.np',
          }
        },
        'Security Concerns': {
          'question': 'Contact us. Proceed with Confirm to proceed',
          'options': ['Confirm'],
        },
        'Popular Services': {
          'question':
              'Please select from the services below to learn more and proceed further.',
          'options': [
            'Broker Payment',
            'Top up',
            'Electricity Payment',
            'Movie Ticket Booking',
            'Lanline Payment',
            'Airlines',
            'Bus Ticketing',
            'And more..'
          ],
          'responses': {
            'Bus Ticketing':
                'Book your bus tickets with us. Select your destination, choose your seats, and confirm your booking in a few clicks!',
            'Broker Payment':
                'You can easily pay your Broker Payment through our platform. Just enter your provider details and proceed with the payment!',
            'Electricity Payment':
                'Pay your electricity bills quickly and securely. Select your electricity board, enter your account number, and complete the payment in seconds!',
            'Movie Ticket Booking':
                'Book tickets for your favorite movies hassle-free. Browse showtimes, select your seats, and confirm your booking right here!',
            'Airlines':
                'Planning a trip? Book your airline tickets effortlessly with us.',
            'Lanline Payment':
                'Pay your landline bills quickly and securely. Select your landline provider, enter your account number, and complete the payment in seconds!',
            'And more..':
                'We offer a wide range of services to make your life easier for the digital payement. Wallets load, Internal Coop transfer, Bank Transfer,KhanePani Payment,Bus Ticketing,Insurance payment, Ride Sharing payment and much more. Visit our homepage to explore more!',
          },
          'nextPrompts': {
            'Electricity Payment': {
              'type': 'input',
              'question':
                  'Ready to keep the lights on? Let’s proceed with your electricity payment.',
              'options': ['Proceed for Payment'],
            },
            'Movie Ticket Booking': {
              'type': 'input',
              'question':
                  'Excited for the show? Let’s book your movie tickets!',
              'options': ['Proceed for Payment'],
            },
            'Airlines': {
              'type': 'input',
              'question':
                  'Planning your next adventure? Let’s book your flight tickets.',
              'options': ['Proceed for Payment'],
            },
            'Bus Ticketing': {
              'type': 'input',
              'question':
                  'Heading somewhere? Let’s secure your bus tickets now.',
              'options': ['Proceed for Payment'],
            },
            'Broker Payment': {
              'type': 'input',
              'question':
                  'Need to settle your broker payment? Let’s handle it quickly.',
              'options': ['Proceed for Payment'],
            },
            'Lanline Payment': {
              'type': 'input',
              'question':
                  'Ready to stay connected? Let’s pay your landline bill.',
              'options': ['Proceed for Payment'],
            },
          }
        },
        'Top Up': {
          'options': ['NTC', 'NCELL'],
          'question': 'Which mobile network do you want to top up?',
          'responses': {
            'NTC': 'You selected NTC. Please enter your phone number.',
            'NCELL': 'You selected NCELL. Please enter your phone number.',
          },
          'nextPrompts': {
            'NTC': {
              'type': 'input',
              'question': 'Enter your NTC phone number:',
              'nextPrompt': {
                'question': 'Select top-up amount:',
                'options': ['50', '100', '150', '200', '300'],
                'responses': {
                  '50': 'You selected Rs. 50 top-up.',
                  '100': 'You selected Rs. 100 top-up.',
                  '150': 'You selected Rs. 150 top-up.',
                  '200': 'You selected Rs. 200 top-up.',
                  '300': 'You selected Rs. 300 top-up.',
                }
              }
            },
          }
        },
      }
    }
  };

  static String? getResponse(String currentPromptKey, String userInput) {
    final currentPrompt = findPrompt(prompts, currentPromptKey);
    if (currentPrompt == null) return null;

    final responses = currentPrompt['responses'] as Map<String, dynamic>? ?? {};
    final normalizedInput = userInput.toLowerCase().trim();

    for (var option in responses.keys) {
      if (option.toLowerCase() == normalizedInput) {
        return responses[option];
      }
    }

    return null;
  }

  static Map<String, dynamic>? findPrompt(
      Map<String, dynamic> promptMap, String key) {
    for (var entry in promptMap.entries) {
      if (entry.key == key) return entry.value;

      final nextPrompts = entry.value['nextPrompts'];
      if (nextPrompts != null) {
        final nestedPrompt = findPrompt(nextPrompts, key);
        if (nestedPrompt != null) return nestedPrompt;
      }
    }
    return null;
  }

  static List<String> getCurrentOptions(String promptKey) {
    final prompt = findPrompt(prompts, promptKey);
    return (prompt?['options'] as List<String>?) ?? [];
  }

  static String getCurrentQuestion(String promptKey) {
    final prompt = findPrompt(prompts, promptKey);
    return prompt?['question'] as String? ?? 'How can I assist you today?';
  }

  static String? getNextPromptKey(String currentPromptKey, String userInput) {
    final currentPrompt = findPrompt(prompts, currentPromptKey);
    if (currentPrompt == null) return null;

    final nextPrompts = currentPrompt['nextPrompts'] as Map<String, dynamic>?;
    if (nextPrompts == null) return null;

    final normalizedInput = userInput.toLowerCase().trim();
    for (var option in nextPrompts.keys) {
      if (option.toLowerCase() == normalizedInput) {
        return option;
      }
    }

    return null;
  }

  // Method to add a new prompt dynamically
  static void addPrompt(
      String parentKey, String newKey, Map<String, dynamic> promptDetails) {
    final parentPrompt = findPrompt(prompts, parentKey);
    if (parentPrompt != null) {
      parentPrompt['nextPrompts'] ??= {};
      (parentPrompt['nextPrompts'] as Map<String, dynamic>)[newKey] =
          promptDetails;
    }
  }
}
