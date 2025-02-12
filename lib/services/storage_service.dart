import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';

class S3UploadService {
  final String _bucketName = 'wepgcomp';
  final String _region = 'us-east-1';

  Future<String?> uploadImageToS3() async {
    try {
      // Seleciona o arquivo
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null) {
        final fileBytes = result.files.single.bytes;
        final fileName = DateTime.now().millisecondsSinceEpoch.toString();
        final fileExtension = result.files.single.extension;

        // Configura o Dio para enviar o arquivo
        final dio = Dio();
        final url =
            'https://$_bucketName.s3.$_region.amazonaws.com/$fileName.$fileExtension';

        final response = await dio.put(
          url,
          data: fileBytes,
          options: Options(
            headers: {
              'Content-Type': 'image/$fileExtension',
            },
          ),
        );

        if (response.statusCode == 200) {
          return url;
        } else {
          print('Erro ao fazer upload: ${response.statusCode}');
          return null;
        }
      } else {
        print('Nenhum arquivo selecionado.');
        return null;
      }
    } catch (e) {
      print('Erro: $e');
      return null;
    }
  }
}
