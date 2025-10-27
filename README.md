# network_cool_client

A robust Dart package for efficient network request handling, session management, real-time network state tracking, and seamless error handling for modern applications.

[![Pub Version](https://badgen.net/pub/v/network_cool_client)](https://pub.dev/packages/network_cool_client/)
[![Pub Likes](https://badgen.net/pub/likes/network_cool_client)](https://pub.dev/packages/network_cool_client/score)
[![Pub Points](https://badgen.net/pub/points/network_cool_client)](https://pub.dev/packages/network_cool_client/score)
[![Pub Downloads](https://badgen.net/pub/dm/network_cool_client)](https://pub.dev/packages/network_cool_client)
[![Dart SDK Version](https://badgen.net/pub/sdk-version/network_cool_client)](https://pub.dev/packages/network_cool_client/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/coolosos/network_cool_client/blob/main/LICENSE)
[![](https://img.shields.io/badge/linted%20by-coolint-0553B1)](https://pub.dev/packages/coolint)
[![codecov](https://codecov.io/gh/coolosos/networkcoolclient/graph/badge.svg)](https://codecov.io/gh/coolosos/networkcoolclient)

---

## ✨ Features

* 🔐 Session-based client with auto token renewal and error handling
* 🌐 Observes and notifies about network states (offline, maintenance, etc.)
* 🧩 Extensible and easy to integrate with existing architectures
* 🧪 Built-in testing and override-friendly design

---

## 🚀 Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  network_cool_client: ^1.0.0
```

Then run:

```bash
dart pub get
```

---

## 📆 Usage

### Basic usage

```dart
final client = NccClient(
  id: 'ncc-client',
  client: http.Client(),
);

final response = await client.get(Uri.parse('https://api.example.com/data'));
```

### Session-based usage

```dart
final client = SessionClient(
  id: 'session-client',
  client: http.Client(),
);

final response = await client.get(
  Uri.parse('https://api.example.com/secure-data'),
);
```

You can customize token renewal, header logic, and handle session expiration seamlessly.

---

## 📚 API Reference

Check the full API reference on [pub.dev → network_cool_client](https://pub.dev/packages/network_cool_client).

---

## 💡 Examples

### Creation of Custom Session Client

```dart
final class MySessionClient extends SessionClient {
  MySessionClient({required this.sessionTokenStorage, required this.renewSessionRepository})
      : super(
          id: 'my-session-client',
          client: Client(),
        );

    final LocalStorageOfSessionToken sessionTokenStorage;
    final RenewSessionRepository renewSessionRepository;

  @override
  Future<String?> getBearerToken() async {
    //Obtain the token from the datasource where you store on the login request
    final token = await sessionTokenStorage.call();
    return token;
  }

  @override
  Future<bool> renewSession() async {
    //Renew session as your application need
    final renew = await renewSessionRepository.call();
    return renew.isValid;
  }
}
```

You can find usage examples in the [`example/`](example/) folder.

---

## 🤝 Contributing

Contributions are welcome!

* Open issues for bugs or feature requests
* Fork the repo and submit a PR
* Run `dart format` and `dart test` before submitting

---

## 🧪 Testing

To run tests and see code coverage:

```bash
dart test
```

---

## 📄 License

MIT © 2025 [Coolosos](https://github.com/coolosos)
