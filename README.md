# Quiz Hint Pro — Final All-in-One Project

App name: Quiz Hint Pro
Package ID: com.soikot.quizhint
Suggested GitHub repo: quizhintpro
Target SDK: API 36

Included:
- Complete Flutter app
- 12 built-in quiz questions
- 3 starter credits
- 1 hint = 1 credit
- Consumable Google Play Billing integration
- $1–$10 intended credit tiers via product IDs
- Custom app icon
- Signed APK + AAB Codemagic workflow
- Privacy policy

Before Play Console:
- You can build/install the APK and test the quiz + credit usage now.
- Shop items will show Not active until the product IDs are created in Play Console.

Mobile GitHub upload:
- Upload app_icon.png, pubspec.yaml, analysis_options.yaml, codemagic.yaml, IAP_PRODUCT_IDS.txt, README.md to repo root.
- Put main.dart inside lib/.
- Put privacy-policy.html inside docs/.

Codemagic workflow: Quiz Hint Pro API 36 Signed APK + AAB
Existing signing identity used: agecalculator_upload


## Update v1.0.1
- Quiz bank increased from 12 to 100 questions.
- Questions are shuffled each round.
- Added `credits_5` = 5 credits, target price $0.51.
- Changed target tiers:
  - 10 credits = $1.01
  - 20 credits = $2.01
  - 30 credits = $3.01
  - ...
  - 100 credits = $10.01
- 1 hint still costs 1 credit.
- Version updated to 1.0.1+2.


## Update v1.0.2
- Removed target-price and internal product-ID text from each credit pack card.
- Removed the bottom target-price explanatory paragraph.
- Actual Google Play localized prices still appear on the purchase buttons when products are active.


## Update v1.0.3
- Kept the clean Shop UI with target prices and internal product IDs hidden.
- Kept the bottom target-price paragraph removed.
- Replaced the Shop helper text with:
  Need help with a question?
  Use 1 credit to reveal a hint.
  New users get 3 free credits.
