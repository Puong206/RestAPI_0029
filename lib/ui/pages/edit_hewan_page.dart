import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restapi_0029/data/models/hewan_model.dart';
import 'package:restapi_0029/logic/bloc/hewan/hewan_bloc.dart';
import 'package:restapi_0029/logic/bloc/hewan/hewan_event.dart';
import 'package:restapi_0029/logic/bloc/hewan/hewan_state.dart';

class EditHewanPage extends StatefulWidget {
  final HewanModel hewan;
  const EditHewanPage({super.key, required this.hewan});

  @override
  State<EditHewanPage> createState() => _EditHewanPageState();
}

class _EditHewanPageState extends State<EditHewanPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaController;
  late final TextEditingController _jenisController;
  late final TextEditingController _tanggalController;
  late final TextEditingController _hargaController;
  late String _statusSelected;
  final List<String> statusOptions = ['tersedia'];

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.hewan.nama);
    _jenisController = TextEditingController(text: widget.hewan.jenis);
    _tanggalController = TextEditingController(text: widget.hewan.tanggalLahir);
    _hargaController = TextEditingController(
      text: widget.hewan.harga.toString(),
    );
    _statusSelected = widget.hewan.status;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _jenisController.dispose();
    _tanggalController.dispose();
    _hargaController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final data = {
        'nama': _namaController.text.trim(),
        'jenis': _jenisController.text.trim(),
        'tanggal_lahir': _tanggalController.text.trim(),
        'harga': int.tryParse(_hargaController.text.trim()) ?? 0,
        'status': _statusSelected,
      };
      context.read<HewanBloc>().add(UpdateHewan(widget.hewan.id, data));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HewanBloc, HewanState>(
      listener: (context, state) {
        if (state is HewanCreatedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Hewan berhasil diperbarui! ✨'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.pop(context);
          });
        } else if (state is HewanError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text(
            '✏️ Edit Hewan',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: const Color(0xFF2E7D32),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2E7D32), Color(0xFF558B2F)],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Header Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8D6E63).withOpacity(0.3),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: const Text(
                              '🐄',
                              style: TextStyle(fontSize: 32),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Perbarui Data Hewan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Ubah informasi hewan ternak Anda',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Form Fields
                    _buildInputField(
                      controller: _namaController,
                      label: 'Nama Hewan',
                      hint: 'Ubah nama hewan',
                      icon: Icons.pets,
                    ),
                    const SizedBox(height: 16),

                    _buildInputField(
                      controller: _jenisController,
                      label: 'Jenis Hewan',
                      hint: 'Ubah jenis hewan',
                      icon: Icons.category,
                    ),
                    const SizedBox(height: 16),

                    _buildInputField(
                      controller: _tanggalController,
                      label: 'Tanggal Lahir',
                      hint: 'YYYY-MM-DD',
                      icon: Icons.calendar_today,
                    ),
                    const SizedBox(height: 16),

                    _buildInputField(
                      controller: _hargaController,
                      label: 'Harga (Rp)',
                      hint: 'Ubah harga',
                      icon: Icons.attach_money,
                      isNumber: true,
                    ),
                    const SizedBox(height: 16),

                    _buildStatusField(),
                    const SizedBox(height: 32),

                    // Submit Button
                    BlocBuilder<HewanBloc, HewanState>(
                      builder: (context, state) {
                        bool isLoading = state is HewanLoading;

                        return SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8D6E63),
                              foregroundColor: Colors.white,
                              disabledBackgroundColor:
                                  const Color(0xFF8D6E63).withOpacity(0.6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 4,
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : const Text(
                                    'Simpan Perubahan',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.95),
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.35),
              fontSize: 14,
            ),
            prefixIcon: Icon(
              icon,
              color: Colors.white.withOpacity(0.6),
              size: 20,
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 48),
            filled: true,
            fillColor: Colors.white.withOpacity(0.08),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.white.withOpacity(0.15),
                width: 1.2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.white.withOpacity(0.15),
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF8D6E63),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFFF6B6B),
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFFF6B6B),
                width: 2,
              ),
            ),
            errorStyle: const TextStyle(
              color: Color(0xFFFF6B6B),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '$label tidak boleh kosong';
            }
            if (isNumber) {
              if (int.tryParse(value.trim()) == null) {
                return '$label harus berupa angka';
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildStatusField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status',
          style: TextStyle(
            color: Colors.white.withOpacity(0.95),
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
              width: 1.2,
            ),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white.withOpacity(0.08),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            value: _statusSelected,
            dropdownColor: const Color(0xFF2E7D32),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
            underline: Container(),
            icon: Icon(
              Icons.expand_more,
              color: Colors.white.withOpacity(0.6),
              size: 24,
            ),
            items: statusOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _statusSelected = newValue;
                });
              }
            },
          ),
        ),
      ],
    );
  }
}