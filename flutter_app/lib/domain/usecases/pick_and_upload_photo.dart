import 'package:image_picker/image_picker.dart';

import '../../core/error/failures.dart';
import '../../core/usecase/usecase.dart';
import '../../core/error/either.dart';
import '../repositories/profile_repository.dart';

/// Picks a new profile picture from the gallery / camera and publishes it.
///
/// This use case owns the whole flow on purpose: the screen only says "let the
/// user change their photo", while the use case decides *how* (picker ->
/// repository -> Firestore URL). Keeping them together is what stops the same
/// five lines from being copy-pasted into every profile-like screen.
class PickAndUploadPhoto
    implements UseCase<Either<Failure, String>, PickAndUploadPhotoParams> {
  const PickAndUploadPhoto(this._picker, this._repository);

  final ImagePicker _picker;
  final ProfileRepository _repository;

  @override
  Future<Either<Failure, String>> call(PickAndUploadPhotoParams params) async {
    final XFile? file;
    try {
      file = await _picker.pickImage(
        source: params.source,
        maxWidth: 1024,
        imageQuality: 85,
      );
    } catch (_) {
      // No gallery, permission denied, or the OS picker crashed.
      return const Left(CancelledFailure());
    }

    if (file == null) return const Left(CancelledFailure());

    try {
      return await _repository.updatePhotoUrl(
        uid: params.uid,
        photoUrl: file.path,
      );
    } on Exception {
      return const Left(ServerFailure());
    }
  }
}

/// Parameters for [PickAndUploadPhoto].
class PickAndUploadPhotoParams extends Params {
  const PickAndUploadPhotoParams({required this.uid, required this.source});

  final String uid;
  final ImageSource source;

  @override
  List<Object?> get props => [uid, source];
}
