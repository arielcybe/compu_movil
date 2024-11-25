/* class ServicioNotificaciones {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Autorización aceptada');
    } else if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Autorización provisional aceptada');
    } else {
      print('Autorización denegada');
    }
  }
} */

//Reservado para hacer las notificaciones 