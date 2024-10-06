import 'package:doo_cx_flutter_sdk/doo_callbacks.dart';
import 'package:doo_cx_flutter_sdk/doo_parameters.dart';
import 'package:doo_cx_flutter_sdk/di/modules.dart';

/// Represent all needed parameters necessary for [dooRepositoryProvider] to successfully provide an instance
/// of [DOORepository].
class RepositoryParameters {
  /// See [DOOParameters]
  DOOParameters params;

  /// See [DOOCallbacks]
  DOOCallbacks callbacks;

  RepositoryParameters({required this.params, required this.callbacks});
}
