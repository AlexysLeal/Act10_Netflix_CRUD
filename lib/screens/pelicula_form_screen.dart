import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/pelicula_model.dart';
import '../services/pelicula_service.dart';

class PeliculaFormScreen extends StatefulWidget {
  final Pelicula? pelicula;
  const PeliculaFormScreen({super.key, this.pelicula});

  @override
  State<PeliculaFormScreen> createState() => _PeliculaFormScreenState();
}

class _PeliculaFormScreenState extends State<PeliculaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = PeliculaService();

  late TextEditingController _nombreCtrl;
  late TextEditingController _generoCtrl;
  late TextEditingController _duracionCtrl;
  late TextEditingController _calificacionCtrl;
  late TextEditingController _urlPosterCtrl;

  bool _loading = false;
  String _previewUrl = '';

  bool get _isEditing => widget.pelicula != null;

  @override
  void initState() {
    super.initState();
    final p = widget.pelicula;
    _nombreCtrl = TextEditingController(text: p?.nombre ?? '');
    _generoCtrl = TextEditingController(text: p?.genero ?? '');
    _duracionCtrl = TextEditingController(text: p?.duracion ?? '');
    _calificacionCtrl =
        TextEditingController(text: p?.calificacion.toString() ?? '');
    _urlPosterCtrl = TextEditingController(text: p?.urlPoster ?? '');
    _previewUrl = p?.urlPoster ?? '';

    _urlPosterCtrl.addListener(() {
      setState(() => _previewUrl = _urlPosterCtrl.text.trim());
    });
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _generoCtrl.dispose();
    _duracionCtrl.dispose();
    _calificacionCtrl.dispose();
    _urlPosterCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      final pelicula = Pelicula(
        idPelicula: widget.pelicula?.idPelicula ?? '',
        nombre: _nombreCtrl.text.trim(),
        genero: _generoCtrl.text.trim(),
        duracion: _duracionCtrl.text.trim(),
        calificacion:
            double.tryParse(_calificacionCtrl.text.trim()) ?? 0.0,
        urlPoster: _urlPosterCtrl.text.trim(),
      );

      if (_isEditing) {
        await _service.updatePelicula(pelicula);
      } else {
        await _service.addPelicula(pelicula);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF1A1A1A),
            content: Row(
              children: [
                const Icon(Icons.check_circle_outline,
                    color: Color(0xFFE50914), size: 18),
                const SizedBox(width: 8),
                Text(
                  _isEditing
                      ? 'Película actualizada correctamente'
                      : 'Película agregada al catálogo',
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red[900],
            content: Text('Error: $e',
                style: GoogleFonts.inter(color: Colors.white)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isEditing ? 'Editar Película' : 'Nueva Película',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFF1F1F1F)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poster preview
              _buildPosterPreview(),
              const SizedBox(height: 28),
              _buildSectionTitle('Información del Título'),
              const SizedBox(height: 16),
              _buildField(
                controller: _nombreCtrl,
                label: 'Nombre de la Película',
                icon: Icons.title_rounded,
                validator: (v) =>
                    v != null && v.isNotEmpty ? null : 'Campo requerido',
              ),
              const SizedBox(height: 14),
              _buildField(
                controller: _generoCtrl,
                label: 'Género',
                icon: Icons.category_outlined,
                hint: 'Ej: Acción, Drama, Comedia',
                validator: (v) =>
                    v != null && v.isNotEmpty ? null : 'Campo requerido',
              ),
              const SizedBox(height: 14),
              _buildField(
                controller: _duracionCtrl,
                label: 'Duración',
                icon: Icons.schedule_rounded,
                hint: 'Ej: 2h 30min',
                validator: (v) =>
                    v != null && v.isNotEmpty ? null : 'Campo requerido',
              ),
              const SizedBox(height: 14),
              _buildField(
                controller: _calificacionCtrl,
                label: 'Calificación (0.0 - 10.0)',
                icon: Icons.star_outline_rounded,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  final d = double.tryParse(v ?? '');
                  if (d == null || d < 0 || d > 10) {
                    return 'Ingresa un valor entre 0.0 y 10.0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 28),
              _buildSectionTitle('Arte y Poster'),
              const SizedBox(height: 16),
              _buildField(
                controller: _urlPosterCtrl,
                label: 'URL del Poster',
                icon: Icons.image_outlined,
                hint: 'https://image.tmdb.org/...',
                keyboardType: TextInputType.url,
                validator: (v) =>
                    v != null && v.isNotEmpty ? null : 'Campo requerido',
              ),
              const SizedBox(height: 36),
              // Save button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _loading ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE50914),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    elevation: 0,
                  ),
                  child: _loading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5),
                        )
                      : Text(
                          _isEditing ? 'Guardar Cambios' : 'Agregar al Catálogo',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPosterPreview() {
    return Center(
      child: Column(
        children: [
          Text(
            'Vista Previa del Póster',
            style: GoogleFonts.inter(
              color: Colors.grey[500],
              fontSize: 12,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 140,
              height: 210,
              child: _previewUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: _previewUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        color: const Color(0xFF1A1A1A),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFE50914),
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: const Color(0xFF1A1A1A),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image_outlined,
                                color: Colors.grey[700], size: 36),
                            const SizedBox(height: 8),
                            Text(
                              'URL inválida',
                              style: GoogleFonts.inter(
                                  color: Colors.grey[700], fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      color: const Color(0xFF1A1A1A),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.movie_outlined,
                              color: Colors.grey[700], size: 40),
                          const SizedBox(height: 8),
                          Text(
                            'Ingresa una URL',
                            style: GoogleFonts.inter(
                                color: Colors.grey[700], fontSize: 11),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: const Color(0xFFE50914),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.inter(
            color: Colors.grey[300],
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: GoogleFonts.inter(color: Colors.white, fontSize: 15),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: GoogleFonts.inter(color: Colors.grey[600], fontSize: 13),
        hintStyle: GoogleFonts.inter(color: Colors.grey[700], fontSize: 13),
        prefixIcon: Icon(icon, color: Colors.grey[600], size: 18),
        filled: true,
        fillColor: const Color(0xFF161616),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide:
              const BorderSide(color: Color(0xFFE50914), width: 1.5),
        ),
        errorStyle:
            GoogleFonts.inter(color: Colors.grey[500], fontSize: 11),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
