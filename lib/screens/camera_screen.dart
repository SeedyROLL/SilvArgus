import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/scanner_overlay.dart';
import 'result_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _controller = CameraController(_cameras![0], ResolutionPreset.high);
      await _controller!.initialize();
      if (mounted) {
        setState(() {
          _isInit = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _captureImage() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    
    try {
      final XFile file = await _controller!.takePicture();
      _processImage(file.path);
    } catch (e) {
      debugPrint('Error taking picture: \$e');
    }
  }

  Future<void> _pickGalleryImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      _processImage(file.path);
    }
  }

  void _processImage(String path) {
    if (!mounted) return;
    
    // Dispose the camera controller before navigating away to save resources
    _controller?.dispose();
    _controller = null;
    
    final appState = context.read<AppState>();
    appState.analyzeImage(path);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ResultScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInit || _controller == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Color(0xFF81C784))),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_controller!),
          const ScannerOverlay(),
          
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.photo_library, color: Colors.white, size: 30),
                      onPressed: _pickGalleryImage,
                    ),
                    GestureDetector(
                      onTap: _captureImage,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: const CircleAvatar(
                          radius: 35,
                          backgroundColor: Color(0xFF81C784),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Balancing the gallery icon
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
