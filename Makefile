init:
	(echo "API_BASE_URL=https://example.com"  >> .env.development; echo "API_BASE_URL=https://example.com" >> .env.production; echo "API_BASE_URL=https://example.com"  >> .env.staging; flutter clean; flutter pub get; dart run build_runner build -d)

get:
	(flutter pub get)

fresh:
	(rm pubspec.lock; flutter clean; flutter pub get; dart run build_runner build -d)

runner:
	(dart run build_runner build -d)

watch:
	(dart run build_runner watch -d)

apk:
	(flutter build apk --flavor production --target lib/main_production.dart)

integration-dev:
	(flutter drive --driver=integration_test/integration_driver.dart --target=integration_test/app_test.dart --flavor development)

coverage:
	(flutter test --coverage)

coverage-html:
	(genhtml coverage/lcov.info -o coverage/html && open coverage/html/index.html)
