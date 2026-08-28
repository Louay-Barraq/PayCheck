// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'PayCheck';

  @override
  String get appSubtitle => 'Gestión de contratos y recibos';

  @override
  String get clients => 'Clientes';

  @override
  String get dashboard => 'Tablero';

  @override
  String get settings => 'Ajustes';

  @override
  String get email => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get signUp => 'Registrarse';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get orContinueWith => 'O CONTINUAR CON';

  @override
  String get signInWithGoogle => 'Iniciar sesión con Google';

  @override
  String get dontHaveAccount => '¿No tienes una cuenta?';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta?';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get resetPassword => 'Restablecer contraseña';

  @override
  String get enterEmailToReset =>
      'Introduce tu dirección de correo electrónico para recibir un enlace de restablecimiento.';

  @override
  String get send => 'Enviar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get close => 'Cerrar';

  @override
  String get emailSentSuccess =>
      '¡Se ha enviado un enlace de restablecimiento a tu correo!';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get logoutConfirmation => '¿Estás seguro de que deseas cerrar sesión?';

  @override
  String get deleteAccount => 'Eliminar mi cuenta';

  @override
  String get deleteAccountTitle => 'Eliminar cuenta permanentemente';

  @override
  String get deleteAccountConfirmation =>
      'Advertencia: Esta acción es irreversible.\nTodos tus datos (clientes, contratos, historial de pagos) se eliminarán de forma permanente.';

  @override
  String get deletingAccount => 'Eliminando cuenta...';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get version => 'Versión';

  @override
  String get language => 'Idioma';

  @override
  String get french => 'Francés';

  @override
  String get english => 'Inglés';

  @override
  String get arabic => 'Árabe';

  @override
  String get spanish => 'Español';

  @override
  String get search => 'Buscar...';

  @override
  String get addClient => 'Añadir cliente';

  @override
  String get editClient => 'Editar cliente';

  @override
  String get clientDetails => 'Detalles del cliente';

  @override
  String get fullName => 'Nombre completo';

  @override
  String get phone => 'Número de teléfono';

  @override
  String get address => 'Dirección';

  @override
  String get contractNumber => 'Número de contrato';

  @override
  String get paymentPeriod => 'Período de pago';

  @override
  String get monthly => 'Mensual';

  @override
  String get quarterly => 'Trimestral';

  @override
  String get semester => 'Semestral';

  @override
  String get annual => 'Anual';

  @override
  String get amountDue => 'Monto debido';

  @override
  String get contractStartDate => 'Fecha de inicio del contrato';

  @override
  String get nextPaymentDue => 'Próximo pago pendiente';

  @override
  String get active => 'Activo';

  @override
  String get inactive => 'Inactivo';

  @override
  String get archive => 'Archivar';

  @override
  String get activate => 'Activar';

  @override
  String get save => 'Guardar';

  @override
  String get clientAdded => '¡Cliente añadido con éxito!';

  @override
  String get clientUpdated => '¡Cliente actualizado con éxito!';

  @override
  String get addPayment => 'Añadir pago';

  @override
  String get recordPayment => 'Registrar pago';

  @override
  String get paymentHistory => 'Historial de pagos';

  @override
  String get viewHistory => 'Ver historial';

  @override
  String get amountPaid => 'Monto pagado (DT)';

  @override
  String get paymentDate => 'Fecha de pago';

  @override
  String get periodStart => 'Inicio del período';

  @override
  String get periodCoveredFrom => 'Inicio del período cubierto';

  @override
  String get periodEnd => 'Fin del período';

  @override
  String periodUntil(String date) {
    return 'Hasta $date';
  }

  @override
  String get paymentMethod => 'Método de pago';

  @override
  String get cash => 'Efectivo';

  @override
  String get card => 'Tarjeta bancaria';

  @override
  String get check => 'Cheque';

  @override
  String get postal => 'Giro postal';

  @override
  String get quittanceGiven => 'Recibo entregado';

  @override
  String get quittanceRemote => 'Pago a distancia — recuerda enviar el recibo';

  @override
  String get quittanceDate => 'Fecha del recibo';

  @override
  String get paymentAdded => '¡Pago registrado con éxito!';

  @override
  String get savingPayment => 'Guardando...';

  @override
  String get savePayment => 'Guardar pago';

  @override
  String get invalidAmount => 'Monto inválido';

  @override
  String get enterValidAmount => 'Ingrese un monto válido (> 0)';

  @override
  String get totalRevenue => 'Ingresos totales';

  @override
  String get activeClients => 'Clientes activos';

  @override
  String get overdueClients => 'Clientes morosos';

  @override
  String get pendingQuittances => 'Recibos pendientes';

  @override
  String allOverdueClients(int count) {
    return 'Clientes atrasados ($count)';
  }

  @override
  String get contract => 'Contrato';

  @override
  String viewAllOverdue(int count) {
    return 'Ver todos los retrasos (+$count)';
  }

  @override
  String get noClients => 'No hay clientes aún. ¡Añade tu primer cliente!';

  @override
  String get noPayments => 'No hay pagos registrados aún.';

  @override
  String get overdue => 'Atrasado';

  @override
  String get upToDate => 'Al día';

  @override
  String get quittancePending => 'Recibo pendiente';

  @override
  String get syncOnline => 'En línea — Sincronizado';

  @override
  String get syncOffline => 'Fuera de línea — Guardado localmente';

  @override
  String get requiresRecentLogin =>
      'Por razones de seguridad, inicie sesión de nuevo antes de eliminar su cuenta.';

  @override
  String get invalidEmail => 'Correo inválido';

  @override
  String get minPasswordLength => 'Mínimo 6 caracteres';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get requiredField => 'Campo obligatorio';

  @override
  String get infoAndLegal => 'Información y Legal';

  @override
  String get account => 'Cuenta';

  @override
  String get loginFailed => 'Error al iniciar sesión';

  @override
  String get googleSignInFailed => 'Error al iniciar sesión con Google';

  @override
  String get error => 'Error';

  @override
  String get collectedThisMonth => 'Recaudado este mes';

  @override
  String vsLastMonth(String pct) {
    return '$pct% vs mes anterior';
  }

  @override
  String paymentsCount(int count) {
    return '$count pagos';
  }

  @override
  String get overdueTitle => 'Clientes atrasados';

  @override
  String get distributionByMethod => 'Distribución por método de pago';

  @override
  String get dueSoon => 'Próximos vencimientos (7d)';

  @override
  String get historyTitle => 'Historial de pagos';

  @override
  String get history => 'Historial';

  @override
  String get noPaymentsHistory => 'No hay pagos registrados';
}
